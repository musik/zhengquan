#encoding: utf-8
class StoresController < ApplicationController
  load_and_authorize_resource :except=>[:province,:province_company]
  before_filter :yyb_breadcrumbs,except: %w(province_company)
  def yyb_breadcrumbs
    breadcrumbs.add :yyb,(action_name == 'index' && params[:page].nil?) ? nil : stores_url
  end
  # GET /stores
  # GET /stores.json
  
  def index
    @stores = Store.page(params[:page] || 1).includes([:company,:province,:city])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @stores }
    end
  end
  def province
    @province = Province.find_by_name_en(params[:province])
    @companies = @province.companies if params[:page].nil?
    @stores = @province.stores.page(params[:page] || 1).includes([:company,:province,:city])
    @groups = @province.stores.group(:company_id).includes(:company)
    breadcrumbs.add @province.name,(params[:page].nil? ? nil : province_url(@province.name_en))
    @title = "#{@province.short_name}证券公司"
    #render :index
  end
  def province_company
    @province = Province.find_by_name_en(params[:province])
    #@companies = @province.companies if params[:page].nil?
    @company = Company.find_by_slug(params[:id])
    @stores = @province.stores.where(:company_id=>@company.id).page(params[:page] || 1).includes([:company,:province,:city])
    #@groups = @province.stores.group(:company_id).includes(:company)
    @pgroups = @company.stores.group(:province_id).includes(:province)
    breadcrumbs.add @company.to_short,company_home_url(@company.slug)
    breadcrumbs.add @province.short_name + "分公司"
    @title = "#{@company.short}#{@province.short_name}分公司_#{@company.name}在#{@province.name}的营业部"
    @header = "#{@province.short_name}分公司"
    @header = "<span class='pre'>#{@company.name} &raquo;</span> #{@header}"
    #render :province
  end
  def dirty
    @stores = Store.includes([:company,:province,:city]).page(params[:page] || 1).per(100)
    if params[:pnull]
      @stores = @stores.province_null
    elsif params[:cnull]
      @stores = @stores.city_null
    else
      @stores = @stores.city_null.province_null
    end
  end

  # GET /stores/1
  # GET /stores/1.json
  def show
    breadcrumbs.add @store.company.short,company_home_url(@store.company)
    breadcrumbs.add @store.short_name

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @store }
    end
  end

  # GET /stores/new
  # GET /stores/new.json
  def new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @store }
    end
  end

  # GET /stores/1/edit
  def edit
  end

  # POST /stores
  # POST /stores.json
  def create

    respond_to do |format|
      if @store.save
        format.html { redirect_to @store, notice: 'Store was successfully created.' }
        format.json { render json: @store, status: :created, location: @store }
      else
        format.html { render action: "new" }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /stores/1
  # PUT /stores/1.json
  def update

    respond_to do |format|
      if @store.update_attributes(params[:store])
        format.html { redirect_to @store, notice: 'Store was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stores/1
  # DELETE /stores/1.json
  def destroy
    @store.destroy

    respond_to do |format|
      format.html { redirect_to stores_url }
      format.json { head :no_content }
    end
  end
end
