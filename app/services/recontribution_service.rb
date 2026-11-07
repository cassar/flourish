class RecontributionService
  attr_accessor :issued_dividends

  def initialize(issued_dividends:)
    @issued_dividends = issued_dividends
  end

  def call
    issued_dividends.each(&:auto_recontributed!)
  end
end
