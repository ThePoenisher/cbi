
define cbi::zsh ($user=$title, $rcfile=undef) {
  include cbi::config
  include cbi::users
  $userhash=hiera("${user}_user")
  $home=$userhash[home]

  
  user{ $user:
    shell => "/bin/zsh"
    }
  
      #  file { "$rcfile": }
      #define link1 () {
        notify{'a':message=>$home
          
            #      generate("/bin/bash","-c","/bin/echo ~$user")
            ,
            require => [                          Cbi::Users::Custom_user["root"] ]
        }
        
      }



