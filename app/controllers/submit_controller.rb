class SubmitController < ApplicationController
  def new
    @submitter = "system"
  end

  def create
    puts "==============create=============="
    puts params

    # TODO:check origin

    @origin = Origin.new
    @origin.title        = params[:submit][:origin_title]
    @origin.url          = params[:submit][:origin_url]
    @origin.page_rank    = 1
    @origin.added_person = params[:submit][:added_person]

    if @origin.save
      @translate = Translate.new
      @translate.title        = params[:submit][:translate_title]
      @translate.url          = params[:submit][:translate_url]
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
end
