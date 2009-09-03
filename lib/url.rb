module Plog

  class URL

    def initialize(url)
      @url = url
      @obj = URI.parse(url)
    end

    def to_s
      @url
    end

    def simplify
      @simplify_url = @url
      simplifiers.each { |k, v| @simplify_url.gsub!(k, v) if k =~ @simplify_url }
      @simplify_url
    end

    def hashify
      ::MD5.hexdigest simplify
    end

    protected

    def simplifiers
      {
        /\?.*/ => '?',
        /\d+/ => '[0-9]',
        /http:..[^\/]+/ => ''
      }
    end

  end

end
