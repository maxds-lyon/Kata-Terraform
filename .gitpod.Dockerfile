FROM gitpod/workspace-full:latest

USER gitpod
## Terraform
RUN sudo apt-get update && sudo apt-get install -y gnupg software-properties-common \
    && wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null \
    && gpg --no-default-keyring \
    --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    --fingerprint \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list \
    && sudo apt update \
    && sudo apt-get install terraform \
    && pip install --upgrade pip \ 
    && pip install terraform-local

## Localstack-cli
RUN pip install --upgrade pip \
    && python3 -m pip install localstack

## AWS Cli
RUN sudo apt-get update && sudo apt-get install -y curl unzip \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && sudo ./aws/install

COPY config .
RUN mkdir -p  /home/gitpod/.aws \ 
    && mv config /home/gitpod/.aws/config

USER root
SHELL ["/bin/sh", "-c"]