module Stats
  class Hit
    attr_reader :time, :lesson_id, :unique

    def initialize(time, lesson_id, unique)
      @time      = time
      @lesson_id = lesson_id
      @unique    = !!unique
    end

    def record
      HourView.new(self).record
      DailyView.new(self).record
      TotalView.new(self).record
    end
  end
end
