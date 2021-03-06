class Admin::MenusController < ApplicationController
#Includes
  include ApplicationHelper
  #FILTERS
   before_filter :find_menu, :only => [:show, :edit, :update, :destroy]
  before_filter :require_admin

  # GET /menus
  # GET /menus.xml
  def index
    @all_menus = get_all_menus(Menu.new).collect{|m|[m.treename,m.id]}
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @menus }
    end
  end

  # GET /menus/1
  # GET /menus/1.xml
  def show
   # @menu = Menu.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @menu }
    end
  end

  # GET /menus/new
  # GET /menus/new.xml
  def new
    @menu = Menu.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @menu }
    end
  end

  # GET /menus/1/edit
  def edit
    #@menu = Menu.find(params[:id])
  end

  # POST /menus
  # POST /menus.xml
  def create
    @menu = Menu.new(params[:menu])

    respond_to do |format|
      if @menu.save
        format.html { redirect_to(menus_path, :notice => t(:menu_created)) }
        format.xml  { render :xml => @menu, :status => :created, :location => @menu }
      else
        format.html { render  "new" }
        format.xml  { render :xml => @menu.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /menus/1
  # PUT /menus/1.xml
  def update
   # @menu = Menu.find(params[:id])

    respond_to do |format|
      if @menu.update_attributes(params[:menu])
        format.html { redirect_to(menus_path, :notice => t(:menu_updated)) }
        format.xml  { head :ok }
      else
        format.html { render  "edit" }
        format.xml  { render :xml => @menu.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /menus/1
  # DELETE /menus/1.xml
  def destroy
   # @menu = Menu.find(params[:id])
    @menu.destroy

    respond_to do |format|
      format.html { redirect_to(menus_url,:notice=>t(:menu_deleted)) }
      format.xml  { head :ok }
    end
  end

  # POST /menus/update_position
  # POST /menus/update_position.xml
  def update_position
     Menu.all.each do |menu|
      menu.update_attribute(:position,params["#{menu.id}"])
    end
    respond_to do |format|
      format.html { redirect_to(menus_url) }
      format.xml  { head :ok }
    end
  end
  private
  def find_menu
     @menu = Menu.find(params[:id])
  end
end
