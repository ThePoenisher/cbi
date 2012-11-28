#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/../
export FACTER_CBIROOT=$DIR
export FACTER_CBIMACHINE=`cat $DIR/puppet/machine_name`
a="$1"
if [ -z "$a" ]; then
		a="class{'cbi':}"
fi

puppet apply -e "$a" $2 $3 $4  --modulepath=$DIR/puppet/modules:/etc/puppet/modules --hiera_config=$DIR/puppet/hiera.yaml 
