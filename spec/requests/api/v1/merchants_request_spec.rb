require 'rails_helper'

describe "Merchants API" do
  it "sends a list of merchants" do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(3)

    merchants[:data].each do |merchant|
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end 
  end
  
  it "can get one merchant by its id" do
    id = create(:merchant).id
    
    get "/api/v1/merchants/#{id}"
    
    merchant = JSON.parse(response.body, symbolize_names: true)
    
    expect(response).to be_successful
    expect(merchant[:data][:attributes]).to have_key(:name)
    expect(merchant[:data][:attributes][:name]).to be_a(String)
  end

  it "can get all items for one merchant" do
    merchant = create(:merchant)
    item1 = create(:item, merchant: merchant)
    item2 = create(:item, merchant: merchant)
    item3 = create(:item, merchant: merchant)

    get "/api/v1/merchants/#{merchant.id}/items"

    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(items).to have_key(:data)
    expect(items[:data]).to be_an(Array)
    expect(items[:data].count).to eq(3)

    items[:data].each do |item|
      expect(item).to have_key(:id)
      expect(item).to have_key(:type)
      expect(item[:type]).to eq("item")

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes]).to have_key(:description)
      
      expect(item[:attributes][:name]).to be_a(String)
      expect(item[:attributes][:description]).to be_a(String)
      expect(item[:attributes][:unit_price]).to be_a(Float)
      expect(item[:attributes][:merchant_id]).to eq(merchant.id)
    end
  end


end