class DividendInformationChannel < ApplicationCable::Channel
  COMMON = "common_dividend_information"

  def subscribed
    stream_from COMMON
  end
end
