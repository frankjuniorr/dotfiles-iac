FROM ubuntu:24.04

RUN apt update && apt install -y \
    software-properties-common \
    python3 \
    python3-pip \
    python3-apt \
    python3-venv \
    && apt clean

RUN apt-add-repository -y ppa:ansible/ansible && \
    apt update && \
    apt install -y ansible && \
    apt clean

WORKDIR /app

COPY requirements.txt requirements.txt
COPY requirements.yaml requirements.yaml

RUN python3 -m venv .venv \
    && . .venv/bin/activate \
    && .venv/bin/pip install --upgrade pip \
    && .venv/bin/pip install -r requirements.txt \
    && ansible-galaxy collection install -r requirements.yaml

# Copie o playbook e os arquivos relacionados
COPY . .

RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh

