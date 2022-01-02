defmodule Sudoku.Board do
  alias __MODULE__
  alias Sudoku.Cell

  defstruct size: 9,
            box_size: 3,
            valid: True,
            solved: False,
            representation: nil,
            cells: nil

  def build_from_new_candidate(board, cell, [[candidate]], space) do
    new_representation =
      board.representation
      |> List.update_at(cell.x, fn x ->
        List.update_at(x, cell.y, &List.replace_at(&1, 0, candidate))
      end)

    IO.inspect(new_representation)
    board = %{board | representation: new_representation}
    build_from_charlist(board, space, {cell.x, cell.y})
  end

  def build_from_str(board) do
    board = %Board{representation: board |> list_list_str_to_list_list_charlist}

    if validate_board_size(board) and is_valid_sudoku(board) do
      space = 1..9 |> Enum.map(&Integer.to_charlist/1) |> MapSet.new()
      {:ok, build_from_charlist(board, space)}
    else
      {:error}
    end
  end

  defp build_from_charlist(board, space, ignore \\ nil) do
    cells =
      for {row, row_idx} <- Enum.with_index(board.representation),
          {val, col_idx} <- Enum.with_index(row),
          into: Map.new() do
        if val == [?.] or {row_idx, col_idx} == ignore do
          candidates = get_candidates(board, row_idx, col_idx, space)
          {{row_idx, col_idx}, Cell.new(row_idx, col_idx, val, true, candidates)}
        else
          {{row_idx, col_idx}, Cell.new(row_idx, col_idx, val, false, MapSet.new())}
        end
      end

    %Board{board | cells: cells}
  end

  def get_candidates(board, row_idx, col_idx, space) do
    cols = get_col_major(board.representation)
    squares = get_squares(board.representation)

    row = Enum.at(board.representation, row_idx)
    col = Enum.at(cols, col_idx)

    square = Enum.at(squares, get_square_index(row_idx, col_idx))

    candidates =
      MapSet.union(MapSet.new(row), MapSet.new(col))
      |> MapSet.union(MapSet.new(square))

    MapSet.difference(space, candidates)
  end

  def get_square_index(row_idx, col_idx) do
    to_add =
      cond do
        row_idx < 3 -> 0
        row_idx < 6 -> 3
        row_idx < 9 -> 6
      end

    cond do
      col_idx < 3 -> to_add
      col_idx < 6 -> to_add + 1
      col_idx < 9 -> to_add + 2
    end
  end

  def transpose(lst), do: lst |> Enum.zip() |> Enum.map(&Tuple.to_list/1)

  def validate_board_size(%{representation: representation}) do
    size = 9

    Enum.count(representation) == size &&
      Enum.count(representation, &(Enum.count(&1) == size)) == size
  end

  def list_list_str_to_list_list_charlist(lst),
    do: lst |> Enum.map(fn x -> Enum.map(x, &String.to_charlist/1) end)

  def unique?(list), do: Enum.uniq(list) == list

  def remove_period_str(list), do: Enum.map(list, fn x -> Enum.reject(x, &(&1 == ".")) end)
  def remove_period_char(list), do: Enum.map(list, fn x -> Enum.reject(x, &(&1 == [?.])) end)

  def get_col_major(lst), do: lst |> transpose
  def get_row_major(lst, transformation), do: transformation.(lst)
  def get_col_major(lst, transformation), do: transformation.(lst |> transpose)

  def get_squares(lst) do
    lst
    |> Enum.chunk_every(3)
    |> Enum.map(fn x -> Enum.map(x, &Enum.chunk_every(&1, 3)) end)
    |> Enum.map(fn x -> Enum.zip(x) end)
    |> List.flatten()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&List.flatten/1)
    |> Enum.map(fn x -> Enum.map(x, &[&1]) end)
  end

  def get_squares(lst, transformation) do
    transformation.(
      lst
      |> Enum.chunk_every(3)
      |> Enum.map(fn x -> Enum.map(x, &Enum.chunk_every(&1, 3)) end)
      |> Enum.map(fn x -> Enum.zip(x) end)
      |> List.flatten()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.map(&List.flatten/1)
      |> Enum.map(fn x -> Enum.map(x, &[&1]) end)
    )
  end

  def is_valid_sudoku(%{representation: representation}) do
    row_major_board = get_row_major(representation, &remove_period_char/1)

    col_major_board = get_col_major(representation, &remove_period_char/1)

    squares = get_squares(representation, &remove_period_char/1)

    Enum.all?(row_major_board, &unique?/1) &&
      Enum.all?(col_major_board, &unique?/1) &&
      Enum.all?(squares, &unique?/1)
  end
end
