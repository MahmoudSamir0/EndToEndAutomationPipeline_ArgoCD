FROM ubuntu
USER root
# create user
RUN useradd -m jenkins
RUN mkdir -p /var/jenkins_home
RUN chown -R jenkins:jenkins /var/jenkins_home
WORKDIR /home/jenkins
RUN apt update && apt dist-upgrade -y
# Install required packages
RUN apt install -y \
    git \
    apt-transport-https \
    curl \
    software-properties-common \
    unzip \
    openssh-server openssh-client \
    vim \
    ca-certificates \
    gnupg \
    lsb-release
# install docker
RUN mkdir -m 0755 -p /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update
RUN apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Install AZURE CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb |  bash
# install nodejs
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs
# install java
RUN apt install -y openjdk-17-jdk
# install maven
RUN apt-get install -y maven
# expose port
# Cleanup
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*
EXPOSE 22
# running process
ENTRYPOINT ["tail"]
CMD ["-f", "/dev/null"]