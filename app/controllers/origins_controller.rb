class OriginsController < ApplicationController

	before_filter :find_origin, :only=>[:show, :edit, :update, :destroy]

	def index
		@origins = Origin.page(params[:page]).per(50)
		respond_to do |format|
			format.html
			format.xml  {render :xml=>@origins.to_xml}
			format.json {render :json=>@origins.to_json}
		end
	end

	def new
		@origin = Origin.new
		@origin.added_person = "system"
	end

	def create
		@origin = Origin.new(params[:origin])
		if @origin.save
			redirect_to origins_url
		else
			render :action=>:new
		end
	end

	def show
		@page_title = @origin.title
		respond_to do |format|
			format.html {@page_title = @origin.title}
			format.xml
			format.json {render :json=>{title:@origin.title, url:@origin.url}.to_json}
		end
	end

	def edit
		
	end

	def update
		if @origin.update_attributes(params[:origin])
			redirect_to origin_url(@origin)
			flash[:notice] = "origin was successfully updated"
		else
			render :action=>:edit
		end
	end

	def destroy
		@origin.destroy
		redirect_to origins_url
		flash[:alert] = "origin was successfully deleted"
	end

	protected
	def find_origin
		@origin = Origin.find(params[:id])
	end
end
