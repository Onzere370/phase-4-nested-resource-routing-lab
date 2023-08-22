class ItemsController < ApplicationController
  def index
    if params[:user_id]
      user = User.find_by(id: params[:user_id])
      if user
        items = user.items
        render json: items, include: :user
      else
        render json: { error: "User not found" }, status: :not_found
      end
    else
      items = Item.all
      render json: items
    end
  end
  
  def create
    user = User.find(params[:user_id])
    item = user.items.build(item_params)
    if item.save
      render json: item, status: :created
    else
      render json: { errors: item.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def show
    user = User.find_by(id: params[:user_id])
    if user
      item = user.items.find_by(id: params[:id])
      if item
        render json: item
      else
        render json: { error: "Item not found" }, status: :not_found
      end
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end
  
  private
  
  def item_params
    params.require(:item).permit(:name, :description, :price)
  end
end