require 'rubygems'
require 'open-uri'
require 'nokogiri'
require 'sanitize'
require 'diff/lcs'

module UtilityModule

  # 判断string是否是url。
  # 必须是http或https开头，现不支持直接填写网址方式。
  def is_url(string)
    urlRegexp = /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix
    result = urlRegexp.match(string) ? true : false
    return result
  end

  # 计算两个string的相似系数。
  # string比较使用的是“最长公共子序列（LCS）”算法，返回值为lcs和长string的比值。
  # 返回值为0.0~1.0之间的浮点数。
  def string_similarity_factor(str1, str2)
    lcs = Diff::LCS.LCS(str1, str2)
    # puts "#{lcs.length} : #{lcs}"
    # puts "[#{str1}] : [#{str2}] -> #{lcs.length.to_f/[str1.length, str2.length].max.to_f}"
    return lcs.length.to_f / [str1.length, str2.length].max.to_f
  end

  # 检查是否已经拿到有效的文章Title。
  # 当article_title为空时返回false。
  # 或article_title与html_title的相似系数小于0.2时视为无效文章Title也返回false。
  def has_article_title?(article_title, html_title)
    if article_title.empty?
      return false
    end
    if string_similarity_factor(article_title, html_title) < 0.2
      return false
    end
    return true
  end

  # 从<h?>标签中拿到文章Title。
  # 进行了去html标签和去(空格|空行)处理。
  # 当与html_title的相似度大于0.5时视为有效文章Title。
  def title_from_h_tag(h_tags, html_title)
    title = ""
    h_tags.each do |node|
      t = node.inner_html
      if /<[^>]*>/ =~ t
        t = Sanitize.clean(t).strip
      end
      if string_similarity_factor(t, html_title) > 0.5
        # puts "HTML Title   : #{html_title}"
        # puts "Article Title: #{t}"
        # puts "Similarity   : #{string_similarity_factor(t, html_title)}\n\n"
        title = t
      end
    end
    return title
  end

  # 从url的网页中解析出文章Title。
  def article_title_from_url(url)

    doc = Nokogiri::HTML(open(url))

    html_title    = doc.css('title').inner_html
    article_title = ""

    # 从网页的<h?>标签中解析文章Title
    article_title = title_from_h_tag(doc.css('h1'), html_title) unless has_article_title?(article_title, html_title)
    article_title = title_from_h_tag(doc.css('h2'), html_title) unless has_article_title?(article_title, html_title)
    article_title = title_from_h_tag(doc.css('h3'), html_title) unless has_article_title?(article_title, html_title)

    # 从<meta content="Title" property="og:title">中尝试获得文章Title
    unless has_article_title?(article_title, html_title)
      meta = doc.css('meta[property="og:title"]')
      article_title = meta.first['content'] unless meta.empty?
    end

    # 以上方法都无法获得文章Title，则使用网页Title
    article_title = html_title if article_title.empty?

    return article_title
  end

  # 从url的网页中解析出Title。
  def title_from_url(url)
    doc = Nokogiri::HTML(open(url))
    html_title = doc.css('title').inner_html
    return html_title
  end

  module_function
  
end