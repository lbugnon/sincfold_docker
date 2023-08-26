FROM ubuntu:22.04

#=============================
# INSTALL BASE PACKAGES
#=============================
#RUN DEBIAN_FRONTEND=noninteractive \
RUN apt-get update && apt-get install -y --no-install-recommends \
    	    build-essential \
	    default-jre\
	    #openjdk-18-jre\
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
RUN pip3 install -U pip 
RUN pip3 install -U wheel
RUN pip3 install -U pandas
# torch sin cuda
RUN pip3 install -U torch --index-url https://download.pytorch.org/whl/cpu 
RUN pip3 install -U matplotlib
RUN pip3 install -U sincfold

# RNAstructure
RUN wget -q http://rna.urmc.rochester.edu/Releases/current/RNAstructureLinuxTextInterfaces64bit.tgz
RUN tar xfz RNAstructureLinuxTextInterfaces64bit.tgz
RUN rm RNAstructureLinuxTextInterfaces64bit.tgz

WORKDIR "/RNAstructure"
RUN make install
WORKDIR "/"

ENV uid=1000
ENV gid=${uid}
# webdemobuilder usa 1 thread
ENV OPENBLAS_NUM_THREADS=1
ENV OMP_NUM_THREADS=1

RUN echo 'alias python=python3' >> ~/.bashrc