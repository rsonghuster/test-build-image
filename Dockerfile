# 编译阶段
FROM debian:latest

ADD https://images.devsapp.cn/application/ffmpeg-app/480P.mp3 /tmp

WORKDIR /code
COPY app.py app.py 

CMD ["/bin/sh"]


# 运行阶段
FROM python:3.7.4-slim-stretch

MAINTAINER  test

LABEL maintainer=“SvenDowideit@home.org.au”

ARG TEST_ARG=test

RUN apt-get update && apt-get install -y \
  wget \
  unzip\
  fonts-wqy-zenhei \
  fonts-wqy-microhei \
  libreoffice \
  libreoffice-writer\
  --no-install-recommends && rm -r /var/lib/apt/lists/*

RUN mkdir -p /usr/share/man/man1
RUN apt-get update && apt-get install -y \
  openjdk-8-jdk \
  imagemagick \
  --no-install-recommends && rm -r /var/lib/apt/lists/*

RUN pip install flask -i https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip install oss2 -i https://pypi.tuna.tsinghua.edu.cn/simple

RUN chmod 777 /tmp

# Create app directory
WORKDIR /code

COPY --from=0 /code/app.py app.py

ENV USER root

VOLUME ["/data1"]

EXPOSE 9000

ENTRYPOINT [ "python", "-u", "app.py" ]