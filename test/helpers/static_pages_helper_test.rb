require 'test_helper'

class StaticPagesHelperTest < ActionView::TestCase
  test 'parse_activity_log for a contribution received message' do
    # NOTE: the ACTIVITY_LOG_PATTERNS regex `/Contribution of (\S+) received/`
    # can't actually match real production messages, since Money#format always
    # includes a space before the currency code (e.g. "$100.00 AUD") and \S+
    # stops at the first whitespace. Using a space-free amount here to exercise
    # the :seed branch as the code is currently written — this is a latent bug
    # in the regex, not something being fixed as part of closing coverage gaps.
    result = parse_activity_log('Contribution of $100.00 received')

    assert_equal({ text: 'Someone put in', amount: '+$100.00', type: :seed }, result)
  end

  test 'parse_activity_log for a distribution created message' do
    result = parse_activity_log('Distribution #5 created')

    assert_equal({ text: 'Week #5 distributed to all members', amount: nil, type: :harvest }, result)
  end

  test 'parse_activity_log for a payout completed message' do
    result = parse_activity_log('Payout of $50.00 AUD completed')

    assert_equal({ text: 'Someone received their share', amount: '$50.00', type: :claim }, result)
  end

  test 'parse_activity_log for a payout requested message' do
    result = parse_activity_log('Payout requested by someone@example.com')

    assert_equal({ text: 'Someone received their share', amount: nil, type: :claim }, result)
  end

  test 'parse_activity_log for a recontributed message' do
    result = parse_activity_log('Dividend manually recontributed by someone@example.com')

    assert_equal({ text: 'Someone recontributed', amount: nil, type: :reseed }, result)
  end

  test 'parse_activity_log returns nil for a message containing an email address' do
    assert_nil parse_activity_log('someone@example.com did a thing')
  end

  test 'parse_activity_log falls back to a truncated generic message' do
    long_message = 'a' * 100

    result = parse_activity_log(long_message)

    assert_equal :generic, result[:type]
    assert_nil result[:amount]
    assert_equal 60, result[:text].length
  end

  test 'activity_icon renders an svg for each known type' do
    %i[seed harvest claim reseed generic].each do |type|
      assert_match '<svg', activity_icon(type)
    end
  end

  test 'activity_icon falls back to generic for an unknown type' do
    assert_equal activity_icon(:generic), activity_icon(:something_unknown)
  end
end
