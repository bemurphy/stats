require_relative "view"

module Stats
  class DailyView < View
    def self.format_id(time, lesson_id)
      "#{time.year}:#{lesson_id}"
    end

    def key
      "#{hit_time.month}.#{hit_time.day}"
    end
  end
end
