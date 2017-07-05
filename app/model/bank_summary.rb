# idk y i put these here
class String
  def underscore
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end
end

module Model
  class BankSummary
    def initialize(data)
      @raw_data = data
      data.each do |key, val|
        method_name = key.underscore.to_sym
        define_singleton_method(method_name) do
          return BankRecord.new(val) if ["most_outcome", "most_income"].include?(method_name.to_s)
          val
        end
      end
    end

    def to_json
      JSON.generate(raw_data)
    end

    private
    attr_reader :raw_data
  end
end
