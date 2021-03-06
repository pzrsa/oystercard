class Oystercard
  BALANCE_LIMIT = 90
  MIN_BALANCE = 1
  attr_reader :balance, :entry_station, :journeys

  def initialize
    @balance = 0
    @error_messages = {
      valid_amount: "Please provide a valid amount",
      exceed_limit: "Sorry, you cannot exceed the balance limit of £#{BALANCE_LIMIT}",
      insufficient_fare_balance: "Sorry, your balance is not enough to cover the fare",
      in_journey: "You are already in a journey",
      not_in_journey: "You are not in a journey",
      insufficient_min_balance: "Sorry, you don't have the minimum balance required of £#{MIN_BALANCE}",
    }
    @entry_station
    @journeys = []
  end

  def top_up(amount)
    fail @error_messages[:valid_amount] unless valid_amount?(amount)
    fail @error_messages[:exceed_limit] if exceed_limit?(amount)
    @balance += amount
  end

  def touch_in(entry_station)
    fail @error_messages[:in_journey] if in_journey?
    fail @error_messages[:insufficient_min_balance] if fare_exceeds?(MIN_BALANCE)
    @entry_station = entry_station
  end

  def touch_out(exit_station)
    fail @error_messages[:not_in_journey] unless in_journey?
    deduct(MIN_BALANCE)
    save_journey(exit_station)
    @entry_station = nil
  end

  def in_journey?
    @entry_station != nil
  end

  private

  def deduct(fare)
    fail @error_messages[:insufficient_fare_balance] if fare_exceeds?(fare)
    @balance -= fare
  end

  def valid_amount?(amount)
    (amount.is_a?(Integer) || amount.is_a?(Float)) && (amount.positive?)
  end

  def exceed_limit?(amount)
    @balance + amount > BALANCE_LIMIT
  end

  def fare_exceeds?(fare)
    @balance < fare
  end

  def save_journey(exit_station)
    @journeys.push({entry: @entry_station, exit: exit_station})
  end
end
