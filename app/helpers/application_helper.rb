module ApplicationHelper
  def title_text(title)
    return 'Flourish' if title.nil?

    "#{title} | Flourish"
  end
end
