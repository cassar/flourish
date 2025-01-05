module ApplicationHelper
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
end
