class Categoryset < ActiveRecord::Base
  #Associations
  has_many :categories
  has_many :object_models

  #Validations
  validates :name ,:presence=>true,:uniqueness=>true

  #Instance Methods
  def levelname
    treelevel
  end

  def treename
    treelevel
  end

  def treelevel
   self.id = -(self.id) unless self.id.nil?
   lname = self.name
   lname
  end
end

# == Schema Information
#
# Table name: categorysets
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

