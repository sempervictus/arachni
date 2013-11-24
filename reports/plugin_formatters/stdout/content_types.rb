=begin
    Copyright 2010-2014 Tasos Laskos <tasos.laskos@gmail.com>
    All rights reserved.
=end

class Arachni::Reports::Stdout

#
# Stdout formatter for the results of the ContentTypes plugin
#
# @author Tasos "Zapotek" Laskos <tasos.laskos@gmail.com>
#
# @version 0.1.1
#
class PluginFormatters::ContentTypes < Arachni::Plugin::Formatter

    def run
        results.each_pair do |type, responses|
            print_ok type

            responses.each do |res|
                print_status "    URL:    #{res[:url]}"
                print_info   "    Method: #{res[:method]}"

                if res[:params] && res[:method].downcase == 'post'
                    print_info "    Parameters:"
                    res[:params].each_pair do |k, v|
                        print_info "        #{k} => #{v}"
                    end
                end

                print_line
            end

            print_line
        end
    end

end
end
