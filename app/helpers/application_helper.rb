module ApplicationHelper
  include Pagy::Frontend

  def link_to_user_mentions(text)
    # Simple text with URL linking support
    # Convert URLs to links if present
    if text.include?("http")
      # Simple regex to find URLs and convert them to links
      text = text.gsub(/https?:\/\/\S+/) { |url| %(<a href="#{url}" target="_blank" rel="noopener noreferrer" class="text-purple-400 hover:text-purple-300 underline">#{url}</a>) }
    end

    # Escape remaining text and convert newlines to breaks
    simple_format(text.html_safe)
  end
end
