require 'gemoji'
require 'uea-stemmer'

module Emojilator
  class Matcher
    include Emoji

    ALIASES = {
      "skull" => ["die", "dead"],
    }

    def find(word)
      emoji = emoji_for(word)
      return emoji unless emoji.nil?

      name = name_for(word)
      return nil if name.nil?

      emoji = emoji_for(name)
      emoji ? "#{emoji} " : nil
    end

    private
    def name_for(word)
      stem = stem_for(word)

      ALIASES.each do |name, aliases|
        if aliases.include?(stem) && name_exists_for_stem?(name)
          return name
        end
      end

      nil
    end

    def stem_for(word)
      stemmer.stem(word)
    end

    def emoji_for(name)
      found = find_by_alias(name)
      found ? found.raw : nil
    end

    def name_exists_for_stem?(stem)
      names_index.keys.include?(stem)
    end

    def stemmer
      @stemmer ||= UEAStemmer.new
    end
  end
end
