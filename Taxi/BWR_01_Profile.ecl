IMPORT Taxi;
IMPORT DataPatterns;

#WORKUNIT('name', 'Taxi Data: Profile');

rawTaxiData := Taxi.Files.Raw.inFile;
OUTPUT(rawTaxiData, NAMED('rawTaxiDataSample'));

rawTaxiProfileResults := DataPatterns.Profile(rawTaxiData, features := 'fill_rate,cardinality,best_ecl_types,lengths,patterns,modes');
OUTPUT(rawTaxiProfileResults,, Taxi.Files.PATH_PREFIX + '::raw_taxi_data_profile', OVERWRITE);

/*
rawWeatherData := Taxi.Files.Weather.inFile;
OUTPUT(rawWeatherData, NAMED('rawWeatherDataSample'));

rawWeatherProfileResults := DataPatterns.Profile(rawWeatherData, features := 'fill_rate,cardinality,best_ecl_types,lengths,patterns,modes');
OUTPUT(rawWeatherProfileResults,, Taxi.Files.PATH_PREFIX + '::raw_weather_data_profile', OVERWRITE);
*/
