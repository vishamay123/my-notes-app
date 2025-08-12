FROM python:3.9

WORKDIR /app/backend


COPY requirements.txt /app/backend
RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y gcc default-libmysqlclient-dev pkg-config  \
    && rm -rf /var/lib/apt/lists/*


RUN pip install --upgrade pip
RUN pip install mysqlclient
RUN pip install -r requirements.txt


COPY . /app/backend

EXPOSE 8000


# Use an entrypoint script to handle DB migrations before starting
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

