defmodule Sudoku.Algo do
  alias __MODULE__
  alias Sudoku.Board
  alias Sudoku.Cell

  defstruct board: nil,
            current_cell: nil

  def new(board) do
    %Algo{board: board, current_cell: board.cells[{0, 2}]}
  end

  def generate_next(algo) do
    candidates = algo.current_cell.candidates

    x =
      for [candidate | _] <- candidates do
        Board.build_from_new_candidate(algo.board, algo.current_cell, candidate)
      end

    x
  end
end