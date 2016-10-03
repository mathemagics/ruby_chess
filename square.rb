class Square
attr_accessor :occupied
attr_accessor :attacked_white
attr_accessor :attacked_black
attr_accessor :en_passanted

attr_accessor :row
attr_accessor :col

attr_accessor :piece

  def initialize (row,col)
    @occupied = false
    @piece = "empty"
    @row = row
    @col = col
  end

  def place_piece(piece)
    @occupied = true
    @piece = piece
  end

  def remove_piece
    @piece = "empty"
    @occupied =false
  end
  
end
