class GroupsController < ApplicationController
  respond_to :html, :xml, :json
  before_filter :load_group, :only => [:show, :edit, :update, :destroy]
  before_filter :load_groups, :only => [:index]

  protected
  def load_group
    @group = Group.find(params[:id])
  end

  def load_groups
    @search_form = SearchForm.new(params[:search_form])

    if @search_form.q.present?
      @groups = Group.name_matches(@search_form.q)
    else
      @groups = Group.all
    end

    @groups = @groups.asc(:name).paginate(:page => params[:page], :per_page => params[:per_page])
  end

  public
  # GET /groups
  # GET /groups.xml
  def index
    respond_with @groups
  end

  # GET /groups/1
  # GET /groups/1.xml
  def show
    respond_with @group
  end

  # GET /groups/new
  # GET /groups/new.xml
  def new
    @group = Group.new

    respond_with @group
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.xml
  def create
    @group = Group.new(params[:group])

    respond_to do |format|
      if @group.save
        format.html { redirect_to(@group, :notice => 'Group was successfully created.') }
        format.xml  { render :xml => @group, :status => :created, :location => @group }
        format.json  { render :json => @group, :status => :created, :location => @group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
        format.json  { render :json => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.xml
  def update
    respond_to do |format|
      if @group.update_attributes(params[:group])
        format.html { redirect_to(@group, :notice => 'Group was successfully updated.') }
        format.xml  { head :ok }
        format.json  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
        format.json  { render :json => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.xml
  def destroy
    @group.destroy

    respond_to do |format|
      format.html { redirect_to :back }
      format.xml  { head :ok }
      format.json  { head :ok }
    end
  end
end
