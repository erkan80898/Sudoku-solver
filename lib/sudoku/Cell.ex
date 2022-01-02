defmodule Sudoku.Cell do
  alias __MODULE__

  defstruct x: nil,
            y: nil,
            current_val: nil,
            changeable: nil,
            candidates: nil,
            visited: nil

  def new(x, y, current_val, changeable, candidates) do
    %Cell{
      x: x,
      y: y,
      current_val: current_val,
      changeable: changeable,
      candidates: candidates,
      visited: MapSet.new()
    }
  end

  # next iteration takes care of actually removing from candidates list
  def add_to_visited_candidate(cell, candidate) do
    visited = MapSet.union(cell.visited, candidate)
    %{cell | visited: visited}
  end

  def has_candidates?(cell) do
    Enum.empty?(cell.candidates)
  end
end
