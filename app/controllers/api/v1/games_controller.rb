module Api
  module V1
    # Class destined to handle all requests related to minesweeper game
    class GamesController < ApplicationController
      before_action :validate_parameters, only: :create
      before_action :set_tiles_params, only: :create
      before_action :set_game, only: %i[play pause flag]
      before_action :start_game, only: %i[play flag]
      after_action  :set_victory, only: %i[play]

      def create
        @game = Game.new
        @game.tiles.build
        @game = Game.new(game_params)

        if @game.save
          render_response(true , 'Game created!', @game, :ok)
        else
          render_response(false ,  @game.errors.full_messages, [], :unprocessable_entity)
        end
      end

      def play
        adjacent = []

        tile = @game.tiles.find_by(played: false, flagged: 0, key_name: params[:key_name])

        if tile.bomb
          tile.played = true
          tile.bomb = 3
          message = 'BOOM! Game over'
          @game.lost!
        elsif tile.near_bombs.positive?
          tile.played = true
          message = "Near bombs: #{tile.near_bombs}"
        else
          tile.played = true
          @tiles_played = 1
          click_on_zeroed(tile, adjacent)
          message = "Tile zeroed. Total tiles open: #{@tiles_played}"
        end

        if tile.save
          victory = set_victory
          render json: { success: true, message: victory || message, data: tile }, status: :ok
        else
          render json: tile.errors, status: :unprocessable_entity
        end
      rescue NoMethodError
        render_response(false, 'No existing tile', [], :not_found)
      end

      def pause
        @game.paused!
        @game.update_attribute(:elapsed_time, elapsed_time)

        render_response(true, 'Game paused', @game, :ok)
      end

      def flag
        return render_response(
          false , 'Missing flag', [], status = :unprocessable_entity
        ) unless params[:flag]

        tile = @game.tiles.find_by(key_name: params[:key_name], played: false)
        tile.send(params[:flag]+'!')

        render_response(true, "Flag: #{tile.flagged}", tile, :ok)
      rescue ArgumentError
        render_response(false, 'Invalid flag parameter', [], :unprocessable_entity)
      rescue NoMethodError
        render_response(false, 'No existing tile', [], :not_found)
      end

      def set_victory
        if @game.tiles.where(bomb: false, played: false).count.zero?
          @game.won!
          @game.update_attribute(:elapsed_time, elapsed_time)
          'You WON the game!!!'
        end
      end

      private

      def game_params
        params.require(:game).permit(:matrix, :level, :starting_time, :elapsed_time, :status, :user_id,
                                     tiles_attributes: [:key_name, :near_bombs, :flagged, :played, :bomb, :game_id]
        ).merge(user_id: current_user.id)
      end

      def set_game
        @game = current_user.games.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render_response(false, 'Game not found', [], :not_found)
      end

      def validate_parameters
        error = missing_params || malformed_params

        render_response(
          false, 'Malformed parameters', [], :bad_request
        ) if error
      end

      def missing_params
        true if !(params[:game].keys & %w[matrix level] == %w[matrix level]) ||
          params[:game][:matrix].nil? ||
          params[:game][:level].nil?
      end

      def malformed_params
        true if (params[:game][:matrix] =~ /\A\d+\Z/).nil? || (params[:game][:matrix] =~ /\A\d+\Z/).nil?
      end

      def set_tiles_params
        params[:game][:level] = params[:game][:level].to_i

        board = BoardGenerator.new(game_params[:matrix].to_i, Game::BOMB_CHANCE[game_params[:level].to_i]).call

        params[:game].merge!(tiles_attributes: {})

        board.each_with_index do |brd, i|
          params[:game][:tiles_attributes].merge!("#{i}":
                                                    { key_name: brd.first,
                                                      near_bombs: brd.last.adjacent_bombs,
                                                      flagged: 0,
                                                      played: false,
                                                      bomb: brd.last.is_bomb?
                                                    }
          )
        end
      end

      # Start/restart game and set start time
      def start_game
        return if @game.progress?

        if @game.stopped? || @game.paused?
          @game.update!(starting_time: Process.clock_gettime(Process::CLOCK_MONOTONIC), status: 1)
        else
          render_response(
            false, 'Cannot restart a finished game', @game, :forbidden
          ) and return
        end
      end

      def elapsed_time
        (Process.clock_gettime(Process::CLOCK_MONOTONIC) - @game.starting_time) + @game.elapsed_time
      end

      def click_on_zeroed(tile, adjacent)
        row, column = tile.key_name.split(',').map(&:to_i)
        adjacent << "#{row},#{column+1}"
        adjacent << "#{row},#{column-1}"
        adjacent << "#{row-1},#{column+1}"
        adjacent << "#{row-1},#{column}"
        adjacent << "#{row-1},#{column-1}"
        adjacent << "#{row+1},#{column+1}"
        adjacent << "#{row+1},#{column}"
        adjacent << "#{row+1},#{column-1}"

        adjacent.each do |adj|
          adj_tile = @game.tiles.find_by(key_name: adj)
          adjacent.delete(adj)
          next if adj_tile.nil?
          if adj_tile.near_bombs > 0
            adj_tile.update_attribute(:played, true)
            @tiles_played += 1
            return
          elsif !adj_tile.nil? && !adj_tile.played
            adj_tile.update_attribute(:played, true)
            @tiles_played += 1
            click_on_zeroed(adj_tile, adjacent)
          end
        end
      end

      def render_response(success, message, data, status = :ok)
        render json: { success: success, message: message, data: data }, status: status
      end
    end
  end
end
