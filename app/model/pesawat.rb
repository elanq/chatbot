module Model
  # model for pesawat
  class Pesawat < Model::Tiket
    def initialize(schedule)
      column_1 = parse_text(schedule.css('.td1 > .flight_mark > h6'))
      column_2 = parse_text(schedule.css('.td2'))
      column_3 = parse_text(schedule.css('.td3'))
      column_5 = parse_text(schedule.css('.td7 > h3'))

      raise Crawler::InvalidTableColumn unless valid_column?(column_1, column_2, column_3, column_5)

      @name = column_1[0]
      @dep = column_2[1]
      @arrival = column_3[1]
      @price = column_5[0]
    end

    def to_s
      "#{@name} #{@dep} ke #{@arrival} sebesar #{@price}"
    end
  end
end
