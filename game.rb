require_relative "board"
require_relative "piece"

class Game
  attr_accessor :board, :player
  
  def initialize(player)
    @board = Board.new
    @player = player
  end
  
  def over?
    lose?(:white) || lose?(:black)
  end
  
  def lose?(c)
    if @board.pieces_color(@player.color) == 0
      true
    else
      false
    end
  end
  
  def winner
      winner = (lose?(:white) ? :black : :white)  
  end
  
  def remind
    puts "black is capital, white is lowercase"
  end
  
  def play
    puts "Please puts in the row and column like this: 5 2,
        if you want to jump over a few spots, type like this: 5 2,4 3,6 2"
    puts "If you want black color, move capital pieces, 
        otherwise lowercase pieces"
    
    until over? 
      begin
        puts 
        @board.print_board
        puts "Now #{@player.color} play!"
        remind
      
        start =  @player.pick_start("What's the start spot?")
        while @board[start].color != @player.color
          raise CheckersError.new('Something went terrribly wrong!')
          puts "You are using enemy's piece!!"
          start =  @player.pick_start("What's the start spot?")
        end
        
        sequence = @player.pick_seq("What's spot sequence you want to follow?")
      
        piece = @board[start]
        piece.perform_moves(sequence)
        @player.play_turn
      rescue #CheckersError => e
        #puts e.message
        puts "Choose another one"
        retry
      end
    end
    
    puts "#{winner} win!!!"
  end
end

#class CheckersError < StardardError
#end

class Player
  attr_accessor :color
  
  def initialize
    @color = :white
  end
  
  def play_turn
    @color = (@color == :white ? :black : :white)
  end
  
  def parse_loc(input)
    input.split.map {|n| n.to_i}
  end
  
  def parse_seq(input)
    input.split(",").map {|pair| parse_loc(pair)}
  end
  
  def pick_start(prompt)
    puts prompt
    row, col = parse_loc(gets.chomp)
  end
  
  def pick_seq(prompt)
    puts prompt
    parse_seq(gets.chomp)
  end
end

if __FILE__ == $PROGRAM_NAME
  Game.new(Player.new).play
end






