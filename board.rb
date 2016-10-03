
require './square.rb'
require './piece.rb'
require "./rook.rb"
require './bishop.rb'
require './king.rb'
require './knight'
require './pawn.rb'
require './queen.rb'
require 'colorize'
require 'colorized_string'
require 'deep_clone'

class Board
@board
attr_accessor :w_in_check
attr_accessor :b_in_check

  def initialize
    @board=Array.new(8) {Array.new(8)}

    @w_in_check=false
    @b_in_check=false

    @wking="\u2654"
    @wqueen="\u2655"
    @wrook="\u2656"
    @wbishop="\u2657"
    @wknight="\u2658"
    @wpawn= "\u2659"

    @bking="\u265A"
    @bqueen="\u265B"
    @brook="\u265C"
    @bbishop="\u265D"
    @bknight="\u265E"
    @bpawn= "\u265F"

  end

  def make_board
      for row in 0..7
        for column in 0..7
          @board[row][column] = Square.new(row,column)

        end
      end
  end

  def make_pieces
    for column in 0..7
      @board[1][column].place_piece(Pawn.new("white"))
    end
    for column in 0..7
      @board[6][column].place_piece(Pawn.new("black"))
    end

    @board[0][0].place_piece(Rook.new("white"))
    @board[0][1].place_piece(Knight.new("white"))
    @board[0][2].place_piece(Bishop.new("white"))
    @board[0][3].place_piece(Queen.new("white"))
    @board[0][4].place_piece(King.new("white"))
    @board[0][5].place_piece(Bishop.new("white"))
    @board[0][6].place_piece(Knight.new("white"))
    @board[0][7].place_piece(Rook.new("white"))
    @board[7][0].place_piece(Rook.new("black"))
    @board[7][1].place_piece(Knight.new("black"))
    @board[7][2].place_piece(Bishop.new("black"))
    @board[7][3].place_piece(Queen.new("black"))
    @board[7][4].place_piece(King.new("black"))
    @board[7][5].place_piece(Bishop.new("black"))
    @board[7][6].place_piece(Knight.new("black"))
    @board[7][7].place_piece(Rook.new("black"))

  end

  def draw_board

      puts "    A  B  C  D  E  F  G  H"
      for rowz in 7.downto(0)
        print " #{rowz+1} "
        for colz in 0..7

          if (rowz+colz)%2==0
            bg_color=:light_white
          else
            bg_color=:default
          end

          if !@board[rowz][colz].occupied
            print "   ".colorize(:background => bg_color)
          else
            if @board[rowz][colz].piece.color=="white"

              case @board[rowz][colz].piece.class.name
              when "Pawn"
                sq_text = " "+ @wpawn.encode('utf-8')+" "
              when "Rook"
                sq_text =  " "+ @wrook.encode('utf-8')+" "
              when "Knight"
                sq_text =  " "+ @wknight.encode('utf-8')+" "
              when "Bishop"
                sq_text =  " "+ @wbishop.encode('utf-8')+" "
              when "Queen"
                sq_text =  " "+ @wqueen.encode('utf-8')+" "
              when "King"
                sq_text =  " "+ @wking.encode('utf-8')+" "
              end

              print sq_text.colorize(:background => bg_color)

            elsif @board[rowz][colz].piece.color=="black"

              case @board[rowz][colz].piece.class.name
              when "Pawn"
                sq_text = " "+ @bpawn.encode('utf-8')+" "
              when "Rook"
                sq_text = " "+ @brook.encode('utf-8')+" "
              when "Knight"
                sq_text = " "+ @bknight.encode('utf-8')+" "
              when "Bishop"
                sq_text = " "+ @bbishop.encode('utf-8')+" "
              when "Queen"
                sq_text = " "+ @bqueen.encode('utf-8')+" "
              when "King"
                sq_text = " "+ @bking.encode('utf-8')+" "
              end
              print sq_text.colorize(:background => bg_color)

            end



          end
        end
        print " #{rowz+1}"
        puts
      end

      puts "    A  B  C  D  E  F  G  H"
    end

  def  get_square(row, col)
    return @board[row][col]
  end

  def remove_enpassant(color)

    if color=="black"
      for i in 0..7
        if get_square(5,i).en_passanted

          get_square(5,i).en_passanted=false
        end
      end
    elsif color=="white"
      p
      for i in 0..7
        if get_square(2,i).en_passanted

          get_square(2,i).en_passanted=false
        end
      end

    end
  end

  def can_castle?(color, side)
    if color=="black"

      kings_sq=get_square(7,4)
      if !kings_sq.occupied
        return false
      end

      if side=="king"
        rooks_sq=get_square(7,7)
        if !rooks_sq.occupied
          return false
        end
        #checking if the king and kingside rook haven't moved
        #and if the squares in between are empty
        #and not under attack
        return rooks_sq.piece.position=="initial" &&
          kings_sq.piece.position=="initial" &&
          !get_square(7,6).occupied && !get_square(7,5).occupied &&
          !get_square(7,6).attacked_white && !get_square(7,5).attacked_white

      elsif side=="queen"
        rooks_sq=get_square(7,0)
        if !rooks_sq.occupied
          return false
        end
        return rooks_sq.piece.position=="initial" &&
          kings_sq.piece.position=="initial" &&
          !get_square(7,1).occupied && !get_square(7,1).attacked_white &&
          !get_square(7,2).occupied && !get_square(7,2).attacked_white &&
          !get_square(7,3).occupied && !get_square(7,3).attacked_white
      end

    elsif color=="white"
      kings_sq=get_square(0,4)
      if !kings_sq.occupied
        return false
      end
      if side=="king"
        rooks_sq=get_square(0,7)
        if !rooks_sq.occupied
          return false
        end
        #checking if the king and kingside rook haven't moved
        #and if the squares in between are empty
        #and not under attack
        return rooks_sq.piece.position=="initial" &&
          kings_sq.piece.position=="initial" &&
          !get_square(0,6).occupied && !get_square(0,5).occupied &&
          !get_square(0,6).attacked_black && !get_square(0,5).attacked_black

      elsif side=="queen"
        rooks_sq=get_square(0,0)
        if !rooks_sq.occupied
          return false
        end
        return rooks_sq.piece.position=="initial" &&
          kings_sq.piece.position=="initial" &&
          !get_square(0,1).occupied && !get_square(7,1).attacked_white &&
          !get_square(0,2).occupied && !get_square(7,2).attacked_white &&
          !get_square(0,3).occupied && !get_square(7,3).attacked_white
      end
    end
  end

  def set_attack(sq, color)
    #takes defender color and sets the attacker's squares
    if color=="black"
      sq.attacked_white=true
    elsif color=="white"
      sq.attacked_black=true
    end
  end

  # takes the defender color and changes the attacked_by_attacker
  # attribute to false in preparation for resetting
  def reset_attack(defender_color)

    for row in 0..7
      for col in 0..7
        if(defender_color=="white")
          get_square(row,col).attacked_black=false
        elsif defender_color=="black"
          get_square(row,col).attacked_white=false
        end


      end
    end
  end

  def check_check(d_color)
      #put in "under attack by color" inside attacked squares"
      #if enemy king is in an attacked square, set check
      #reset the squares currently under attack
      reset_attack(d_color);
      for r1 in 0..7
        for c1 in 0..7
          this_sq = get_square(r1,c1)
          #getting every pieces movelist
          if this_sq.occupied==true
            this_piece=this_sq.piece
            if this_piece.color!=d_color

              attack_arr = this_piece.movement(r1,c1, self)
              # p " #{this_piece.color} #{this_piece.class.name}  =>  #{attack_arr}"
              unless attack_arr.empty?


              #iterating through possible moves and setting under_attack statuses
              for attack in attack_arr
                #refactor this into a function?

                  atkd_sq=get_square(attack[0],attack[1])
                  set_attack(atkd_sq, d_color)

                  #checking for check and setting white_in_check
                  if atkd_sq.piece.class.name=="King"
                    return true
                  end

                end
              end
            end

          end

        end
      end
      return false

    end


    # Gets every possible defending move and checks to see if it removes check
    # returns true if checkmate, false otehrwise

  def check_checkmate(d_color)
    for row in 0..7
      for col in 0..7
        this_sq=self.get_square(row,col)

        if this_sq.occupied==true
          this_piece=this_sq.piece
          #only choosing defenders pieces
          if this_piece.color==d_color
            #getting this piece's move list
            pos_moves = this_piece.movement(row,col,self)

            #For every possible defending move, checking if check remains
            # return false
            unless pos_moves.empty?
              for move in pos_moves
                #creating a board to explore
                board2=DeepClone.clone self
                move_piece(board2, row, col, move[0], move[1])
                #if a move break check, return false
                if !board2.check_check(d_color)
                  return false
                end

              end
            end
          end
        end
      end
    end

    return true
  end

  def promote_pawn

  end

end
