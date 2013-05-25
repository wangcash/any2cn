class SubmitController < ApplicationController
  include UtilModule

  def new
    @submitter = "system"
  end

  def create
    puts "==============create=============="

    origin_url      = params[:submit][:origin_url]
    origin_title    = params[:submit][:origin_title]
    translate_url   = params[:submit][:translate_url]
    translate_title = params[:submit][:translate_title]

    @errors = Array.new

    @errors.push("原文网址必填！") if origin_url.empty?
    @errors.push("原文标题必填！") if origin_title.empty?
    @errors.push("译文网址必填！") if translate_url.empty?
    @errors.push("译文标题必填！") if translate_title.empty?
    unless @errors.empty?
      # TODO 有输入为空，错误处理
    end

    @errors.push("原文网址格式错误！") unless is_url(origin_url)
    @errors.push("译文网址格式错误！") unless is_url(translate_url)
    unless @errors.empty?
      # TODO 输入网址格式错误，错误处理
    end

    @origin = Origin.where(["origin_url=?", origin_url]);
    puts "1111111111#{@origin}"

    # @origin = Origin.find(origin.origin_id) unless (@origin.nil? && @origin.origin_id.nil?)
    # puts "2222222222#{@origin}"

    # TODO 通过url查询origin，如有原始出处继续拿到对象
    # TODO 保存origin对象
    # TODO 保存translate对象
    # TODO 跳页面


    @origin = Origin.new
    @origin.url          = params[:submit][:origin_url]
    @origin.title        = params[:submit][:origin_title]
    @origin.page_rank    = 1
    @origin.added_person = params[:submit][:added_person]

    if @origin.save
      @translate = Translate.new
      @translate.url          = params[:submit][:translate_url]
      @translate.title        = params[:submit][:translate_title]
      @translate.origin_id    = @origin.id
      @translate.page_rank    = 1
      @translate.added_person = params[:submit][:added_person]
      @translate.save
    end



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
