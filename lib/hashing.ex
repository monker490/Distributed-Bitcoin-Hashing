defmodule Project1 do
  @moduledoc """
  Documentation for Project1.
  """

  def main(zerolead) do

   
    # IO.puts Node.self() 
    #IO.puts Node.get_cookie()

    val = Enum.at(zerolead,0) |> String.trim
    if String.contains?(val,".") do
      Node.start(:"arslan@192.168.0.17")
      Node.set_cookie(Node.self(), :abcookie)
      #ip_addr = "abc@" <> val
      #Node.start(:ip_addr) 
      client_side(val)
    else
      Node.start(:"abc@192.168.0.17")
      Node.set_cookie(Node.self(), :abcookie)
      k = String.to_integer(val)
      server_side(k)
    end
  end


  def server_side(zerolead) do

    pid = Node.spawn(Node.self, Project1, :sender, [zerolead])
    pid1 = Node.spawn(Node.self, Project1, :msg, [])
    send(pid1, {:rahul,zerolead})
    pid2 = Node.spawn(Node.self, Project1, :msg, [])
    send(pid2, {:rahul,zerolead})
    pid3 = Node.spawn(Node.self, Project1, :msg, [])
    send(pid3, {:rahul,zerolead}) 
    pid4 = Node.spawn(Node.self, Project1, :msg, [])
    send(pid4, {:rahul,zerolead})
    pid5 = Node.spawn(Node.self, Project1, :msg, [])
    send(pid5, {:rahul,zerolead})

    msg()
  end

  def msg do
    receive do
      {:rahul, k} -> bitcoingen(k)
    end
  end

  def sender(k) do
    if(List.last(Node.list) != nil) do
      pid = Node.spawn(List.last(Node.list),Project1,:msg2,[])
      send(pid, {k,:substr})
    end
    sender(k)
  end

  def client_side(ip_str) do
    # ip_str_val = "abc@" <> ip_str
    # ip_val = String.to_atom(ip_str_val)
    # IO.puts Node.self()
    # IO.puts Node.get_cookie()
    IO.puts Node.connect(:"abc@192.168.0.10")
    msg2()
  end

  def msg2 do
    receive do
      {k,:substr} -> bitcoingen(k)
    end
  end

  def bitcoingen(k) do 
    substr = String.duplicate("0",k)
    i = 1;
    input_left = "rahulp248;"
    input_right = :crypto.strong_rand_bytes(6) |> Base.encode64
    start = input_left <> input_right 
    inter = start
    keygen(k,start,inter,i,substr)
    bitcoingen(k)
  end


  def keygen(k,start,inter,i,substr) do
    val_hex = :crypto.hash(:sha256,inter) |> Base.encode16 |> String.downcase
    if(String.slice(val_hex,0,k) == substr) do
      hashed_code = IO.puts "#{start}\t#{val_hex}"
      #sender(hashed_code)
    else
      inter = inter <> Integer.to_string(i)
      keygen(k,start,inter,i+1,substr)
    end
  end
end