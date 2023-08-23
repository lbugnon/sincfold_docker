FROM ubuntu:22.04

MAINTAINER Leandro Bugnon <lbugnon@sinc.unl.edu.ar>

ENV python_env="/python_env"

#=============================
# INSTALL BASE PACKAGES
#=============================
RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  pkg-config \
  vim \
  gfortran \
  libatlas-base-dev \
  fonts-lyx \
  libfreetype6-dev \
  libpng-dev \
  python3.10 \
  python3.10-dev \
  python3.10-venv \
  python3-pip \
  python3-setuptools\
  imagemagick\
  wget && \
  rm -rf /var/lib/apt/lists/*


#=============================
# INSTALL PYTHON PACKAGES
#=============================
RUN pip3 install --user virtualenv==20.23.1
RUN python3 -m venv ${python_env}

COPY install_python_module /usr/local/bin/

RUN chmod +x /usr/local/bin/install_python_module

RUN install_python_module pip3==23.1.2
RUN install_python_module setuptools==68.0.0
RUN install_python_module wheel==0.40.0
RUN install_python_module nltk==3.8.1
RUN install_python_module flair==0.12.2
RUN install_python_module networkx==3.1
RUN install_python_module transformers==4.30.2
RUN install_python_module pandas==2.0.3
RUN install_python_module biopython==1.81
RUN install_python_module numpy==1.25.1
RUN install_python_module seaborn==0.12.2
RUN install_python_module scipy==1.11.1
RUN install_python_module matplotlib==3.7.2
RUN install_python_module torch==2.0.1
RUN install_python_module scikit-learn==1.3.0
RUN install_python_module ipdb==0.13.13

RUN install_python_module sincfold


RUN ln -s ${python_env}/bin/python /usr/local/bin/python

# Create a new user "developer".
# It will get access to the X11 session in the host computer

ENV uid=1000
ENV gid=${uid}

COPY init.sh /
COPY create_user.sh /
COPY matplotlibrc_tkagg /
COPY matplotlibrc_agg /

RUN chmod +x /init.sh
RUN chmod +x /create_user.sh

ENTRYPOINT ["/init.sh"]
CMD ["/create_user.sh"]
