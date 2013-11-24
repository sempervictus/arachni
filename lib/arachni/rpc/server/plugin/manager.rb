=begin
    Copyright 2010-2014 Tasos Laskos <tasos.laskos@gmail.com>
    All rights reserved.
=end

module Arachni

require Options.dir['lib'] + 'plugin/manager'

module RPC
class Server
module Plugin

#
# We need to extend the original Manager and redeclare its inherited methods
# which are required over RPC.
#
# @author Tasos "Zapotek" Laskos <tasos.laskos@gmail.com>
#
class Manager < ::Arachni::Plugin::Manager

    # make these inherited methods visible again
    private :available, :results, :loaded, :create
    public  :available, :results, :loaded

    def load( plugins )
        if plugins.is_a?( Array )
            h = {}
            plugins.each { |p| h[p] = @framework.opts.plugins[p] || {} }
            plugins = h
        end
        plugins.each do |plugin, opts|
            prep_opts( plugin, self[plugin], opts )
        end
        @framework.opts.plugins.merge!( plugins )
        super( plugins.keys )
    end

    #
    # Merges the plug-in results of self with the provided results.
    #
    # It uses each plugin's merge() class method to do it.
    #
    # @param    [Array]     results
    #
    def merge_results( results )
        info = {}
        formatted = {}

        results << self.results
        results.each do |plugins|
            plugins.each do |name, res|
                next if !res

                formatted[name] ||= []
                formatted[name] << res[:results]

                info[name] = res.reject{ |k, v| k == :results } if !info[name]
            end
        end

        merged = {}
        formatted.each do |plugin, c_results|
            if !self[plugin].distributable?
                res = c_results[0]
            else
                res = self[plugin].merge( c_results )
            end
            merged[plugin] = info[plugin].merge( :results => res )
        end

        self.results = merged
    end

end

end
end
end
end
