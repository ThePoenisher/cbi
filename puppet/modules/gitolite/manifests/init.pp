class gitolite (
  $home=hiera("gitolite_home"),
  $config=hiera("gitolite_config"),
  $ssh_keys=hiera("gitolite_ssh_keys")
  ) {

  $gituser="git"
  $gitolite_checkout = "$home/gitolite" 
  $gito_path= [ "$home/bin", $cbi::config::standard_path]
  $dot_gitolite ="$home/.gitolite"
  $dot_conf = "$dot_gitolite/conf/gitolite.conf"

  ensure_resource(user, $gituser,
  { ensure => present,
    home => $home,
  })

  
  file { [ $home, "$home/bin" ] :
    ensure => directory,
    mode => 0770,
    owner => $gituser,group => $gituser,
  }

  #cbi::puppetforge-module["puppetlabs-vcsrepo"]
  vcsrepo { $gitolite_checkout:
    ensure => present,
    provider => git,
    source => "git://github.com/sitaramc/gitolite",
    # If you change revision, please check:
    # -  post update hook:  replicate behavior in this class.
    # -  ssh-authkeys: replicate in authorized_keys.erb
    revision => "d491b5384f572d5a4bedb12aac430dc770ea475f",
    user => $gituser,
    require => File["$home"],
  }

  # http://sitaramc.github.com/gitolite/install.html
  exec { "gito installation":
    command => "$gitolite_checkout/install -ln $home/bin",
    creates => "${home}/bin/gitolite",
    user => $gituser,
    require => [ File["${home}/bin"],
                 Vcsrepo[$gitolite_checkout ] ],
  }

  
  # TODO don't run everytime
  # http://sitaramc.github.com/gitolite/setup.html
  exec { "gito setup" :
    command => "gitolite setup -a NO_ADMIN_USER_THERE_IS_NO_ADMIN_USER" ,
    path     => $gito_path,
    environment => "HOME=$home",
    user => $gituser,
    creates => "$home/.gitolite.rc",
    require => [ Exec["gito installation"] ],
  }

  
  file { $dot_conf :
    ensure => present,
    mode => 0770,
    owner => $gituser,group => $gituser,
    content => $config,
    require => Exec["gito setup"],
    notify => Exec[ "gito compile" ],
  }

  exec { "gito compile" :
    refreshonly => true,
    command => "gitolite compile" ,
    path     => $gito_path,
    environment => "HOME=$home",
    user => $gituser,
  }

  file { "$home/.ssh/authorized_keys" :
    ensure => present,
    mode => 0600,
    owner => $gituser,group => $gituser,
    content => template("gitolite/authorized_keys.erb"),
    require => File[$home]
  }
  # ssh keys --> users  http://sitaramc.github.com/gitolite/users.html

  }
