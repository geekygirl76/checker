require_relative "board"
require 'debugger'
class Piece
  attr_accessor :board, :color, :pos, :symbol
  
  def initialize(board, color, pos, symbol= :P)
    @board = board
    @color = color
    @pos = pos
    @board[pos] = self
    @symbol = symbol
  end
  
  def moves
    slide_moves + jump_moves
  end
  
  def slide_moves
    row, col = self.pos
    next_moves= slide_diffs.map {|pair| [pair[0] + row, pair[1] + col]}
    next_moves.select {|spot| self.board.on_board?(spot)}
  end
  
  def jump_moves
    row, col = self.pos
    next_moves = jump_diffs.map {|pair| [pair[0] + row, pair[1] + col]}
    next_moves.select {|spot| self.board.on_board?(spot)}
  end
  
  def perform_slide(target)
    potential_moves = slide_moves
    #puts "potential_moves: #{potential_moves}"
    #puts "target: #{target}"
    raise "Can't move in that direction!" if !potential_moves.include?(target)
    raise "Target not empty!" if !self.board[target].nil?
    
    self.board[target] = self
    self.board[self.pos] = nil
    self.pos = target
    
    maybe_promote
  end
  
  def perform_jump(target)
    potential_moves = jump_moves
    mid = mid_loc(target)
    
    raise "Can't jump over nothing!" if self.board[mid].nil?
    raise "Can't jump onver your own people!" if !self.board[target].nil? ||
       self.board[mid].color == self.color || self.board[mid].nil?
    
    self.board[target] = self
    self.board[self.pos] = nil
    self.pos = target
    self.board[mid] = nil
    
    debugger if maybe_promote == :K
  end
  
  def mid_loc(target)
    mid_x = (self.pos[0] + target[0]) / 2
    mid_y = (self.pos[1] + target[1]) / 2
    mid_loc = [mid_x, mid_y]
  end
  
  def slide_diffs
    if self.color == :white
      if self.symbol == :P
        return [[-1, 1],  [-1, -1]]
      else
        return [[1, 1],  [1, -1], [-1, -1], [-1, 1]]
      end
    else
      if self.symbol == :P
        return [[1, 1],  [1, -1]]
      else
        return [[1, 1],  [1, -1], [-1, -1], [-1, 1]]
      end
    end
  end
  
  def jump_diffs
     slide_diffs.map {|pair| [pair[0] * 2, pair[1] * 2]}
  end
  
  def maybe_promote
    if self.color == :white && self.pos[0] == 0 && self.symbol == :P
      self.symbol = :K 
    end

    if self.color == :black && self.pos[0] == 7 && self.symbol == :P
      self.symbol = :K
    end
  end
  
  def perform_moves!(move_sequence)
    if my_seq(move_sequence)!= move_sequence
      raise "Invalid sequence!"
    end
      
    move_sequence.each do |target|
      if (target[0] - self.pos[0]).abs == 1
        perform_slide(target)
      else
        perform_jump(target)
      end
    end
  end
  
  def my_seq(seq)
    if seq.first[0] - self.pos[0] ==1
      [seq[0]]
    else
      result = [seq[0]]
      i = 1
      while i < seq.length && seq[i][0] - seq[i-1][0] == 2
        result << seq[i]
        i += 1
      end
      result
    end
  end
  
  def valid_move_seq?(move_sequence)
    begin
      new_board = self.board.dup
      new_piece = new_board[self.pos]
      new_piece.perform_moves!(move_sequence)
    rescue
      return false
    else
      return true
    end
  end
  
  def perform_moves(move_sequence)
    #debugger
    if valid_move_seq?(move_sequence)
      perform_moves!(move_sequence)
    else
      raise "InvalidMoveError"
    end
  end 
end

if __FILE__ == $PROGRAM_NAME
  b = Board.new
  b.print_board
  puts
  
  p = b[[5,3]]
  p.symbol = :K
  p.perform_moves([[4,4]])
  b.print_board
  puts 
  
  p.perform_moves([[5,3]])
  b.print_board
  puts
  
  p.valid_move_seq?([[5,3]])
  
  p.perform_moves!([[5,3]])
  
  p.my_seq([[5,3]])!= ([[5,3]])
  
  p.perform_slide([5,3])
end











