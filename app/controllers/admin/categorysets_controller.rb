class Admin::CategorysetsController < ApplicationController
  #FILTER
  before_filter :find_categoryset, :only => [:show, :edit, :update, :destroy]
  before_filter :require_admin

  # GET /categorysets
  # GET /categorysets.xml
  def index
    @categorysets = Categoryset.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @categorysets }
    end
  end

  # GET /categorysets/1
  # GET /categorysets/1.xml
  def show
   # @categoryset = Categoryset.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @categoryset }
    end
  end

  # GET /categorysets/new
  # GET /categorysets/new.xml
  def new
    @categoryset = Categoryset.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @categoryset }
    end
  end

  # GET /categorysets/1/edit
  def edit
    #@categoryset = Categoryset.find(params[:id])
  end

  # POST /categorysets
  # POST /categorysets.xml
  def create
    @categoryset = Categoryset.new(params[:categoryset])
    respond_to do |format|
      if @categoryset.save
        format.html { redirect_to(categorysets_path, :notice => t(:categoryset_created)) }
        format.xml  { render :xml => @categoryset, :status => :created, :location => @categoryset }
      else
        format.html { render  "new" }
        format.xml  { render :xml => @categoryset.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /categorysets/1
  # PUT /categorysets/1.xml
  def update
    #@categoryset = Categoryset.find(params[:id])
    respond_to do |format|
      if @categoryset.update_attributes(params[:categoryset])
        format.html { redirect_to(categorysets_path, :notice => t(:categoryset_updated)) }
        format.xml  { head :ok }
      else
        format.html { render  "edit" }
        format.xml  { render :xml => @categoryset.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /categorysets/1
  # DELETE /categorysets/1.xml
  def destroy
   # @categoryset = Categoryset.find(params[:id])
    @categoryset.destroy
    respond_to do |format|
      format.html { redirect_to(categorysets_url,:notice=> t(:category_deleted)) }
      format.xml  { head :ok }
    end
  end

  protected
  def find_categoryset
    @categoryset = Categoryset.find(params[:id])
   end
end
