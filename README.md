Pacebot
=======

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

A bot to hang out in channels where runners frequent. Create a new heroku app
and push this repository, then configure a slack "Outgoing WebHooks"
integration to point at it. Pacebot can either work with natural text if
confined to a single channel:

    pre> Time for an easy 10 mile!
    pacebot> 10 mi = 16.1 km

    pre> Those 4:00 miles were hard!
    pacebot> 4:00 mile = 2:29 km = 60s lap

    pre> I think I ran 3 mi @ 4:20 pace
    pacebot> 3 mi @ 4:20 pace = 13:00

    pre> Need to run 3 mi in 12:50 to break my record!
    pacebot> 3 mi @ 4:17 pace = 12:50

Or with a trigger word to have it lurk in all channels. I recommend appending
`?help_on_unknown=1` to the URL when doing this to get help text if pacebot
doesn't understand your input:

    pre> pacebot 10 mile
    pacebot> 10 mi = 16.1 km

    pre> pacebot help
    pacebot> examples: 5 mi, 4:00 mi, 3:10 kms, 3 mi @ 4:20, 3 mi in 12:50

Development
-----------

Run tests with `bin/test`. A CLI is provided for quick ad-hoc testing of
parsing and formatting: `pacebot`. Run the server using `bin/dev`, and test it
with `curl`:

     curl -d "text=4:30km" http://localhost:9393

Pacebot also has a web interface that uses [Opal](http://opalrb.org/) to
cross-compile Ruby to Javascript. By default, tests run against both Ruby and
Javascript. To disable the latter (for a substantial speed boost), set
`NO_OPAL=1` in your environment.

Compiled javascript must be checked in. Run `bin/build` to regenerate.

A CLI is also provided for testing:

    > bin/pacebot "5 mi"
    5 mi = 8 km
