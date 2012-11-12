define cbi::puppetforge-module ($my_name = $title) {
  exec { "puppet module install $my_name" :
    path => $cbi::config::standard_path,
    onlyif => "test 0 -eq `puppet module list |  grep -c $my_name`",
  }
}
