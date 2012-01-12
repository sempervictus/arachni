=begin
    Copyright 2010-2012 Tasos Laskos <tasos.laskos@gmail.com>

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
=end

module Arachni
module Modules

#
# @author: Tasos "Zapotek" Laskos
#                                      <tasos.laskos@gmail.com>
#                                      <zapotek@segfault.gr>
# @version: 0.1.2
#
class Htaccess < Arachni::Module::Base

    include Arachni::Module::Utilities

    def run
        return if @page.code != 401

        @http.post( @page.url ).on_complete {
            |res|
            __log_results( res ) if res.code == 200
        }
    end

    def self.info
        {
            :name           => '.htaccess LIMIT misconfiguration',
            :description    => %q{Checks for misconfiguration in LIMIT directives that blocks
                GET requests but allows POST.},
            :elements       => [ ],
            :author         => 'Tasos "Zapotek" Laskos <tasos.laskos@gmail.com>',
            :version        => '0.1.2',
            :references     => {},
            :targets        => { 'Generic' => 'all' },
            :issue   => {
                :name        => %q{Misconfiguration in LIMIT directive of .htaccess file.},
                :description => %q{The .htaccess file blocks GET requests but allows POST.},
                :tags        => [ 'htaccess', 'server', 'limit' ],
                :cwe         => '',
                :severity    => Issue::Severity::HIGH,
                :cvssv2       => '',
                :remedy_guidance    => '',
                :remedy_code => '',
            }
        }
    end

    def __log_results( res )

        log_issue(
            :url          => res.effective_url,
            :method       => res.request.method.to_s.upcase,
            :elem         => Issue::Element::SERVER,
            :response     => res.body,
            :headers      => {
                :request    => res.request.headers,
                :response   => res.headers,
            }
        )

        print_ok( 'Request was accepted: ' + res.effective_url )
    end

end
end
end