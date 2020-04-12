require 'rails_helper'

describe Merchant, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe "relationships" do
    it {should have_many :items}
    it {should have_many :users}
  end

  describe 'instance methods' do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @user = User.create!(name: "Josh Tukman",
                            address: "756 Main St.",
                            city: "Denver",
                            state: "Colorado",
                            zip: "80209",
                            email: "josh.t@gmail.com",
                            password: "secret_password",
                            password_confirmation: "secret_password",
                            role: 0)
    end
    it 'no_orders' do
      expect(@meg.no_orders?).to eq(true)

      order_1 = @user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      item_order_1 = order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

      expect(@meg.no_orders?).to eq(false)
    end

    it 'item_count' do
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 30, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)

      expect(@meg.item_count).to eq(2)
    end

    it 'average_item_price' do
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 40, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)

      expect(@meg.average_item_price).to eq(70)
    end

    it 'distinct_cities' do
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 40, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)
      order_1 = @user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order_2 = @user.orders.create!(name: 'Brian', address: '123 Brian Ave', city: 'Denver', state: 'CO', zip: 17033)
      order_3 = @user.orders.create!(name: 'Dao', address: '123 Mike Ave', city: 'Denver', state: 'CO', zip: 17033)
      order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      order_2.item_orders.create!(item: chain, price: chain.price, quantity: 2)
      order_3.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

      expect(@meg.distinct_cities).to eq(["Denver","Hershey"])
    end

    it 'pending_items' do
      bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
      dog_shop = Merchant.create(name: "Meg's Dog Shop", address: '123 Dog Rd.', city: 'Hershey', state: 'PA', zip: 80203)
      pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      user = User.create!(name: "Josh Tukman",
                            address: "756 Main St.",
                            city: "Denver",
                            state: "Colorado",
                            zip: "80209",
                            email: "mike@gmail.com",
                            password: "secret_password",
                            password_confirmation: "secret_password",
                            role: 0)
      employee = User.create!(name: "Mike Hernandez",
                            address: "756 Main St.",
                            city: "Denver",
                            state: "Colorado",
                            zip: "80209",
                            email: "jt@gmail.com",
                            password: "secret_password",
                            password_confirmation: "secret_password",
                            role: 1)
      order1 = user.orders.create!(name: 'Josh', address: '123 Josh Ave', city: 'Broomfield', state: 'CO', zip: 82345)
      ItemOrder.create!(order_id: order1.id, item_id: tire.id, price: tire.price, quantity: 2)
      ItemOrder.create!(order_id: order1.id, item_id: pull_toy.id, price: pull_toy.price, quantity: 9)
      expect(dog_shop.pending_items).to eq(pull_toy.name)
    end
  end
end
