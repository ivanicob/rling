class ModelSubmission < ActiveRecord::Base
  #Associations
  has_many :model_datas ,:dependent=>:destroy
  belongs_to :object_model
  #validations
  validates :perma_link ,:presence=>true, :uniqueness=>true
end
