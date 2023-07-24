FROM postgres:14
COPY mongodb-database-tools-ubuntu2204-x86_64-100.7.3.deb /tmp
RUN apt update
RUN apt install /tmp/mongodb-database-tools-ubuntu2204-x86_64-100.7.3.deb -y
RUN apt install git -y
RUN mkdir -p /app/persistent/
RUN mkdir -p /app/.ssh/
RUN echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
RUN git config --global user.email "dockerimage"
RUN git config --global user.name "autocommitter"
COPY script.sh /app/
WORKDIR /app/
RUN chmod +x script.sh
ENTRYPOINT ["./script.sh"]