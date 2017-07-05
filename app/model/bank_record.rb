module Model
  class BankRecord
    def initialize(data)
      @raw_data = data
      data.each do |key, val|
        define_singleton_method(key) { val }
      end
    end

    def id
      self._id
    end

    def to_json
      JSON.generate @raw_data
    end
  end

  private
  attr_reader :raw_data
end
