module ChatHelper
  def chat_html(chat)
    "- <span class=\"chat\">chat ##{chat}</span> -".html_safe
  end
end
