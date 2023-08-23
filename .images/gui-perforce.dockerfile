FROM mikhail.shostak/gui

# https://www.perforce.com/manuals/p4sag/Content/P4SAG/install.linux.packages.install.html#For3
RUN wget -qO - https://package.perforce.com/perforce.pubkey | gpg --dearmor | tee /usr/share/keyrings/perforce.gpg

# visit: https://package.perforce.com/apt/ubuntu/dists/ to check what keys available there
RUN echo "deb [signed-by=/usr/share/keyrings/perforce.gpg] https://package.perforce.com/apt/ubuntu  jammy  release" > /etc/apt/sources.list.d/perforce.list

RUN apt-get update

RUN apt install -y helix-cli

RUN wget -O /tmp/p4v.tgz https://www.perforce.com/downloads/perforce/r23.1/bin.linux26x86_64/p4v.tgz && \
    mkdir -p /opt/p4v && \
    tar xzf /tmp/p4v.tgz -C /opt/p4v --strip-components=1 && \
    rm /tmp/p4v.tgz

ENV PATH="$PATH:/opt/p4v/bin:/opt/p4v/lib"

RUN apt-get install -y libxkbcommon0 libnss3
RUN apt-get install -y gedit

CMD sleep infinity
