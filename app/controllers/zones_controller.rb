class ZonesController < ApplicationController
  respond_to :html, :xml, :json
  before_filter :load_zone, :only => [:show, :edit, :update, :destroy, :all_records, :bulk_delete_records, :bulk_add_records, :add_record]
  before_filter :load_zones, :only => [:index]
  before_filter :load_groups, :only => [:index, :new, :edit, :create, :update, :bulk_insert]
  before_filter :load_records, :only => [:all_records, :bulk_delete_records, :bulk_add_records, :add_record]

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

    @zones = @zones.desc(:group_id).asc(:name)
    @zones = @zones.paginate(:page => params[:page], :per_page => params[:per_page]) if params[:per_page]
  end

  def load_groups
    @groups = Group.all.asc(:name)
  end

  def load_records
    @search_form = RecordSearchForm.new(params[:record_search_form])

    if @search_form.q.present? || @search_form.type.present?
      @records = BeagleNsupdate::Record.where(@zone, :name => @search_form.q, :type => @search_form.type)
    else
      @records = BeagleNsupdate::Record.all(@zone)
    end

    @records = @records.paginate(:page => params[:page], :per_page => params[:per_page]) if params[:per_page]
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
        redirect_path = params[:group_id] ? :back : @zone
        format.html { redirect_to(redirect_path, :notice => 'Zone was successfully created.') }
        format.xml  { render :xml => @zone, :status => :created, :location => @zone }
        format.json  { render :json => @zone, :status => :created, :location => @zone }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @zone.errors, :status => :unprocessable_entity }
        format.json  { render :json => @zone.errors, :status => :unprocessable_entity }
      end
    end
  end

  def bulk_insert
    if params[:zones]
      add_zones = params[:zones].reject {|zone| zone["remove"]["_destroy"] == "1" }
      add_zones.each {|zone| zone.delete("remove") }
      @zones = add_zones.map {|zone| Zone.new(zone) }
      @zones = @zones.select {|zone| zone.valid? }

      @zones.each {|zone| zone.save }
    end

    respond_to do |format|
      format.html { redirect_to(zones_url, :notice => 'Executed Bulk insert zones.') }
      format.xml  { head :ok }
      format.json  { head :ok }
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
      format.html { redirect_to :back }
      format.xml  { head :ok }
      format.json  { head :ok }
    end
  end

  # DELETE /zones/bulk_destroy
  def bulk_destroy
    if params[:zones]
      ids = params[:zones].map {|param| param[:id] }
      del_zones = Zone.where(:id.in=> ids).destroy_all
    end

    respond_to do |format|
      format.html { redirect_to :back }
      format.xml  { head :ok }
      format.json  { head :ok }
    end
  end

  # Records
  def all_records
    flash[:errors] = BeagleNsupdate::Record.errors if BeagleNsupdate::Record.errors

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

  def bulk_add_records
    if params[:records]
      add_recs = params[:records].reject {|rec| rec["remove"]["_destroy"] == "1" }
      add_recs.each {|rec| rec.delete("remove") }

      @records = add_recs.map {|rec| BeagleNsupdate::Record.new(rec) }
      @records = @records.select {|rec| rec.valid? }

      @records.each {|rec| rec.save(@zone) }
    end

    respond_to do |format|
      format.html { redirect_to(all_records_zone_url, :notice => 'Executed Bulk add Records.') }
      format.xml  { head :ok }
      format.json  { head :ok }
    end
  end

  def add_record
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
