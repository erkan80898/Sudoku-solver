defmodule Sudoku.Cell do
  alias __MODULE__

  defstruct x: nil,
            y: nil,
            current_val: nil,
            changeable: nil,
            candidates: nil

  def new(x, y, current_val, changeable, candidates) do
    %Cell{
      x: x,
      y: y,
      current_val: current_val,
      changeable: changeable,
      candidates: candidates
    }
  end

  def has_candidates?(cell) do
    Enum.empty?(cell.candidates)
  end
end
