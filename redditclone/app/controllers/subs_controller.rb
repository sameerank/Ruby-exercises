# == Schema Information
#
# Table name: subs
#
#  id           :integer          not null, primary key
#  title        :string           not null
#  description  :text
#  moderator_id :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class SubsController < ApplicationController

  before_action :require_logged_in, except: [:show, :index]
  before_action :require_ownership, only: [:edit, :create, :update, :new]

  def new
    @sub = Sub.new
    render :new
  end

  def create
    @sub = Sub.create(sub_params.merge(moderator_id: current_user.id))
    if @sub.save
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :new
    end
  end

  def index
    @subs = Sub.all
    render :index
  end

  def show
    @sub = Sub.find_by(id: params[:id])
    render :show
  end

  def update
    @sub = Sub.find_by(id: params[:id])
    merged_params = sub_params.merge(moderator_id: current_user.id)
    success = @sub.update(merged_params)
    if success
      redirect_to sub_url(@sub)
    else
      flash.new[:errors] = @sub.errors.full_messages
      render :new
    end
  end

  def edit
    @sub = Sub.find_by(id: params[:id])
  end

  private

  def require_ownership
    @sub = Sub.find_by(id: params[:id])
    unless current_user.id == @sub.moderator_id
      redirect_to sub_url(@sub)
    end
  end

  def sub_params
    params.require(:sub).permit(:title, :description)
  end
end
