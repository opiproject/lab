# Hosting Files on a Webserver

This document details how to serve the install ISO and the autoinstall files from mgmt (`172.22.0.1`) over HTTP,
so that the iDRAC, iLO and BMC virtual media and the Ubuntu installer can fetch them.

mgmt does not run a permanent web server. Start one for the install and stop it afterwards. mgmt also has a
public IP, so bind the server to the lab address `172.22.0.1` only.

The server is the `httpd` applet of busybox (package `busybox-static`, installed on mgmt). It supports HTTP range
requests, which the BMC virtual media needs to read the ISO. `python3 -m http.server` does not support them, so
use it only for the small **user-data** and **meta-data** files.

## Steps

1. **Download the ISO file to the server**

    Download the ISO file from a trusted source to mgmt. In this example, we download the Ubuntu 26.04 Server ISO
    file using `wget`. For the autoinstall ISO, see [Ubuntu Autoinstall ISO Guide](auto_install_ubuntu_iso.md) and
    copy the generated ISO and the **server** folder into the same directory.

    ```sh
    mkdir -p /root/iso_files
    cd /root/iso_files
    wget https://releases.ubuntu.com/26.04/ubuntu-26.04.1-live-server-amd64.iso
    ```

2. **Start the web server**

    ```sh
    busybox httpd -f -vv -p 172.22.0.1:80 -h /root/iso_files
    ```

    `-f` keeps it in the foreground and `-vv` logs every request, so run it in `tmux` or a second SSH session.
    New files in `/root/iso_files` are served without a restart. During a remote autoinstall, `404` for
    `vendor-data` and `network-config` is normal: the installer asks for them, but only `user-data` and
    `meta-data` are needed.

3. **Access the ISO File**

    Files are served at `http://172.22.0.1/<path-to-file>`, for example
    `http://172.22.0.1/ubuntu-26.04.1-live-server-amd64.iso`. To check it from mgmt:

    ```sh
    curl -sI http://172.22.0.1/ubuntu-26.04.1-live-server-amd64.iso
    curl -s -o /dev/null -w '%{http_code}\n' -r 0-9 http://172.22.0.1/ubuntu-26.04.1-live-server-amd64.iso
    ```

    The second command must print `206` (range requests work).

4. **Stopping the Webserver**

    Press `Ctrl+C` in the session that runs `busybox httpd`.
