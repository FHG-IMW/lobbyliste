require 'test_helper'

class RealWorldTest < Minitest::Test
  def test_real_world_sanity_check
    skip unless ENV["RUN_REAL_WORLD_TEST"] == "true"
    VCR.turned_off do
      WebMock.allow_net_connect!
      liste = Lobbyliste.fetch_and_parse

      # There are 2000-3000 organisations
      assert (2000..3000).include?(liste.organisations.count)
      # every organisation has an average of 7 to 10 people
      assert (7..10).include?(liste.organisations.map {|org| org.people.count}.inject(&:+) / liste.organisations.count.to_f)
      # every organisation has an average of 1 to 3 tags
      assert (1..3).include?(liste.organisations.map {|org| org.tags.count}.inject(&:+) / liste.organisations.count.to_f)
    end
  ensure
    WebMock.disable_net_connect!
  end
end
