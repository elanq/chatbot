module Model
  # parent class for model tiket
  class Tiket
    attr_reader :name, :dep, :arrival, :duration, :price

    protected

    def parse_text(column)
      column.first.text.strip.gsub(/\n\t+/, '#').split('#') unless column.first.nil?
    end

    def valid_column?(*columns)
      columns.each do |column|
        return false if column.nil?
      end
      true
    end
  end
end
