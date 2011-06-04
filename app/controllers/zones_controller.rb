class ZonesController < ApplicationController
  respond_to :html, :xml, :json
  before_filter :load_zone, :only => [:show, :edit, :update, :destroy, :all_records, :bulk_delete_records, :add_records]
  before_filter :load_zones, :only => [:index]
  before_filter :load_groups, :only => [:new, :edit, :create, :update]
  before_filter :load_records, :only => [:all_records, :bulk_delete_records, :add_records]

  protected
  def load_zone
    @zone = Zone.find(params[:zone_id] || params[:id])
  end

  def load_zones
    @search_form = SearchForm.new(params[:search_form])

    if params[:group_id]
      @zones = Zone.where(:group_id => params[:group_id])
    else
      if @search_form.q.present?
        @zones = Zone.name_matches(@search_form.q)
      else
        @zones = Zone.all
      end
    end

    @zones = @zones.paginate(:page => params[:page], :per_page => params[:per_page])
  end

  def load_groups
    @groups = Group.all.asc(:name)
  end

  def load_records
    @records = BeagleNsupdate::Record.all(@zone)
  end

  public
  # GET /zones
  # GET /zones.xml
  def index
    respond_with @zones
  end

  # GET /zones/1
  # GET /zones/1.xml
  def show
    respond_with @zone
  end

  # GET /zones/new
  # GET /zones/new.xml
  def new
    @zone = Zone.new

    respond_with @zone
  end

  # GET /zones/1/edit
  def edit
  end

  # POST /zones
  # POST /zones.xml
  def create
    @zone = Zone.new(params[:zone])

    respond_to do |format|
      if @zone.save
        format.html { redirect_to(@zone, :notice => 'Zone was successfully created.') }
        format.xml  { render :xml => @zone, :status => :created, :location => @zone }
        format.json  { render :json => @zone, :status => :created, :location => @zone }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @zone.errors, :status => :unprocessable_entity }
        format.json  { render :json => @zone.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /zones/1
  # PUT /zones/1.xml
  def update
    respond_to do |format|
      if @zone.update_attributes(params[:zone])
        format.html { redirect_to(@zone, :notice => 'Zone was successfully updated.') }
        format.xml  { head :ok }
        format.json  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @zone.errors, :status => :unprocessable_entity }
        format.json  { render :json => @zone.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /zones/1
  # DELETE /zones/1.xml
  def destroy
    @zone.destroy

    respond_to do |format|
      format.html { redirect_to(zones_url) }
      format.xml  { head :ok }
      format.json  { head :ok }
    end
  end

  # Records
  def all_records
    respond_with @records
  end

  def bulk_delete_records
    if params[:records]
      ids = params[:records].map {|param| param[:id] }
      del_recs = ids.inject([]) {|result, id| result << @records.find() {|rec| rec.id == id } }
      BeagleNsupdate::Record.destroy_all(@zone, del_recs)
#      del_recs.each {|rec| rec.destroy(@zone) }
    end

    respond_to do |format|
      format.html { redirect_to(all_records_zone_url) }
      format.xml  { head :ok }
      format.json  { head :ok }
    end
  end

  def add_records
    if params[:record]
      @record = BeagleNsupdate::Record.new(params[:record])

      respond_to do |format|
        if @record.save(@zone)
          format.html { redirect_to(all_records_zone_url, :notice => 'Record was successfully created.') }
          format.xml  { render :xml => @record, :status => :created, :location => @record }
          format.json  { render :json => @record, :status => :created, :location => @record }
        else
          flash[:errors] = @record.errors
          format.html { redirect_to(all_records_zone_url, :alert => 'Record creation was failed!') }
          format.xml  { render :xml => @record.errors, :status => :unprocessable_entity }
          format.json  { render :json => @record.errors, :status => :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to(all_records_zone_url) }
        format.xml  { head :ok }
        format.json  { head :ok }
      end
    end
  end
end
