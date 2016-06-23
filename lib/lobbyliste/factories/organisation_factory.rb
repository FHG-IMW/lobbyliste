module Lobbyliste
  module Factories
    class OrganisationFactory
      def self.build(raw_data)
        factory = new(raw_data)
        ::Lobbyliste::Organisation.new(
            factory.id,
            factory.name_and_address,
            factory.additional_address,
            factory.people,
            factory.interests,
            factory.members,
            factory.associated_organisations
        )
      end

      def initialize(raw_data)
        @raw_data = raw_data
      end

      def id
        @raw_data.first.to_i
      end


      def name_and_address
        data = read_section("N a m e u n d S i t z , 1 . A d r e s s e")
        NameAndAddressFactory.build(data,:primary)
      end

      def additional_address
        data = read_section("W e i t e r e A d r e s s e")
        return nil if data[0] == "–"
        NameAndAddressFactory.build(data,:secondary)
      end

      def people
        data = read_section("V o r s t a n d u n d G e s c h ä f t s f ü h r u n g")
        data.concat read_section("V e r b a n d s v e r t r e t e r / - i n n e n")
        data.reject! {|line| line.match(/\(s\. Abschnitt/)}

        data.map { |person| PersonFactory.build(person) }.uniq
      end

      def interests
        read_section("I n t e r e s s e n b e r e i c h").join("\n")
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

    end
  end
end