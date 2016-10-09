# query checking
module Query
  module_function

  def asking_help?
    /BANTU|TOLONG|HELP|APA/i
  end

  def asking_more?
    /LAGI|NEXT/i
  end

  def testing_connection?
    /TEST|PING/i
  end
end
