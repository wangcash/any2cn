class TranslatesController < ApplicationController

  before_filter :find_translate, :only=>[:show, :edit, :update, :destroy]

  def index
    @translates = Translate.page(params[:page]).per(50)
    respond_to do |format|
      format.html
      format.xml  { render xml: @translates.to_xml }
      format.json { render json: @translates.to_json }
    end
  end

  def new
    @translate = Translate.new
    @translate.added_person = "system"
  end

  def create
    @translate = Translate.new(params[:translate])
    if @translate.save
      redirect_to translates_url
    else
      render :action=>:new
    end
  end

  def show
    # @origin = Origin.find(@translate.origin_id) if @translate.origin_id.nil? == false
    @origin = @translate.origin.nil? ? nil : Origin.find(@translate.origin_id)
  end

  def edit
    
  end

  def update
    if @translate.update_attributes(params[:translate])
      redirect_to translate_url(@translate)
      flash[:notice] = "translate was successfully updated"
    else
      render :action=>:edit
    end
  end

  def destroy
    @translate.destroy
    redirect_to translates_url
    flash[:alert] = "translate was successfully deleted"
  end

  protected
  def find_translate
    @translate = Translate.find(params[:id])
  end
end
