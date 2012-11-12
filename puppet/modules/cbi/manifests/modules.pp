class cbi::modules (){
  class { "config":}
  cbi::puppetforge-module {["puppetlabs-vcsrepo",
                            "puppetlabs-stdlib"]: }
}
