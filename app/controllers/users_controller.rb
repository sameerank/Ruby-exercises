class UsersController < ApplicationController
    def index
      render json: params  #json: params
      # render text: "I'm in the index action!"
    end

    def create
      user = User.new(params[:user].permit(:name, :email))
      if user.save
        render json: user
      else
        render(
        json: user.errors.full_messages, status: :unprocessable_entity
        )
      end
    end

    def show
      render json: User.where(:id => params[:id])
    end

    def update
      puts params[:user]
      User.update(params[:id], params[:user].permit(:name, :email))
    end

    def destroy
      User.destroy(params[:id])
    end
end
