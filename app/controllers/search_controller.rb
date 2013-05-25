class SearchController < ApplicationController
  include UtilModule

  def search
    if is_url(params[:q])  #用户输入URL
      url = params[:q]
      @origin = Origin.where(["url=?", url]).first
      # 找到原文
      if @origin.origin_id != nil
        oid = @origin.origin_id
        @origin = Origin.find(oid)
      end
    else                  #非URL则当作Title处理
      title = params[:q]

      @origins = Origin.where(["upper(title)=upper(?) and origin_id is null", title])

      if @origins.empty?
        substrings = ""
        title.split.each_with_index do |word, i|
          substrings = "#{substrings} or upper(title) like upper('%#{word}%')"
        end
        @origins = Origin.where(["upper(title)=upper(?) #{substrings}", title])
      end

      @origin = @origins.first
      # @origin = Origin.find(15)
    end

    unless @origin.nil?
      @reprints = Origin.where(["origin_id=?", @origin.id]);
      @translates = Translate.where(["origin_id=?", @origin.id])
      @translate = @translates.first
    end
  end

  protected


end
