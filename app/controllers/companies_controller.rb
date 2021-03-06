#encoding: utf-8
class CompaniesController < ApplicationController
  load_and_authorize_resource :find_by=>'slug',:except=>[:city,:new_versions]
  def home
    @companies = Company.all_by_az
  end
  # GET /companies
  # GET /companies.json
  def index
    @companies = Company.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @companies }
    end
  end
  def recent_versions
    breadcrumbs.add "最近编订版本"
    @versions = VestalVersions::Version.includes(:versioned).
      order('id desc').page(params[:page]).per(30)
  end

  # GET /companies/1
  # GET /companies/1.json
  def show
    #@company = Company.find_by_slug(params[:id])
    @version = params[:version] || @company.vn
    @company.revert_to(@version.to_i)
    @stores = @company.stores.limit(10).all
    @groups = @company.stores.group(:Province_id).includes(:province)
    breadcrumbs.add @company.city.name,nil if @company.city.present?
    breadcrumbs.add @company.to_short

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @company }
    end
  end
  def yyb
    @stores = @company.stores.page(params[:page] || 1)
    @pgroups = @company.stores.group(:province_id).includes(:province)
    #breadcrumbs.add @company.city.name,nil if @company.city.present?
    breadcrumbs.add @company.name,company_home_url(@company.slug)
    breadcrumbs.add :yyb,nil
  end
  def versions
    breadcrumbs.add @company.name,company_home_url(@company.slug)
    breadcrumbs.add :versions,nil
  end


  # GET /companies/new
  # GET /companies/new.json
  def new
    @company = Company.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @company }
    end
  end

  # GET /companies/1/edit
  def edit
    #@company = Company.find_by_slug(params[:id])
    breadcrumbs.add @company.to_short,company_home_url(@company.slug)
    breadcrumbs.add :edit
  end

  # POST /companies
  # POST /companies.json
  def create
    @company = Company.new(params[:company])

    respond_to do |format|
      if @company.save
        format.html { redirect_to @company, notice: 'Company was successfully created.' }
        format.json { render json: @company, status: :created, location: @company }
      else
        format.html { render action: "new" }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /companies/1
  # PUT /companies/1.json
  def update
    #@company = Company.find_by_slug(params[:id])
    if params[:vn]
      @company.update_vn params[:vn]
      head :no_content
      return
    end
    respond_to do |format|
      if @company.update_attributes(params[:company])
        format.html { redirect_to @company, notice: '信息已提交，请等待审核通过才会更新。' }
        format.json { head :no_content }
        format.js { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    #@company = Company.find_by_slug(params[:id])
    @company.destroy

    respond_to do |format|
      format.html { redirect_to companies_url }
      format.json { head :no_content }
    end
  end
end
