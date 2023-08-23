FROM mikhail.shostak/base

# https://www.perforce.com/manuals/p4sag/Content/P4SAG/install.linux.packages.install.html#For3
RUN wget -qO - https://package.perforce.com/perforce.pubkey | gpg --dearmor | tee /usr/share/keyrings/perforce.gpg

# visit: https://package.perforce.com/apt/ubuntu/dists/ to check what keys available there
RUN echo "deb [signed-by=/usr/share/keyrings/perforce.gpg] https://package.perforce.com/apt/ubuntu  jammy  release" > /etc/apt/sources.list.d/perforce.list

RUN apt-get update

RUN apt install -y helix-cli

CMD sleep infinity
