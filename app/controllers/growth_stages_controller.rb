class GrowthStagesController < ApplicationController
  layout "dashboard"
  before_action :set_stage, only: [:edit, :update, :destroy]
  before_action :require_admin!, only: [:new, :create, :edit, :update, :destroy]

  def index
    @stages = GrowthStage.order(:position)
  end

  def new
    @stage = GrowthStage.new
  end

  def edit
  end

  def create
    @stage = GrowthStage.new(stage_params)
    if @stage.save
      redirect_to growth_stages_path, notice: "Growth stage was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @stage.update(stage_params)
      redirect_to growth_stages_path, notice: "Growth stage was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @stage.destroy
    redirect_to growth_stages_path, notice: "Growth stage was successfully deleted."
  end

  private

  def set_stage
    @stage = GrowthStage.find(params[:id])
  end

  def stage_params
    params.require(:growth_stage).permit(:name, :gdd_threshold, :description, :position)
  end
end
