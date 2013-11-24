=begin
    Copyright 2010-2014 Tasos Laskos <tasos.laskos@gmail.com>
    All rights reserved.
=end

module Arachni

require Options.dir['lib'] + 'rpc/client/base'

module RPC
class Client

# {RPC::Server::Browser} client.
#
# @author Tasos "Zapotek" Laskos <tasos.laskos@gmail.com>
class Browser < RemoteObjectMapper

    def initialize( socket, token = nil )
        super( RPC::Client::Base.new( Options.instance, socket, token ), 'browser' )
    end

end

end
end
end
