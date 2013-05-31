class SubmitController < ApplicationController
  include UtilityModule
  include BingModule

  def new
    @submitter = "system"
  end

  def create
    puts "==============create=============="

    origin_url      = params[:submit][:origin_url]
    origin_title    = params[:submit][:origin_title]
    translate_url   = params[:submit][:translate_url]
    translate_title = params[:submit][:translate_title]
    added_person    = params[:submit][:added_person]

    @errors = Array.new

    @errors.push("原文网址必填！") if origin_url.empty?
    @errors.push("原文标题必填！") if origin_title.empty?
    @errors.push("译文网址必填！") if translate_url.empty?
    @errors.push("译文标题必填！") if translate_title.empty?
    unless @errors.empty?
      # TODO 有输入为空，错误处理
      return
    end

    @errors.push("原文网址格式错误！") unless is_url(origin_url)
    @errors.push("译文网址格式错误！") unless is_url(translate_url)
    unless @errors.empty?
      # TODO 输入网址格式错误，错误处理
      return
    end

    # 通过url查询origin，如有源头继续拿到源头对象
    @origins = Origin.where(["url=?", origin_url]);
    if @origins.empty?
      @origin              = Origin.new
      @origin.title        = origin_title
      @origin.url          = origin_url
      @origin.added_person = added_person

      # 通过Bing搜索源头
      search_results   = search_by_bing(origin_title)
      search_top_title = top_title_from_bing_results(search_results)
      search_top_url   = top_url_from_bing_results(search_results)

      # 当search_top_url和origin_url不是同一个网页，就将搜索结果保存为源头
      if (search_top_url != origin_url)
        find_origin              = Origin.new
        find_origin.title        = search_top_title
        find_origin.url          = search_top_url
        find_origin.added_person = "bing.com"
        find_origin.save
        @origin.origin_id        = find_origin.id
      end

      @origin.save
    else
      @origin = @origins.first
      @origin = Origin.find(@origin.origin_id) unless @origin.origin_id.nil?
    end

    # 通过url查询translate
    @translates = Translate.where(["url=?", translate_url])
    if @translates.empty?
      @translate              = Translate.new
      @translate.url          = translate_url
      @translate.title        = translate_title
      @translate.origin_id    = (find_origin == nil) ? @origin.id : find_origin.id
      @translate.page_rank    = 1
      @translate.added_person = added_person
      @translate.save
    else
      @translate           = @translates.first
      @translate.page_rank = @translate.page_rank + 1
      @translate.save
    end

    # TODO 跳页面

    # if @origin.save
    #   redirect_to origins_url
    # else
    #   render :action=>:new
    # end
  end

  def show
    
  end

  protected

end
