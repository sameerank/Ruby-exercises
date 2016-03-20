require 'byebug'

class Tile

  attr_accessor :bomb, :revealed, :flag

  def initialize(bomb = false, location = [], board_class )
    @bomb = bomb
    @revealed = false
    @location = location
    @board_class = board_class
    @flag = false
  end

  def reveal_tile
    @revealed = true
  end

  def neighbors
    row, column = @location
    neighbors_array = []
    (-1..1).each do |delta_row|
      (-1..1).each do |delta_column|
        possible_neighbor = [row + delta_row, column + delta_column]
        if possible_neighbor.all?{|el| el.between?(0,8)} && possible_neighbor != @location
          neighbors_array << possible_neighbor
        end
      end
    end
    neighbors_array
  end

  def neighbor_bomb_count
    bomb_count = 0
    neighbors.each do |neighbord_location|
      r, c = neighbord_location
      bomb_count += 1 if @board_class.grid[r][c].bomb
    end
    bomb_count
  end

  def inspect
    if @revealed
      if @bomb
        "|B| "
      else
        if neighbor_bomb_count > 0
          "|#{neighbor_bomb_count}| "
        else
          "|X| "
        end
      end
    else
      "|_| "
    end
  end

end

class Board
  attr_accessor :grid
  BOMB_PROBABLITY = 0.2

  def initialize
    @grid = Array.new(9) {Array.new(9)}
    populate
  end

  def populate

    @grid.each_index do |row_index|
      @grid[row_index].each_index do |column_index|

        rand < BOMB_PROBABLITY ? b = true : b = false

        @grid[row_index][column_index] = Tile.new(b, [row_index, column_index], self)
      end
    end
  end

  def display

    @grid.each_index do |row_index|
      virtual_row = ""
      @grid[row_index].each_index do |column_index|
        virtual_row << @grid[row_index][column_index].inspect
      end
      p virtual_row
    end
  end
end

class Player
end

class Game

  def initialize
    @board = Board.new
    system("clear")
  end

  def play
    until end_of_game
      row, col = get_input
      tile = @board.grid[row][col]
      tile.reveal_tile
        if tile.bomb
          @board.grid.flatten.each {|el| el.reveal_tile}
        end 
      @board.display
    end
      puts "Game Over"
  end

  def end_of_game
    @board.grid.flatten.all? {|el| el.revealed}
  end

  def get_input
    puts "Pick a position. Ex. row column."
    input = STDIN.gets.chomp
    row, col = input.split(" ").map {|el| Integer(el) } #cleans up the input
    [row, col]
  end

end

if __FILE__ == $PROGRAM_NAME
  running_game = Game.new
  running_game.play
end
