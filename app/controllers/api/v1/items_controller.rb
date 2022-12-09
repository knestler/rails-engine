class Api::V1::ItemsController < ApplicationController

  def index
    if params[:merchant_id] && Merchant.find(params[:merchant_id])
      render json: ItemSerializer.new(Item.where(merchant_id: params[:merchant_id]))
    else 
      render json: ItemSerializer.new(Item.all)
    end
  end

  def show
      render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    if item_params.has_key?(:name) && item_params.has_key?(:description) && item_params.has_key?(:unit_price) && item_params.has_key?(:merchant_id)
      render json: ItemSerializer.new(Item.create(item_params)), status: 201 
    else 
      render json: {"Error": "Record not found"}, status: 404
    end
  end

  def update
    Merchant.find(params[:item][:merchant_id]) if params[:item][:merchant_id] 
      render json: ItemSerializer.new(Item.update(params[:id], item_params))
  end

  def destroy
    render json: Item.delete(params[:id])
  end
  
private
  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end

end