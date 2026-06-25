class TagsController < ApplicationController
  layout "dashboard"
  before_action :require_admin!

  def index
    @tags = Tag.order(:name)
    @tag  = Tag.new
  end

  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      redirect_to tags_path, notice: "Tag created."
    else
      @tags = Tag.order(:name)
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    Tag.find(params[:id]).destroy
    redirect_to tags_path, notice: "Tag deleted."
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end
end
