defmodule Sudoku.Algo do
  alias __MODULE__
  alias Sudoku.Board
  alias Sudoku.Cell

  defstruct board: nil,
            current_cell: nil

  def new(board) do
    %Algo{board: board, current_cell: board.cells[{0, 2}]}
  end


  def generate_next(%{current_cell: %{x: row_idx, y: col_idx}}) when row_idx >= 8 and col_idx >= 8,
    do: :end

  def generate_next(algo) do

    candidates = algo.current_cell.candidates
    [candidate] = Enum.take(candidates, 1)

    new_board = Board.build_from_new_candidate(algo.board, algo.current_cell, candidate)

    {row_idx, col_idx, cells} = {algo.current_cell.x, algo.current_cell.y, algo.board.cells}
    key = if col_idx >= 8, do: {row_idx + 1, 0}, else: {row_idx, col_idx + 1}

    %{algo | board: new_board, current_cell: cells[key]}
  end

  def has_future?(board) do
    Board.is_valid_sudoku(board.representation)
  end
end
