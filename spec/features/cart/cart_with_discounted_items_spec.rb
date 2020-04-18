require 'rails_helper'

RSpec.describe "as a user, when I visit my cart, if I have items that qualify for discounts", type: :feature do
  before(:each) do
    @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
    @rusty_chain = @bike_shop.items.create(name: "Rusty Chain", description: "Its old and covered in rust.", price: 1, image: "https://thumbs.dreamstime.com/z/rusty-bicycle-chain-picture-blog-rusty-bicycle-chain-picture-blog-background-title-132179093.jpg", inventory: 1, active?:false)
    @bike_shop.discounts.create(name: "10 for 5", description: "Recieve 10% off an item when you purchase 5 or more", amount: 10, quantity: 5)

    @review_1 = @chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
    @review_2 = @chain.reviews.create(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4)
    @review_3 = @chain.reviews.create(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1)
    @review_4 = @chain.reviews.create(title: "Not too impressed", content: "v basic bike shop", rating: 2)
    @review_5 = @chain.reviews.create(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3)
    @user = User.create!(name: "Josh Tukman",
                          address: "756 Main St.",
                          city: "Denver",
                          state: "Colorado",
                          zip: "80209",
                          email: "josh.t@gmail.com",
                          password: "secret_password",
                          password_confirmation: "secret_password",
                          role: 0)

    @discount_order = @user.orders.create!(name: 'Josh', address: '123 Josh Ave', city: 'Broomfield', state: 'CO', zip: 82345)
    ItemOrder.create!(order_id: @discount_order.id, item_id: @chain.id, price: @chain.price, quantity: 5)
  end

  it "I see a message saying that I have items that qualify for discounts" do

    visit "/cart"

    expect(page).to have_content("Your order has items that qualify for a bulk discount!")
  end
end
