require 'test_helper'

class Lobbyliste::Factories::OrganisationFactoryTest < Minitest::Test
  def setup
    @organisation_data = [
        "1",
        "N a m e u n d S i t z , 1 . A d r e s s e",
        "1219. Deutsche Stiftung für interreligiösen und interkulturellen",
        "Dialog e. V.",
        "Hinter der katholischen Kirche 3",
        "10117 Berlin",
        "Tel.: (030) 51057773 Fax: (030) 51057785",
        "E-Mail: schimmel@1219.eu",
        "Internet: http://www.1219.eu",
        "W e i t e r e A d r e s s e",
        "c/o Missionszentrale der Franziskaner",
        "Albertus-Magnus-Straße 39",
        "53177 Bonn",
        "Tel.: (0228) 953540 Fax: (0228) 9535440",
        "V o r s t a n d u n d G e s c h ä f t s f ü h r u n g",
        "Vorstand:",
        "Pater Claudius Groß OFM, 1. Vorsitzender",
        "Markus Hoymann, 2. Vorsitzender",
        "Weitere Vorstandsmitglieder:",
        "Dr.rer.pol. Thomas M. Schimmel, Geschäftsführer",
        "I n t e r e s s e n b e r e i c h",
        "Interreligiöser und interkultureller Dialog:",
        "- wissenschaftliche Bearbeitung von Aspekte des Dialogs und der",
        "Funktion von Religion in der deutschen und europäischen Gesell-",
        "schaft;",
        "Religions-",
        "und Meinungsfreiheit",
        "- Eintreten für das Grundrecht und das universale Menschenrecht Re-",
        "ligionsfreiheit (auch die negative Religionsfreiheit/Weltan-",
        "schauungsfreiheit);",
        "- Vermittlung von Kenntnissen über alle Aspekten von Religionen und",
        "Kulturen;",
        "- Diskussion von Toleranz und Offenheit gegenüber anderen Religio-",
        "nen und Kulturen in einer demokratischen Gesellschaft;",
        "- der Einsatz für die Rechte bedrohter Kulturen und",
        "- die Förderung von Dialogkultur als friedensschaffende und integrati-",
        "ve Maßnahme.",
        "M i t g l i e d e r z a h l",
        "7",
        "A n z a h l d e r a n g e s c h l o s s e n e n O r g a n i s a t i o n e n",
        "5",
        "V e r b a n d s v e r t r e t e r / - i n n e n",
        "(s. Abschnitt \"Vorstand und Geschäftsführung\")",
        "Max Mustermann",
        "A n s c h r i f t a m S i t z v o n B T u n d B R g",
        "Rahel-Hirsch-Straße 10 (3. OG)",
        "10557 Berlin",
        "Tel.: (030) 590083562 Fax: (030) 590083700",
        "E-Mail: contact@ziv-zweirad.de",
        "Internet: http://www.ziv-zweirad.de",
    ]
    @name = "1219. Deutsche Stiftung für interreligiösen und interkulturellen Dialog e. V."
    @org = Lobbyliste::Factories::OrganisationFactory.new(@name, @organisation_data)
  end

  def test_factory_builds_an_organisation
    organisation = Lobbyliste::Factories::OrganisationFactory.build(@name, @organisation_data,[],[])
    assert organisation.is_a?(Lobbyliste::Organisation)
    assert 1, organisation.id
  end

  def test_id_extraction
    assert_equal 1, @org.id
  end

  def test_address_extraction
    name_and_address = @org.address
    assert name_and_address.is_a?(Lobbyliste::Address)
    assert_equal @name, name_and_address.name
    assert_equal :primary, name_and_address.type
  end

  def test_additional_address_extraction
    name_and_address = @org.additional_address
    assert name_and_address.is_a?(Lobbyliste::Address)
    assert name_and_address.address.include? "c/o Missionszentrale der Franziskaner"
    assert_equal :secondary, name_and_address.type
  end

  def test_additional_address_is_nil_if_there_is_none
    data = [
        "1",
        "N a m e u n d S i t z , 1 . A d r e s s e",
        "1219. Deutsche Stiftung für interreligiösen und interkulturellen",
        "Dialog e. V.",
        "Hinter der katholischen Kirche 3",
        "10117 Berlin",
        "Tel.: (030) 51057773 Fax: (030) 51057785",
        "E-Mail: schimmel@1219.eu",
        "Internet: http://www.1219.eu",
        "W e i t e r e A d r e s s e",
        "–",
        "V o r s t a n d u n d G e s c h ä f t s f ü h r u n g",
        "Pater Claudius Groß OFM, 1. Vorsitzender",
        "Markus Hoymann, 2. Vorsitzender",
        "Dr.rer.pol. Thomas M. Schimmel, Geschäftsführer",
    ]
    org = Lobbyliste::Factories::OrganisationFactory.new(@name, data)

    assert_nil org.additional_address
  end

  def test_address_at_bt_br_extraction
    address = @org.address_at_bt_br
    assert address.is_a?(Lobbyliste::Address)
    assert address.address.include? "Rahel-Hirsch-Straße 10"
    assert_equal :secondary, address.type
  end

  def test_address_at_bt_br_ignores_see_other
    data = [
      "A n s c h r i f t a m S i t z v o n B T u n d B R g",
      "(s. Abschnitt \"Name und Sitz, 1. Adresse\")"
    ]
    org = Lobbyliste::Factories::OrganisationFactory.new(@name, data)

    assert_nil org.address_at_bt_br
  end

  def test_people_extraction
    assert_equal 4, @org.people.count
    assert @org.people.first.is_a?(Lobbyliste::Person)
    assert_equal ["Claudius Groß","Markus Hoymann","Thomas M. Schimmel","Max Mustermann"], @org.people.map(&:name)
  end

  def test_interest_extraction
    interests = @org.interests

    assert interests.include? "- die Förderung von Dialogkultur als friedensschaffende und integrative\n"
    assert interests.include? "Maßnahme."
    refute interests.include? "Religionsund Meinungsfreiheit"
  end

  def test_member_extraction
    assert_equal 7, @org.members
  end

  def test_associated_organisations_extraction
    assert_equal 5, @org.associated_organisations
  end
end
