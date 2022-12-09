require 'rails_helper'

describe "Items API" do
  it "gets a list of items" do
    create_list(:item, 3)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(3)

    items[:data].each do |item|
      expect(item).to have_key(:id)
      expect(item).to have_key(:type)
      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:name]).to be_a(String)
      expect(item[:attributes][:description]).to be_a(String)
      expect(item[:attributes][:unit_price]).to be_a(Float)
    end 
  end

  it "can get one item by its id" do
    id = create(:item).id

    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(item[:data]).to have_key(:id)
    expect(item[:data]).to have_key(:type)
    expect(item[:data]).to have_key(:attributes)

    expect(item[:data][:attributes]).to have_key(:name)
    expect(item[:data][:attributes]).to have_key(:description)
    expect(item[:data][:attributes]).to have_key(:unit_price)
    expect(item[:data][:attributes]).to have_key(:merchant_id)
    expect(item[:data][:attributes][:name]).to be_a(String)
    expect(item[:data][:attributes][:description]).to be_a(String)
    expect(item[:data][:attributes][:unit_price]).to be_a(Float)
  end

  it "can create a new item" do
    id = create(:merchant).id
    item_params = ({
                    name: 'jeans',
                    description: 'bottoms',
                    unit_price: 70.75,
                    merchant_id: id,
                  })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    created_item = Item.last

    expect(response).to be_successful
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])
  end

  it "can create a new item - sad path" do
    id = create(:merchant).id
    item_params = ({
                    name: 'jeans',
                    description: 'bottoms',
                    # unit_price: 70.75,
                    merchant_id: id,
                  })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    created_item = Item.last
    
    expect(response.status).to eq 404

  end

  it 'can update an existing item' do
    id = create(:item).id
    previous_name = Item.last.name
    item_params = { name: 'Jeans' }
    headers = { "CONTENT_TYPE" => "application/json" }

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
    item = Item.find_by(id: id)

    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq('Jeans')
  end

  it "can update an existing item - sad path" do
    m_id = create(:merchant, id: 1).id
    id = create(:item, merchant_id: m_id).id
    item_params = ({
                    name: 'jeans',
                    description: 'bottoms',
                    unit_price: 70.75,
                    merchant_id: 2,
                  })

    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})

    expect(response.status).to eq 404
  end

  it "can destroy an item" do
    item = create(:item)

    expect(Item.count).to eq(1)

    delete "/api/v1/items/#{item.id}"

    expect(response).to be_successful
    expect(Item.count).to eq(0)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'can find merchant by id' do 
    merchant1 = create(:merchant)
    merchant2 = create(:merchant)
    id = create(:item, merchant: merchant1).id

    get "/api/v1/items/#{id}/merchant"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(merchant).to have_key(:data)
    expect(merchant[:data]).to have_key(:attributes)
    expect(merchant[:data][:attributes]).to have_key(:name)
    expect(merchant[:data][:attributes][:name]).to eq(merchant1.name)
  end
end