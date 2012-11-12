#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/../puppet

puppet apply -e "class{'cbi':root=>'$DIR'}" --modulepath=$DIR/modules:/etc/puppet/modules --hiera_config=$DIR/hiera.yaml 
