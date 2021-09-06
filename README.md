# Aquameter

Display aquarium temperature over time with nice graphs.

# Requirements

- R-language environment, version 4+ is best. 
- `tidyverse` package
- Raspberry pi computer
- DS18B20 or similar 1-wire temperature sensor.

## A note on `R` and the Raspberry pi
You may want to install this on a different computer than the raspberry pi, 
especially if you're using a pi zero. R packages like `tidyverse` require
compilation steps via `gcc` and `g++` when installed, which can take hours
on an under-powered machine.

# Usage
## GPIO Setup

There are many guides that cover connecting a 1-wire temperature sensor to
the raspberry pi via GPIO pins. A popular one will do a better job explaining
the process than this quick README. So, before going forward, review some
material on general temperature sensor setup.

## Recording temperatures
When you finish setting up your sensor, run the following on your pi:

```
ls -l /sys/bus/w1/devices
```

You should see something like this come back:

```
lrwxrwxrwx 1 root root 0 Sep  5 23:54 28-012456a067aa 
lrwxrwxrwx 1 root root 0 Sep  5 22:17 w1_bus_master1 
```

Take note of the entry prefixed with `28-` and create a shell script 
somewhere in the home directory of the user that will be recording temperatures.
Here's an example that writes the date and time, a tab character, and a 
temperature reading in a file named `temp.log` each time it's run.

```
#!/bin/bash
echo -e "$(date --rfc-3339=seconds --universal)\t$(cat /sys/bus/w1/devices/28-012456a067aa/temperature)" >> "$HOME/temp.log"
```

Place the value you found earlier (prefixed with `28-`) between `/devices/` 
and `/temperature`. Save the file and run `crontab -e` to set up a schedule.

## Scheduled readings

To record a temperature every two minutes, you can use a value like this:

```
*/2 * * * * /home/<username>/get_temp.sh
```
*Make sure to set the right value for `<username>` if you copy and paste.*

## Generating reports

After a while you'll have a log file that looks like this:

```
2021-09-06 00:30:01+00:00       24875
2021-09-06 00:32:01+00:00       24875
2021-09-06 00:34:01+00:00       24875
2021-09-06 00:36:01+00:00       24875
2021-09-06 00:38:01+00:00       24875
```

Simply `scp` this file to the computer that will run the reports (where you have
`R` installed and setup). Then, run the `mkindex` shell script to produce
an `index.html` file. You can set this up to run on a schedule as well, and
serve the static file any way you like.

Note that you can configure where the R-markdown script looks for the temperature 
reading log using an additional parameter, `infile`. 