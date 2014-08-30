require_relative "view"

module Stats
  class TotalView < View
    def self.format_id(time, lesson_id)
      lesson_id.to_s
    end

    def key
      'all'
    end
  end
end
