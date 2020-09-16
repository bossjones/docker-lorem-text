FROM behance/docker-base:2-ubuntu-20.04

LABEL Maintainer "Jarvis <jarvis@theblacktonystark.com>"

ENV NON_ROOT_USER=developer \
    container=docker \
    TERM=xterm-256color

WORKDIR /app

# Install packages for building ruby
RUN apt-get update && \
    apt-get install -y build-essential curl git && \
    apt-get install -y zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt-dev bash-completion vim tree sudo python2.7-dev libffi-dev && \
    apt-get install -y build-essential python-dev python-setuptools python-pip python-smbus && \
    apt-get install -y libncursesw5-dev libgdbm-dev libc6-dev && \
    apt-get install -y zlib1g-dev libsqlite3-dev tk-dev && \
    apt-get install -y libssl-dev openssl && \
    apt-get install -y libffi-dev && \
    apt-get clean

# sudo apt-get install libncursesw5-dev libgdbm-dev libc6-dev
# sudo apt-get install zlib1g-dev libsqlite3-dev tk-dev
# sudo apt-get install libssl-dev openssl
# sudo apt-get install libffi-dev

# USER ${NON_ROOT_USER}
# WORKDIR /home/${NON_ROOT_USER}

ENV LANG C.UTF-8
ENV CI true

# --------------------------------------------------
# SOURCE: https://github.com/awslabs/amazon-sagemaker-examples/issues/319
# SOURCE: https://github.com/rycus86/webhook-proxy/blob/master/Dockerfile#L18
# Setting PYTHONUNBUFFERED=TRUE or PYTHONUNBUFFERED=1 (they are equivalent) allows for log messages to be immediately dumped to the stream instead of being buffered. This is useful for receiving timely log messages and avoiding situations where the application crashes without emitting a relevant message due to the message being "stuck" in a buffer.

# As for performance, there can be some (minor) loss that comes with using unbuffered I/O. To mitigate this, I would recommend limiting the number of log messages. If it is a significant concern, one can always leave buffered I/O on and manually flush the buffer when necessary.
# --------------------------------------------------
ENV PYTHONUNBUFFERED=1

ENV PYENV_ROOT /.pyenv
ENV PATH="${PYENV_ROOT}/shims:${PYENV_ROOT}/bin:${PATH}"
ENV PYTHON_CONFIGURE_OPTS="--enable-shared"

RUN curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash && \
    git clone https://github.com/jawshooah/pyenv-default-packages ${PYENV_ROOT}/plugins/pyenv-default-packages && \
    find ${PYENV_ROOT} -name "*.tmp" -exec rm {} \; && \
    find ${PYENV_ROOT} -type d -name ".git" -prune -exec rm -rf {} \;

RUN PYTHONDONTWRITEBYTECODE=true pyenv install 3.7.8 && pyenv global 3.7.8 && pip3 install -U pip

RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python

ENV PATH="~/.poetry/bin:${PATH}"

# RUN poetry completions bash > /etc/bash_completion.d/poetry.bash-completion

# RUN pip3 install --no-cache-dir lorem-text && \
#     pyenv rehash

# RUN apt-get update && \
#     apt-get install -y --no-install-recommends netcat && \
#     rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# COPY poetry.lock pyproject.toml ./
# RUN pip install poetry==1.0.* && \
#     poetry config virtualenvs.create false && \
#     poetry install --no-dev

# Overlay the root filesystem from this repo
COPY ./container/root /

# ENTRYPOINT ["/init"]
