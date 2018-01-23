IMPORT Taxi;
IMPORT DataPatterns;

#WORKUNIT('name', 'Taxi Data: Profile Weather Data');

rawWeatherData := DATASET(Taxi.Files.Weather.PATH + '.txt', Taxi.Files.Weather.FlatWeatherRec, CSV(SEPARATOR('\t'), QUOTE('')));
OUTPUT(rawWeatherData, NAMED('rawWeatherDataSample'));

rawWeatherProfileResults := DataPatterns.Profile(rawWeatherData, features := 'fill_rate,cardinality,best_ecl_types,lengths,patterns,modes');
OUTPUT(rawWeatherProfileResults,, Taxi.Files.PATH_PREFIX + '::raw_weather_data_profile', OVERWRITE);
