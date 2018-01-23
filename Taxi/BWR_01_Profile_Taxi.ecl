IMPORT Taxi;
IMPORT DataPatterns;

#WORKUNIT('name', 'Taxi Data: Profile Taxi Data');

rawTaxiData := Taxi.Files.Raw.inFile;
OUTPUT(rawTaxiData, NAMED('rawTaxiDataSample'));

rawTaxiProfileResults := DataPatterns.Profile(rawTaxiData, features := 'fill_rate,cardinality,best_ecl_types,lengths,patterns,modes');
OUTPUT(rawTaxiProfileResults,, Taxi.Files.PATH_PREFIX + '::raw_taxi_data_profile', OVERWRITE);
