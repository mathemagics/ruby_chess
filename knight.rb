require "./piece.rb"

class Knight < Piece

  def initialize(color)
    super(color)
  end

  def movement(row1, col1, board)

    possible_moves=Array.new
    # adding all possible moves
    possible_moves = [[row1+1,col1+2],[row1-1,col1+2],
                      [row1+2,col1+1],[row1-2,col1+1],
                      [row1+1,col1-2],[row1-1,col1-2],
                      [row1+2,col1-1],[row1-2,col1-1]]

    #removing moves that go off the board
    possible_moves.select! do |a|
          a[0]>=0 && a[0]<8 && a[1]>=0 && a[1]<8
      end

    #removing moves occupied by teammates
    possible_moves.reject! do |a|
      board.get_square(a[0],a[1]).occupied==true  && board.get_square(a[0],a[1]).piece.color==@color
    end
    return possible_moves
  end





end
