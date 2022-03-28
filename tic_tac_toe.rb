class Board
	attr_accessor :size, :boxes
	def initialize(size)
		@size = size
		@boxes = Array.new(size){Array.new(size)}
	end

	def check_row(number, entity)
		row = @boxes[number]
		row.each do |ent|
			return false if ent != entity
		end
		return true
	end

	def check_column(number, entity)
		for i in (0..@size-1)
			return false if @boxes[i][number] != entity
		end
		return true
	end

	def check_left_diagonal(entity)
		@size.times do |i|
			return false if entity != @boxes[i][i]
		end
		return true
	end

	def check_right_diagonal(entity)
		@size.times do |i|
			return false if entity != @boxes[i][@size-1-i]
		end
		return true
	end

end

class Player
	attr_accessor :id, :name, :total_wins, :rank, :entity
	def initialize(id, name, entity)
		@id = id
		@name = name
		@entity = entity
	end
end




class BoardEntity
end

class O < BoardEntity
end

class X < BoardEntity
end

class Game
	attr_accessor :board, :players, :winner, :winning_move, :current_turn, :entity_player_map

	def initialize
		@players = []
		@entity_player_map = {}
		@current_turn = nil
		@winning_move = nil
		@winner = nil
		@board = nil
	end

	def move(player, row, col)
		#valid player
		return false if player != @current_turn

		#valid move
		return false if row >= @board.size || col >= @board.size
		return false unless @board.boxes[row][col].nil?
		entity = player.entity
		#move
		@board.boxes[row][col] = player.entity
		row_crossed = @board.check_row(row, entity)
		col_crossed = @board.check_column(col, entity)
		dig1_crossed = @board.check_left_diagonal(entity)
		dig2_crossed = @board.check_right_diagonal(entity)		

		if row_crossed || col_crossed || dig1_crossed || dig2_crossed
			@winner = player
			@winning_move = true
		end

		if player == @players[0]
			@current_turn = @players[1]
		else
			@current_turn = @players[0]
		end

	end

end


class GameBuilder
	attr_accessor :game 
	def initialize
		@game = Game.new
	end

	def add_board(size)
		@game.board = Board.new(size)
	end
	
	def add_player_and_entity(name, entity)
		if @game.entity_player_map[entity].nil?
			player = Player.new(rand().to_s, name, entity)
			@game.players << player
			@game.entity_player_map[entity] = player
			@game.current_turn = player if @game.current_turn.nil?
		end
	end

	def play
		while true
			row = rand(@game.board.size)
			col = rand(@game.board.size) 
			@game.move(@game.current_turn, row, col)
			return @game.winner, @game.board if @game.winning_move
		end
	end

end

builder = GameBuilder.new
builder.add_board(6)
builder.add_player_and_entity("nitin", X)
builder.add_player_and_entity("sharmaa", O)
winner, board = builder.play
p winner
p board