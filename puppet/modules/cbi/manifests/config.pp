class cbi::config (){
  $standard_path=["/bin", "/usr/local/sbin",
                  "/usr/local/bin","/usr/sbin","/usr/bin"]
  
  $ssh_key_dir="$cbiroot/ssh-keys"
  
  $machine = file("$cbiroot/puppet/machine_name")
}
