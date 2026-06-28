module MembershipsHelper
  DIVIDEND_STATUS_BADGES = {
    'issued' => { label: 'Issued', css: 'badge-neutral' },
    'pending_pay_out' => { label: 'Payout Pending', css: 'badge-warning' },
    'pay_out_complete' => { label: 'Paid Out', css: 'badge-success' },
    'manually_recontributed' => { label: 'Recontributed', css: 'badge-info' },
    'auto_recontributed' => { label: 'Recontributed', css: 'badge-info' }
  }.freeze

  def dividend_status_badge(dividend)
    config = DIVIDEND_STATUS_BADGES[dividend.status] || { label: dividend.status.titleize, css: 'badge-neutral' }
    content_tag(:span, config[:label], class: "badge badge-sm #{config[:css]}")
  end

  def notification_toggle(enabled)
    enabled ? '●' : '○'
  end
end
