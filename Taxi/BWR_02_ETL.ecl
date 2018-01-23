IMPORT Taxi;

#WORKUNIT('name', 'Taxi Data: ETL');

rawTaxiData := DATASET(Taxi.Files.Raw.PATH, Taxi.Files.ETL.CoercedYellowLayout, CSV(HEADING(1)));

etlTaxiData := PROJECT
    (
        rawTaxiData,
        TRANSFORM
            (
                Taxi.Files.ETL.YellowLayout,
                SELF.record_id := COUNTER,
                SELF := LEFT
            )
    );

OUTPUT(etlTaxiData,, Taxi.Files.ETL.PATH, COMPRESSED, OVERWRITE);

weatherData := DATASET(Taxi.Files.Weather.PATH + '.txt', Taxi.Files.Weather.FlatWeatherRec, CSV(SEPARATOR('\t'), QUOTE('')));

OUTPUT(weatherData,,Taxi.Files.Weather.PATH,OVERWRITE);
