class ContributionsController < ApplicationController
  # Dollars with up to two decimal places, e.g. "25", "25.5" or "1,000.00".
  AMOUNT_FORMAT = /\A\d{1,7}(\.\d{1,2})?\z/

  before_action :set_pot

  def new; end

  def create
    @amount = params.dig(:contribution, :amount).to_s.strip
    cents = amount_in_cents(@amount)

    unless cents&.positive?
      @error = 'Enter an amount in dollars, like 25 or 25.50.'
      return render :new, status: :unprocessable_content
    end

    distribution = create_distribution_with_contribution(cents)

    redirect_to pot_distribution_path(@pot, distribution),
                notice: t('controllers.contributions.create.success', name: distribution.name)
  end

  private

  def set_pot
    @pot = current_member.pots.find(params.expect(:pot_id))
  end

  def amount_in_cents(amount)
    normalized = amount.delete('$,')
    return unless normalized.match?(AMOUNT_FORMAT)

    (BigDecimal(normalized) * 100).to_i
  end

  # Each contribution gets a distribution of its own, which pays it out.
  def create_distribution_with_contribution(cents)
    Distribution.transaction do
      distribution = @pot.distributions.create!(
        number: @pot.distributions.maximum(:number).to_i + 1,
        amount_in_base_units: cents
      )
      @pot.contributions.create!(member: current_member, distribution:,
                                 amount_in_base_units: cents, currency: 'AUD')
      distribution
    end
  end
end
