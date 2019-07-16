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

RUN apt-get install -y \
        build-essential \
        libssl-dev

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get update && apt-get install -y nodejs

RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - \
    && apt-get update -y && apt-get install google-cloud-sdk -y

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl

#liferay.sh
ADD ./liferay-ci-sa-key.json /tmp/key.json
RUN gcloud config configurations create liferay-sh \
    && gcloud auth activate-service-account --key-file=/tmp/key.json \
    && gcloud beta container clusters get-credentials liferay --region us-west1 --project liferaycloud-development

RUN kubectl config set-context --current --namespace=liferay