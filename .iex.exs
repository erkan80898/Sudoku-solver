alias(Sudoku.Board)
alias(Sudoku.Cell)
alias(Sudoku.Algo)

IEx.configure(inspect: [limit: :infinity])
board = [["5","3",".",".","7",".",".",".","."],["6",".",".","1","9","5",".",".","."],[".","9","8",".",".",".",".","6","."],["8",".",".",".","6",".",".",".","3"],["4",".",".","8",".","3",".",".","1"],["7",".",".",".","2",".",".",".","6"],[".","6",".",".",".",".","2","8","."],[".",".",".","4","1","9",".",".","5"],[".",".",".",".","8",".",".","7","9"]]
{x, board_s} = board |> Board.build_from_str

algo_start = board_s |> Algo.new |> Algo.generate_next
