class ObjectModel < ActiveRecord::Base
  include PermalinkHelper

  #Associations
  has_many :model_components, :dependent=>:destroy ,:order =>:position
  has_many :model_submissions, :dependent=>:destroy
  has_many :comment_components, :dependent=>:destroy 
  has_one  :mailer
  belongs_to :categoryset
  
#Validations
    regex_pattern = /(?=.*[A-Za-z0-9])[A-Za-z0-9-]+\z/i
  validates :perma_link_parent ,:presence=>true, :uniqueness=>true , :format=>{:with=>regex_pattern ,:message=>"Should contain a  / and alphabets or alphabets and numbers and may contailn - separator"}
  validates :name ,:presence=>true, :uniqueness=>true

  #call backs
  after_create :create_2_model_components, :verify_comments 
  after_create :create_permissions
  after_save :verify_comments
  after_update :verify_comments 
  after_destroy :remove_permissions


  #Instance Methods

 def perma_link_generate
     #self.perma_link_parent = "/" + generate_perma_link(ObjectModel,create_permalink(self.name,'plural'))
     self.perma_link_parent = generate_perma_link(ObjectModel,create_permalink(self.name,'plural')) 
 end

 def published_model_submissions
   return self.model_submissions.find(:all,:conditions=>["status =?","Published"])
 end
 
private 

 def create_2_model_components
    self.model_components.create(:component_name=>'title',:component_display_name=>"Title",:component_type=>"Textfield",:default_value=>"Enter a title",:is_deletable=>false,:is_mandatory=>true)
    self.model_components.create(:component_name=>'body',:component_display_name=>"Body",:component_type=>"RichtextEditor",:default_value=>"Enter a Content",:is_deletable=>false,:is_mandatory=>false)
 end

 def create_permissions
   #Create
    perm = Permission.create(:activity_code=>"create",:activity_display_text=>"Create a #{self.name.capitalize}",:permission_type=>"ObjectModel",:permission_object=>self.name)
    [2,3].each {|role| PermissionRole.create(:role_id=>role, :permission_id=>perm.id, :value=>true)}
   #Edit 
    perm = Permission.create(:activity_code=>"edit",:activity_display_text=>"Modify your own #{self.name.capitalize}",:permission_type=>"ObjectModel",:permission_object=>self.name)
    [2,3].each {|role| PermissionRole.create(:role_id=>role, :permission_id=>perm.id, :value=>true)}
   #Edit Others 
    perm = Permission.create(:activity_code=>"editother",:activity_display_text=>"Modify others' #{self.name.capitalize}",:permission_type=>"ObjectModel",:permission_object=>self.name)
    PermissionRole.create(:role_id=>3, :permission_id=>perm.id, :value=>true)
   #Delete 
    perm = Permission.create(:activity_code=>"delete",:activity_display_text=>"Delete your own #{self.name.capitalize}",:permission_type=>"ObjectModel",:permission_object=>self.name)
    [2,3].each {|role| PermissionRole.create(:role_id=>role, :permission_id=>perm.id, :value=>true)}
   #Delete Others
    perm = Permission.create(:activity_code=>"deleteother",:activity_display_text=>"Delete others' #{self.name.capitalize}",:permission_type=>"ObjectModel",:permission_object=>self.name)
    PermissionRole.create(:role_id=>3, :permission_id=>perm.id, :value=>true)
   #View 
    perm = Permission.create(:activity_code=>"view",:activity_display_text=>"View a #{self.name.capitalize}",:permission_type=>"ObjectModel",:permission_object=>self.name)
    Role.all.each { |role| PermissionRole.create(:role_id=>role.id, :permission_id=>perm.id, :value=>true) }
   #View All 
    perm = Permission.create(:activity_code=>"viewlist",:activity_display_text=>"View all #{self.name.capitalize.pluralize}",:permission_type=>"ObjectModel",:permission_object=>self.name)
    Role.all.each { |role| PermissionRole.create(:role_id=>role.id, :permission_id=>perm.id, :value=>true) }
    create_comment_permissions
 end

def create_comment_permissions
   if self.allow_comments && Permission.where(:permission_type=>"ObjectModel",:permission_object=>self.name).size == 0
    #Can comment
    perm = Permission.create(:activity_code=>"createcomment",:activity_display_text=>"Comment on #{self.name.pluralize} submissions",:permission_type=>"ObjectModel",:permission_object=>self.name)
    Role.all.each { |role| PermissionRole.create(:role_id=>role.id, :permission_id=>perm.id, :value=>true) }
    #Delete my comments
    perm = Permission.create(:activity_code=>"deletecomment",:activity_display_text=>"Delete my comments for #{self.name}",:permission_type=>"ObjectModel",:permission_object=>self.name)
    #Delete comments for my blog
    perm = Permission.create(:activity_code=>"deletecommentother",:activity_display_text=>"Delete comments for #{self.name}",:permission_type=>"ObjectModel",:permission_object=>self.name)
    #Delete comments for others blog
    perm = Permission.create(:activity_code=>"deletemycomments",:activity_display_text=>"Delete comments for my #{self.name}",:permission_type=>"ObjectModel",:permission_object=>self.name)
   end

end

def remove_comment_permission
  unless self.allow_comments
    ["createcomment","deletecomment","deletecommentother","deletemycomments"].each do |code|
      permissions = Permission.find(:all,:conditions=>["permission_type=? and permission_object=? and activity_code=>?","ObjectModel",self.name,code])
      permissions.each do |permission|
        permission.destroy
      end
    end
  end
end

 def remove_permissions
    permissions = Permission.find(:all,:conditions=>["permission_type=? and permission_object=?","ObjectModel",self.name])
    permissions.each do |permission|
      permission.destroy
    end
 end

 def verify_comments
    unless self.allow_comments
      remove_comment_permissions
      self.comment_components.each do |comment_component|
       comment_component.destroy
      end
      self.model_submissions.each do |model_submission|
        model_submission.comment_submissions.each do |comment_submission|
         comment_submission.destroy
        end
      end
    else
     create_comment_permissions
     if self.comment_components.find_by_component_name('comment_text').nil?
       self.comment_components.create(:component_name=>'comment_text',:component_display_name=>"Comment Text",:component_type=>"Textarea",:default_value=>"Plz comment!",:mandatory=>true)
     end
     if self.email_on_comment
       subject= "comment has been submitted "
       body='Sample body template. Please Modify once all the form components are created'
       self.create_mailer(:handle=>self.perma_link_parent,:subject=>subject,:body=>body,:is_deletable=>false,:allowable_tags=>'CommentSubmission')
     end
   end
  
 end

end




# == Schema Information
#
# Table name: object_models
#
#  id                   :integer(4)      not null, primary key
#  name                 :string(255)
#  perma_link_parent    :string(255)
#  description          :text
#  created_at           :datetime
#  updated_at           :datetime
#  comment_component_id :integer(4)
#  allow_comments       :boolean(1)      default(FALSE)
#  is_comment_recursive :boolean(1)      default(FALSE)
#  email_on_comment     :boolean(1)      default(FALSE)
#  layout               :string(255)
#  categoryset_id       :integer(4)
#

