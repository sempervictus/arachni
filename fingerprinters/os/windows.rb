=begin
    Copyright 2010-2014 Tasos Laskos <tasos.laskos@gmail.com>
    All rights reserved.
=end

module Arachni
module Platform::Fingerprinters

#
# Identifies Windows operating systems.
#
# @author Tasos "Zapotek" Laskos <tasos.laskos@gmail.com>
#
# @version 0.1
#
class Windows < Platform::Fingerprinter

    IDs = %w(windows win32)

    def run
        IDs.each do |id|
            next if !server_or_powered_by_include? id
            return platforms << :windows
        end
    end

end

end
end
