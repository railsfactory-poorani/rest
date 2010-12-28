class ProjectUser < ActiveRecord::Base
	belongs_to :Project
	belongs_to :User
end
