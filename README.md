# logging
technique for looking at older pico-engine.log files

The Logging tab of the UI will show activity for a pico within the last 12 hours.
When you need to look further back in time, you can use these tools.

1. Find the desired log file(s)
2. Find the pico_id
3. Isolate the log entries for the pico
4. Use the `logging.krl` ruleset to peruse the logs

## Find the desired log files()
The pico-engine.log files are written by the pico engine in the folder
identified by PICO_ENGINE_HOME which by default is `packages/pico-engine` when using `npm start`
and `~/.pico-engine/` when using `pico-engine` (an `npm` global installation).

For the remainder of this explanation, we'll assume that we are working 
in the folder in which we cloned the pico-engine (and from which we start the engine using `npm start`).

```
$ ls -lrt packages/pico-engine/pico-engine.log*
-rw-r--r--  1 bconrad  staff   1913922 Jul  3 15:33 packages/pico-engine/pico-engine.log.5
-rw-r--r--  1 bconrad  staff  24771100 Jul 12 16:24 packages/pico-engine/pico-engine.log.4
-rw-r--r--  1 bconrad  staff  10377389 Jul 19 16:42 packages/pico-engine/pico-engine.log.3
-rw-r--r--  1 bconrad  staff   3086067 Jul 26 14:59 packages/pico-engine/pico-engine.log.2
-rw-r--r--  1 bconrad  staff  15935527 Aug  2 16:24 packages/pico-engine/pico-engine.log.1
-rw-r--r--  1 bconrad  staff   9700594 Aug  9 11:57 packages/pico-engine/pico-engine.log.0
-rw-r--r--  1 bconrad  staff  23074914 Aug 16 14:37 packages/pico-engine/pico-engine.log
```

Determine which log files contain the information of interest using the file
last-modified dates.

In the examples below, we'll be using the latest log file (the one without a numeric extension).
Adapt the `cat` portion of the commands to include the log file(s) you actually need.

## Find the pico_id
If it is a pico which you still use, but you need to look at earlier log entries,
you can find the pico_id in the About tab.

If it is a pico which has just been deleted,
use the command line to search for the pico_id.
(The command shown here must be typed as a single line):

```
cat packages/pico-engine/pico-engine.log |
grep -o '"event received: wrangler/intent_to_delete_pico attributes {."id.":."[0-9a-z]*."' 
```

This will show all of the picos which were deleted. For example:

```
"event received: wrangler/intent_to_delete_pico attributes {\"id\":\"cjxnp6d24003ho8ph6dn1fhof\"
"event received: wrangler/intent_to_delete_pico attributes {\"id\":\"cjzbnndgb004rqvph4rdlh95j\"
"event received: wrangler/intent_to_delete_pico attributes {\"id\":\"cjzbowtit0076qvphbu3d4x84\"
"event received: wrangler/intent_to_delete_pico attributes {\"id\":\"cjzdb96id0009lkphctrp5dcc\"
```

If you need to find the pico given its name (for example, `"Bob"`), try a command like (on a single line):

```
cat packages/pico-engine/pico-engine.log |
grep '"event received: wrangler/child_created attributes {."name.":."Bob."' |
grep -o '"pico_id":"[a-z0-9]*"'
```
giving a result looking like this (in time order):

```
"pico_id":"cjzbnndgb004rqvph4rdlh95j"
"pico_id":"cjzbowtit0076qvphbu3d4x84"
```

## Isolate the log entries for the pico
Use a command like the following (assuming we want the latest "Bob" pico created):

```
cat packages/pico-engine/pico-engine.log |
grep '"pico_id":"cjzbowtit0076qvphbu3d4x84"' > packages/pico-engine/public/Bob.log 
```

Be careful. You are writing a new file into a `public` folder which contains many files
necessary for the UI, and you don't want to overwrite any of them!
It doesn't have any files with the extension `.log` so use that to be safe.

## Use the `logging.krl` ruleset to peruse the logs
Install the [`logging` ruleset](https://raw.githubusercontent.com/b1conrad/logging/master/krl/logging.krl)
included in this repository into a pico of your choice.

Go to that pico's Testing tab, and click the checkbox beside `logging`.

Enter a URL like the one below where prompted, and click the `fmtLogs` link.

```
http://localhost:8080/Bob.log
```

The example assumes that you are running the pico engine locally, on port `8080` so
adjust as needed.
You placed the isolated log entries into a file in your engine's `public` folder
so that they could be addressed as a resource in this manner.
