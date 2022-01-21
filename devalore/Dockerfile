FROM python:3.9-slim
COPY . /srv/devalore
WORKDIR /srv/devalore
RUN pip install --no-cache-dir -r requirements.txt
CMD pytest