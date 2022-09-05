class PagesController < ApplicationController
  before_action :set_page, only: %i[show edit update destroy history]
  include PagesHelper

  # GET /pages or /pages.json
  def index
    @page = Page.find_or_initialize_by slug: ENV.fetch('HOME_TITLE', 'home')
    authorize @page, :show?

    if @page.persisted?
      redirect_to @page
    else
      redirect_to edit_page_url(@page) unless @page.persisted?
    end
  end

  def history
    authorize @page, :history?

    render inline: @page.history.to_s
  end

  def rebuild
    authorize Page, :rebuild?

    Page.find_each do |page|
      page.sync_to_ipfs
      page.history_ipfs_cid = Ipfs::NewContent.new(page.history.to_s).cid
      page.save!
    end
  end

  # GET /pages/1 or /pages/1.json
  def show
    redirect_to edit_page_url(@page) unless @page.persisted?
  end

  # GET /pages/new
  def new
    @page = Page.new
  end

  # GET /pages/1/edit
  def edit
    render layout: 'admin'
  end

  # POST /pages or /pages.json
  def create
    @page = Page.new(page_params)

    respond_to do |format|
      if @page.save
        format.html { redirect_to page_url(@page), notice: 'Page was successfully created.' }
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
        format.html { redirect_to page_url(@page), notice: 'Page was successfully updated.' }
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
      format.html { redirect_to pages_url, notice: 'Page was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_page
    @page = Page.find_or_initialize_by(slug: params[:id])
    authorize @page
  end

  # Only allow a list of trusted parameters through.
  def page_params
    params.require(:page).permit(:slug, :content)
  end
end
