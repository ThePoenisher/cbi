class cbi (){

  class { 'config':}

  class { 'users': }

  case $cbimachine {
    strauss: {
      
      class { 'gitolite':
        home=>"/var/jo/git",
      }

      zsh { 'root' :}
    }
  }

  
}

