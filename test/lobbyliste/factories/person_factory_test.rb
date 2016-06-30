require 'test_helper'

class Lobbyliste::Factories::PersonFactoryTest < Minitest::Test
  def test_extract_names
    data = [
        ["Prof. Dr.med.vet Max Mustermann, 1. Vorsitzender", "Max Mustermann"],
        ["Dipl.-Ing Dirk Meier","Dirk Meier"],
        ["Apothekerin Jane Doe, Geschäftsführerin","Jane Doe"],
        ["Franz Müller","Franz Müller"],
        ["Pater Claudius Groß OFM, 1. Vorsitzender","Claudius Groß"],
        ["Richter am Finanzgericht Rüdiger Schmittberg","Rüdiger Schmittberg"]
    ]

    data.each do |line,expected_name|
      factory = Lobbyliste::Factories::PersonFactory.new(line)
      assert_equal expected_name, factory.name, "'#{line}' should be extracted to #{expected_name}"
    end
  end

  def test_extract_titles
    data = [
        ["Prof. Dr.med.vet Max Mustermann, 1. Vorsitzender", ["Prof. Dr.med.vet","1. Vorsitzender"]],
        ["Dipl.-Ing Dirk Meier",["Dipl.-Ing"]],
        ["Apothekerin Jane Doe, Geschäftsführerin",["Apothekerin","Geschäftsführerin"]],
        ["Franz Müller",[]]
    ]

    data.each do |line,expected_titles|
      factory = Lobbyliste::Factories::PersonFactory.new(line)
      assert_equal expected_titles, factory.titles, "'#{line}' should be extracted to #{expected_titles}"
    end
  end

  def test_building_a_person
    line = "Prof. Dr.med.vet Max Mustermann, 1. Vorsitzender"
    person = Lobbyliste::Factories::PersonFactory.build(line)
    assert person.is_a?(Lobbyliste::Person)
    assert_equal "Max Mustermann", person.name
    assert_equal ["Prof. Dr.med.vet","1. Vorsitzender"], person.titles
    assert_equal line, person.original_name
  end
end
