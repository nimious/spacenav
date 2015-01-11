#
#  io-spacenav - Nim wrapper for libspnav, the free 3Dconnexion device driver
#                (c) Copyright 2015 Headcrash Industries LLC
#                   https://github.com/nimious/io-spacenav
#
# Spacenav and the libspnav library provide a free, compatible alternative to
# the proprietary 3Dconnexion device driver and SDK, for their 3D input devices,
# such as SpaceNavigator, SpacePilot and SpaceTraveller (http://spacenav.sf.net)
#
# This file is part of the `Nim I/O` package collection for the Nim programming
# language (http://nimio.us). See the file LICENSE included in this distribution
# for licensing details. Pull requests for fixes or improvements are encouraged.
#

{.deadCodeElim: on.}


when defined(linux) and not defined(android):
  const
    dllname = "libspnav.so"
elif defined(macosx):
  const
    dllname = "libspnav.dylib"
else:
  {.error: "Platform does not support libspnav".}


const
  SPNAV_ERROR* = -1         ## Error return value for selected procs
  SPNAV_EVENT_ANY* = 0      ## Matches any event (used by *spnavRemoveEvents*).
  SPNAV_EVENT_MOTION* = 1   ## Motion event type
  SPNAV_EVENT_BUTTON* = 2   ## Button event type (includes press and release).


type
  SpnavMotionEvent* {.packed.} = object
    ## Structure for motion events (spnav_event_motion)
    motionType*: cint
    x*, y*, z*: cint
    rx*, ry*, rz*: cint
    period*: cuint
    data*: ptr cint

  SpnavButtonEvent* {.packed.} = object
    ## Structure for button events (spnav_event_button)
    buttonType*: cint
    pressed*: cint
    buttonId*: cint

  SpnavEvent* {.packed, union.} = object
    ## Union type for events (spnav_event)
    eventType*: cint
    motion*: SpnavMotionEvent
    button*: SpnavButtonEvent


proc spnavOpen*(): cint {.cdecl, dynlib: dllname, importc: "spnav_open".}
  ## Opens a connection to the Spacenav daemon.
  ##
  ## Returns `SPNAV_ERROR` on failure.

proc spnavClose*(): cint {.cdecl, dynlib: dllname, importc: "spnav_close".}
  ## Closes a previously opened connection to the Spacenav daemon.
  ##
  ## Returns `SPNAV_ERROR` on failure.

proc spnavFd*(): cint {.cdecl, dynlib: dllname, importc: "spnav_fd".}
  ## Retrieves the file descriptor used for communication with the daemon.
  ##
  ## Returns the file descriptor on success, or `SPNAV_ERROR` on error or if no
  ## connection is open.

proc spnavSensitivity*(sens: float64): cint {.cdecl, dynlib: dllname, importc: "spnav_sensitivity".}
  # TODO: document

proc spnavWaitEvent*(event: ptr SpnavEvent): cint {.cdecl, dynlib: dllname, importc: "spnav_wait_event".}
  ## Blocks waiting for a Spacenav events.
  ##
  ## - ``event`` Pointer to a *SpnavEvent* object that will hold the event data
  ##
  ## Returns the event type, or 0 if an error occured.

proc spnavPollEvent*(event: ptr SpnavEvent): cint {.cdecl, dynlib: dllname, importc: "spnav_poll_event".}
  ## Checks for availability of Spacenav events without blocking.
  ##
  ## - ``event`` Pointer to a *SpnavEvent* object that will hold the event data
  ##
  ## Returns the event type, or 0 if no event was available.

proc spnavRemoveEvents*(eventType: cint): cint {.cdecl, dynlib: dllname, importc: "spnav_remove_events".}
  ## Removes any pending events of the specified type. Pass *SPNAV_EVENT_ANY* to
  ## remove all events.
  ##
  ## - ``eventType`` The type of events to remove.
  ##
  ## Returns the number of removed events.
