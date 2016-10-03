require "./piece.rb"

class King < Piece

  def initialize(color)
    super(color)
  end

  def movement(row1, col1, board)

    #adding all possible moves
    possible_moves=Array.new
    possible_moves = [
    [row1+1,col1-1],[row1+1,col1],[row1+1,col1+1],
    [row1,col1-1],[row1,col1+1],
    [row1-1,col1-1],[row1-1,col1],[row1-1,col1+1] ]

    # removing moves that go off the board
    possible_moves.select! do |a|
     a[0]>=0 && a[0]<8 && a[1]>=0 && a[1]<8
    end

    #removing moves blocked by teammates
    possible_moves.reject! do |a|
     this_sq=board.get_square(a[0],a[1])
     this_sq.occupied==true && this_sq.piece.color == @color
    end

    # removing moves under attack by enemy
    possible_moves.reject! do |a|
      this_sq=board.get_square(a[0],a[1])
        (@color=="black" && this_sq.attacked_white==true)  || (@color=="white" && this_sq.attacked_black==true)

     end

     #adding castling moves
     if board.can_castle?(@color, "king")
       possible_moves << (@color=="black" ?  [7,6] : [0,6])
     end
     if board.can_castle?(@color, "queen")
       possible_moves << (@color=="black" ?  [7,2] : [0,2] )
     end


    return possible_moves
  end



end
