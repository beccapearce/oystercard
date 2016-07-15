
class Journey

  MINIMUM_FARE = 1
  PENALTY_FARE = 6

  attr_reader :start_station, :end_station
  def initialize
    @start_station = nil
    @end_station = nil
  end

  def start(station)
    @start_station = station
  end

  def end(station)
    @end_station = station
  end

  def in_journey?
    !!start_station && !end_station
  end

  def completed?
    !!start_station && !!end_station
  end

  def fare
    @fare = completed? ? MINIMUM_FARE : PENALTY_FARE
  end
end
