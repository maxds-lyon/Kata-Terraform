# Big image but it's cached on gitpod nodes already
FROM gitpod/workspace-full:latest

# Install tools as the gitpod user
USER gitpod
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
    && sudo apt-get install terraform

# SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# # Install helper tools
# RUN brew update && brew upgrade && brew install \
#     gawk coreutils pre-commit tfenv terraform-docs \
#     tflint tfsec instrumenta/instrumenta/conftest \
#     && brew install --ignore-dependencies cdktf \
#     && brew cleanup
# RUN tfenv install latest && tfenv use latest

# COPY .gitpod.bashrc /home/gitpod/.bashrc.d/custom

# Give back control
USER root
#  and revert back to default shell
#  otherwise adding Gitpod Layer will fail
SHELL ["/bin/sh", "-c"]