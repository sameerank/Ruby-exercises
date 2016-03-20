# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  url        :string
#  content    :text
#  sub_id     :integer          not null
#  author_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PostsController < ApplicationController
  before_action :require_logged_in, except: [:show]
  before_action :require_ownership, only: [:edit, :create, :update, :new]

  def new
    @post = Post.new()
  end

  def edit
    
  end

  def show

  end

  def create

  end

  def update

  end

  def destroy

  end

  private

  def post_params
    params.require(:post).permit(:title, :url, :content, :sub_id, :author_id)
  end
end
