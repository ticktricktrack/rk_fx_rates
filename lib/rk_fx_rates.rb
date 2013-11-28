require "rk_fx_rates/version"
require 'rk_fx_rates/provider/ecb'

require "httparty"
require 'chronic'
require 'yaml/store'
require 'pry-remote'

# To make sure the data from all source will be compatible, they are converted to a standardized data structure
# {
#   downloaded_at: "2013-11-27",
#   data: {
#     "2013-11-27" => {
#       'USD' => 1.3547,
#       'GBP' => 0.83830,
#       ...
#     },
#     "2013-11-26" => ...
#   }
# }

module RkFxRates
  class ExchangeRate
    include HTTParty

  	def initialize(source = RkFxRates::Provider::Ecb)
  		@source = source
      @fx_hash = retrieve
  	end

    def retrieve
      retrieve_latest unless File.exists?('exchange_rates.store')
      fx_hash = YAML::load_file('exchange_rates.store')['rates']

      fx_hash = retrieve_latest if fx_hash['downloaded_at'] < Chronic.parse('last weekday').to_date
      return fx_hash
    end
  	
  	def retrieve_latest
      response = HTTParty.get(@source.data_url)
      fx_hash = @source.generate_fx_hash(response.parsed_response)

      # persist latest rates
      store(fx_hash)
      
      return fx_hash
    end

    def at(date, from_currency, to_currency)
      return to_euro(date, from_currency) * from_euro(date, to_currency)
    end

    def available_currencies
      @fx_hash["data"].first[1].keys
    end

    def available_dates
      return @fx_hash["data"].keys
    end

    private
    	
    def from_euro(date, to_currency)
      return 1.0 if to_currency == 'EUR'
      rate = @fx_hash["data"][date][to_currency]
    end

    def to_euro(date, from_currency)
      return 1.0 if from_currency == 'EUR'
      rate = 1.0 / @fx_hash["data"][date][from_currency]
    end

    def store(fx_hash)
      store = YAML::Store.new("exchange_rates.store")
      store.transaction do
        store['rates'] = fx_hash        
      end
    end
  end 
end
