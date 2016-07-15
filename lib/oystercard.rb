require_relative 'journey'

class OysterCard
  attr_reader :balance, :entry_station, :journeys

  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1
  MINIMUM_FARE    = 1
  PENALTY_FARE =6

  def initialize(balance = 0)
    @balance = balance
    @journeys = []
    @journey = Journey.new
  end

  def top_up(amount)
    fail "Max balance of £#{MAXIMUM_BALANCE} exceeded" if amount + balance > MAXIMUM_BALANCE
    @balance += amount
  end

  def in_journey?
    @journey.in_journey?
  end

  def touch_in(station)
    fail "Card has insufficient balance" if @balance < MINIMUM_BALANCE
    touch_in_charge
    @journey.start(station)
    @journeys << {entry_station: station}
    station
  end

  def touch_out(station)
    @journey.end(station)
    charge
    @journey = Journey.new
  end

  def touch_in_charge
    @journey.in_journey? ? charge : 0
  end

  def charge
    deduct(@journey.fare)
  end

  private

  def deduct(amount)
    @balance -= amount
  end
end
