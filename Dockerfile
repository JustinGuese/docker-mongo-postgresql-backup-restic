FROM postgres:14
COPY mongodb-database-tools-ubuntu2204-x86_64-100.7.3.deb /tmp
COPY mongodb-database-tools-ubuntu2204-arm64-100.7.4.deb /tmp
RUN apt update
# Detect the architecture and set the package name accordingly
RUN dpkg --print-architecture | grep -q "arm64" && \
    apt install /tmp/mongodb-database-tools-ubuntu2204-arm64-100.7.4.deb -y || \
    apt install /tmp/mongodb-database-tools-ubuntu2204-x86_64-100.7.3.deb -y
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