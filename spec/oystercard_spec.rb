require 'oystercard'
# require 'journey'

describe OysterCard do
  subject(:card) {described_class.new}
  let(:station) {double :station}

  describe 'initialize' do

    it 'check new card has balance 0' do
      expect(card.balance).to eq(0)
    end
  end

  describe '#top_up' do

    before do
      card.top_up(50)
    end

    it 'when top_up it changes the balance' do
      expect{card.top_up(10)}.to change{card.balance}.by 10
    end

    it 'raises an error if the maximum balance is exceeded' do
      maximum_balance = OysterCard::MAXIMUM_BALANCE
      expect{card.top_up(41)}.to raise_error "Max balance of £#{maximum_balance} exceeded"
    end
  end

  describe '#journey' do


    before do
      card.top_up(50)
    end


    it 'is initially not in a journey' do
      allow(card).to receive(:in_journey?).and_return(false)
      expect(card).not_to be_in_journey
    end

    it 'can touch in' do
      card.touch_in(station)
      expect(card).to be_in_journey
    end

    it 'can touch out' do
      card.touch_in(station)
      card.touch_out(station)
      expect(card).not_to be_in_journey
    end
    it 'when touch_out it deducts amount' do
      card.touch_in(station)
      expect{card.touch_out(station)}.to change{card.balance}.by(-OysterCard::MINIMUM_FARE)
    end

    it 'stores the station entry' do
      expect(card.touch_in(station)).to eq station
    end

    it 'has an empty list of journeys by default' do
      expect(card.journeys).to be_empty
    end

    it 'charges penalty fare if only touched in' do
      subject.touch_in(station)
      expect{ subject.touch_in(station) }.to change{card.balance}.by (-6)
    end

    it 'charges penalty fare if only touched out' do
      expect{ subject.touch_out(station) }.to change{card.balance}.by (-6)
    end


    let(:journey){ {begining_station: station, final_station: station} }

    it 'stores a journey' do

      card.touch_in(station)
      card.touch_out(station)
      expect(card.journeys.size).to eq(1)
    end
  end
  describe '#touch_in' do
  it 'error if card has insufficient balance' do
    card.top_up(1)
    card.touch_in(station)
    card.touch_out(station)
    expect{card.touch_in(station)}.to raise_error "Card has insufficient balance"
  end
  end
end
