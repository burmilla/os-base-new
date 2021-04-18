# New OS base for BurmillaOS
This repository contains early alpha/beta versions of scripts which combines [os-kernel](https://github.com/burmilla/os-kernel/) to root file system from debian:bullseye-slim Docker image.


It replaces these components totally:
* [os-base](https://github.com/burmilla/os-base)
* [os-initrd-base](https://github.com/burmilla/os-initrd-base)
* [os-system-docker](https://github.com/burmilla/os-system-docker)


# How to test:
* Use Linux desktop with QEMU installed.
* Run scripts scripts on alphabetical order.

Credentials:
* User: **root**
* Password: **root**

By default machine does not have any IP address. You can get it by running command:
```
udhcpc -i ens3
```

