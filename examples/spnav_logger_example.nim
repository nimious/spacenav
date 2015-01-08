#
#  io-spacenav - Nim wrapper for libspnav, the free 3Dconnexion device driver
#                   (c) Copyright 2015 Gerke Max Preussner
#                   https://github.com/nimious/io-spacenav
#
# Spacenav and the libspnav library provide a free, compatible alternative to
# the proprietary 3Dconnexion device driver and SDK, for their 3D input devices,
# such as SpaceNavigator, SpacePilot and SpaceTraveller (http://spacenav.sf.net)
#
# This file is part of the Nimious collection of modules for the Nim programming
# language (http://nimio.us). See the file LICENSE included in this distribution
# for licensing details. Pull requests for fixes or improvements are encouraged.
#

import spnav, strutils


# The following program is a basic example of using the `spnav` module to log
# Spacenav events from one or more connected 3Dconnexion devices to the console.

# connect to daemon
if spnavOpen() == SpnavError:
  echo "Error: Failed to open connection to Spacenav daemon."
else:
  echo "Connection to Spacenav daemon opened successfully."
  echo "Press `s` to set sensitivity, `q` to quit."

  # main loop
  while true:

    # input handling
    case stdin.readChar
    of 'q':
      break
    of 's':
      echo "Enter a value for sensitivity and hit Return:"
      var sensitivity = parseFloat(stdin.readLine)
      if spnavSensitivity(sensitivity) == SpnavError:
        echo "Error: Failed to set sensitivity."
      else:
        echo "Sensitivity set successfully."
      echo "Press any key to continue:"
      if stdin.readChar == '\0': echo "discard workaround" #discard
    else:
      echo "Unknown command"

    # event handling
    var e: SpnavEvent
    case spnavPollEvent(addr(e))
    of SPNAV_EVENT_BUTTON:
      echo "Button event  ",
        "| type: ", e.button.buttonType,
        ", press: ", e.button.press,
        ", bnum: ", e.button.bnum
    of SPNAV_EVENT_MOTION:
      echo "Motion event  ",
        "| type: ", e.motion.motionType,
        ", x: ", e.motion.x,
        ", y: ", e.motion.y,
        ", rx: ", e.motion.rx,
        ", ry: ", e.motion.ry,
        ", rz: ", e.motion.rz,
        ", period: ", e.motion.period
    else:
      echo "Unknown event | ", e.eventType

  # disconnect from daemon
  if spnavClose() == SpnavError:
    echo "Error: Failed to disconnect from Spacenav daemon."
  else:
    echo "Successfully disconnected from Spacenav daemon."

echo "Exiting."
