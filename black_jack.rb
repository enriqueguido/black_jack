class Blackjack

  def initialize
    start_game
    # @player = Player.new
  end

  def start_game
    Game.new

  end

  class Player
    def initialize
      create_player

    end

    def create_player
      puts "Welcome to Black Jack. Enter your age to get started!"
      age = gets.chomp.to_i
      age_check(age)
      puts "What should we call you?"
      name = gets.chomp.downcase
    end

    def age_check(age)
      if age < 21
        puts "You are too young to play"
        exit
      elsif age>= 21
        puts "Thank you!"
        puts "You may begin playing"
      end
    end
  end


  class Card

    attr_reader :suit, :value

    def initialize(suit, value)
      @suit = suit
      @value = value
    end

    def value
      if ["J", "Q", "K"].include?(@value)
        return 10
      elsif @value == "A"
        return 11
      else
        @value
      end
    end

    def to_s
      "#{@value}-#{suit}"
      # "A-Diamonds"
    end
  end
#
  class Deck

    attr_reader :cards

    def initialize
      @cards = Deck.build_cards
    end

    def self.build_cards
      cards = []
      [:clubs, :diamonds, :spades, :hearts].each do |suit|
        (2..10).each do |number|
          cards << Card.new(suit, number)
        end
        ["J", "Q", "K", "A"].each do |facecard|
          cards << Card.new(suit, facecard)
        end
      end
      cards.shuffle
    end
  end


  class Hand

    attr_reader :cards

    def initialize
      @cards = []
    end
    def hit!(deck)
      card = deck.cards.shift
      @cards << card
      puts card
    end

    def values
      cards.inject(0) do |sum, card|
        sum += card.value
      end
    end

    def play_as_dealer(deck)
      if value < 16
        hit!(deck)
        play_as_dealer(deck)
      end
    end
  end


  class Game

    attr_reader :player_hand, :dealer_hand

    def initialize
      Player.new
      @deck = Deck.new
      @player_hand = Hand.new
      @dealer_hand = Hand.new

      puts "Player cards:"
      2.times { @player_hand.hit!(@deck) }

      puts "Dealer cards:"
      2.times { @dealer_hand.hit!(@deck) }

      winner = determine_winner(@player_hand.values, @dealer_hand.values)
      # p winner

      puts "Would you like to hit or stand?"
      option = gets.chomp.downcase
      if option == "stand"
        # puts "This is your final hand #{status[:player_cards]}"
        # puts "This is the dealer hand #{status[:dealer_cards]}"
        puts winner
        if @player_hand.values < @dealer_hand.values
          puts "Sorry you lose! Better luck next time!"
          puts "Press enter to start a new hand or type exit to finish the game"
          option = gets.chomp.downcase
          if option == "exit"
            exit
          else
            Game.new
          end
        else @dealer_hand.values < @player_hand.values
          puts @dealer_hand.hit!(@deck)
          while @dealer_hand.values < 21 do
            @dealer_hand.hit!(@deck)
            until @dealer_hand.values >= 21
            end
          end
        end
        if @dealer_hand.values > 21
          puts "Congratulations you are the winer!"
          puts "Press enter to start a new hand or type exit to finish the game"
          option = gets.chomp.downcase
          if option == "exit"
            exit
          else
            Game.new
          end
        end
      else option == "hit"
        puts "Player cards:"
        puts @player_hand.hit!(@deck)
        while @player_hand.values < 21 do
          puts "Would you like to hit or stand?"
          option = gets.chomp.downcase
          if option == "hit"
            puts "Player cards:"
            puts @player_hand.hit!(@deck)
            # end
            until @player_hand.values > 21
              puts winner
              puts "Sorry you lose! Better luck next time!"
              puts "Press enter to start a new hand or type exit to finish the game"
              option = gets.chomp.downcase
              if option == "exit"
                exit
              else
                Game.new
              end
              # if option == "stand" || @player_hand.values > 21
              #   puts "The winner is #{winner}"
              # end
            end
          end
        end
      end
    end

    def hit
      @player_hand.hit!(@deck)
    end

    def stand
      @dealer_hand.play_as_dealer(@deck)
      @winner = determine_winner(@player_hand.values, @dealer_hand.values)
    end

    def status
      {
        :player_cards => @player_hand.cards,
        :player_value =>@player_hand.values,
        :dealer_cards => @dealer_hand.cards,
        :dealer_value => @dealer_hand.values,
        :winner => @winner
      }
    end

    def determine_winner(player_value, dealer_value)
        # player_hand = @player_hand.value
        if player_value > 21
          return :dealer
        elsif dealer_value > 21
          return :player
        elsif player_value == dealer_value
          :push
        elsif player_value > dealer_value
          return :player
        else
          return :dealer
      end
   end

    def inspect
      status
    end
  end
end

Blackjack.new
