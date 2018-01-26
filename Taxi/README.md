## Taxi Data

Most of the data used for this training is sourced from Todd Schneider's excellent
project at https://github.com/toddwschneider/nyc-taxi-data.  Since we are
targeting programmers who are new to HPCC Systems and ECL, we use only a subset
of the data Todd has gathered.  The choice to use a subset of the data was
driven by two considerations:

1. Class time is necessarily limited, so working with a smaller, homogenous
dataset avoided the complexity of merging disparate file formats

2. Some students may be using small HPCC instances, such as those running with
virtual machines on laptop computers.  The small VMs cannot handle large
datasets well, or at least not within the timeframes required for a class.

In addition to the taxi data, weather data for the same time period and location
is included.  This data was collected from [Dark Sky](https://darksky.net/dev).

### Obtaining the data

Instructions:

* Execute the [`Taxi/Data/download_raw_data.sh`](Taxi/Data/download_raw_data.sh)
script.  That script will create a new subdirectory named `data` and will use
`wget` to download the contents of the S3 buckets defined in
[`Taxi/Data/raw_data_urls.txt`](Taxi/Data/raw_data_urls.txt) into that
subdirectory.  (It should be noted that the list of S3 buckets is derived from
Todd Schneider's list, and that list defines the subset of data for this
training.)

	* You can execute the script on your local system and then copy the resulting
files (~35GB) to your HPCC cluster's landing zone.
	* Alternatively, if you have shell access to your HPCC cluster's landing zone,
you can copy just the two small files and execute the script there, saving the
copy.

* The weather data is already included here, in
[`Taxi/Data/weather_new_york_city.txt`](Taxi/Data/weather_new_york_city.txt).


### Importing the data into your HPCC cluster

Instructions:

1. Import the taxi data by choosing the files and selecting Delimited Spray
	1. The default values are set for a .csv formatted file, which is correct for
this data so no delimiters need to be changed
	1. Check the **Record Structure Present** checkbox, as each file contains the
field definitions as the first line
	1. Modify the **Target Scope** value to read `taxi_data::raw` to set a filename
prefix; this value matches what is expected in the included ECL code
	1. It would be a good idea to checked the **Compress** option, as these files are
sizable
	1. Note that you can select all of the taxi data files and perform the one
spray; you don't have to spray each file individually
1. Import the weather data by selecting the `weather_new_york_city.txt` file and
selecting Delimited Spray
	1. This file is tab-delimited, so change **Delimiters** to read `\t`
	1. Modify the **Target Scope** value to read `taxi_data`; this value matches what
is expected in the included ECL code


### What is in the data, really?

The first step in working with unknown data is to figure out what is there.

[`BWR_01_Profile_Taxi.ecl`](BWR_01_Profile_Taxi.ecl) runs the profiler against
the entire taxi fare dataset and saves the result as a logical file so it can be
easily referred to at a later time.  The goal is to get an idea of what kind of
information is really stored within the data.  The immediate benefit is so that
we can design an efficient ECL **RECORD** structure that better represents each
fields' data type.  Additionally, the information in the profile gives us an
indication of what kind of data is included in each field.

Only a portion of the profiler's routines are executed, as some of the routines
are designed more for strongly typed data (e.g. correlations amongst numeric
fields).  The profiler outputs requested are, for each field:

*	fill_rate:  How many records have a value
*	cardinality:  How many unique values there
*	best_ecl_types:  A hint to the 'real' data type
*	lengths:  The min, max and average value length, if the values were
expressed as strings
*	patterns:  Show common and rare "patterns" of string data; patterns
generalize upper- and lower-case lettering, numerics, and punctuation.
*	modes:  The most common value

This type of profile runs against the entire dataset in order to find any edge
cases in the data (if we were interested in only the general shape and were okay
with estimations, we could have asked the profiler to process only a sample of
the data instead).  The taxi fare data is sizable, so be aware that this may
take some time.

[`BWR_01_Profile_Weather.ecl`](BWR_01_Profile_Weather.ecl) is the same profile,
but run against the small weather dataset instead.  It will execute very quickly
due to the data's small size.
