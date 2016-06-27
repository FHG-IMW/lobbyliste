module Lobbyliste
  module Factories
    class PersonFactory
      REGEX = [
         # Prof titles
        /Prof\.?/,
        # Dr. titles
        /(Dr\.(([a-z]+\.?)+|(\-\w+\.?))*)/,
        # Dipl. titles
        /(Dipl[\.|\-]+([\w|ÖöÄäÜüß]*[\.|\-]*)*)/,
        # other academic abbreviations
        /\b([a-z]+\.)+/,
        # general abbreviations
        /\(?\b(M\.?Sc|B\.?Sc|B\.?sc|FH|fh|BA|Ba|TH|Th|VWA|univ|US|PD|RA|CCM|LD|Ing\.|OTL|CISA|CIA|CISM|CRISC|StB|vBP|StD|habil|med)\b\)?/,
        # job titles
        /((^\s*und)?(Mathematiker|(Bundes)?Vorstand|Assistent|Generalstabs[aä]rzt|Augenoptikermeister|Mediziner|agrar|Gesundheitsökonom|Straßenbaumeister|Bruder|Pater|Theologe|Jurist|med|(Medizin)?pädagog|Verwaltungs-Wirt|Veterinär|Kauf|Generalleutnant|General|Generalarzt|Ergotherapeut|Fregattenkapitän|Agrarbiolog|Amtsanw[aä]lt|Apotheker|(Freie )?Architekt|(Berg-)?Assessor|Betriebswirt|Bischof( von [a-z]+)?|Botschafter|(vereidigter )?Buchprüfer|Bundesbankoberamtsrat|Bundesinnungsmeister|Bundesminister|Bundespräsident|Bundestagspräsident|Bürgermeister|Chefapotheker|Diakon|Dompropst|Augenoptiker|Optometrist|Biolog|Brennmeister|Chemiker|((Kommunikations|Grafik)[\-\s]?)?Designer|Finanzwirt|Forstwirt|Geograph|Geolog|Geophysiker|Handelslehrer|Holzwirt|Informatiker|Jurist|Kauf|Mathematiker|Medizinpädagog|Meteorolog|physiker|Politolog|Psycholog|Pädagog|Rechtspfleger|Restaurator|Sachverständig|Sozialpädagog|Sozialwirt|Sozialwissenschaftler|Soziolog|Stomatolog|Verwaltungsbetriebswirt|Verwaltungswirt|Verwaltungswissenschaftler|Volkswirt|Wirtschafts(ing)?|Wirtschaftsjurist|Ökonom|Übersetzer|Domkapitular|Probst|Finanzfachwirt|(Forst|Bau)assessor|Hauptfeldwebel|Hauptmann|Honorar|Honorargeneralkonsul|Honorarkonsul|Justizminister|Kapitän(leutnant)?|Konsul|Land(es)?rat|Landwirtschaftsmeister|Lohnsteuerberater|Landwirtschaftsdirektor|Luftverkehrskauf|Magistratsr[aä]t|Major|Minist|Ministerialdirektor|Ministerialdirigent|Monsignore|Notar|Oberamtsanw[aä]lt|Oberbürgermeister|Oberfeldarzt|Obermeister|Oberst|Oberstaatsanw[aä]lt|Oberstabsboots|Oberstabsfeldwebel|Oberstleutnant|Oberstudiendirektor|Staatssekretär|Parlamentarischer|Parlamentspräsident|Patentanw[aä]lt|(Landesjugend)?[Pp]farrer|Politikwissenschaftler|Privatdozent|Priv(\\.|at)-?Dozent|RA|Ran|Fachanwalt( für [a-z]+)?|Realschulrektor|Rechtsreferent|Regierungsamts(rat)?|Regionspräsident|Revieroberjäger|Richter(in)?( am [a-z]+)?|Senator|Staats(minister|sekretär)|Stabsfeldwebel|Stabshauptmann|(Steuer|Wirtschafts)(berater|prüfer)|Stuckateurmeister|Studiendirektor|Studienrat|Uni(v(ersitäts)?)?|Verleger|Rechtsjournalist|Rechtsjurist|Veterinärdirektor|Vizepräsident des Verwaltungsgerichts|Zahntechnikermeister|[AÄ]rzt)(er|e|\s?in|mann|frau)?)(\s?am\s(Finanzgericht|Bundesverwaltungsgerichtshof|Verwaltungsgerichtshof))?(\bD\.)?( a\\.D\\.)?([\.\-,\s\/]+|$)/,
        # Beamtenbezeichnung?
        /^D\.\s/,
        # more abbreviations
        /\b[A-ZÜÄÖ]{2,}\b/,
        # Everything after first colon
        /,.*$/
      ]



      def self.build(raw_data)
        factory = new(raw_data)
        ::Lobbyliste::Person.new(factory.name,factory.titles)
      end

      def initialize(raw_data)
        @raw_data = raw_data
        @name = nil
      end

      def name
        return @name if @name

        @name = @raw_data.dup
        REGEX.each do |regex|
          @name = clean(@name.gsub(regex,""))
        end

        @name
      end

      def titles
        @raw_data.gsub(name,"").split(", ").map(&:squish).reject{|x| x==""}
      end


      private

      def clean(string)
        string.gsub(/^(\s*[,:()|\.])*/,"").squish
      end
    end
  end
end