module Model
  # parent class for model tiket
  class Tiket
    attr_reader :name, :dep, :arrival, :duration, :price
    def initialize(schedule)
      column_1 = parse_text(schedule.css('.td1'))
      column_2 = parse_text(schedule.css('.td2'))
      column_3 = parse_text(schedule.css('.td3'))
      column_4 = parse_text(schedule.css('.td4 > div'))
      column_5 = parse_text(schedule.css('.td5').css('.td5a > div'))

      @name = column_1[0]
      @dep = column_2[1]
      @arrival = column_3[1]
      @duration = column_4[0]
      @price = column_5[0]
    end

    def to_s
      "#{@name} #{@dep} ke #{@arrival} selama #{@duration} sebesar #{@price}"
    end

    private

    def parse_text(column)
      column.first.text.strip.gsub(/\n\t+/, '#').split('#')
    end
  end
end
