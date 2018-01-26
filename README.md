## ECL Training Samples

ECL stands for "Enterprise Control Language" and it is the language you use when
working with HPCC Systems' big data technology.  More information on the
technology can be found at https://hpccsystems.com.  The platform's Open Source
repo is at https://github.com/hpcc-systems/HPCC-Platform.

### IDE Setup Information

* [VS Code](https://code.visualstudio.com) - Cross-platform
	* HPCC Client Tools is required to provide an interface to an HPCC cluster from
your local system; download and install the appropriate version from the Tools
section of the [HPCC Systems download page](https://hpccsystems.com/download)
	* The VS Code ECL extension needs to be installed; simply search for 'ecl' in
the extension marketplace (author: Gordon Smith) and install the extension
normally
	* By sure your launch profile references the HPCC cluster you will be using, and
that your "targetCluster" is set to "thor"
	* All code included here assumes that the directory opened by VS Code is this
Training-Samples directory (in other words, the root level of this git repo)

* HPCC Systems' ECL IDE - Windows only
	* The ECL IDE can be downloaded from the [HPCC Systems download
page](https://hpccsystems.com/download)
	* All code included here assumes that you have added this Training-Samples
directory to your compiler's ECL Folders list (Preferences -> Compiler)
	* Be sure to set the target of your jobs to "thor"


### [Taxi Data](Taxi)

This data is primarily New York City cab fare information from the Yellow Cab
Company.  The timeframe of the data is Jan. 2015 thru Jun. 2016.  It is
approximately 35GB in size, containing a little over 215M rows.

In addition to the taxi fare data, we have collected weather information for the
same time period.  This weather data can be used to augment the fare data to
perhaps draw correlations between taxi use and how nice the weather is (e.g.
more people use taxis during inclement weather).