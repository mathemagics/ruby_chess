 require "./piece.rb"

class Rook < Piece

  def initialize(color)
    super(color)
  end

    def movement(row1, col1,board)

      possible_moves = Array.new

      r1=row1+1
      c1=col1
      while r1<8

        this_sq=board.get_square(r1,c1)
        if this_sq.occupied==true && this_sq.piece.color == @color
          break;
        elsif this_sq.occupied==true && this_sq.piece.color != @color
          possible_moves << [r1,c1]
          break
        end

        possible_moves << [r1,c1]
        r1+=1
      end

      r1=row1-1
      c1=col1
      while r1>=0
        this_sq=board.get_square(r1,c1)
        if this_sq.occupied==true && this_sq.piece.color == @color
          break;
        elsif this_sq.occupied==true && this_sq.piece.color != @color
          possible_moves << [r1,c1]
          break
        end

        possible_moves << [r1,c1]
        r1-=1

      end

      r1=row1
      c1=col1+1
      while c1<8
        this_sq=board.get_square(r1,c1)
        if this_sq.occupied==true && this_sq.piece.color == @color
          break;
        elsif this_sq.occupied==true && this_sq.piece.color != @color
          possible_moves << [r1,c1]
          break
        end

        possible_moves << [r1,c1]
        c1+=1

      end

      r1=row1
      c1=col1-1
      while c1>=0
        this_sq=board.get_square(r1,c1)
        if this_sq.occupied==true && this_sq.piece.color == @color
          break;
        elsif this_sq.occupied==true && this_sq.piece.color != @color
          possible_moves << [r1,c1]
          break
        end
        possible_moves << [r1,c1]
        c1-=1

      end

          return possible_moves

        end



end
