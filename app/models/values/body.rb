module Values
  class Body
    attr_reader :mentions, :emoticons

    def initialize(content)
      @content = content
      extract_mentions
      extract_emoticons
    end

    def to_s
      @content
    end

    private

    def extract_mentions
      @mentions = []
      @content.scan(/@\w+/).each do |mention|
        @mentions << GithubUser.from_github("login" => mention.gsub(/^@/, ''))
      end
    end

    def extract_emoticons
      @emoticons = []
      @content.scan(/:\S+:/).each do |emoticon|
        @emoticons << emoticon
      end
    end
  end
end
