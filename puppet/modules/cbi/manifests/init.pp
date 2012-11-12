class cbi ($root){

  class { 'config':}
  $machine = file("$root/machine_name")
  notify{ "cbi/puppet: '$root'. Machine: '$machine'":}

  notify {"a" :
    #    message => decrypt_file("/root/cbi/puppet/hieradata/strauss.yaml.gpg")
  }
  
  case $machine {
    strauss: {
      
      class { 'gitolite':
        home=>"/var/jo/git",
      }
    }
  }

  
}

