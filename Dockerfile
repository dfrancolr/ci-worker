FROM jenkins/jnlp-slave

USER root

RUN apt-get update && apt-get install -y \
      liblinux-usermod-perl \
      apt-transport-https \
      ca-certificates \
      curl \
      gnupg2 \
      software-properties-common \
      ruby-full \
      zlib1g-dev \
      build-essential \
      xvfb \
      x11vnc \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/debian \
      $(lsb_release -cs) \
      stable" \
    && curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list

RUN apt-get update && apt-get install -y \
      docker-ce \
      docker-ce-cli \
      containerd.io \
      google-chrome-stable \
    && usermod -aG docker jenkins \
    && gem install bundler