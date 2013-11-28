require 'spec_helper'

describe RkFxRates do

  before(:each) do
    @fx_api = RkFxRates::ExchangeRate.new
  end

  it "should download the current exchange rates" do
    @fx_api.retrieve_latest.should_not be nil
  end

  it "should display the download date" do
    @fx_api.retrieve_latest["downloaded_at"].should == Date.today
  end

  # using the last monday to make sure the test runs with a weekday date
  # simplified case with Euro as the start currency
  it "should calcute the Exchange rate from EUR to USD" do
    date = Chronic.parse('last monday').to_date
    @fx_api.at( date, 'EUR', 'USD' ).should be > 1.2
  end

  it "should calculate the exchange rate from GBP to USD" do
    date = Chronic.parse('last monday').to_date
    @fx_api.at(date, 'GBP', 'USD').should be > 1.5
  end

  it "should calculate the exchange rate from EUR to EUR" do
    date = Chronic.parse('last monday').to_date
    @fx_api.at(date, 'EUR', 'EUR').should be == 1.0
  end

  context "with existing and current data" do
    before(:each) do
      @fx_api.retrieve_latest
      WebMock.disable_net_connect!
    end

    it "should not download the data again" do
      date = Chronic.parse('last monday').to_date
      @fx_api.at(date, 'GBP', 'USD').should be > 1.5
    end

    after(:each) do
      WebMock.allow_net_connect!
    end
  end

end