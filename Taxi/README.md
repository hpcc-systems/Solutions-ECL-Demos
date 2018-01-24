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
script.  This will use `wget` to download the contents of the S3 buckets defined
in [`Taxi/Data/raw_data_urls.txt`](Taxi/Data/raw_data_urls.txt).  (It should be
noted that the list of S3 buckets is derived from Todd Schneider's list, and
that list defines the subset of data for this training.)

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
	1. Modify the Target Scope value to read `taxi_data::raw` to set a filename
prefix
	1. Note that you can select all of the taxi data files and perform the one
spray; you don't have to do spray each file individually
1. Import the weather data by selecting the `weather_new_york_city.txt` file and
selecting Delimited Spray
	1. This file is tab-delimited, so change Delimiters to read `\t`
	1. Modify the target scope value to read `taxi_data`

The Target Scope settings in the two spray operations place the raw data files
in a location that matches what the ECL code expects.  If you want to use a
different prefix, you can change the PREFIX attribute in
[Taxi/Files.ecl](Taxi/Files.ecl).
