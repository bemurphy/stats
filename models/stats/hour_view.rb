require_relative "view"

module Stats
  class HourView < View
    def self.format_id(time, lesson_id)
      [time.year, time.month, time.day, lesson_id].join(':')
    end

    def key
      hit_time.hour.to_s
    end
  end
end
