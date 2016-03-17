require_relative './matcher'

class String
  def emojify
    gsub(/\b(\w+)\b/) { |word|
      emoji_matcher.find(word.downcase) || word
    }
  end

  private
  def emoji_matcher
    @emoji_matcher ||= ::Emojilator::Matcher.new
  end
end

loop do
  string = gets
  puts string.emojify
end
