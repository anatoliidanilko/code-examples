class ItemPresenter
  def initialize(item)
    @item = item
  end

  def content_with_type
    "#{content} [#{type}]"
  end

  def short_content_with_type
    "#{content_truncated} [#{type}]"
  end

  def content
    "#{@item.content.is_a?(Array) && @item.content.join || @item.content}"
  end

  def content_truncated(length = 30)
    content.truncate(length)
  end

  def type
    @item.class.name
  end

  def version
    return if @item.content_versioning.original?
    " (#{@item.content_versioning.title})"
  end
end
