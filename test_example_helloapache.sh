#!/bin/bash
atomic install aweiteka/helloapache:app
atomic run aweiteka/helloapache:app
sleep 2
kubectl get pod | grep -q fedora
if [ $? -eq 0 ]; then
  stat=$(kubectrl get pod | grep fedora | awk '{print $7}')
  while [ $stat != 'Running' ]; do
    sleep 2
    stat=$(kubectrl get pod | grep fedora | awk '{print $7}')
  done
  ret=$(curl http://localhost/)
  if [ $ret == 'Apache' ]; then
    exit 0
  else 
    echo 'Returned value now what we expected'
    exit 1
  fi
  exit 0
else
  echo 'Kube ctrl failed to launch pod'
  exit 1
fi
