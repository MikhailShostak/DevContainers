FROM mikhail.shostak/python

RUN apt-get install -y cmake
RUN pip install conan

RUN conan profile detect

ENV PATH=$PATH:/opt/conan:/opt/build

COPY .scripts/conan /opt/conan
CMD conan-install-debug && sleep infinity
