#!/bin/bash
sleep 10
sudo apt-get update -y
sudo apt-get -y install  \
  xterm                  \
  gpg                    \
  g++                    \
  expect                 \
  libapr1                \
  python                 \
  libpython3.6           \
  libpython2.7           \
  curl                   \
  libaprutil1            \
  libatlas3-base         \
  libboost-system1.62.0  \
  libmemcached11         \
  libmemcachedutil2      \
  libmysqlclient20       \
  libv8-3.14.5           \
  libboost-regex1.65.1   \
  libxslt1.1             \
  libcurl3-gnutls
