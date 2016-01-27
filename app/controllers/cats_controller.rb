# == Schema Information
#
# Table name: cats
#
#  id          :integer          not null, primary key
#  birth_date  :date
#  color       :string
#  name        :string           not null
#  sex         :string(1)
#  description :text
#

class CatsController < ApplicationController
  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find_by(id: params[:id])
    if @cat
      render :show
    else
      fail "Cat not found".
      render :index
    end
  end

  def new
    # @cat = Cat.create(params[:cats])
    @cat = Cat.new
    # render :index
  end

  def create
    @cat = Cat.new(cat_params)
    @cat.save
    redirect_to cat_url(@cat)
  end

  def edit
    @cat = Cat.find_by(id: params[:id])
  end

  def update
    @cat = Cat.find_by(id: params[:id])
    @cat.update(cat_params)
    redirect_to cat_url(@cat)
  end

  private
  def cat_params
    params[:cat].permit(:name, :birth_date, :color, :sex, :description)
  end
end
