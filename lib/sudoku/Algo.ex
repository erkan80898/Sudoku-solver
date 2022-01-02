defmodule Sudoku.Algo do
  alias __MODULE__
  alias Sudoku.Board
  alias Sudoku.Cell

  defstruct board: nil,
            current_cell: nil

  def new(board) do
    %Algo{board: board, current_cell: board.cells[{0, 2}]}
  end

  # keep in mind for :end
  def backtracker(current_algo, prev_algo) do
    {next_step, candidate} = generate_next(current_algo)

    if has_future?(next_step) == False do
      new_cell = Cell.remove_candidate(prev_algo.current_cell, candidate)
      %{prev_algo | current_cell: new_cell}
    end
  end

  def generate_next(%{current_cell: %{x: row_idx, y: col_idx}})
      when row_idx >= 8 and col_idx >= 8,
      do: :end

  def generate_next(algo) when algo.board.val != '.',
    do: %{algo | current_cell: get_next_cell(algo)}

  def generate_next(algo) do
    candidates = algo.current_cell.candidates
    candidate = Enum.take(candidates, 1)

    adjusted_current_cell =
      Cell.add_to_visited_candidate(algo.current_cell, MapSet.new(candidate))

    new_board =
      Board.build_from_new_candidate(
        algo.board,
        adjusted_current_cell,
        candidate,
        adjusted_current_cell.visited
      )

    {%{algo | board: new_board, current_cell: get_next_cell(algo)}, candidate}
  end

  def get_next_cell(%{board: %{cells: cells}, current_cell: %{x: row_idx, y: col_idx}}) do
    key = if col_idx >= 8, do: {row_idx + 1, 0}, else: {row_idx, col_idx + 1}
    cells[key]
  end

  def has_future?(%{board: board}) do
    Board.is_valid_sudoku(board.representation)
  end
end
