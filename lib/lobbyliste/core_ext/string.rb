class Object
  def blank?
    respond_to?(:empty?) ? !!empty? : !self
  end

  class String
    def squish
      self.dup.gsub(/[[:space:]]+/, ' ').strip
    end

    def blank?
       empty? || /\A[[:space:]]*\z/ === self
    end
  end

  class Nil
    def blank?
      true
    end
  end
end