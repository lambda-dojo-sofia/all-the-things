defmodule Snake do

  # def input do
  #   [[ 7, 5, 2, 3, 1 ],
  #    [ 3, 4, 1, 4, 4 ],
  #    [ 1, 5, 6, 7, 8 ],
  #    [ 3, 4, 5, 8, 9 ],
  #    [ 3, 2, 2, 7, 6 ]]
  # end

  def input do
    [[ 7, 5],
     [ 3, 4]]
  end

  def pr do
    IO.puts input()
    IO.puts "fake"
  end


  def paths(x, y, matrix) when x > length(matrix) - 1, do: []

  def paths(x, y, matrix) do
    if y > length(Enum.at(matrix, x)) - 1 do
      []
    else
      current = Enum.at(Enum.at(matrix, x), y)
      [[current],
       [current] ++ paths(x + 1, y, matrix),
       [current] ++ paths(x, y + 1, matrix)]
    end
  end

  def main do
    matrix = input()
    for {row, x} <- Enum.with_index(matrix) do
      for {_, y} <- Enum.with_index(row) do
        paths(x, y, matrix)
        # TODO accumulate result from paths()
      end
    end
  end
end

IO.inspect( Snake.paths(0, 0, Snake.input()) ) # [7], [7, 3], [7, 5, 4]

