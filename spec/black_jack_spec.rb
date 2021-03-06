require './black_jack'

describe Player do
  it "should have an age of 21 or older" do
    player = Player.new(:name, 21)
    # expect(player.name).to eq("Max")
    expect(player.age).to eq(21)
  end
end

describe Card do
  it "should accept suit and value when building" do
    card = Card.new(:clubs, 10)
    expect(card.suit).to eq(:clubs)
    expect(card.value).to eq(10)
  end
  it "should have a value of 10 for facecards" do
    facecards = ["J", "Q", "K"]
    card = Card.new(:hearts, "J")
    expect(card.value).to eq(10)
    facecards.each do |facecard|
    end
  end
  it "shoulf have a value of 4 for the 4-clubs" do
    card = Card.new(:clubs, 4)
    expect(card.value).to eq(4)
  end
  it "should return 11 for Ace" do
    card = Card.new(:diamonds, "A")
    expect(card.value).to eq(11)
  end
  it "should be formatted" do
    card = Card.new(:diamonds, "A")
    expect(card.to_s).to eq("A-diamonds")
  end
end

describe Deck do
  it "should build 52 cards" do
    expect(Deck.build_cards.length).to eq(52)
  end
  it "should have 52 cards when new deck" do
    expect(Deck.new.cards.length).to eq(52)
  end
end

describe Hand do

  xit "should calculate the value correctly" do
    deck = Deck.new
    hand = Hand.new
    52.times {hand.hit!(deck)}
    expect(hand.values).to eq(380)
  end
  it "should take from the top of the deck" do
    club4 = Card.new(:clubs, 4)
    diamond7 = Card.new(:diamonds, 7)
    clubK = Card.new(:clubs, "K")

    deck = mock(:deck, :cards => [club4, diamond7, clubK])
    hand = Hand.new
    2.times { hand.hit!(deck) }
    hand.cards.should eq([club4, diamond7])
  end
describe "#play_as_dealer" do
  it "should hit below 16" do
    deck = mock(:deck, :cards => [Card.new(:clubs, 4), Card.new(:diamonds, 4), Card.new(:clubs, 2), Card.new(:hearts,6)])
    hand = Hand.new
    2.times{hand.hit!(deck)}
    hand.play_as_dealer(deck)
    expect(hand.value).to eq(16)
  end
  it "should not hit above 16" do
    deck = mock(:deck, :cards => [Card.new(:clubs, 8), Card.new(:diamonds, 9)])
    hand = Hand.new
    2.times{hand.hit!(deck)}
    hand.play_as_dealer(deck)
    expect(hand.value).to eq(17)
  end
  it "should stop on 21" do
     deck = mock(:deck, :cards => [
       Card.new(:clubs, 4),
       Card.new(:diamonds, 7),
       Card.new(:clubs, "K")
     ])
     hand = Hand.new
     2.times { hand.hit!(deck) }
     hand.play_as_dealer(deck)
     hand.value.should eq(21)
   end
 end
end

describe Game do
  it "should have a players hand" do
    expect(Game.new.player_hand.cards.length).to eq(2)
  end
  it "should have a dealers hand" do
    expect(Game.new.dealer_hand.cards.length).to eq(2)
  end
  it "should have a status" do
    expect(Game.new)
  end
  it "should hit when I tell it to" do
    game = Game.new
    game.hit
    expect(game.player_hand.cards.length).to eq(3)
  end

  it "should play the dealer hand when I stand" do
    game = Game.new
    game.stand
    expect(game.status[:winner]).to_not be(nil)
  end

  describe "#determine_winner" do
    it "should have dealer win when player busts" do
      Game.new.determine_winner(22, 15).should eq(:dealer)
    end
    it "should player win if dealer busts" do
      Game.new.determine_winner(18, 22).should eq(:player)
    end
    it "should have player win if player > dealer" do
      Game.new.determine_winner(18, 16).should eq(:player)
    end
    it "should have push if tie" do
      Game.new.determine_winner(16, 16).should eq(:push)
    end
  end
end
