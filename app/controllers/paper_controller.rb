class PaperController < ApplicationController
	def index
		
	end
	def query
		@origin    = Origin.find("15")
		@translate = Translate.find("4")
	end
end
