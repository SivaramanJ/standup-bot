module ApplicationHelper
  # Simple Markdown-to-HTML renderer without requiring a gem.
  # Handles: headings, bold, bullet lists, horizontal rules, paragraphs.
  def render_markdown(text)
    return "" if text.blank?

    html = text
      .gsub("&", "&amp;")   # Escape HTML entities first
      .gsub("<", "&lt;")
      .gsub(">", "&gt;")
      .gsub(/^### (.+)$/, '<h3>\1</h3>')   # Headings
      .gsub(/^## (.+)$/, '<h2>\1</h2>')
      .gsub(/^# (.+)$/, '<h1>\1</h1>')
      .gsub(/\*\*(.+?)\*\*/, '<strong>\1</strong>')   # Bold (**text** or __text__)
      .gsub(/__(.+?)__/, '<strong>\1</strong>')
      .gsub(/(?<!\*)\*([^*]+?)\*(?!\*)/, '<em>\1</em>')   # Italic (*text* or _text_)
      .gsub(/^---$/, '<hr>')   # Horizontal rule
      .gsub(/^[-*] (.+)$/, '<li>\1</li>')   # Bullet lists

    # Wrap consecutive <li> blocks in <ul>
    html = html.gsub(/(<li>.*?<\/li>\n?)+/m) { "<ul>#{$&}</ul>" }

    # Paragraphs — blank-line-separated blocks not already wrapped in a tag
    paragraphs = html.split(/\n{2,}/)
    html = paragraphs.map do |block|
      block = block.strip
      next block if block.start_with?("<h", "<ul", "<hr", "<li")
      next block if block.blank?

      "<p>#{block.gsub("\n", "<br>")}</p>"
    end.join("\n")

    html.html_safe
  end
end
