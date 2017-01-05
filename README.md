# Home Assistant

This is a fork of https://github.com/home-assistant/home-assistant

See official documentation from there.

## New features

This image has added support for Telldus Tellstick Duo, an USB-connected
generic 433 MHz tranceiver. To use it under Docker, container must
be run in privileged mode (to use USB-devices) and the USB-bus needs to
be visible inside the container.

Here is an example compose file you might use:

```
version: '2'
services:
  hass:
    image: "taskinen/home-assistant"
    volumes:
      - "./some/dir/config:/config"
      - "./some/dir/tellstick.conf:/etc/tellstick.conf"
    devices:
      - "/dev/bus/usb:/dev/bus/usb"
    ports:
      - "8123:8123"
    restart: unless-stopped
    network_mode: "host"
    privileged: true
```

## Configuration of Tellstick

The `/etc/tellstick.conf` file inside the container configures
the Tellstick software. The above Docker compose example mounts
it from the host. Create it somewhere in your host and makes
sure the path matches the Docker compose configuration.

Here is an example tellstick.conf file you need to customize:

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
