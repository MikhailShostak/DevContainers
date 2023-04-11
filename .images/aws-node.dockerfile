FROM mikhail.shostak/aws

RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt install -y nodejs npm
RUN npm install -g nodemon typescript ts-node

COPY .scripts /opt/scripts
ENV PATH=/opt/scripts:$PATH

CMD npm install && sleep infinity
