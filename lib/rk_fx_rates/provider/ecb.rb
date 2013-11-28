module RkFxRates
  module Provider

    # Exchange rates over the last 90 days rom the European Central Bank
    class Ecb
      
      def self.data_url
        return 'http://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml'        
      end

      # convert xml to a defined default format
      # see rk_fx_rates.rb for data structure description
      def self.generate_fx_hash(data)
        fx_hash = Hash.new
        fx_hash["data"] = Hash.new
        fx_hash["downloaded_at"] = Date.today

        data["Envelope"]["Cube"]["Cube"].each do |daily|
          date = Chronic.parse( daily["time"] ).to_date
          fx_hash["data"][date] = Hash.new
          daily["Cube"].each do |currency|
            fx_hash["data"][date] [currency["currency"]] = currency["rate"].to_f
          end
        end
        return fx_hash
      end

    end # Ecb 
  end # Provider
end # RkFxRates 