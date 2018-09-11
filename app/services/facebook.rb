require 'koala'
class Facebook
  class << self
    def fbgraph(token)
      Koala::Facebook::API.new(token)
    end

    def get_object(token, id, args = {}, options = {}, &block)
      fbgraph(token).get_object(id, args, options, &block)
    end

    def get_friends
    # @graph = Koala::Facebook::GraphAPI.new(@token)
    # @friends = @graph.get_connections("another user id", "friends")
    end

  end
end
