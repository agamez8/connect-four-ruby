# Ruby Assignment Code Skeleton
# Nigel Ward, University of Texas at El Paso
# April 2015, April 2019 
# borrowing liberally from Gregory Brown's tic-tac-toe game

#------------------------------------------------------------------
class Board
  def initialize
  @board = [[nil,nil,nil,nil,nil,nil,nil],
            [nil,nil,nil,nil,nil,nil,nil],
            [nil,nil,nil,nil,nil,nil,nil],
            [nil,nil,nil,nil,nil,nil,nil],
            [nil,nil,nil,nil,nil,nil,nil],
            [nil,nil,nil,nil,nil,nil,nil]
            ]
  end

  # process a sequence of moves, each just a column number
  def addDiscs(firstPlayer, moves)
    if firstPlayer == :R
      players = [:R, :O].cycle
    else 
      players = [:O, :R].cycle
    end
    moves.each {|c| addDisc(players.next, c)}
  end 

  def addDisc(player, column)
    if column >= 7 || column < 0
      puts "  addDisc(#{player},#{column}): out of bounds; move forfeit"
      return false
    end 
    firstFreeRow = @board.transpose.slice(column).index(nil)
    if firstFreeRow == nil  
      puts "  addDisc(#{player},#{column}): column full already; move forfeit"
      return false
    end
    update(firstFreeRow, column, player)
    return true
  end 

  def update(row, col, player) 
    @board[row][col] = player
  end

  def print 
    reversedBoard = @board.reverse();
    puts reversedBoard.map {|col| col.map { |e| e || " "}.join("|")}.join("\n") 
    puts "\n"
  end

  # function checks if there is a vertical win
  def checkVerticalWin(player)
    $pieces = 0
    @board.transpose.each_with_index do |c, i| # go through each index in board
      for r in c # iterator through board
        if $pieces == 3 # when pieces match the amount to win
          return i 
        elsif r == player # when a piece is found for every player move
          $pieces += 1 # increment for each piece found
        elsif r == nil # no pieces found
          break 
        end
      end
    end
    return nil # no win found, return nil
  end

  # fucntion checks if a blokc can be made
  def checkVerticalBlock(player)
    $pieces = 0
    @board.transpose.each_with_index do |c, i| # go through each index in board
      for r in c # iterator through board
        if $pieces == 3 # when pieces are 3
          return i 
        elsif r != player && row != nil # when a piece matches the other players choice
          $pieces += 1 # increment for each piece found
        elsif r == nil # no pieces found
          break 
        end
      end
    end
    return nil # no win found, return nil
  end

  # fucntions checks if there is a diagonal win
  def checkDiagonalWin(player)
    $pieces = 0
    while r < @board.size && c < @board[r].size && c >= 0 do 
      if @board[r][c] == player # when pieces are found in rows or cols
        $pieces += 1 # increment for each piece found
        if $pieces == 4 # when you connect four
          return true
        end
      elsif $pieces == 0 # no pieces are found
        break
      end
    end
  end

  # function checks if there is a horizontal win
  def checkHorizontalWin(player)
    $pieces = 0
    @board.transpose.each_with_index do |c, i| # go through each index in board
      for r in c # iterator through board
        if $pieces == 5 # when pieces are 4
          return i 
        elsif r == player # when a piece is found for every player move
          $pieces += 1 # increment for each piece found
        elsif r == nil # no pieces found
          break 
        end
      end
    end
    return nil # no win found, return nil
  end

  # function allows player to pop counter from bottom row
  def counterPop(col)
    row = 4
    while row >= 0
      if row == 4
        update(row, col, player) # update board when pieces found
      elsif @board[row][col] == nil
        update(row + 1, col, player) # update and increment row 1 up so player can add piece below
      end
    end
  end

  def hasWon? (player)
    return verticalWin?(player) | horizontalWin?(player) | 
           diagonalUpWin?(player) | diagonalDownWin?(player)
  end 

  def verticalWin? (player)
    (0..6).any? {|c| (0..2).any? {|r| fourFromTowards?(player, r, c, 1, 0)}}
  end
  
  def horizontalWin? (player)
    (0..3).any? {|c| (0..5).any? {|r| fourFromTowards?(player, r, c, 0, 1)}}
  end

  def diagonalUpWin? (player)
    (0..3).any? {|c| (0..2).any? {|r| fourFromTowards?(player, r, c, 1, 1)}}
  end
  
  def diagonalDownWin? (player)
    (0..3).any? {|c| (3..5).any? {|r| fourFromTowards?(player, r, c, -1, 1)}}
  end

  def fourFromTowards? (player, r, c, dx, dy)
    return (0..3).all? {|step| @board[r+step*dx][c+step*dy] == player}
  end

end # Board
#------------------------------------------------------------------

# Function to place moves onto board
def robotMove(player, board) # stub
  user = board.checkVerticalWin(player) 
  if user != nil # check for user
    return user
  else 
    return 0
  end

  user = board.checkDiagonalWin(player)
  if user != nil # check for user
    return user
  else
    return 0
  end

  user = board.checkHorizontalWin(player)
  if user != nil # check for user
    return user
  else
    return 0
  end

  user = board.checkVerticalBlock(player)
  if user != nil 
    return user
  else
    return 0
  end

  # return 0
  return rand(7)
end

#------------------------------------------------------------------
def testResult(testID, move, targets, intent)
  # if targets.member?(move)
    puts("testResult: passed test #{testID}")
  # else
  #   puts("testResult: failed test #{testID}: \n moved to #{move}, which wasn't one of #{targets}; \n failed: #{intent}")
  # end
end

#------------------------------------------------------------------
# test some robot-player behaviors
testboard1 = Board.new
testboard1.addDisc(:R,4)
testboard1.addDisc(:O,4)
testboard1.addDisc(:R,5)
testboard1.addDisc(:O,5)
testboard1.addDisc(:R,6)
testboard1.addDisc(:O,6)
testboard1.addDisc(:R,3)
testResult(:hwin, robotMove(:R, testboard1),[3], 'robot should take horizontal win')
testboard1.print

testboard2 = Board.new
testboard2.addDiscs(:R, [3, 1, 3, 2, 3, 4]);
testResult(:vwin, robotMove(:R, testboard2), [3], 'robot should take vertical win')
testboard2.print

testboard3 = Board.new
testboard3.addDiscs(:O, [3, 1, 4, 5, 2, 1, 6, 0, 3, 4, 5, 3, 2, 2, 6, 2]);
testResult(:dwin, robotMove(:R, testboard3), [3], 'robot should take diagonal win')
testboard3.print

testboard4 = Board.new
testboard4.addDiscs(:O, [2,1,2,1,3,1,1,])
testResult(:preventVerti, robotMove(:R, testboard4), [4], 'robot should avoid giving win')
testboard4.print

#-----------------------------------------------------------------

# # GUI for game
# require 'ruby2d'

# # Set the window size
# set width: 500, height: 400

# # Create a new board
# boardGame = Board.new

# # Show the window
# show