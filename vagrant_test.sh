#!/bin/bash

cd ~/sync/
vagrant init atomicapp/dev
vagrant up
UpdtPkgs=$(vagrant ssh -c "sudo yum -d0 list updates | wc -l")
echo 'Updates backlog :' ${UpdtPkgs} 
if [ $UpdtPkgs -gt 0 ]; then
    echo 'Box needs an update'
    vagrant ssh -c "sudo yum -y update"
fi
vagrant ssh -c 'cd sync; sudo env "PATH=$PATH" bash test_example_helloapache.sh'
if [ $? -ne 0 ]; then
  echo 'failed'
  exit 2
else
  exit 0
fi
