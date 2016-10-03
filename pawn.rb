
require "./piece.rb"

class Pawn < Piece

  def initialize(color)
    super(color)
  end

# rewrite this in a format that checks conditions before adding
  def movement(row1, col1, board)

    possible_moves=Array.new
      if @color=="white"
        # checking square in front
        if  row1+1<8 && board.get_square(row1+1,col1).occupied==false
          possible_moves <<[row1+1,col1]

          #checking 2 squares forward
          if @position=="initial"  && !board.get_square(row1+2,col1).occupied
            possible_moves <<[row1+2,col1]
          end
        end

        # checking attacking squares
        if row1+1<8 && col1-1>=0
          atk_sq1 = board.get_square(row1+1,col1-1)

          if  atk_sq1.occupied && atk_sq1.piece.color != @color || !atk_sq1.occupied && atk_sq1.en_passanted
            possible_moves <<[row1+1,col1-1]
          end
        end
        if row1+1<8 && col1+1<8
          atk_sq2 = board.get_square(row1+1,col1+1)
          if  atk_sq2.occupied && atk_sq2.piece.color != @color || !atk_sq2.occupied && atk_sq2.en_passanted
            possible_moves <<[row1+1,col1+1]
          end
        end

      elsif @color=="black"
        # checking square in front
        if  row1-1>=0 && board.get_square(row1-1,col1).occupied==false
          possible_moves <<[row1-1,col1]

          # checking for 2 squares forward
          if @position=="initial"  && board.get_square(row1-2,col1).occupied==false
            possible_moves <<[row1-2,col1]
          end
        end

        # checking attacking squares
        if row1-1>=0 && col1-1>=0
          atk_sq1 = board.get_square(row1-1,col1-1)
            if  (atk_sq1.occupied && atk_sq1.piece.color != @color) || (!atk_sq1.occupied && atk_sq1.en_passanted)
              possible_moves <<[row1-1,col1-1]
            end
        end
        if row1-1>=0 && col1+1<8
          atk_sq2 = board.get_square(row1-1,col1+1)
            if  (atk_sq2.occupied && atk_sq2.piece.color != @color) || (!atk_sq2.occupied && atk_sq2.en_passanted)
              possible_moves <<[row1-1,col1+1]
            end
        end
      end

    #removing moves that go off the board
    possible_moves = possible_moves.select do |a|
      a[0]>=0 && a[0]<8 && a[1]>=0 && a[1]<8
    end

    return possible_moves

  end
end
