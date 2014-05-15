require_relative "piece"

class Board
  def self.grid
    Array.new(8) {Array.new(8)}
  end
  
  def initialize(fill = true)
    @grid = self.class.grid
    
    if fill
      [0, 2, 6].each do |row|
        (0..7).each do |col|
          if col.even?
            my_color = (row == 6? :white : :black)
            Piece.new(self, my_color, [row, col] )
          end
        end
      end
      
      [1, 5, 7].each do |row|
        (0..7).each do |col|
          if !col.even?
            my_color = (row == 1? :black : :white)
            Piece.new(self, my_color, [row, col] )
          end
        end
      end
    end
  end
  
  def [](loc)
    @grid[loc[0]][loc[1]]
  end
  
  def []=(loc, piece)
    @grid[loc[0]][loc[1]] = piece
  end
  
  def on_board?(spot)
    (0..7).include?(spot[0]) && (0..7).include?(spot[1])
  end
  
  def pieces
    @grid.flatten.compact
  end
  
  def pieces_color(c)
    pieces.select {|p| p.color == c}
  end
  
  def dup
    new_board = self.class.new(false)
    pieces.each do |p|
      p.class.new(new_board, p.color, p.pos, p.symbol)
    end
    
    new_board
  end
    
  def print_board
    pic = "    0  1  2  3  4  5  6  7 \n"
    (0..7).each do |row|
      pic += row.to_s + "  "
      
      (0..7).each do |col|
        if self[[row, col]].nil?
          if (row.even? && col.even?) || (!row.even? && !col.even?)
            pic += "__ "
          else
            pic += "   "
          end
        else
          if self[[row, col]].color == :white
            pic += self[[row, col]].symbol.to_s + "W "
          else
            pic += self[[row, col]].symbol.to_s + "B "
          end
        end
      end
      pic += "\n"
    end
    puts pic
    return nil
  end   
end


if __FILE__ == $PROGRAM_NAME
  b = Board.new
  b.print_board
  puts
  
  b[[5,1]].perform_moves([[4,0]])
  b.print_board
  puts
  
  
  b[[4,0]].perform_moves([[3,1]])
  b.print_board
  puts
  
  
  b[[2,2]].perform_moves([[3,3]])
  b.print_board
  puts
  
 
  b[[1,3]].perform_moves([[2,2]])
  b.print_board
  puts
  
  
  b[[3,1]].perform_moves([[1,3]])
  b.print_board
  puts
  
  b[[1,1]].perform_moves([[2, 2]])
  b.print_board
  puts
  
  b[[0,2]].perform_moves([[1,1]])
  b.print_board
  puts
  
  
  b[[1,3]].perform_moves([[0,2]])
  b.print_board
  puts
  
  b[[0,2]].perform_moves([[1, 3]])
  b.print_board
  puts
end














