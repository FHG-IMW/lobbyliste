class String
  def squish
    self.dup.gsub(/[[:space:]]+/, ' ').strip
  end
end