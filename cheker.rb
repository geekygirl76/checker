class Piece
  def initialize(board, color, pos)
    @board = board
    @color = color
    @pos = pos
  end
  
  def moves
    row, col = @pos
    @deltas.map {|pair| [pair[0] + row, pair[1] +col]}
  end
  
  def directions
    raise NotImplementedError
  end
  
end

class King < Piece
  def directions
    @deltas = [[-1, 1], [1, 1], [-1, -1], [1, -1]]
  end
end

class Pawn < Piece
  def directions
    @deltas = [ [1, 1],  [1, -1]]
  end
  
end