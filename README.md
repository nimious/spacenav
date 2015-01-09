# io-spacenav
Nim bindings for *libspnav*, the free 3Dconnexion device driver.

![io-spacenav Logo](logo.png)

## About
io-spacenav contains bindings to the Spacenav SDK (libspnav) for the Nim
programming language. Spacenav provides a free, compatible and open source
alternative to 3Dconnexion's popular 3D input device drivers and SDK.

## Supported Platforms
The latest version of this module has been tested with **spacenavd 0.6**
and **libspnav 0.2.3**, which currently support the following devices:

- All USB 3Dconnexion 6DOF devices (Linux)
- All serial Spaceball devices (Linux, FreeBSD, MacOSX)

Support for USB devices under Windows and MacOSX is underway, but incomplete.

This module currently supports bindings for the following platforms:

- ~~FreeBSD~~
- Linux
- ~~MacOSX~~

If you wish to use USB based 3Dconnexion devices in Nim under MacOSX or Windows,
you may also consider using [io-3dxware](https://github.com/nimious/io-3dxware)
bindings instead.

## Prerequisites
To compile the bindings in this module you must have **libspnav**, the Spacenav
SDK library, installed on your computer. Users of your program also need to
install and run **spacenavd**, the Spacenav Daemon, that implements the actual
device driver.

### Linux
If your Linux distribution includes a package manager or community repository,
it may already have pre-compiled binaries for both the Daemon and the SDK. For
example, on ArchLinux the SDK is available in the official package repository:

`sudo pacman -Sy libspnav`

The daemon is available in AUR:

`yaourt spacenavd`

Make sure to verify the available version numbers as they may be very outdated.
It is then preferable to manually build the daemon and SDK from the source code
in the Sourceforge repository.

### MacOSX
TODO

### FreeBSD
TODO

### Windows
TODO

## Usage
Import the *spnav* module from this package to starting using the bindings:

```nimrod
import spnav
```

Linux: If your installation of libspnav includes the X11 related Spacenav APIs,
which is the default for binary distributions, you must also link against the
X11 library by adding the following parameter to the Nim compiler command line:

```--passL:"-lX11"```

## References
* [Spacenav Project Page](http://spacenav.sourceforge.net/)
* [Spacenav on Sourceforge](http://sourceforge.net/projects/spacenav/)
* [3Dconnexion Homepage](http://www.3dconnexion.com/i)
* [Nim Programming Language](http://nim-lang.org/)
