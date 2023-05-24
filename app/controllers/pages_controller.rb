# frozen_string_literal: true

class PagesController < ApplicationController
  before_action :set_page, only: %i[edit update]
  before_action :set_page_aggregate, only: %i[show]
  include PagesHelper

  # GET /pages or /pages.json
  def index
    @page = Page.new(DependenciesContainer.resolve(:pages).find_aggregate(ENV.fetch('HOME_TITLE', 'home')))
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
      render inline:
        WithInjectedIpfsLink.new(
          @page.processed_content_with_layout, @page
        )
    else
      redirect_to edit_page_url(@page)
    end
  end

  # GET /pages/new
  def new
    @page = NewPage.new
  end

  # GET /pages/1/edit
  def edit
    render layout: 'admin'
  end

  # POST /pages or /pages.json
  def create
    @page = NewPage.new(page_params)

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
    @page = Page.new ::Page.new(params[:id])

    authorize @page
  end

  def set_page_aggregate
    @page = Page.new(DependenciesContainer.resolve(:pages).find_aggregate(params[:id]))
    authorize @page
  end

  # Only allow a list of trusted parameters through.
  def page_params
    params.require(:page).permit(:slug, :content)
  end
end
