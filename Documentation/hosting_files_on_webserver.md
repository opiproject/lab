# Hosting Files on a Webserver using Docker

This document details the steps required to spin up an HTTP/HTTPS webserver using Docker. It also covers how to host files on the web server.

## Prerequisites

- Docker is installed on the server.

## Steps

1. **Download the ISO file to the server**

    Download the ISO file of the operating system you want to use for the web server from a trusted source to the server. In this example, we download the Ubuntu 22.04 Server ISO file using `wget` and move it to the required directory.

    ```sh
    mkdir -p ~/ansible/iso_files
    cd ~/ansible/iso_files
    wget https://releases.ubuntu.com/22.04/ubuntu-22.04.5-live-server-amd64.iso
    ```

2. **Create a Docker Compose Definition**

    Create a `docker-compose.yml` file with the following content:

    ```yaml
    version: '3.8'
    services:
      web-http:
        image: docker.io/library/httpd:2.4.57-alpine3.17
        volumes:
          - ./ansible/iso_files:/usr/local/apache2/htdocs
        ports:
          - 80:80
        networks:
          - opi
    networks:
      opi:
    ```

    This maps the `./ansible/iso_files/` directory to the webserver's `apache2/htdocs` directory. This setup allows you to add new files to the web server without needing to restart the container.

3. **Start the Docker Compose Service**

    Navigate to the working directory and start the service:

    ```sh
    docker-compose up -d
    ```

4. **Access the ISO File**

    Open your web browser and navigate to `http://<webserver-ip-address>/<path-to-iso-file>`. For example, you can access it at: `http://172.22.0.1/ubuntu-22.04.5-live-server-amd64.iso` to access the hosted ISO file.

5. **Stopping/Removing the Webserver**

    Check the list of containers running to find the container_id of the webserver:

    ```sh
    docker ps -a
    ```

    Then To stop the webserver, run:

    ```sh
    docker stop <container_id_or_name>
    ```

    To remove the container, run:

    ```sh
    docker rm <container_id_or_name>
    ```
