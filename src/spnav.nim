## *spacenav* - Nim bindings for `libspnav <http://spacenav.sf.net>`_, the free
## 3Dconnexion device driver and SDK.
##
## This file is part of the `Nim I/O <http://nimio.us>`_ package collection.
## See the file LICENSE included in this distribution for licensing details.
## GitHub pull requests are encouraged. (c) 2015 Headcrash Industries LLC.
##
## ------------
##
## The *spnav* module declares all types and functions exported by the
## *libspnav* library. The integration of 3Dconnexion devices using this module
## typically involves the following three steps:
##
## - On application startup, **open a connection** to the Spacenav driver
##   daemon using `spnavOpen <#spnavOpen>`_
## - In the application's event loop, **poll the driver** for available input
##   events using `spnavPollEvent <#spnavPollEvent>`_
## - **Process** any received `SpnavEvent <#SpnavEvent>`_ events in your
##   application
## - **Close the connection** to the Spacenav driver daemon using
##   `spnavClose <#spnavClose>`_ on application shutdown.
##
## Check the *examples* directory of this distribution for demonstrations of
## this approach.
##
## ------------
##
## Note: The X11 related Spacenav APIs have been ommitted from this module as
## they were provided only for backward compatibility with existing 3dxWare
## based software and are not needed for new applications.

{.deadCodeElim: on.}


when defined(linux) and not defined(android):
  const
    dllname = "libspnav.so"
elif defined(macosx):
  const
    dllname = "libspnav.dylib"
else:
  {.error: "spacenav does not support this platform".}


const
  spnavError* = -1 ## Error return code for selected procs.
  spnavSuccess* = 0 ## Success return code for selected procs.


type
  SpnavEventTypes* {.pure, size: sizeof(cint).} = enum ## Spacenav event types.
    any = 0, ## Matches any event
    motion = 1, ## Motion events
    button = 2 ## Button events (includes both press and release)


type
  SpnavMotionEvent* {.packed.} = object
    ## Structure for motion events.
    motionType*: cint
    x*, y*, z*: cint
    rx*, ry*, rz*: cint
    period*: cuint
    data*: ptr cint

  SpnavButtonEvent* {.packed.} = object
    ## Structure for button events.
    buttonType*: cint
    pressed*: cint
    buttonId*: cint

  SpnavEvent* {.packed, union.} = object
    ## Union type for events.
    eventType*: cint
    motion*: SpnavMotionEvent
    button*: SpnavButtonEvent


proc spnavOpen*(): cint {.cdecl, dynlib: dllname, importc: "spnav_open".}
  ## Open a connection to the Spacenav daemon.
  ##
  ## result
  ##   - `spnavSuccess <#spnavSuccess>`_ on success
  ##   - `spnavError <#spnavError>`_ on failure
  ##
  ## See also `spnavClose <#spnavClose>`_


proc spnavClose*(): cint {.cdecl, dynlib: dllname, importc: "spnav_close".}
  ## Close a previously opened connection to the Spacenav daemon.
  ##
  ## result
  ##   - `spnavSuccess <#spnavSuccess>`_ on success
  ##   - `spnavError <#spnavError>`_ on failure
  ##
  ## See also `spnavOpen <#spnavOpen>`_


proc spnavFd*(): cint {.cdecl, dynlib: dllname, importc: "spnav_fd".}
  ## Retrieve the file descriptor used for communication with the daemon.
  ##
  ## result
  ##   - The file descriptor on success
  ##   - `spnavError <#spnavError>`_ on error or if no connection is open


proc spnavSensitivity*(sens: float64): cint
  {.cdecl, dynlib: dllname, importc: "spnav_sensitivity".}
  ## Set the sensitivity of the device(s).
  ##
  ## sens
  ##   The sensitivity to set
  ## result
  ##   - `spnavSuccess <#spnavSuccess>`_ on success
  ##   - `spnavError <#spnavError>`_ on failure


proc spnavWaitEvent*(event: ptr SpnavEvent): SpnavEventTypes
  {.cdecl, dynlib: dllname, importc: "spnav_wait_event".}
  ## Wait for Spacenav events.
  ##
  ## event
  ##   A pointer to a `SpnavEvent <#SpnavEvent>`_ object that will hold the
  ##   event data if the call succeeded
  ## result
  ##   - The event type on success
  ##   - ``0`` if an error occured
  ##
  ## This function blocks until an event is available. For non-blocking checks
  ## use `spnavPollEvent <#spnavPollEvent>`_ instead.


proc spnavPollEvent*(event: ptr SpnavEvent): SpnavEventTypes
  {.cdecl, dynlib: dllname, importc: "spnav_poll_event".}
  ## Check for availability of Spacenav events.
  ##
  ## event
  ##   A pointer to a `SpnavEvent <#SpnavEvent>`_ object that will hold the
  ##   event data if the call succeeded
  ## result
  ##   - The event type on success
  ##   - `SpnavEventTypes.any <#SpnavEventTypes>`_ if no event was available
  ##
  ## Unlike `spnavWaitEvent <#spnavWaitEvent>`_, this function returns
  ## immediately.


proc spnavRemoveEvents*(eventType: SpnavEventTypes): cint
  {.cdecl, dynlib: dllname, importc: "spnav_remove_events".}
  ## Remove any pending events of the specified type.
  ##
  ## eventType
  ##   The type of events to remove, or
  ##   `SpnavEventTypes.any <#SpnavEventTypes>`_ to remove all events
  ## result
  ##   The number of removed events
