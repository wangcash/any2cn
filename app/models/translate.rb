class Translate < ActiveRecord::Base
  attr_accessible :title, :url, :page_rank, :origin_id, :heat, :favorite, :sharer
end
