Pacebot
=======

A bot to hang in channels where runners frequent.  Create a new heroku app and
push this repository to it, then configure a slack "Outgoing WebHooks"
integration to point at it.

    pre> Those 4:00 miles were hard!
    pacebot> 4:00 mile = 2:29 km = 60s lap

    pre> I think I ran 3 mi @ 4:20 pace
    pacebot> 3 mi @ 4:20 pace = 13:00

    pre> Need to run 3 mi in 12:50 to break my record!
    pacebot> 3 mi @ 4:17 pace = 12:50

Development
-----------

A CLI is provided for testing parsing and formatting: `pacebot`.

Run the server using `rackup`, and test it with `curl`:

     curl -d "text=4:30km" http://localhost:9292
