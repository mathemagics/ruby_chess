require './board.rb'
require './player.rb'
require 'deep_clone'

#   to do:

#   fix: select a different piece via cancel if the piece you chosen
#   if pinned to the king

#  fix: white rook landing on back square. theres some shady promotion stuff
#    promotion check during check_check??

#   castling queenside on white when both castles are open didnt work
#   same with black. kingside, however, worked.

#   refactor to remove player object
#   remove pawn "in front" moves from attack

#   refactor game playing mechanism to eliminate deep nesting

#   rework en passant to only check last pawn move instead of entire row
#   rework pawns to use initial status
#   and change initial status to a boolean

#   add movelist and use it to check enpassant
#   add 'undo'

#   refactor move_piece so it does not accept a board argument but rather is
#   called by the board

#   refactor lots of the code to take advantage of @board being an array
#   refactor the code for sending messages to users on incorrect inputs

#   refactor check_check log to see if w_in_check or b_in_check needed

# m

checkmate=false
turn=true

attacker_c="white"
defender_c="black"

player1=Player.new("white")
player2=Player.new("black")

board=Board.new
board.make_board
board.make_pieces

def move_piece(board, row1, col1, row2, col2)

 dest=board.get_square(row2,col2)
 origin=board.get_square(row1, col1)
 atk_color=origin.piece.color

 # castling movement
 if origin.piece.class.name=="King" && board.can_castle?(atk_color,"king")

   if (atk_color=="black" && dest.row==7 && dest.col==6)
     board.get_square(7,6).place_piece(origin.piece)
     board.get_square(7,5).place_piece(board.get_square(7,7).piece)
     board.get_square(7,7).remove_piece
     origin.remove_piece
   elsif (atk_color=="white" && dest.row==0 && dest.col==6)

     board.get_square(0,6).place_piece(origin.piece)
     board.get_square(0,5).place_piece(board.get_square(0,7).piece)
     board.get_square(0,7).remove_piece
     origin.remove_piece
   end
 elsif origin.piece.class.name=="King" && board.can_castle?(atk_color,"queen")
   if (atk_color=="black" && dest.row==7 && dest.col==2)
     board.get_square(7,2).place_piece(origin.piece)
     board.get_square(7,3).place_piece(board.get_square(7,0).piece)
     origin.remove_piece
     board.get_square(7,0).remove_piece
   elsif (atk_color=="white")
     board.get_square(0,2).place_piece(origin.piece)
     board.get_square(0,3).place_piece(board.get_square(0,0).piece)
     origin.remove_piece
     board.get_square(0,0).remove_piece
   end
 else
    if origin.piece.class.name=="Pawn"
     #setting en passant
     if (origin.piece.position=="initial")
        if atk_color == "black" &&  (dest.row-origin.row==-2)
          board.get_square(row1-1,col1).en_passanted=true;
        elsif atk_color == "white" && (dest.row-origin.row==2)
          board.get_square(row1+1,col1).en_passanted=true;
        end
     end

     if dest.en_passanted
       board.get_square(row1,col2).remove_piece
     end

     if dest.row==7 || dest.row==0
        print  "Promote pawn to which piece? N, B, R or Q? > "
        promote = gets.chomp.downcase
        while promote!='n' && promote!='b' && promote!='r' && promote !='q'
          print  "Promote pawn to which piece? N, B, R or Q? > "
          promote = gets.chomp.downcase
        end
        case promote
        when 'n'
          origin.piece= Knight.new(atk_color)
        when 'b'
          origin.piece= Bishop.new(atk_color)
        when 'r'
          origin.piece= Rook.new(atk_color)
        when 'q'
          origin.piece= Queen.new(atk_color)
        end

     end
    end

   origin.piece.position="moved"
   dest.place_piece(origin.piece)
   origin.remove_piece
  end
end

def valid_input(input)
  return input!=nil && input.length==2 && input[0].downcase.ord.between?(97,104) &&
  input[1].to_i.between?(1,8)
end

def convert_to_array(move)
  return [move[1].to_i-1,move[0].downcase.ord-97]
end

def print_movelist(piece,pos)
  print "#{piece.class.name} at #{chosen[0].upcase}#{chosen[1]}"
  print "Possible Moves: "

  board.get_square(r1,c1).piece.movement(r1,c1,board).each do |x|
    print "#{(x[1]+97).chr.upcase}#{x[0]+1}  "
  end
end


while (!checkmate)

  while(turn)

    board.draw_board

    board.remove_enpassant(attacker_c)

    # THis may need some tweaking or refactoring if its okay as it is...
    if board.w_in_check || board.b_in_check
      print "CHECK! "
    end

    print "#{attacker_c} to move. Select your Piece  > "
    valid=false
    valid_move=false

    while(!valid)

      chosen = gets.chomp
      #checking is input is valid
      if valid_input(chosen)

        #translating to array notation
        r1c1 = convert_to_array(chosen)
        r1=r1c1[0]
        c1=r1c1[1]
        in_piece=board.get_square(r1, c1).piece

        #Checking if this is your piece
        if (in_piece!="empty" && in_piece.color == attacker_c)

          # Showing player the possible moves
          print "#{in_piece.class.name} at #{chosen[0].upcase}#{chosen[1]}. "
          print "Moves: "
          in_piece.movement(r1,c1,board).each do |x|
            print "#{(x[1]+97).chr.upcase}#{x[0]+1}  "
          end
          puts

          print "Type in destination or 'cancel' > "

          while(!valid_move)

            move = gets.chomp
            #checking if destination input is valid
            if valid_input(move)

              r2c2 = convert_to_array(move)
              r2=r2c2[0]
              c2=r2c2[1]
              possible_moves=in_piece.movement(r1,c1,board)

              #if the given move is a possible move: do it & switch turns
              if possible_moves.include? [r2,c2]

                board2=DeepClone.clone board
                move_piece(board2, r1, c1, r2, c2)

                #checking if your move places either you or enemy in check
                board2.w_in_check = board2.check_check("white")
                board2.b_in_check = board2.check_check("black")
                checkmate = board2.check_checkmate(defender_c)
                if checkmate
                  board2.draw_board
                  puts " CHECKMATE! #{attacker_c.upcase} WINS!"
                  valid_move=true
                  valid=true
                  turn=false
                  break
                end
                if attacker_c=="white"  && board2.w_in_check
                  board.draw_board
                  p "Your king would be in check, try again"

                  #check this! and...
                  valid_move=true

                elsif attacker_c=="black" && board2.b_in_check
                  board.draw_board
                  p "Your king would be in check, try again"
                  #check this
                  break
                else

                  board=DeepClone.clone board2
                  attacker_c=="white" ? defender_c="white" : defender_c="black"
                  attacker_c=="white" ? attacker_c="black": attacker_c="white"
                  valid=true
                  valid_move=true
                end


              else
                board.draw_board
                p "You can't go there! Try again or 'cancel'"

                p "#{board.get_square(r1,c1).piece.class.name} at #{chosen[0].upcase}#{chosen[1]}"
                print "Possible Moves: "

                board.get_square(r1,c1).piece.movement(r1,c1,board).each do |x|
                  print "#{(x[1]+97).chr.upcase}#{x[0]+1}  "
                end
              end

            elsif move.downcase == "cancel"
              board.draw_board
              p "Select a Piece!  >"
              break

            else
              board.draw_board
             # print_movelist()
              p "Invalid Input! Try again or 'cancel' "
              p "#{in_piece.class.name} at #{chosen[0].upcase}#{chosen[1]}"
              print "Possible Moves: "

              board.get_square(r1,c1).piece.movement(r1,c1,board).each do |x|
                print "#{(x[1]+97).chr.upcase}#{x[0]+1}  "
              end

            end
          end

        else
          board.draw_board
          p "Not a valid selection, make another selection  >"

        end
      else
      board.draw_board
      p "Not a valid input!  Try again!>"
      end
    end

  end
end
