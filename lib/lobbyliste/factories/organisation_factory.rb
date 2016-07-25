module Lobbyliste
  module Factories

    # This class is used to build an organisation from raw data
    class OrganisationFactory

      # @return [Lobbyliste::Organisation]
      def self.build(name, raw_data,tags,abbreviations)
        factory = new(name, raw_data)
        ::Lobbyliste::Organisation.new(
            factory.id,
            factory.name,
            factory.address,
            factory.additional_address,
            factory.address_at_bt_br,
            factory.people,
            factory.interests,
            factory.members,
            factory.associated_organisations,
            tags,
            abbreviations
        )
      end

      attr_reader :name

      def initialize(name,raw_data)
        @name = name
        @raw_data = raw_data
      end

      def id
        @raw_data.first.to_i
      end


      def address
        data = read_section("N a m e u n d S i t z , 1 . A d r e s s e")
        AddressFactory.build(name, data, :primary)
      end

      def additional_address
        data = read_section("W e i t e r e A d r e s s e")
        return nil if data[0] == "–"
        AddressFactory.build(name, data, :secondary)
      end

      def address_at_bt_br
        data = read_section("A n s c h r i f t a m S i t z v o n B T u n d B R g")
        return nil if data[0] == "–" || data[0].match(/\(s\. Abschnitt/)
        AddressFactory.build(name, data, :secondary)
      end

      def people
        data = read_section("V o r s t a n d u n d G e s c h ä f t s f ü h r u n g")
        data.concat read_section("V e r b a n d s v e r t r e t e r / - i n n e n")
        data.reject! {|line| ignored_person_line?(line)}

        data.map { |person| PersonFactory.build(person) }.uniq.reject(&:nil?)
      end

      def interests
        interest_lines = read_section("I n t e r e s s e n b e r e i c h").dup


        (0..interest_lines.count-1).each do |i|
          line = interest_lines[i]
          next_line = interest_lines[i+1]

          if line =~ /[-–]$/ && !(next_line.start_with?("und"," und", "oder", " oder"))
            line.gsub!(/[-–]$/,"")
            next_line_words = next_line.split(" ")

            line += next_line_words.slice!(0)
            next_line = next_line_words.join(" ")
          end

          interest_lines[i] = line
          interest_lines[i+1] = next_line
        end

        interest_lines.reject(&:blank?).join("\n")
      end

      def members
        read_section("M i t g l i e d e r z a h l")[0].to_i || nil
      end

      def associated_organisations
        read_section("A n z a h l d e r a n g e s c h l o s s e n e n O r g a n i s a t i o n e n")[0].to_i || nil
      end



      private
        def new_section?(line)
           line =~ /^([a-zA-Z\d\,\.\-\/äöüß]\s){3,}\w$/
        end

        def read_section(section)
          start_line = @raw_data.index {|line| line == section}
          return [] unless start_line

          @raw_data.drop(start_line+1).take_while {|line| !new_section?(line)}
        end

        def ignored_person_line?(line)
          [
            /^–$/,
            /\(s\. Abschnitt/,
            /\:$/,
            /^GdW$/,
            /^Forschung$/,
            /^des Verwaltungsrats$/,
            /^Schatzmeister$/,
            /^Kinder- u\. Jugendmed\.$/,
            /^u\. Kinderchirurgen$/,
            /^Finanzen & Recht I$/,
            /^Geschäftsführ(er(in)?|ung)$/,
            /^gleichzeitig Verbandsdirektor^/,
            /^(stellvertretender )?Vorsitzender?$/,
            /^weitere Vorstandsmitglieder$/,
            /^Managementgesellschaft des DZVhÄ/,
            /^Besonderer Vertreter nach § 30/,
            /^Sektretär$/,
            /^Alleingesellschafter: Ev\.Werk für/
          ].any? {|regexp| line.match(regexp) }
        end

    end
  end
end
