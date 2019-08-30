FROM node:12.9.1-stretch AS node
FROM python:2.7.16-stretch AS python2
FROM python:3.7.4-stretch AS python3
FROM debian:stretch-slim AS combined

ENV DEBIAN_FRONTEND noninteractive

COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/include/node /usr/local/include/node
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=node /opt /opt

COPY --from=python2 /usr/local/bin/pip2.7 /usr/local/bin/pip2.7
COPY --from=python2 /usr/local/bin/python2.7 /usr/local/bin/python2.7
COPY --from=python2 /usr/local/bin/python2.7-config /usr/local/bin/python2.7-config
COPY --from=python2 /usr/local/lib/libpython2.7.so.1.0 /usr/local/lib/libpython2.7.so.1.0
COPY --from=python2 /usr/local/lib/python2.7 /usr/local/lib/python2.7
COPY --from=python2 /usr/local/include/python2.7 /usr/local/include/python2.7

COPY --from=python3 /usr/local/bin/pip3 /usr/local/bin/pip3
COPY --from=python3 /usr/local/bin/pip3.7 /usr/local/bin/pip3.7
COPY --from=python3 /usr/local/bin/pydoc3.7 /usr/local/bin/pydoc3.7
COPY --from=python3 /usr/local/bin/python3.7 /usr/local/bin/python3.7
COPY --from=python3 /usr/local/bin/python3.7m /usr/local/bin/python3.7m
COPY --from=python3 /usr/local/bin/python3.7m-config /usr/local/bin/python3.7m-config
COPY --from=python3 /usr/local/lib/libpython3.7m.so.1.0 /usr/local/lib/libpython3.7.so.1.0
COPY --from=python3 /usr/local/lib/libpython3.so /usr/local/lib/libpython3.so
COPY --from=python3 /usr/local/lib/python3.7 /usr/local/lib/python3.7
COPY --from=python3 /usr/local/include/python3.7m /usr/local/include/python3.7m

RUN ["/bin/bash", "-c", "\
  set -eux -o pipefail \
    && apt-get -qq update \
    && apt-get -qq install -y --no-install-recommends apt-utils  \
    && apt-get -qq install -y --no-install-recommends \
      curl ca-certificates git \
      libyaml-dev zlib1g-dev libssl-dev libbz2-dev libreadline-dev \
      make ssh-client \
    \
    && ln -s /usr/local/bin/node /usr/local/bin/nodejs \
    && ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm \
    && ln -s /usr/local/lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx \
    && ln -s /opt/yarn-*/bin/yarn /usr/local/bin/yarn \
    && ln -s /opt/yarn-*/bin/yarnpkg /usr/local/bin/yarnpkg \
    && node -v \
    && yarn -v \
    && npm -v \
    \
    && ln -s /usr/local/bin/pip2.7 /usr/local/bin/pip2 \
    && ln -s /usr/local/bin/pip2 /usr/local/bin/pip \
    && ln -s /usr/local/bin/python2.7 /usr/local/bin/python2 \
    && ln -s /usr/local/bin/python2 /usr/local/bin/python \
    && ln -s /usr/local/bin/python2.7-config /usr/local/bin/python2-config \
    && ln -s /usr/local/bin/python2-config /usr/local/bin/python-config \
    && ln -s /usr/local/lib/libpython2.7.so.1.0 /usr/local/lib/libpython2.7.so \
    && ldconfig \
    && python2 --version \
    && pip --version \
    && pip install wheel==0.31.1 --upgrade \
    \
    && sed -i -e '1 s/python$/python3/' /usr/local/bin/pip3 \
    && sed -i -e '1 s/python$/python3.7/' /usr/local/bin/pip3.7 \
    && ln -s /usr/local/bin/python3.7 /usr/local/bin/python3 \
    && ln -s /usr/local/bin/pydoc3.7 /usr/local/bin/pydoc3 \
    && ln -s /usr/local/bin/python3.7m-config /usr/local/bin/python3.7-config \
    && ln -s /usr/local/bin/python3.7-config /usr/local/bin/python3-config \
    && ln -s /usr/local/lib/libpython3.7m.so.1.0 /usr/local/lib/libpython3.7m.so \
    && ldconfig \
    && python3 --version \
    && pip3 --version \
    && pip3 install wheel==0.31.1 --upgrade \
    \
    && apt-get -qq autoremove -y \
    && apt-get -qq clean \
    && rm -rf ~/.cache/pip/ \
    && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* \
"]

CMD ["/bin/bash"]
