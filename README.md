# subsurface-ml-docker [![Build Status](https://travis-ci.org/softwareunderground/subsurface-ml-docker.svg?branch=master)](https://travis-ci.org/softwareunderground/subsurface-ml-docker)
__A docker image fully loaded with Sufurface & ML related packages.__

This is a very easy way to bring up a GPU capable ML environment on a linux machine. 

The focus is on tensorflow which is the framework which has had the most testing. Pytorch and theano are installed by default too.

**NOTE** This image used nvidia-docker which is only supported on linux. The docker container could still be used as-is on mac or windows for non GPU dependent apps/libs but will need customisation to install non gpu versions of tensorflow etc if you want to use those.

# Quick Start

The fastest way to start is to pull the image from dockerhub. Note this can still take 20-30 mins on AWS, or much longer on a slower local connection.

## Machine/Instance Setup

 1. Start with a clean ubuntu installation e.g. Ubuntu running on a fresh AWS EC2 instance
    1. Ensure you have ssh access to your instance
    1. Esure port 8888 is open for inbound traffic
 1. Install `docker` for your platform [docs](https://docs.docker.com/installation/) and make sure you can run docker without sudo
 1.  Install and up to date NVIDIA graphics driver from PPA
     1. check for latest PPA driver version [here](https://launchpad.net/~graphics-drivers/+archive/ubuntu/ppa)
     1. add PPA repository to your system

            sudo add-apt-repository ppa:graphics-drivers/ppa
            sudo apt-get update
     1. install latest driver (e.g. v390)

            sudo apt-get install nvidia-390 nvidia-settings

     1. Reboot

 1. Install `nvidia-docker 2.0` [docs](https://github.com/NVIDIA/nvidia-docker/wiki/Installation-(version-2.0))

## Running the container and connecting
 1. pull the image from docker hub (the image is big, this will take some time, takes aout 5 min on EC2)

        docker pull softwareunderground/subsurface-ml-docker

 1. run the container - the following command will start the container in the background (you can exit the terminal session and the continer will keep running) and map a single local folder onto the container
        
        setsid nvidia-docker run -t -v <insert-local-path>:/home/geo/workspace --net=host --env KERAS_BACKEND=tensorflow softwareunderground/subsurface-ml-docker
    
    1. mapping a local folder - change the `<insert-local-path>` for a valid local path to your source code directory containing repos, notebooks etc that you want to run. That folder will mounted at `/home/geo/workspace` on the continer
    1. map additional folders - add additional `-v <insert-local-path>:/home/geo/<mount-folder>` arguments to the commamnd to mount additional folders on the container

 1. connect to jupyter lab - browse to `http://<your-instance-ip>:8888/lab` and enter the password `softwareunderground` when prompted
    1. `http://<your-instance-ip>:8888/tree` if you don't want the lab interface


# Start from a local build (unbuntu/linux)
 1. Follow the Machine/Instance setup steps in the Quick Start section then instead of running `docker pull`:
 1. clone this repo into a folder *alongside* other repos or folders with code you want to execute in
 1. build and launch a container
    1. On macos/linux run `make notebook`
    1. On windows run `run_build.bat`

### Local build convenience commands
We are using `Makefile` to simplify docker commands within make commands.

Build the container and start a Jupyter Notebook

    $ make notebook

Build the container and start an iPython shell

    $ make ipython

Build the container and start a bash

    $ make bash

## What's in the Box
A full Anaconda install is huge and we are adding to that with common ml and geo packages. To try and stop this getting too bloated we have stuck with a MiniConda base image, meaning we need to be exoplicit about what we add but we only get what we want.

Some attempt has been made to have sections in the `Dockerfile` in the hope that it's easier for people to customise to their needs.
 
 - Data Science & Viz
 [x] pandas
 [x] 

## Running the container

We are using `Makefile` to simplify docker commands within make commands.

Build the container and start a Jupyter Notebook

    $ make notebook

Build the container and start an iPython shell

    $ make ipython

Build the container and start a bash

    $ make bash

For GPU support install NVIDIA drivers (ideally latest) and
[nvidia-docker](https://github.com/NVIDIA/nvidia-docker). Run using

    $ make notebook GPU=0 # or [ipython, bash]

Switch keras between Theano and TensorFlow

    $ make notebook BACKEND=theano
    $ make notebook BACKEND=tensorflow

Mount a volume for external data sets

    $ make DATA=~/mydata

Prints all make tasks

    $ make help

You can change Theano parameters by editing `/docker/theanorc`.

Note: If you would have a problem running nvidia-docker you may try the old way
we have used. But it is not recommended. If you find a bug in the nvidia-docker report
it there please and try using the nvidia-docker as described above.

    $ export CUDA_SO=$(\ls /usr/lib/x86_64-linux-gnu/libcuda.* | xargs -I{} echo '-v {}:{}')
    $ export DEVICES=$(\ls /dev/nvidia* | xargs -I{} echo '--device {}:{}')
    $ docker run -it -p 8888:8888 $CUDA_SO $DEVICES gcr.io/tensorflow/tensorflow:latest-gpu

# License
MIT

# Credits
This docker and Makefile layout was originally based on the [docker starter example in the keras repo](https://github.com/keras-team/keras/tree/master/docker). THe Docker file in particular has been customised to make it easier to see groups of related packages and add remove as necessary. But the makefile and instructions in this readme are pretty much as-is and lovely. The original repository available under [MIT here](https://github.com/keras-team/keras/blob/master/LICENSE)