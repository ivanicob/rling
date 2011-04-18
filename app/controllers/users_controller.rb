class UsersController < ApplicationController
  include ApplicationHelper

  #FILTERS
  before_filter :require_user, :except => [:new,:create,:activate]
  before_filter :require_admin, :only => [:index,:destroy]

  # GET /users
  # GET /users.xml
  def index
    @users = User.all
    @user_detail_settings = UserDetailSetting.all(:order =>'position')
  
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    userid = params[:id]
    userid = current_user.id if userid.nil?
    @user = User.find(userid)
    @user_detail_settings=UserDetailSetting.all
    @objects= [] 
    ObjectModel.all.each do |om|
      permission = Permission.where(:activity_code=>"viewlist",:permission_type=>"ObjectModel",:permission_object=>om.name)
      unless permission.nil?
        pm = PermissionRole.where(:role_id=>@user.role_id,:permission_id=>permission[0].id)
        @objects << om if !pm.empty? && pm[0].value
      end
    end

     respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
   if current_user?
     setting = Setting.find_by_name("allow_admin_register_user")
     if current_user.admin? && !setting.setting_data
       flash[:notice] = "Admin cannot create a new User"
       respond_to do |format|
       format.html {redirect_to users_path }
       end
     else
       if current_user.admin? && setting.setting_data
       @user = User.new
       respond_to do |format|
         format.html # new.html.erb
         format.xml  { render :xml => @user }
         end
       else
       respond_to do |format|
         format.html {redirect_to account_url }
         format.xml  { render :xml => @user }
       end
       end
     end
  else
    setting = Setting.find_by_name("allow_user_register_user")
    unless setting.setting_data
      flash[:notice] = "User is not authorized to register into the site"
      respond_to do |format|
        format.html {redirect_to "/"}
      end
    else
      @user = User.new
      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @user }
      end
    end
  end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    @user.login = @user.email if @user.login.blank?
    respond_to do |format|
      if @user.save
        flash[:notice] = "User registered successfully"
        Notifier.welcome_email(@user).deliver if get_setting("send_welcome_email")
        #Write code for Send welcome email if setting is true
        if (get_setting("user_activation_required_on_user") && !current_user?) || (get_setting("user_activation_required_on_admin") && current_user? && current_user.admin?)
          @user.create_activation_key
          @user.activation_url
          Notifier.activation_email(@user).deliver
          flash[:notice] = "User created successfully, An email has been sent to you, please follow the instructions to activate yourself to the website"
        else
          @user.is_activated = true
          @user.save
        end
        if current_user? and current_user.admin?
          format.html {redirect_to users_path }
        else
          format.html { redirect_to '/login'}
        end
        format.xml { render :xml => user.email, :status => :created }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
     end
  end
 
  # GET /users/1/activate
  # GET /users/1/activate.xml
  def activate
    @user = User.find_by_activation_key(params[:id]) unless params[:id].nil?
    unless @user.nil?
      @user.is_activated=true
      @user.delete_activation_key
      respond_to do |format|
            format.html {redirect_to login_path, :notice=>'Your account has been activated'}
            format.xml {render :xml =>@user}
      end
    else
      flash[:notice]="No user found"
      respond_to do |format|
        format.html {redirect_to login_path}
        format.xml {render :xml =>@user}
      end
    end
  end
 
  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    if @user.admin? 
     if User.admins.size > 1
       @user.destroy
       flash[:notice] = "User deleted successfully"
     else
       flash[:notice] = "Atleast one administrator required to execute website activities"
     end
    else
      @user.destroy
      flash[:notice] = "User deleted successfully"
    end
    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end

  # GET /users/1/user_details
  # GET /users/1/user_details.xml
  def user_details
    @user_detail_settings=UserDetailSetting.all
    respond_to do |format|
      unless @user_detail_settings.empty?
        @user=User.find(params[:id])
        format.html {render :action=>"user_details"}
      else
        format.html {redirect_to users_path}
      end
      format.xml  { render :xml=>@user_detail_settings }
    end
  end

  # POST /users/1/update_details
  # POST /users/1/update_details.xml
 def update_details
    user_id=params[:user_id]
    form_field=params[:form_field]
    mandatory_failed = false
    unless form_field.nil?
      UserDetailSetting.all.each do |user_detail_setting|
        if user_detail_setting.mandatory && form_field[user_detail_setting.field_name].blank?
          mandatory_failed = true
          break
        end
        user_detail=UserDetail.find_by_user_id_and_user_detail_setting_id(user_id,user_detail_setting.id)
        user_detail=UserDetail.new if user_detail.nil?
        user_detail.user_id=user_id if user_detail.user_id.nil?
        user_detail.user_detail_setting_id=user_detail_setting.id if user_detail.user_detail_setting_id.nil?
        case user_detail_setting.field_type
        when "File"
          unless form_field[user_detail_setting.field_name].nil?
            asset = Asset.create(:sizes=>user_detail_setting.default_value,:upload=>form_field[user_detail_setting.field_name])
            Asset.find(user_detail.selected_value).destroy if !user_detail.selected_value.blank? && (user_detail.selected_value.to_i != 0)
            user_detail.selected_value = asset.id.to_s
          end
        when "Checkbox"
          if form_field[user_detail_setting.field_name].nil?
            user_detail.selected = "0"
          else
            user_detail.selected_value=form_field[user_detail_setting.field_name]
          end
        when "Date"
          user_detail.selected_value= Date.parse(form_field[user_detail_setting.field_name].to_a.sort.collect{|c| c[1]}.join("-"))
        else
          user_detail.selected_value=form_field[user_detail_setting.field_name]
        end
        user_detail.save
      end
    end
    respond_to do |format|
      if mandatory_failed
        @user = User.find(user_id)
        @userdetailsettings = UserDetailSetting.all
        flash[:notice]="All the mandatory fields are necessary"
        format.html {redirect_to user_details_user_path(@user)}
        format.xml {render :xml=>@user,:status=>:unprocessable_entity}
      else
        flash[:notice]="Successfully updated"
        if current_user.admin?
          format.html {redirect_to users_path}
        else
          format.html {redirect_to account_path}
        end
        format.xml {render :xml=>@user,:notice=>flash[:notice]}
      end
    end
 end

  # GET /users/1/delete_asset
  # GET /users/1/delete_asset.xml 
  def delete_asset
    user_detail = UserDetail.find(params[:id])
    unless user_detail.nil?
      asset = Asset.find(user_detail.selected_value)
      asset.destroy unless asset.nil?
      user_detail.selected_value = nil
      user_detail.save
    end
    respond_to do |format|
      format.html { redirect_to(user_details_user_path(user_detail.user_id)) }
      format.xml  { head :ok }
    end
  end

 end
