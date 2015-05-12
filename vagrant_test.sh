#!/bin/bash

cd ~/sync/
vagrant init atomicapp/dev
vagrant up --provider virtualbox

provider=$(vagrant ssh -c "sudo yum -y -d1 install virt-what && virt-what | tail -n1" )
if [ $provider == 'virtualbox' ]; then
  UpdtPkgs=$(vagrant ssh -c "sudo yum -d0 list updates | wc -l")
  echo 'Updates backlog :' ${UpdtPkgs} 
  vagrant ssh -c 'cd sync; sudo env "PATH=$PATH" bash test_example_helloapache.sh' -- -t
  if [ $? -ne 0 ]; then
    echo 'failed'
    exit 2
  else
    exit 0
  fi
else
  echo 'Invalid provider!'
  exit 1
fi
