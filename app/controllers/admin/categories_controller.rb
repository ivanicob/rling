class Admin::CategoriesController < ApplicationController
  # Includes
  include ApplicationHelper
  #FILTER
  before_filter :find_category, :only => [:show, :edit, :update, :destroy]

  before_filter :require_admin

  # GET /categories
  # GET /categories.xml
  def index
    @all_categories = get_all_categories(Category.new).collect{|c|[c.treename,c.id]}
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @categories }
    end
  end

  # GET /categories/1
  # GET /categories/1.xml
  def show
    #@category = Category.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @category }
    end
  end

  # GET /categories/new
  # GET /categories/new.xml
  def new
    @category = Category.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @category }
    end
  end

  # GET /categories/1/edit
  def edit
    #@category = Category.find(params[:id])
  end

  # POST /categories
  # POST /categories.xml
  def create
    @category = Category.new(params[:category])
    respond_to do |format|
      if @category.save
        format.html { redirect_to(categories_path, :notice => t(:category_created)) }
        format.xml  { render :xml => @category, :status => :created, :location => @category }
      else
        format.html { render  "new" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /categories/1
  # PUT /categories/1.xml
  def update
   # @category = Category.find(params[:id])
    respond_to do |format|
      if @category.update_attributes(params[:category])
        format.html { redirect_to(categories_path, :notice => t(:category_updated)) }
        format.xml  { head :ok }
      else
        format.html { render  "edit" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.xml
  def destroy
   # @category = Category.find(params[:id])
    @category.destroy
    respond_to do |format|
      format.html { redirect_to(categories_url,:notice=> t(:category_deleted)) }
      format.xml  { head :ok }
    end
  end

  # POST /categories/update_position
  # POST /categories/update_position.xml
  def update_position
     Category.all.each do |category|
      category.update_attribute(:position,params["#{category.id}"])
    end
    respond_to do |format|
      format.html { redirect_to(categories_url) }
      format.xml  { head :ok }
    end
  end

  protected
  def find_category
    @category = Category.find(params[:id])
   end
end