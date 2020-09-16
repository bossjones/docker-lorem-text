#!/bin/bash

# Ensure that worker entrypoint does not also run app processes
echo '[run] enabling app'

# Enable app as a supervised service
if [ -d /etc/services.d/app ]
then
  echo '[run] app already enabled'
else
  ln -s /etc/services-available/app /etc/services.d/app
fi
