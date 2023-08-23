FROM mikhail.shostak/gui

RUN apt-get install -y \
    build-essential \
    scons \
    pkg-config \
    libx11-dev \
    libxcursor-dev \
    libxinerama-dev \
    libgl1-mesa-dev \
    libglu-dev \
    libasound2-dev \
    libpulse-dev \
    libudev-dev \
    libxi-dev \
    libxrandr-dev

RUN wget https://github.com/godotengine/godot/releases/download/4.0.3-stable/Godot_v4.0.3-stable_linux.x86_64.zip && \
    unzip Godot_v4.0.3-stable_linux.x86_64.zip -d /opt/godot && \
    rm Godot_v4.0.3-stable_linux.x86_64.zip

CMD sleep infinity
