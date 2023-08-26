FROM ubuntu:22.04

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
  openjdk-18-jre\
  wget && \
  rm -rf /var/lib/apt/lists/*


#=============================
# INSTALL PYTHON PACKAGES
#=============================
RUN pip3 install --user virtualenv==20.23.1
RUN python3 -m venv ${python_env}

COPY install_python_module /usr/local/bin/

RUN chmod +x /usr/local/bin/install_python_module

RUN install_python_module pandas
RUN install_python_module "torch --index-url https://download.pytorch.org/whl/cpu"
RUN install_python_module sincfold
RUN install_python_module matplotlib
RUN install_python_module varnaapi

RUN ln -s ${python_env}/bin/python /usr/local/bin/python

# RNAstructure
RUN wget -q http://rna.urmc.rochester.edu/Releases/current/RNAstructureLinuxTextInterfaces64bit.tgz
RUN tar xfz RNAstructureLinuxTextInterfaces64bit.tgz
RUN rm RNAstructureLinuxTextInterfaces64bit.tgz

WORKDIR "/RNAstructure"
RUN make install
WORKDIR "/"

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
