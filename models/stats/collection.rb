module Stats
  module Collection
    class ZeroData < Hash
      def [](key)
        self.class.new
      end

      def to_i
        0
      end

      def to_s
        to_str
      end

      def to_str
        '0'
      end
    end

    def self.included(base)
      base.send(:attr_reader, :hit)
      base.extend(ClassMethods)
    end

    def initialize(hit)
      @hit = hit
    end

    def hit_time
      @hit.time
    end

    def db
      self.class.db
    end

    def collection
      self.class.collection
    end

    def id
      self.class.format_id(hit_time, lesson_id)
    end

    module ClassMethods
      def db
        @@db ||=
          begin
            db = Moped::Session.new(["127.0.0.1:27017"])
            db.use :stats
            db
          end
      end

      def record(hit)
        new(hit).record
      end

      def collection
        @collection ||= db[collection_name]
      end


      def collection_name
        name.downcase.gsub(/[^a-z]+/i, '_')
      end

      def format_id(time, lesson_id)
        raise NotImplementedError
      end

      def get(time, lesson_id)
        collection.find(_id: format_id(time, lesson_id)).select(_id: 0).first ||
          ZeroData.new
      end
    end
  end
end
