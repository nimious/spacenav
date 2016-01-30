# spacenav

Nim bindings for *libspnav*, the free 3Dconnexion device driver.
![spacenav Logo](docs/logo.png)


## About

This package contains bindings to the Spacenav SDK (libspnav) for the
[Nim](http://nim-lang.org) programming language. Spacenav provides a free,
compatible and open source alternative to 3Dconnexion's popular 3D input device
drivers and SDK.


## Supported Platforms

io-spnav was last built and tested with **spacenavd 0.6** and
**libspnav 0.2.3**, which currently support the following devices:

- All USB 3Dconnexion 6DOF devices (Linux)
- All serial Spaceball devices (BSD, Linux, MacOSX)

Support for USB devices under Windows and MacOSX is underway, but incomplete.
The daemon will compile and run, but USB devices may not work or will crash.

The bindings in this package currently support the following platforms:

- ~~BSD~~
- Linux
- Mac OSX

If you wish to use USB based 3Dconnexion devices under MacOSX or Windows, you
may also consider using the [io-3dxware](https://github.com/nimious/io-3dxware)
bindings instead.


## Prerequisites

To compile the bindings in this package you must have **libspnav**, the Spacenav
SDK library, installed on your computer. Users of your program need to install
and run **spacenavd**, the Spacenav Daemon, that implements the actual device
driver.

### BSD

TODO

### Linux

If your Linux distribution includes a package manager or community repository,
it may already have pre-compiled binaries for both the Daemon and the SDK. For
example, on ArchLinux the SDK is available in the official package repository:

`sudo pacman -Sy libspnav`

The daemon is available in AUR:

`yaourt spacenavd`

Make sure to verify the available version numbers as they may be outdated. It is
then preferable to manually build the daemon and SDK from the source code in the
Sourceforge repository.

### MacOSX

Download the source code for both spacenavd and libspnav from the Spacenav
Sourceforge repository and follow the instructions in their README file for
building and installing them.

### Windows

TODO


## Dependencies

This package does not have any dependencies to other Nim packages at this time.


## Usage

Import the *spnav* module from this package to make the bindings available in
your project:

```nimrod
import spnav
```

Linux: If your installation of libspnav includes the X11 related Spacenav APIs,
which is the default for binary distributions, you must also link against the
X11 library by adding the following parameter to the Nim compiler command line:

`--passL:"-lX11"`


## Support

Please [file an issue](https://github.com/nimious/spacenav/issues), submit a
[pull request](https://github.com/nimious/spacenav/pulls?q=is%3Aopen+is%3Apr)
or email us at info@nimio.us if this package is out of date or contains bugs.
For issues related to input devices or the device driver software visit the
3Dconnexion or Spacenav web sites below.


## References

* [Spacenav Project Page](http://spacenav.sourceforge.net/)
* [Spacenav on Sourceforge](http://sourceforge.net/projects/spacenav/)
* [3Dconnexion Homepage](http://www.3dconnexion.com/)
* [Nim Programming Language](http://nim-lang.org/)
