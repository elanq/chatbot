module Parser
  module BankerParser
    module_function

    def parse(data)
      data.map do |val|
       ::Model::BankRecord.new(val)
      end
    end
  end
end
