#class JournalsController < ApplicationController
#class OfficeController < ApplicationController
class OfficeController < OfficeBaseController


  before_action :set_context, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /contexts
  # GET /contexts.json
#  def index
#    @contexts = Context.all
#    @conferences = Conference.all
#    @journals = Journal.all
#  end

  # GET /contexts/1
  # GET /contexts/1.json
  def show
    @sidebar_active='dashboard'
  end

=begin

  # GET /contexts/new
  def new
    @context = Context.new
  end

  # GET /contexts/1/edit
  def edit
#        authorize @context, :can_admin?
  end

  # POST /contexts
  # POST /contexts.json
  def create
    @context = Context.new(context_params.merge user: current_user)

    respond_to do |format|
      if @context.save
        format.html { redirect_to @context, notice: 'Context was successfully created.' }
#        format.html { redirect_to contexts_path, notice: 'Context was successfully created.' }
        format.json { render :show, status: :created, location: @context }
      else
        format.html { render :new }
        format.json { render json: @context.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contexts/1
  # PATCH/PUT /contexts/1.json
  def update
    respond_to do |format|
      if @context.update(context_params)
        format.html { redirect_to @context, notice: 'Context was successfully updated.' }
        format.json { render :show, status: :ok, location: @context }
      else
        format.html { render :edit }
        format.json { render json: @context.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contexts/1
  # DELETE /contexts/1.json
  def destroy
    @context.destroy
    respond_to do |format|
      format.html { redirect_to contexts_url, notice: 'Context was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

=end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_context
      @journal = Journal.all.first
      #@journal = Journal.find(params[:id])
      #add_breadcrumb @context.title, context_path(@context)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def context_params
#      params.require(:context).permit(:title, :desription, :slug, :type, :user_id)
      params.require(:context).permit(:title, :description, :slug, :type)
    end
end

