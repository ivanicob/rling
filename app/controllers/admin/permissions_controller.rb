class Admin::PermissionsController < ApplicationController
 #FILTERS
  before_filter :find_permission, :only => [:show, :edit, :update, :destroy]
  before_filter :require_admin

  # GET /permissions
  # GET /permissions.xml
  def index
    @permissions = Permission.all
    @roles = Role.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @permissions }
    end
  end

  # GET /permissions/1
  # GET /permissions/1.xml
  def show
    #@permission = Permission.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @permission }
    end
  end

  # GET /permissions/new
  # GET /permissions/new.xml
  def new
    @permission_role = PermissionRole.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @permission_role }
    end
  end

  # GET /permissions/1/edit
  def edit
    #@permission = Permission.find(params[:id])
  end

  # POST /permissions
  # POST /permissions.xml
  def create
    @permission_role = PermissionRole.new(params[:permission_role])

    respond_to do |format|
      if @permission_role.save
        format.html { redirect_to(@permission, :notice => t(:permission_created)) }
        format.xml  { render :xml => @permission, :status => :created, :location => @permission }
      else
        format.html { render  "new" }
        format.xml  { render :xml => @permission.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /permissions/1
  # PUT /permissions/1.xml
  def update
   # @permission = Permission.find(params[:id])
    respond_to do |format|
      if @permission.update_attributes(params[:permission])
        format.html { redirect_to(@permission, :notice => t(:permission_updated)) }
        format.xml  { head :ok }
      else
        format.html { render  "edit" }
        format.xml  { render :xml => @permission.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /permissions/1
  # DELETE /permissions/1.xml
  def destroy
    #@permission = Permission.find(params[:id])
    @permission.destroy

    respond_to do |format|
      format.html { redirect_to(permissions_url) }
      format.xml  { head :ok }
    end
  end

  # POST /permissions/save_permission_roles
  # POST /permissions/save_permission_roles.xml
  def save_permission_roles
    PermissionRole.update_all(:value=>false)
    params[:permission_role].each do |k,v|
      v.each do |k1,v1|
        permission_role=PermissionRole.where(:permission_id=>k,:role_id=>k1).first
        if permission_role.nil?
          PermissionRole.create_role(k,k1)
          #pr=PermissionRole.new
         # pr.permission_id=k
          #pr.role_id=k1
        end
        permission_role.value=true
        permission_role.save
      end
    end
    flash[:notice]=t(:permission_saved)
    respond_to do |format|
      format.html { redirect_to admin_dashboard_path }
      format.xml  { head :ok }
    end
  end
  private
  def find_permission
     @permission = Permission.find(params[:id])
  end
end
