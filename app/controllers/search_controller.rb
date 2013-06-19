class SearchController < ApplicationController
  include UtilityModule
  include BingModule

  def search

    @input = params[:q]

    if is_url(@input) # 用户输入URL

      url = @input

      origins = origins_by_url(url)

      if origins.empty? # 通过url不能搜索到Origins
        
        # 尝试通过网页的title进行搜索
        article_title = article_title_from_url(url)
        origins = origins_by_title(article_title)

        if origins.empty? # 通过title也搜索不到Origin

          # 根据url和title创建一个Origin
          @origin          = Origin.new
          @origin.url      = url
          @origin.title    = article_title
          @origin.heat     = 1
          @origin.favorite = 1
          @origin.entry    = "[SEARCH]"
          @origin.save

        else # 可以通过title搜索到*原始*Origin

          @origin = origins.first

        end
      else # 通过url可以搜索到Origins

        @origin = origins.first

        # 拿到*原始*Origin
        @origin = origin_by_origin(@origin)

      end
    else # 非URL则当作Title处理

      title = @input

      # 搜索与title完全匹配的Origin
      @origins = origins_by_title(title)

      if @origins.empty? # 没有搜索到任何Origins

        # 将title进行分词后再次搜索
        @origins = origins_by_title_words(title)
        render :action => :origins
        return

      elsif @origins.length == 1 # 搜索到唯一的Origin

        @origin = @origins.first
        @translates = translates_by_origin_id(@origin.id)

      else # 搜索到多个Origins

        render :action => :origins
        return

      end

    end

    # 搜索Translates
    unless @origin.nil?
      @translates = translates_by_origin_id(@origin.id)
    end

    render :action => :translates
    return

  end

  protected

  # 查找当前Origin是否有*原始*Origin
  # 存在*原始*Origin时，返回*原始*Origin
  # 不存在*原始*Origin时，返回当前Origin
  def origin_by_origin(origin)
    if origin.origin_id.nil?
      o_origin = origin
    else
      o_origin = Origin.find(origin.origin_id)
    end
    return o_origin
  end

  # 通过url查找对应的Origins
  def origins_by_url(url)
    return Origin.where(["upper(url)=upper(?)", url])
  end

  # 查找与Title完全匹配的*原始*Origins(忽略大小写)
  def origins_by_title(title)
    return Origin.where(["upper(title)=upper(?) and origin_id is null", title])
  end

  # 通过Title进行简单分词查找
  def origins_by_title_words(title)
    sub_sql = ""
    title.split.each_with_index do |word, i|
      sub_sql = "#{sub_sql} or upper(title) like upper('% #{word} %')"
    end
    return Origin.where(["upper(title)=upper(?) #{sub_sql}", title])
  end

  # 根据Origin找到Translates
  def translates_by_origin_id(origin_id)
    return @translates = Translate.where(["origin_id=?", origin_id])
  end

end
