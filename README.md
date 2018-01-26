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


### A Note About Data Profiling

Many training samples include a step for data profiling.  In important part of
working with new data is finding out what is really there.  You may have been
given a schema along with some data, but that often doesn't tell you how
sparsely populated a given field may be, if there are incorrect values in some
fields (e.g. a typeID field that should have only three possible values actually
has four, or two), or even if there is suspected garbage (this crops up a lot
when dealing with data passed as text files).  Knowing the "shape" of the data
you're working with can influence your choice of analytic algorithms, challenge
assumptions regarding usability of the data, and provide hints for data handling
optimizations.

An ECL-based data profiler has been included within these training samples. 
DataPatterns.Profiler() contains a rich set of analysis tools for
examining both data you have not seen before (where fields are generically data
typed as strings) as well as data that has been strongly typed.  Details
regarding the Profiler are not included here; please see the embedded
documentation for further details.

Be sure to import the DataPatterns submodule before running the data profiling
code.  If, after cloning this repo, the DataPatterns directory is empty, you
will need to explicitly update submodules:

	git submodule update --init --recursive

### [Taxi Data](Taxi)

This data is primarily New York City cab fare information from the Yellow Cab
Company.  The timeframe of the data is Jan. 2015 thru Jun. 2016.  It is
approximately 35GB in size, containing a little over 215M rows.

In addition to the taxi fare data, we have collected weather information for the
same time period.  This weather data can be used to augment the fare data to
perhaps draw correlations between taxi use and how nice the weather is (e.g.
more people use taxis during inclement weather).