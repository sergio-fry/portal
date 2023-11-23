# frozen_string_literal: true

class PagesController < ApplicationController
  before_action :set_page, only: %i[show edit update]
  include PagesHelper

  # GET /pages or /pages.json
  def index
    @page = Page.new(
      DependenciesContainer.resolve(:pages).find_aggregate(ENV.fetch('HOME_TITLE', 'home')),
      context: self
    )

    authorize @page, :show?

    if @page.exists?
      redirect_to page_url(@page.slug)
    else
      redirect_to edit_page_url(@page)
    end
  end

  def rebuild
    authorize :page, :rebuild?

    Dependencies.container.resolve(:pages).each do |page|
      RebuildPageJob.perform_later page.slug
    end

    redirect_to :admin
  end

  # GET /pages/1 or /pages/1.json
  def show
    if @page.exists?
      redirect_to URI.parse(@page.url).path
    else
      redirect_to edit_page_url(@page)
    end

    fresh_when(@page)
  end

  # GET /pages/new
  def new
    @page = NewPage.new context: self, params: page_params
    authorize @page, :new?, policy_class: PagePolicy
    render layout: 'admin'
  end

  # GET /pages/1/edit
  def edit
    render layout: 'admin'
  end

  # POST /pages or /pages.json
  def create
    @page = NewPage.new(params: page_params, context: self)
    authorize @page

    respond_to do |format|
      if @page.save
        format.html { redirect_to page_url(@page) }
        format.json { render :show, status: :created, location: @page }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pages/1 or /pages/1.json
  def update
    respond_to do |format|
      @page.assign_attributes(page_params)

      if @page.save
        format.html { redirect_to page_url(@page) }
        format.json { render :show, status: :ok, location: @page }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_page
    @page = Page.new(DependenciesContainer.resolve(:pages).find_aggregate(params[:id]), context: self)
    authorize @page
  end

  # Only allow a list of trusted parameters through.
  def page_params
    params.require(:page).permit(:slug, :content)
  rescue ActionController::ParameterMissing
    {}
  end
end
