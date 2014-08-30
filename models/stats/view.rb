module Stats
  class View
    include Collection

    def record
      upsert = {'$inc' => {}}
      upsert['$inc']["#{key}.t"] = 1

      if hit.unique
        upsert['$inc']["#{key}.u"] = 1
      end

      collection.find(_id: id).upsert(upsert)
    end

    def key
      raise NotImplementedError
    end

    def id
      self.class.format_id(hit_time, hit.lesson_id)
    end
  end
end
