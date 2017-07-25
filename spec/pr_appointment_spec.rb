require "spec_helper"
require "selenium-webdriver"

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(
    app,
    browser: :firefox,
    desired_capabilities: Selenium::WebDriver::Remote::Capabilities.firefox(marionette: false)
  )
end

RSpec.describe PrAppointment, :type => :feature, :js => :true do

  def available?
    visit 'https://eappointment.ica.gov.sg/ibook/gethome.do'
    select 'Apply for PR', from: 'apptDetails.apptType'
    fill_in name: 'apptDetails.identifier1', with: ENV['MY_ID']
    fill_in name: 'apptDetails.identifier2', with: '4'
    fill_in name: 'apptDetails.identifier3', with: ENV['MY_NUMBER']
    click_on 'Submit'
    while not page.has_css?('.cal_AS') do
      click_link '<Next>'
      expect(page).to have_content ''
      return false unless page.has_css?('.cal_AF')
    end
    return true
  end

  it "signs me in" do
    while not available?
      `say 'fully booked, try next time.'`
      sleep 30 * 60
    end
    `say 'Hey, Good news. There is a timeslot available.'`
  end
end
