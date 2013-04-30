

class PaperController < ApplicationController
	def index
		
	end

	def query
		if isUrl(params[:q])
			url = params[:q]
			@origin = Origin.where(["url=?", url]).first
			# 找到原文
			if @origin.origin_id != nil
				oid = @origin.origin_id
				@origin = Origin.find(oid)
			end
		else
			title = params[:q]
			@origin = Origin.where(["title=? and origin_id is null", title]).first
		end

		if !@origin.nil?
			@reprints = Origin.where(["origin_id=?", @origin.id]);
			@translates = Translate.where(["origin_id=?", @origin.id])
			@translate = @translates.first
		end
	end

	protected

	# 判断string是否是url。
	# 必须是http或https开头，现不支持直接填写网址方式。
	def isUrl(string)
		urlRegexp = /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix
		result = urlRegexp.match(string) ? true : false
		return result
	end

end
