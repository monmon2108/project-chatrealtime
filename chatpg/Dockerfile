FROM registry.angstrom.co.th:8443/centos7_nodejs:4.4.7
RUN npm install -g coffee-script
RUN yum install -y gcc-c++ automake autoconf libtool libxml2 libxml2-devel
RUN wget https://github.com/quickfix/quickfix/archive/v.1.14.4.tar.gz \
 && tar -xf v.1.14.4.tar.gz \
 && mkdir /usr/local/include/quickfix \
 && cd quickfix-v.1.14.4 \
 && ./bootstrap \
 && ./configure \
 && make \
 && make install \
 && cp ./config.h /usr/local/include/quickfix  \
 && cp /quickfix-v.1.14.4/src/C++/.libs/libquickfix.so.16 /usr/lib64 \
 && cd / \
 && npm install node-quickfix \
 && npm install express \
 && npm install -g nodemon \
 && npm install url \
 && npm install request \
 && npm install --save ejs \
 && npm install --save socket.io \
 && npm install redis


WORKDIR /src
