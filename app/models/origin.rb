class Origin < ActiveRecord::Base
  attr_accessible :title, :url, :page_rank, :origin_id, :heat, :favorite, :entry
end
