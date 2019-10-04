FROM python:3.7-stretch

WORKDIR /tmp

ADD files/apt-transport-https_1.4.8_amd64.deb /tmp

RUN echo 'Acquire::CompressionTypes::Order:: "gz";' > /etc/apt/apt.conf.d/02update &&\
    echo 'Acquire::http::Timeout "10";' > /etc/apt/apt.conf.d/99timeout &&\
    echo 'Acquire::ftp::Timeout "10";' >> /etc/apt/apt.conf.d/99timeout &&\
    dpkg -i /tmp/apt-transport-https_1.4.8_amd64.deb &&\
    apt-get install --allow-unauthenticated -y /tmp/apt-transport-https_1.4.8_amd64.deb &&\
    apt-get update --allow-unauthenticated -y -o Dir::Etc::sourcelist="sources.list.d/main.list" -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0"


RUN apt-get update && \
    apt-get -y install default-jdk

# Detect JAVA_HOME and export in bashrc.
# This will result in something like this being added to /etc/bash.bashrc
#   export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
RUN echo export JAVA_HOME="$(readlink -f /usr/bin/java | sed "s:/jre/bin/java::")" >> /etc/bash.bashrc

# Upgrade pip and setuptools
RUN pip install --upgrade pip setuptools

# Install core python packages
RUN pip install pipenv
