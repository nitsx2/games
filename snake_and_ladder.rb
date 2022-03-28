class Player
	attr_accessor :id, :name, :current_at
	def initialize(id, name)
		@name = name
		@id = id
		@current_at = 0
	end

end

class Board
	attr_accessor :heads, :tails, :size

	def initialize(n)
		@size = n
		@heads = {}
		@tails = {}
	end

end

class BoardEntity
	attr_accessor :head, :tail
	def initialize(head, tail)
		@head = head
		@tail = tail
	end
end

class Snake < BoardEntity
	def initialize(head, tail)
		super(head, tail)
	end

end

class Ladder < BoardEntity
	def initialize(head, tail)
		super(head, tail)
	end
end

class Dice
	attr_accessor :size
	def initialize(n)
		@size = n
	end

	def throw
		rand(@size+1)
	end

end

class Game
	attr_accessor :board, :players, :dice, :current_turn, :winning_move, :winner
	def initialize
		@board = nil
		@players = []
		@dice = nil
		@current_turn = nil
		@winner = nil
		@winning_move = false
	end

	def move(player, number)
		#valid player
		return false if player != @current_turn

		#valid move
		current_position = player.current_at
		new_position = number + current_position
		return false if new_position > @board.size


		snake = @board.heads[new_position] if !@board.heads[new_position].class == Snake
		if !snake.nil?
			new_position = snake.tail
		end

		ladder = @board.tails[new_position] if !@board.tails[new_position].class == Ladder

		if !ladder.nil?
			new_position = ladder.head
		end

		player.current_at = new_position

		if new_position == @board.size
			@winning_move = true
			@winner = player
		else
			if player == @players[0]
				player = @players[1]
			else
				player = @players[0]
			end
			@current_turn = player
		end
		return true
	end

end


class GameBuilder
	attr_accessor :game

	def initialize
		@game = Game.new
	end

	def add_board(n)
		@game.board = Board.new(n)
	end

	def add_dice(n)
		@game.dice = Dice.new(n)
	end

	def add_player(name)
		player =  Player.new(rand().to_s, name)
		if @game.players.empty?
			@game.current_turn = player 
		end
		@game.players << player
	end

	def add_board_entities(entity, head, tail)
		e = entity.new(head,tail)
		if @game.board.heads[head].nil? && @game.board.heads[tail].nil? && @game.board.tails[head].nil?
			@game.board.heads[head] = entity
			@game.board.tails[tail] = entity
		end
	end

	def make_move
		while true
			number = @game.dice.throw
			player = @game.current_turn
			status = @game.move(player, number)
			return @game.winner if @game.winning_move
		end
	end

end


builder = GameBuilder.new
game = builder.game
builder.add_board(100)
builder.add_player("nitin")
builder.add_player("sharma")
builder.add_board_entities(Snake, 35, 10)
builder.add_board_entities(Snake, 70, 2)
builder.add_board_entities(Snake, 85, 5)
builder.add_board_entities(Snake, 99, 1)

builder.add_board_entities(Ladder, 97, 7)
builder.add_board_entities(Ladder, 50, 9)
builder.add_board_entities(Ladder, 80, 20)
builder.add_board_entities(Ladder, 91, 5)
builder.add_dice(6)
o = builder.make_move
p o