#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/../puppet

puppet apply -v -e "class{'cbi::modules':}" --modulepath=$DIR/modules:/etc/puppet/modules --hiera_config=$DIR/hiera.yaml
