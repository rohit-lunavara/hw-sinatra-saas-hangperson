class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.
  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses

  # Get a word from remote "random word" service

  # def initialize()
  # end
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end
  
  def guess(letter)
    if letter.nil? || letter.strip.empty? || !letter.match(/^[a-zA-Z]+$/)
      raise(ArgumentError)
    end

    letter.downcase!
    if @guesses == letter
      return false
    end
    if @wrong_guesses == letter
      return false
    end
    
    if @word.count(letter) > 0
      @guesses += letter
    else
      @wrong_guesses += letter
    end
    return true
  end

  def self.guess_several_letters(letters)
    letters.each_char {
      |letter|
      guess(letter)
    }
  end

  def word_with_guesses()
    result = ''
    @word.each_char {
      |actual|
      if @guesses.include? actual
        result += actual
      else
        result += '-'
      end
    }
    return result
  end

  def check_win_or_lose()
    if !word_with_guesses.include?('-')
      return :win
    end
    if (@guesses.length + @wrong_guesses.length) == 7
      return :lose
    end
    if word_with_guesses.include?('-') && (@guesses.length + wrong_guesses.length) <= 7
      return :play
    end
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

end
