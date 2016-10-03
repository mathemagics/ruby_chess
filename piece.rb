

class Piece
  attr_accessor :color
  attr_accessor :position
  attr_accessor :possible_moves

  def initialize (color)
    @color = color
    @possible_moves = Array.new
    @position="initial"
  end

  def movement(row1, col1, board)
    
    possible_moves = possible_moves.select do |a|
      a[0]>=0 && a[0]<8 && a[1]>=0 && a[1]<8
    end

  end


end
