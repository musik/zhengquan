class Pinyin
  def self.abbr chars
    t(chars).split(' ').collect{|word| word[0]}.join
  end
end
