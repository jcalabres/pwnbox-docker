FROM phusion/baseimage
MAINTAINER jcalabres00

ENV DEBIAN_FRONTEND noninteractive

RUN dpkg --add-architecture i386
RUN apt-get update && apt-get -y upgrade

#-------------------------------------#
# Install packages from Ubuntu repos  #
#-------------------------------------#
RUN apt-get install -y \
    build-essential \
    gcc-multilib \
    g++-multilib \
    gdb \
    gdb-multiarch \
    python-dev \
    python3-dev \
    python-pip \
    python3-pip \
    default-jdk \
    vim \
    zsh \
    git \
    strace \
    ltrace \
    netcat \
    nmap \
    net-tools \
    wget \
    unzip \
    man-db \
    manpages-dev 

RUN apt-get -y autoremove
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#-------------------------------------#
# Install stuff from pip repos        #
#-------------------------------------#
RUN pip install \
    r2pipe 

#-------------------------------------#
# Install stuff from GitHub repos     #
#-------------------------------------#
# Install radare2
RUN git clone https://github.com/radare/radare2.git /opt/radare2 && \
    cd /opt/radare2 && \
    git fetch --tags && \
    git checkout $(git describe --tags $(git rev-list --tags --max-count=1)) && \
    ./sys/install.sh  && \
    make symstall

# Install gef
RUN git clone https://github.com/hugsy/gef.git /opt/gef

# Install ohmyzsh
RUN git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh && \
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

#-------------------------------------#
# Configuring enviroment              #
#-------------------------------------#
RUN git clone git://github.com/robbyrussell/oh-my-zsh.git /home/.oh-my-zsh && \
    cp /home/.oh-my-zsh/templates/zshrc.zsh-template /home/.zshrc

RUN chsh -s /bin/zsh

ENTRYPOINT ["/bin/zsh"]
