FROM        docker.io/python
RUN         useradd -u 1001 python
WORKDIR     /home/python
COPY        payment.ini payment.py rabbitmq.py requirements.txt /home/python/
RUN         pip install -r requirements.txt
ENTRYPOINT  ["uwsgi","--ini","payment.ini"]

