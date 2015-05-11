#!/bin/bash

cd ~/sync/
vagrant init atomicapp/dev
vagrant up
UpdtPkgs=$(vagrant ssh -c "sudo yum -d0 list updates | wc -l")
echo 'Updates backlog :' ${UpdtPkgs} 
#if [ $UpdtPkgs -gt 10 ]; then
#    echo 'More than 10 packages due an update!'
#    exit 1
#else
    vagrant ssh -c 'cd sync; sudo env "PATH=$PATH" bash test_example_helloapache.sh'
    if [ $? -ne 0 ]; then
      echo 'failed'
      exit 2
    else
      exit 0
    fi
#fi
