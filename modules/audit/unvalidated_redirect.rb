=begin
                  Arachni
  Copyright (c) 2010-2012 Tasos "Zapotek" Laskos <tasos.laskos@gmail.com>

  This is free software; you can copy and distribute and modify
  this program under the term of the GPL v2.0 License
  (See LICENSE file for details)

=end

module Arachni

module Modules

#
# Unvalidated redirect audit module.
#
# It audits links, forms and cookies, injects URLs and checks
# the Location header field to determnine whether the attack was successful.
#
#
# @author: Tasos "Zapotek" Laskos
#                                      <tasos.laskos@gmail.com>
#                                      <zapotek@segfault.gr>
# @version: 0.1.3
#
# @see http://www.owasp.org/index.php/Top_10_2010-A10-Unvalidated_Redirects_and_Forwards
#
class UnvalidatedRedirect < Arachni::Module::Base

    def run
        [
          'www.arachni-boogie-woogie.com',
          'http://www.arachni-boogie-woogie.com',
        ].each {
            |url|
            audit( url ) {
                |res, opts|
                log( opts, res ) if( res.headers_hash['Location'] == url )
            }
        }
    end


    def self.info
        {
            :name           => 'UnvalidatedRedirect',
            :description    => %q{Injects URLs and checks the Location header field
                to determnine whether the attack was successful.},
            :elements       => [
                Issue::Element::FORM,
                Issue::Element::LINK,
                Issue::Element::COOKIE,
                Issue::Element::HEADER
            ],
            :author         => 'Tasos "Zapotek" Laskos <tasos.laskos@gmail.com> ',
            :version        => '0.1.3',
            :references     => {
                 'OWASP Top 10 2010' => 'http://www.owasp.org/index.php/Top_10_2010-A10-Unvalidated_Redirects_and_Forwards'
            },
            :targets        => { 'Generic' => 'all' },

            :issue   => {
                :name        => %q{Unvalidated redirect},
                :description => %q{The web application redirects users to unvalidated URLs.},
                :tags        => [ 'unvalidated', 'redirect', 'injection', 'header', 'location' ],
                :cwe         => '819',
                :severity    => Issue::Severity::MEDIUM,
                :cvssv2       => '',
                :remedy_guidance    => '',
                :remedy_code => '',
            }

        }
    end

end
end
end
