#!/bin/sh

vagrant plugin install vagrant-vbguest

cd ./vagrant && vagrant up && vagrant package --output ../centos-dev.box && vagrant destroy -f