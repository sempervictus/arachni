=begin
    Copyright 2010-2014 Tasos Laskos <tasos.laskos@gmail.com>
    All rights reserved.
=end

#
# Extracts paths from "link" HTML elements.
#
# @author Tasos "Zapotek" Laskos <tasos.laskos@gmail.com>
#
# @version 0.1.1
#
class Arachni::Parser::Extractors::Links < Arachni::Parser::Extractors::Base

    #
    # Returns an array of paths as plain strings
    #
    # @param    [Nokogiri]  doc  Nokogiri document
    #
    # @return   [Array<String>]  paths
    #
    def run( doc )
        doc.search( "//link[@href]" ).map { |a| a['href'] }
    end

end
