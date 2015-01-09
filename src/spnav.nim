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

{.deadCodeElim: on.}


when defined(linux) and not defined(android):
  const
    dllname = "libspnav.so"
else:
  {.error: "Platform does not support libspnav".}


const
  SPNAV_ERROR* = -1         ## Error return value for selected procs
  SPNAV_EVENT_ANY* = 0      ## Matches any event (used by spnavRemoveEvents).
  SPNAV_EVENT_MOTION* = 1   ## Motion event type
  SPNAV_EVENT_BUTTON* = 2   ## Button event type (includes press and release).


type
  SpnavMotionEvent* {.packed.} = object
    ## Structure for motion events (spnav_event_motion)
    motionType*: int16
    x*, y*, z*: int16
    rx*, ry*, rz*: int16
    period*: uint16
    data*: ptr int16

  SpnavButtonEvent* {.packed.} = object
    ## Structure for button events (spnav_event_button)
    buttonType*: int16
    press*: int16
    bnum*: int16

  SpnavEvent* {.packed, union.} = object
    ## Union type for events (spnav_event)
    eventType*: int16
    motion*: SpnavMotionEvent
    button*: SpnavButtonEvent


proc spnavOpen*(): int {.dynlib: dllname, importc: "spnav_open".}
  ## Opens a connection to the Spacenav daemon.
  ## Returns `SPNAV_ERROR` on failure.

proc spnavClose*(): int {.dynlib: dllname, importc: "spnav_close".}
  ## Closes a previously opened connection to the Spacenav daemon.
  ## Returns `SPNAV_ERROR` on failure.

proc spnavFd*(): int {.dynlib: dllname, importc: "spnav_fd".}
  ## Retrieves the file descriptor used for communication with the daemon.
  ## Returns the file descriptor, or `SPNAV_ERROR` on error or if no
  ## connection is open.

proc spnavSensitivity*(sens: float64): int {.dynlib: dllname, importc: "spnav_sensitivity".}

proc spnavWaitEvent*(event: ptr SpnavEvent): int {.dynlib: dllname, importc: "spnav_wait_event".}
  ## Blocks waiting for a Spacenav events. Returns 0 if an error occurs.

proc spnavPollEvent*(event: ptr SpnavEvent): int {.dynlib: dllname, importc: "spnav_poll_event".}
  ## Checks for availability of Spacenav events without blocking.
  ## Returns the event type, if available, or 0 otherwise.

proc spnavRemoveEvents*(eventType: int): int {.dynlib: dllname, importc: "spnav_remove_events".}
  ## Removes any pending events of type `eventType`, or all pending events if
  ## the type is `SPNAV_EVENT_ANY`. Returns the number of removed events.
