class Comment
  POSITIVE_EMOTICONS = %w(
    :+1:
    :santa:
    :shipit:
    :rainbow:
    :raised_hands:
    :rocket:
    :ship:
    :sheep:
  )
  NEGATIVE_EMOTICONS = %w':-1:'

  attr_reader :commenter, :body, :parsed_body

  def initialize(params)
    @commenter = GithubUser.from_github(params[:user][:login])
    @parsed_body = Values::Body.new(params[:body])
  end

  def score
    s = 0
    # last emoticon wins
    @parsed_body.emoticons.each do |emoticon|
      s += 1 if POSITIVE_EMOTICONS.include?(emoticon)
      s -= 1 if NEGATIVE_EMOTICONS.include?(emoticon)
    end

    s
  end

  def approved?
    score > 0
  end

  def rejected?
    score < 0
  end
end
