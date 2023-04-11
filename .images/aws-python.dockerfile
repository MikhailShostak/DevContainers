FROM mikhail.shostak/aws

RUN apt-get install -y python3
RUN curl -sSL https://install.python-poetry.org | python3 -

ENV PATH="$PATH:/root/.local/share/pypoetry/venv/bin"

CMD poetry update && sleep infinity
