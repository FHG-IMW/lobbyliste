module Lobbyliste
  module Factories
    class ListFactory
      attr_reader :data

      def self.build(raw_data)
        factory = new(raw_data)
        ::Lobbyliste::List.new(
          factory.organisations,
          factory.tags
        )
      end

      def initialize(data)
        @data = data
        @lines = data.each_line.to_a
      end

      def organisations
        organisations = organisation_data.map {|organisation| ::Lobbyliste::Factories::OrganisationFactory.build(organisation) }

        tags.each_pair do |organisation_id,tags|
          org = organisations.find {|org| org.id == organisation_id}
          org.tags = tags if org
        end

        organisations
      end


      def tags
        tags = Hash.new{|h,k| h[k] = []}
        tag_data = extract_tag_data

        current_tag = "A"
        tag_data.each do |line|
          if line.match(/^[A-ZÄÖÜ][a-zäöüß]+$/) && [current_tag[0],current_tag[0].next].include(line[0])
            current_tag = line
          elsif line.match(/^\– \d+/)
            id = line.match(/^\– (\d+)/)[1].to_i
            tags[id] << current_tag
          end
        end

        tags
      end

      private


        def organisation_data
          start_lines = []
          end_line = nil

          @lines.each_with_index do |line,i|
            line.chomp!
            next if ignored_line?(line)

            if possible_organisation_id?(line) && begin_organisation?(@lines[i+1])
              start_lines << i
            elsif line == "Stichwortverzeichnis"
              end_line = i - 1
              break
            end
          end

          organisation_data = start_lines.each_cons(2).map do |a,b|
            @lines[a..b-1]
          end

          organisation_data << @lines[start_lines.last..end_line-1]
          organisation_data
        end

        def extract_tag_data
          tag_data = []
          start_line = @lines.index {|line| line == "Stichwortverzeichnis"}
          p start_line
          @lines.drop(start_line+1) do |line|
            line.chomp!
            next if ignored_line?(line)
            break if line == "Verzeichnis der anderen Namensformen"
            tag_data << line
          end
          p tag_data

          tag_data
        end



        def ignored_line?(line)
          regexps = [
                      /^– \d+ –$/,
                      /^Aktuelle Fassung der öffentlichen Liste/,
                      /^Die Zahlen verweisen auf die forlaufenden Namen/,
                      /^\n$/

          ]
          regexps.any? {|regexp| line =~ regexp}
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