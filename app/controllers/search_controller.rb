class SearchController < ApplicationController
  include UtilityModule
  include BingModule

  def search
    if is_url(params[:q]) #用户输入URL
      url = params[:q]
      @origin = Origin.where(["url=?", url]).first

      # 找到原文
      if @origin.origin_id != nil
        oid = @origin.origin_id
        @origin = Origin.find(oid)
      end
      
      # 找到译文
      unless @origin.nil?
        @translates = translates_by_origin_id(@origin.id)
      end

      # 返回译文列表
      render :action => :translates
      return
    else #非URL则当作Title处理
      title = params[:q]

      # 查找完全匹配
      # @origins = Origin.where(["upper(title)=upper(?) and origin_id is null", title])
      @origins = origins_by_title(title)

      # 分伺候按单词匹配
      if @origins.empty?
        @origins = origins_by_title_words(title)
        render :action => :origins
        return
      elsif @origins.length == 1
        @origin = @origins.first
        @translates = translates_by_origin_id(@origin.id)
        render :action => :translates
        return
      else
        render :action => :origins
        return
      end

      # 返回原文标题选择列表
      render :action => :origins
    end

    
  end

  protected

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
