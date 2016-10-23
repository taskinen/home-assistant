# Home Assistant

This is a fork of https://github.com/home-assistant/home-assistant

See official documentation from there.

## New features

This image has added support for Telldus Tellstick, a USB-powered
generic 433 MHz tranceiver. To use it under Docker, container must
be run with privilege mode (to use USB-devices) and the USB-bus
must be visible inside the container.

Here is an example compose file you might use:

```
version: '2'
services:
  core:
    image: "taskinen/home-assistant"
    container_name: "hass"
    volumes:
      - "/var/docker-volumes/hass/config:/config"
      - "/var/docker-volumes/hass/tellstick.conf:/etc/tellstick.conf"
    devices:
      - "/dev/bus/usb:/dev/bus/usb"
    ports:
      - "8123:8123"
    restart: always
    network_mode: "host"
    privileged: true
```

## Configuration of Telldus

Mount tellstick.conf file and customize it. Here is an example:

```
user = "root"
group = "root"
device {
  id = 2
  name = "Example light"
  controller = 0
  protocol = "arctech"
  model = "selflearning-switch"
  parameters {
    house = "1"
    unit = "2"
  }
}
device {
  id = 3
  name = "Another example"
  controller = 0
  protocol = "arctech"
  model = "selflearning-switch"
  parameters {
    house = "3"
    unit = "4"
  }
}
```

## Other options

Network_mode needs to be set to `host` if you want auto-discovery of devices to work.

Privileged needs to be set for USB-devices to work. Also `/dev/bus/usb` needs to be set as devices.
