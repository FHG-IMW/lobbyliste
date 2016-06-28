module Lobbyliste
  module Factories
    class AddressFactory
      def self.build(name,raw_data, type=:primary)
        factory = new(name,raw_data,type)
        ::Lobbyliste::Address.new(
          factory.name,
          factory.address,
          factory.postcode,
          factory.city,
          factory.country,
          factory.tel,
          factory.fax,
          factory.website,
          factory.email,
          factory.type
        )
      end

      attr_reader :name, :tel, :fax, :website, :email, :country, :postcode, :city, :type

      def initialize(name,raw_data,type=:primary)
        @name = name
        @raw_data = raw_data

        @address = []
        @tel = nil
        @fax = nil
        @website = nil
        @email = nil
        @country = "Deutschland"
        @postcode = nil
        @city = nil
        @type=type

        parse
      end

      def parse
        @raw_data.each_with_index do |line,i|
          case label(line,i)
            when :addr then @address << line
            when :tel then extract_tel_fax(line)
            when :postcode then extract_postcode_city(line)
            when :email then extract_email(line)
            when :website then extract_website(line)
            when :country then @country = line
            else next
          end
        end
      end

      def address
        @address.join(", ")
      end

      private

      def label(line,i)
        # this line is part of the name
        return :name if name.include?(line)

        return :tel if line.match(/^(Tel\.|Fax): /)
        return :email if   line.match(/^E\-Mail\: /)
        return :website if  line.match(/^Internet\:/)

        # international postcodes
        return :postcode if line.match(/^\d{5,7}\s(.+)$/)
        # UK postcodes
        return :postcode if line.match(/^([A-Z0-9]{3}\s?[A-Z0-9]{3})$/)

        # if the line looks like an address
        return :addr if  line.match(/(c\/o|^postfach\b|[Ss]tr(aße|\.)?\b|[Aa]llee\b|[Pp]latz\b|[Gg]asse\b|[Ww]eg\b|\b([0-9]+\-)?[0-9]+\s?[a-zA-Z]*$|[Vv]orstand|[Ss]ekretär|[Gg]eschäfts)/)
        # if the previous line ended with e.V. the next line is addr
        return :addr if @raw_data[i-1].match(/(e\.\s?V\.|\([A-Z]+\)$)/)

        return :country if %w(Niederlande Belgien Schweiz Luxemburg Dänemark Österreich Tschechien Polen USA Israel Russland).include?(line)
        # a single Word with a capital letter is probably a country
        return :country if i > 3 && line.match(/^[A-Z][a-zA-Zöüä?]+$/)
        return :country if line == "Vereinigtes Königreich"

        :addr
      end

      def extract_tel_fax(line)
        _tel = line.match(/Tel\.\: ((\(?\d+\)? )?(\d+\s?)+\d+)/)
        if _tel
          @tel = _tel[1].gsub(/[\(|\)]/,"").gsub(/^0{1,2}/,"+49")
        end

        _fax = line.match(/Fax\: ((\(?\d+\)? )?(\d+\s?)+\d+)/)
        if _fax
          @fax = _fax[1].gsub(/[\(|\)]/,"").gsub(/^0{1,2}/,"+49")
        end
      end

      def extract_postcode_city(line)
        _postcode_city = line.match(/(\d{5,7})\s?(.+)?/)
        if _postcode_city
          @postcode = _postcode_city[1]
          @city = _postcode_city[2]
        else
          _uk_postcode = line.match(/^([A-Z0-9]{3}\s?[A-Z0-9]{3})$/)
          @postcode = _uk_postcode[1] if _uk_postcode
        end
      end

      def extract_website(line)
        _website = line.match(/^Internet\:\s?(.+)$/)
        if _website
          @website = _website[1]
        end
      end

      def extract_email(line)
        _email = line.match(/^E\-Mail\:\s?(.+)$/)
        if _email
          @email = _email[1]
        end
      end

    end
  end
end