class Project < ActiveRecord::Base
	has_many :ProjectUsers
	has_many :Users, :through=> :ProjectUsers
end
