maintainer       ""
maintainer_email ""
license          ""
description      "Creates users from a databag search"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.1"

%w{ ubuntu debian redhat centos fedora freebsd}.each do |os|
  supports os
end
