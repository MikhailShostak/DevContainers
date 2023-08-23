FROM mikhail.shostak/python

RUN apt-get install -y cmake
RUN pip install conan

RUN conan profile detect

#RUN apt-get install -y sudo
#RUN useradd -ms /bin/bash wsl && echo "wsl:wsl" | chpasswd && adduser wsl sudo

COPY .scripts/conan /work/.conan

ENV PATH=$PATH:/work:/work/.conan

WORKDIR /work

#USER wsl
CMD conan-install-release ; sleep infinity
