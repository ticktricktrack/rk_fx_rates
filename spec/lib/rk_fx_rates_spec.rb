require 'spec_helper'

describe RkFxRates do

  before(:each) do
    # too slow
    # File.delete('exchange_rates.store')
    @date = Chronic.parse('last monday').to_date
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
    @fx_api.at( @date, 'EUR', 'USD' ).should be > 1.2
  end

  it "should calculate the exchange rate from GBP to USD" do
    @fx_api.at( @date, 'GBP', 'USD').should be > 1.5
  end

  it "should calculate the exchange rate from EUR to EUR" do
    date = Chronic.parse('last monday').to_date
    @fx_api.at( @date, 'EUR', 'EUR').should be == 1.0
  end

  it "should provide a list with the available currencies" do
    @fx_api.available_currencies.should include("USD")
  end

  it "should provide a list with the available dates" do
    @fx_api.available_dates.should include(@date)
  end

  context "with existing and current data" do
    before(:each) do
      @fx_api.retrieve_latest
      WebMock.disable_net_connect!
    end

    it "should not download the data again" do
      @fx_api.at( @date, 'GBP', 'USD').should be > 1.5
    end

    after(:each) do
      WebMock.allow_net_connect!
    end
  end

end