module TwitterValidator
  extend ActiveSupport::Concern
  include Twitter::Validation

  def invalid_tweet?
    return :empty if (!text || text.empty?) && !has_media?
    begin
      length = tweet_length(text) + (has_media? ? DEFAULT_TCO_URL_LENGTHS[:characters_reserved_per_media] + 1 : 0)
      return :too_long if length > MAX_LENGTH
      return :invalid_characters if Twitter::Regex::INVALID_CHARACTERS.any?{|invalid_char| text.include?(invalid_char) }
    rescue ArgumentError
      # non-Unicode value.
      return :invalid_characters
    end

    return false
  end
end
