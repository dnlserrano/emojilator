require 'gemoji'
require 'uea-stemmer'
require 'json'

module Emojilator
  class Matcher
    def find(word)
      e = find_by_alias(word)
      return e unless e.nil?

      e = find_by_alias(stem(word))
      e ? "#{e} " : nil
    end

    private
    def stem(word)
      stemmer.stem(word)
    end

    def find_by_alias(name)
      found = emoji_finder.find_by_alias(name)
      found ? found.raw : nil
    end

    def name_exists_stem?(stem)
      names_index.keys.include?(stem)
    end

    def stemmer
      @stemmer ||= UEAStemmer.new
    end

    def emoji_finder
      @emoji_finder ||= begin
        load_aliases
        Emoji
      end
    end

    def load_aliases
      emoji_aliases.each do |original, aliases|
        emoji = Emoji.find_by_alias(original)

        Emoji.edit_emoji(emoji) do |char|
          aliases.each do |a|
            char.add_alias(a)
          end
        end
      end
    end

    def emoji_aliases
      JSON.parse(File.read(file_name))
    rescue
      puts "Error loading JSON file containing emoji aliases: #{file_name}"
      {}
    end

    def file_name
      @file_name ||= (ENV['EMOJI_ALIASES_FILE'] || 'emoji_aliases.json')
    end
  end
end
