class PagesController < ApplicationController
  before_action :set_page, only: %i[show edit update destroy]

  # GET /pages or /pages.json
  def index
    @page = Page.find_or_initialize_by title: ENV.fetch("HOME_TITLE", "home")
    authorize @page, :show?

    if @page.persisted?
      redirect_to @page
    else
      redirect_to edit_page_url(@page) unless @page.persisted?
    end
  end

  def rebuild
    authorize Page, :rebuild?
    Page.find_each { |page| ExportPageToIpfsJob.perform_later page }
  end

  # GET /pages/1 or /pages/1.json
  def show
    if !@page.persisted?
      redirect_to edit_page_url(@page)
    elsif !signed_in?
      redirect_to @page.ipfs.url, allow_other_host: true
    end
  end

  # GET /pages/new
  def new
    @page = Page.new
  end

  # GET /pages/1/edit
  def edit
    render layout: "admin"
  end

  # POST /pages or /pages.json
  def create
    @page = Page.new(page_params)

    respond_to do |format|
      if @page.save
        format.html { redirect_to page_url(@page), notice: "Page was successfully created." }
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
        format.html { redirect_to page_url(@page), notice: "Page was successfully updated." }
        format.json { render :show, status: :ok, location: @page }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1 or /pages/1.json
  def destroy
    @page.destroy

    respond_to do |format|
      format.html { redirect_to pages_url, notice: "Page was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_page
    @page = Page.find_or_initialize_by(title: params[:id])
    authorize @page
  end

  # Only allow a list of trusted parameters through.
  def page_params
    params.require(:page).permit(:title, :content)
  end
end
