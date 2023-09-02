FROM ubuntu:22.04

#=============================
# INSTALL BASE PACKAGES
#=============================
#RUN DEBIAN_FRONTEND=noninteractive \
RUN apt-get update && apt-get install -y --no-install-recommends \
    	    build-essential \
	    pkg-config \
	    gfortran \
	    libatlas-base-dev \
	    fonts-lyx \
	    libfreetype6-dev \
	    libpng-dev \
	    sudo \
	    python3 \
	    python3-pip \
	    python3-setuptools\
	    python3-dev\
	    imagemagick\
      	wget && \
    rm -rf /var/lib/apt/lists/*    

#=============================
# INSTALL PYTHON PACKAGES
#=============================
# torch sin cuda
RUN pip3 install -U torch --index-url https://download.pytorch.org/whl/cpu 
RUN pip3 install sincfold==0.10

ENV uid=1000
ENV gid=${uid}
# webdemobuilder usa 1 thread
ENV OPENBLAS_NUM_THREADS=1
ENV OMP_NUM_THREADS=1

RUN echo 'alias python=python3' >> ~/.bashrc