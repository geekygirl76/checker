class Piece
  def initialize(board, color, pos)
    @board = board
    @color = color
    @pos = pos
  end
  
  def moves
    slide_moves + jump_moves
  end
  
  def slide_moves
    row, col = @pos
    @slide_deltas.map {|pair| [pair[0] + row, pair[1] + col]}
  end
  
  def jump_moves
    row, col = @pos
    @jump_deltas.map {|pair| [pair[0] + row, pair[1] + col]}
  end
  
  def perform_slide(target)
    raise "Invalid move!" if !@board[target].nil?
    
    @board[target] = self
    @board[@pos] = nil
    @pos = target
  end
  
  def perform_jump(target)
    raise "Invalid move!" if @board[mid_loc].nil?
    raise "Invalid move!" if @board[target].nil? || @board[target].color == @color
    
    mid_x = (@pos[0] + target[0]) / 2
    mid_y = (@pos[1] + target[1]) / 2
    mid_loc = [mid_x, mid_y]
    
    @board[target] = self
    @board[@pos] = nil
    @pos = target
    @board[mid_loc] = nil
  end
  
  def diffs
    raise NotImplementedError
  end
  
  def on_board(spot)
    (0..7).include?(spot[0]) && (0..7).include?(spot[1])
  end
end

class King < Piece
  def diffs
    @slide_deltas = [[-1, 1], [1, 1], [-1, -1], [1, -1]]
    @jump_deltas = @slide_deltas.map {|pair| [pair[0] * 2, pair[1] * 2]}
  end
end

class Pawn < Piece
  def diffs
    @slide_deltas = [[1, 1],  [1, -1]]
    @jump_deltas = @slide_deltas.map {|pair| [pair[0] * 2, pair[1] * 2]}
  end
end

