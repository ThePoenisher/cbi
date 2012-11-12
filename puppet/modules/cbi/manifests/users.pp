class cbi::users (){
  $users=hiera("users")
  custom_user{ $users: }
  
  define custom_user ($user=$title){
    $userhash=hiera("${user}_user","DEADBEEF")
    $a={ensure=>present}
   notice("asd") 
    if(is_hash($userhash)){
      $b=merge($a,$userhash)
      if(has_key($userhash,'gid')){
        $gid=$userhash[gid]
      }else{
        $gid=$user
      }
      if(has_key($userhash,'home')){
        $home= $userhash[home]
        file{ $home:
          ensure => directory,
          require => User[$user],
          mode => 0755,
          owner => $user,group => $gid,
        }
       }
     }else{
      $b=$a
     }
     ensure_resource(user,$user,$b)
     
  }
}

