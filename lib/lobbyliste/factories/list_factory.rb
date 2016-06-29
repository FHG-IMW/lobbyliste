module Lobbyliste
  module Factories
    # This class is used to build the list from raw data
    class ListFactory
      attr_reader :data

      # @return [Lobbyliste::List]
      def self.build(text_data,html_data)
        factory = new(text_data,html_data)
        ::Lobbyliste::List.new(
          factory.organisations,
          factory.tags,
          factory.abbreviations,
          factory.last_update
        )
      end

      def initialize(text_data,html_data)
        @text_data = text_data
        @html_data = html_data

        @lines = text_data.each_line.to_a.map(&:chomp)

        @organisations = nil
        @tags = nil
        @abbreviations = nil
        @names = nil
      end

      def organisations
        return @organisations if @organisations

        @organisations = organisations_data.map do |organisation_data|
          id = organisation_data[0].to_i
          name = names[id]
          tags = tags_for_organisation(id)
          abbreviations = abbreviations_for_organisation(id)
          ::Lobbyliste::Factories::OrganisationFactory.build(name,organisation_data,tags,abbreviations)
        end
      end

      def names
        extract_names unless @names
        @names
      end


      def tags
        return @tags if @tags

        tags = Hash.new{|h,k| h[k] = []}
        tag_data = extract_tag_data

        current_tag = "A"
        tag_data.each do |line|
          if line.match(/^[A-ZÄÖÜ][a-zäöüß]+$/) && [current_tag[0],current_tag[0].next].include?(line[0])
            current_tag = line
          elsif line.match(/^\– \d+/)
            id = line.match(/^\– (\d+)/)[1].to_i
            tags[current_tag] << id
          end
        end

        @tags = tags
      end


      def abbreviations
        return @abbreviations if @abbreviations
        abbreviations = Hash.new{|h,k| h[k] = []}
        current_abbr = "A"
        extract_abbreviation_data.each do |line|
          if line.match(/^[A-ZÄÖÜ][A-ZÄÖÜa-zäöüß]+$/) && [current_abbr[0],current_abbr[0].next].include?(line[0])
            current_abbr = line
          elsif line.match(/^\– \d+/)
            id = line.match(/^\– (\d+)/)[1].to_i
            abbreviations[current_abbr] << id
          end
        end

        @abbreviations = abbreviations
      end

      def last_update
        date = @text_data.match /^Stand: (\d\d\.\d\d\.\d\d\d\d)/
        Date.parse(date[1])
      end

      private


        def organisations_data
          start_lines = []
          end_line = nil

          @lines.each_with_index do |line,i|
            if possible_organisation_id?(line) && begin_organisation?(@lines[i+1])
              start_lines << i
            elsif line == "Stichwortverzeichnis"
              end_line = i - 1
              break
            end
          end

          organisations_data = start_lines.each_cons(2).map do |a,b|
            @lines[a..b-1]
          end

          organisations_data.
              push(@lines[start_lines.last..end_line]).
              map { |data| data.reject {|line| ignored_line?(line)} }
        end



        def extract_tag_data
          start_line = @lines.index {|line| line == "Stichwortverzeichnis"}
          @lines.
            drop(start_line+1).
            take_while {|line| !(line == "Verzeichnis der anderen Namensformen")}.
            reject {|line| ignored_line?(line)}
        end

        def extract_abbreviation_data
          start_line = @lines.index {|line| line == "Verzeichnis der anderen Namensformen"}
          @lines.
            drop(start_line+1).
            reject {|line| ignored_line?(line)}
        end

        def tags_for_organisation(organisation_id)

          tags.
              select {|_,organisation_ids| organisation_ids.include?(organisation_id)}.
              map(&:first)
        end

        def abbreviations_for_organisation(organisation_id)
          abbreviations.
              select {|_,organisation_ids| organisation_ids.include?(organisation_id)}.
              map(&:first)
        end


        def extract_names
          names = {}

          regexp = Regexp.compile(/<p><b>(\d+)\n<\/b>N a m e u n d S i t z \, 1 \. A d r e s s e\n<\/p>\n<p><b>(.*?)\n<\/b>/m)

          @html_data.to_enum(:scan, regexp).each do
            match = Regexp.last_match
            names[match[1].to_i] = CGI.unescape_html(match[2].gsub("\n"," "))
          end

          @names = names
        end


        def ignored_line?(line)
          regexps = [
                      /^– \d+ –$/,
                      /^Aktuelle Fassung der öffentlichen Liste/,
                      /^Die Zahlen verweisen auf die fortlaufenden Nummern im Hauptteil/,
                      /^\n$/

          ]
          regexps.any? {|regexp| line.match(regexp)}
        end

        def possible_organisation_id?(line)
          line =~ /^\d+$/
        end

        def begin_organisation?(line)
          line =~/^N a m e u n d S i t z \, 1 \. A d r e s s e$/
        end
    end
  end
end
