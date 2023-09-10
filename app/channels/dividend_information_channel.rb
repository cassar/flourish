class DividendInformationChannel < ApplicationCable::Channel
  COMMON = 'common_dividend_information'.freeze

  def subscribed
    stream_from COMMON
  end
end
