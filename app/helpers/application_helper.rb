module ApplicationHelper
  DIVIDEND_STATUS_BADGES = {
    'issued' => { label: 'Issued', css: 'badge-neutral' },
    'pending_pay_out' => { label: 'Payout Pending', css: 'badge-warning' },
    'pay_out_complete' => { label: 'Paid Out', css: 'badge-success' },
    'manually_recontributed' => { label: 'Recontributed', css: 'badge-info' },
    'auto_recontributed' => { label: 'Recontributed', css: 'badge-info' }
  }.freeze

  def title_text(title)
    return 'Flourish' if title.blank?

    "#{title} | Flourish"
  end

  def layout_path
    if current_page?(root_path)
      'layouts/root_page'
    else
      'layouts/app_page'
    end
  end

  MEMBER_DIVIDEND_STATUS_LABELS = {
    'issued' => 'Shared'
  }.freeze

  def dividend_status_badge(dividend, audience: :admin)
    config = DIVIDEND_STATUS_BADGES[dividend.status] || { label: dividend.status.titleize, css: 'badge-neutral' }
    label = audience == :member ? MEMBER_DIVIDEND_STATUS_LABELS[dividend.status] || config[:label] : config[:label]
    content_tag(:span, label, class: "badge badge-sm #{config[:css]}")
  end

  def notification_toggle(enabled)
    enabled ? '●' : '○'
  end
end
