# Build Images

```bash
chmod +x ./build.sh
./build.sh
```

# Profiles

## Windows Terminal

DevImages

```json
{
  "name": "DevImages",
  "icon": "https://www.docker.com/wp-content/uploads/2023/04/cropped-Docker-favicon-32x32.png",
  "commandline": "wsl",
  "startingDirectory": "/projects/DevImages"
}
```

Docker Terraform

```json
{
  "name": "Terraform",
  "commandline": "wsl /projects/DevImages/run.sh /projects/Terraform/compose.yml",
  "icon": "https://www.terraform.io/favicon.ico"
}
```

## VSCode Integrated Terminal

DevImages

```json
"terminal.integrated.profiles.linux": {
    "DevImages": {
        "path": "/projects/DevImages/bash.sh",
        "args": ["/projects/DevImages"],
        "overrideName": true,
        "icon": "layers",
        "color": "terminal.ansiYellow"
    }
}
```

Docker Terraform

```json
"terminal.integrated.profiles.linux": {
    "Terraform": {
        "path": "/projects/DevImages/run.sh",
        "args": ["/projects/Terraform/compose.yml"],
        "overrideName": true,
        "icon": "server",
        "color": "terminal.ansiMagenta"
    }
}
```

# Docker Compose Usage

## cat AWS Images

```yaml
version: '3'

services:
  env:
    image: mikhail.shostak/aws
    environment:
      - AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}
      - AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
      - AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - .:/opt/source
```

## GUI Images

```yaml
version: '3'

services:
  env:
    image: mikhail.shostak/gui
    environment:
      - DISPLAY=${DISPLAY}
    volumes:
      - /tmp/.X11-unix:/tmp/.X11-unix
      - .:/opt/source
```


