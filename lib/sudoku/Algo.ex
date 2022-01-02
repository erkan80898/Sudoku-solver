defmodule Sudoku.Algo do
  alias __MODULE__
  alias Sudoku.Board
  alias Sudoku.Cell

  defstruct board: nil,
            current_cell: nil

  def new(board) do
    %Algo{board: board, current_cell: board.cells[{0, 2}]}
  end

  # Note: will fail on a cell with an empty candidnate -> shouldn't get there
  def generate_next(algo) do
    candidates = algo.current_cell.candidates

    [new_state | _] =
      for candidate <- candidates do
        Board.build_from_new_candidate(algo.board, algo.current_cell, candidate)
      end

    new_state
  end

  def has_future?(board) do
    Board.is_valid_sudoku(board.representation)
  end
end
