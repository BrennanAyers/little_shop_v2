require 'rails_helper'

RSpec.describe 'Edit address page', type: :feature do
  context 'As a regular user' do
    describe 'When I Update My home address' do
      before :each do
        @user = User.create!(email: "test@test.com", password_digest: "t3s7", role: 0, active: true, name: "Testy McTesterson", address: "123 Test St", city: "Testville", state: "Test", zip: "01234")

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      end

      it 'Im taken to an Update address form' do
        visit profile_path

        within('.home-address') do
          click_link('Update address')
        end

        expect(page).to have_content('Update an Address')

        fill_in 'Address nickname', with: 'home'
        fill_in 'Address', with: '2222 New Street'
        fill_in 'City', with: 'Denver'
        fill_in 'State', with: 'CO'
        fill_in 'Zip', with: '80226'

        click_button('Update Address')

        expect(page).to have_content('You have updated your home address.')

        @user.reload

        within ".home-address" do
          expect(page).to have_content("Street: #{@user.address}")
          expect(page).to have_content("City: #{@user.city}")
          expect(page).to have_content("State: #{@user.state}")
          expect(page).to have_content("Zip Code: #{@user.zip}")
        end
      end

      xit 'Im not allowed to change if it is associated with another order' do
        visit profile_path

        within('.home-address') do
          click_link('Update address')
        end

        expect(page).to have_content('Update an Address')

        fill_in 'Nickname', with: 'home'
        fill_in 'Street', with: '2222 New Street'
        fill_in 'City', with: 'Denver'
        fill_in 'State', with: 'CO'
        fill_in 'Zip', with: '80226'

        click_button('Update Address')

        expect(page).to have_content('You have updated your home address.')

        within ".home-address" do
          expect(page).to have_content("Street: #{@user.address}")
          expect(page).to have_content("City: #{@user.city}")
          expect(page).to have_content("State: #{@user.state}")
          expect(page).to have_content("Zip Code: #{@user.zip}")
        end
      end
    end

    describe 'When I update an address that isnt my home address' do
      before :each do
        @user = User.create!(email: "test@test.com", password_digest: "t3s7", role: 0, active: true, name: "Testy McTesterson", address: "123 Test St", city: "Testville", state: "Test", zip: "01234")

        @other_address = @user.addresses.create!(nickname: "Second Address", street: "222 Other Address rd", city: "Denver", state: "CO", zip: "80225")
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      end

      xit 'Im taken to an Update address form' do
        visit profile_path

        within("#other-address-#{@other_address.id}") do
          click_link('Update address')
        end

        expect(page).to have_content('Update an Address')

        fill_in 'Nickname', with: 'Second Address'
        fill_in 'Street', with: '2222 New Street'
        fill_in 'City', with: 'Denver'
        fill_in 'State', with: 'CO'
        fill_in 'Zip', with: '80226'

        click_button('Update Address')

        @other_address.reload

        expect(page).to have_content('You have updated that address.')

        within "#other-address-#{@other_address.id}" do
          expect(page).to have_content("Street: #{@other_address.street}")
          expect(page).to have_content("City: #{@@other_address.city}")
          expect(page).to have_content("State: #{@@other_address.state}")
          expect(page).to have_content("Zip: #{@@other_address.zip}")
        end
      end
    end
  end
end
