class SubmitController < ApplicationController
  include UtilityModule
  include BingModule

  def new
    # @origin_url      = "htt://www.google.com/"
    # @origin_title    = "Google"
    # @translate_url   = "htt://www.google.com.hk/"
    # @translate_title = "谷歌"
    # @sharer          = "[SYSTEM]"
    render :layout => false
  end

  def create_by_request

    origin_url      = params[:submit_origin_url].nil?      ? "" : params[:submit_origin_url]
    origin_title    = params[:submit_origin_title].nil?    ? "" : params[:submit_origin_title]
    translate_url   = params[:submit_translate_url].nil?   ? "" : params[:submit_translate_url]
    translate_title = params[:submit_translate_title].nil? ? "" : params[:submit_translate_title]
    sharer          = params[:submit_sharer].nil?          ? "" : params[:submit_sharer]

    @errors = Array.new
    @errors.push("请输入原文链接！") if origin_url.empty?
    @errors.push("请输入原文标题！") if origin_title.empty?
    @errors.push("请输入译文链接！") if translate_url.empty?
    @errors.push("请输入译文标题！") if translate_title.empty?
    unless @errors.empty?
      render json: Hash[errors: @errors].to_json
      return
    end

    @errors.push("原文链接格式错误！") unless is_url(origin_url)
    @errors.push("译文链接格式错误！") unless is_url(translate_url)
    unless @errors.empty?
      render json: Hash[errors: @errors].to_json
      return
    end

    origin, translate = share_translate(origin_url, origin_title, translate_url, translate_title, sharer)

    render json: Hash[origin: origin, translate: translate].to_json
    return
  end # create_by_request

  def create_by_form

    if params[:submit].nil?
      @errors = Array.new
      @errors.push("表单为空！")
      render json: Hash[errors: @errors].to_json
      return
    end

    origin_url      = params[:submit][:origin_url].nil?      ? "" : params[:submit][:origin_url]
    origin_title    = params[:submit][:origin_title].nil?    ? "" : params[:submit][:origin_title]
    translate_url   = params[:submit][:translate_url].nil?   ? "" : params[:submit][:translate_url]
    translate_title = params[:submit][:translate_title].nil? ? "" : params[:submit][:translate_title]
    sharer          = params[:submit][:sharer].nil?          ? "" : params[:submit][:sharer]

    @errors = Array.new
    @errors.push("请输入原文链接！") if origin_url.empty?
    @errors.push("请输入原文标题！") if origin_title.empty?
    @errors.push("请输入译文链接！") if translate_url.empty?
    @errors.push("请输入译文标题！") if translate_title.empty?
    unless @errors.empty?
      render json: Hash[errors: @errors].to_json
      return
    end

    @errors.push("原文链接格式错误！") unless is_url(origin_url)
    @errors.push("译文链接格式错误！") unless is_url(translate_url)
    unless @errors.empty?
      render json: Hash[errors: @errors].to_json
      return
    end

    origin, translate = share_translate(origin_url, origin_title, translate_url, translate_title, sharer)

    render json: Hash[origin: origin, translate: translate].to_json
    return
  end # create_by_form

  def show
    
  end

  protected

  def share_translate(origin_url, origin_title, translate_url, translate_title, sharer)

    # 通过url查询origin，如有源头继续拿到源头对象
    origins = Origin.where(["url=?", origin_url]);
    if origins.empty?
      origin              = Origin.new
      origin.title        = origin_title
      origin.url          = origin_url
      origin.heat         = 1
      origin.favorite     = 1
      origin.entry        = sharer

      # TODO 暂时关闭
      # # 通过Bing搜索源头
      # search_results   = search_by_bing(origin_title)
      # search_top_title = top_title_from_bing_results(search_results)
      # search_top_url   = top_url_from_bing_results(search_results)

      # # 当search_top_url和origin_url不是同一个网页，就将搜索结果保存为源头
      # if (compare_url(search_top_url, origin_url) != 0)
      #   find_origin              = Origin.new
      #   find_origin.title        = search_top_title
      #   find_origin.url          = search_top_url
      #   find_origin.heat         = 1
      #   find_origin.favorite     = 0
      #   find_origin.entry        = "[BING.COM]"
      #   find_origin.save
      #   origin.origin_id        = find_origin.id
      # end

      origin.save
    else
      origin = origins.first
      origin = Origin.find(origin.origin_id) unless origin.origin_id.nil?
    end

    # 通过url查询translate
    translates = Translate.where(["url=?", translate_url])
    if translates.empty?
      translate              = Translate.new
      translate.url          = translate_url
      translate.title        = translate_title
      # translate.origin_id    = (find_origin == nil) ? origin.id : find_origin.id
      translate.origin_id    = origin.id
      translate.heat         = 1
      translate.favorite     = 1
      translate.sharer       = sharer
      translate.save
    else
      translate           = translates.first
      translate.favorite  = translate.favorite + 1
      translate.save
    end

    return origin, translate

  end # share_translate

end
