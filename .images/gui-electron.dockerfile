FROM mikhail.shostak/gui

RUN apt install -y nodejs npm
RUN npm install -g electron-packager

RUN apt-get install -y libnss3 libatk1.0-0 libatk-bridge2.0-0 libcups2 libgtk-3-0 libasound2

RUN dpkg --add-architecture i386
RUN wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key && \
    wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/focal/winehq-focal.sources

RUN apt-get update
RUN apt-get install -y winehq-stable

#RUN npm install -g chrome-launcher

#RUN useradd -ms /bin/bash electron
#USER electron

# Copy the package.json and package-lock.json files to the container
#COPY package*.json ./

# Install dependencies
#RUN npm install

# Copy the rest of the application code to the container
#COPY . .

# Build the Electron application using Electron Packager
#RUN electron-packager .

# Set the command to run when the container starts
CMD npm install || sleep infinity
