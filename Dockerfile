FROM ubuntu:16.04
MAINTAINER tescom <tescom@atdt01410.com>

ARG PYENV_URL=https://github.com/yyuu/pyenv.git
ARG PYENV_VENV_URL=https://github.com/yyuu/pyenv-virtualenv.git

ENV PYENV_ROOT $HOME/.pyenv
ENV PATH $PYENV_ROOT/bin:$PATH

ARG PYTHON=$PYENV_ROOT/versions/numpy/bin/python
ARG PIP=$PYENV_ROOT/versions/numpy/bin/pip

RUN rm -f /etc/localtime \
        && ln -s /usr/share/zoneinfo/Japan /etc/localtime \
        && echo 'export TERM=xterm' >> /root/.bashrc

RUN apt-get update
RUN apt-get install -y ca-certificates \
                openssh-server \
                curl \
                locales \
                wget \
                vim \
                dnsutils \
                less \
                cron \
                make \
                gcc \
                g++ \
                git \
                build-essential \
                zlib1g-dev \
                libbz2-dev \
                libreadline-dev \
                libsqlite3-dev \
                libssl-dev \
                libxml2-dev \
                libxslt1-dev \
                libmysqlclient-dev \
                libssl1.0.0 \
                tk-dev

RUN locale-gen ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8


RUN git clone $PYENV_URL $PYENV_ROOT \
        && git clone $PYENV_VENV_URL $PYENV_ROOT/plugins/pyenv-virtualenv

RUN echo 'eval "$(pyenv init -)"' >> /root/.bashrc
RUN echo 'eval "$(pyenv virtualenv-init -)"' >> /root/.bashrc

RUN env PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install 3.6.2
RUN pyenv virtualenv 3.6.2 numpy
RUN $PIP install gunicorn \
        mysqlclient \
        sqlalchemy \
        aiohttp \
        aiomysql \
        uvloop \
        requests \
        luigi \
        numpy \
        pandas \
        scipy \
        matplotlib \
        scikit-learn \
        statsmodels \
        ipython

VOLUME ["/data"]

#CMD ["/bin/bash"]
CMD ["/usr/sbin/sshd -D"]
