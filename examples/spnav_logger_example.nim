## *spacenav* - Nim bindings for `libspnav <http://spacenav.sf.net>`_, the free
## 3Dconnexion device driver and SDK.
##
## This file is part of the `Nim I/O <http://nimio.us>`_ package collection.
## See the file LICENSE included in this distribution for licensing details.
## GitHub pull requests are encouraged. (c) 2015 Headcrash Industries LLC.
##
## ------------
##
## The following program is a basic example of using the `spnav` module to log
## events from one or more connected 3Dconnexion devices to the console.

import spnav, strutils



# connect to daemon
if spnavOpen() == spnavError:
  echo "Error: Failed to open connection to Spacenav daemon."
else:
  echo "Connection to Spacenav daemon opened successfully."
  echo "Press `Ctrl+C` to quit."

  # main loop
  while true:

    # event handling
    var e: SpnavEvent
    case spnavPollEvent(addr(e))
    of SpnavEventTypes.any:
      continue
    of SpnavEventTypes.button:
      echo "Button event  ",
        "| type: ", e.button.buttonType,
        ", pressed: ", e.button.pressed,
        ", buttonId: ", e.button.buttonId
    of SpnavEventTypes.motion:
      echo "Motion event  ",
        "| type: ", e.motion.motionType,
        ", x: ", e.motion.x,
        ", y: ", e.motion.y,
        ", z: ", e.motion.z,
        ", rx: ", e.motion.rx,
        ", ry: ", e.motion.ry,
        ", rz: ", e.motion.rz,
        ", period: ", e.motion.period
    else:
      echo "Unknown event | ", e.eventType

  # disconnect from daemon
  if spnavClose() == spnavError:
    echo "Error: Failed to disconnect from Spacenav daemon."
  else:
    echo "Successfully disconnected from Spacenav daemon."

echo "Exiting."
