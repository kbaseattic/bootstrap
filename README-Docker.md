# Building a runtime for docker images

This is just to build the runtime which can then be used to build other images.
See the docker branch in https://github.com/kbase/deploy_tools

## Prerequisites

A functioning deployment currently requires around 15 of disk space available but deploying 
kbase services will require additional space.

## Build the image and tag it appropriately

    docker built -t kbase/rtmin:1.2 .

That's it.
