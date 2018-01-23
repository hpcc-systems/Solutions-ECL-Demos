IMPORT Taxi;
IMPORT Std;

#WORKUNIT('name', 'Taxi Data: Enrich');

validatedData := Taxi.Files.Validated.inFile;
weatherData := Taxi.Files.Weather.inFile;

withTimeEnrichment := PROJECT
    (
        validatedData,
        TRANSFORM
            (
                Taxi.Files.Enriched.YellowLayout,
                SELF.pickup_date := Std.Date.FromStringToDate(LEFT.tpep_pickup_datetime[..10], '%Y-%m-%d'),
                SELF.pickup_time := Std.Date.FromStringToTime(LEFT.tpep_pickup_datetime[12..], '%H:%M:%S'),
                SELF.pickup_minutes_after_midnight := Std.Date.Hour(SELF.pickup_time) * 60 + Std.Date.Minute(SELF.pickup_time),
                SELF.pickup_time_window := SELF.pickup_minutes_after_midnight DIV Taxi.Constants.TIME_WINDOW_MINUTES + 1,
                SELF.pickup_time_hour := Std.Date.Hour(SELF.pickup_time),
                SELF.pickup_day_of_week := Std.Date.DayOfWeek(SELF.pickup_date),
                SELF.dropoff_date := Std.Date.FromStringToDate(LEFT.tpep_dropoff_datetime[..10], '%Y-%m-%d'),
                SELF.dropoff_time := Std.Date.FromStringToTime(LEFT.tpep_dropoff_datetime[12..], '%H:%M:%S'),
                SELF.dropoff_minutes_after_midnight := Std.Date.Hour(SELF.dropoff_time) * 60 + Std.Date.Minute(SELF.dropoff_time),
                SELF.dropoff_time_window := SELF.dropoff_minutes_after_midnight DIV Taxi.Constants.TIME_WINDOW_MINUTES + 1,
                SELF.dropoff_time_hour := Std.Date.Hour(SELF.dropoff_time),
                SELF.dropoff_day_of_week := Std.Date.DayOfWeek(SELF.dropoff_date),
                SELF.trip_duration_minutes := MAP
                    (
                        SELF.dropoff_date = SELF.pickup_date        =>  SELF.dropoff_minutes_after_midnight - SELF.pickup_minutes_after_midnight + 1,
                        SELF.dropoff_date = SELF.pickup_date + 1    =>  SELF.dropoff_minutes_after_midnight + ((24 * 60) - SELF.pickup_minutes_after_midnight) + 1,
                        SELF.dropoff_date > SELF.pickup_date + 1    =>  ((Std.Date.DaysBetween(SELF.pickup_date, SELF.dropoff_date) - 1) * (60 * 24)) + SELF.dropoff_minutes_after_midnight + ((24 * 60) - SELF.pickup_minutes_after_midnight) + 1,
                        0
                    ),
                SELF.trip_distance_bucket := LEFT.trip_distance DIV Taxi.Constants.TRIP_DISTANCE_BUCKET_SIZE + 1,
                SELF := LEFT
            )
    );

withWeatherEnrichment := JOIN
    (
        withTimeEnrichment,
        weatherData,
        LEFT.pickup_date = RIGHT.Date
            AND RIGHT.minutes_after_midnight BETWEEN LEFT.pickup_minutes_after_midnight - 30 AND LEFT.pickup_minutes_after_midnight + 30,
        TRANSFORM
            (
                Taxi.Files.Enriched.WeatherAddedLayout,
                SELF.weather := RIGHT,
                SELF.weather.precipTypeID := Taxi.Util.precipTypeDictionary[SELF.weather.precipType].id,
                SELF := LEFT
            ),
        LOOKUP, LEFT OUTER
    );

OUTPUT(withWeatherEnrichment,,Taxi.Files.Enriched.PATH,COMPRESSED,OVERWRITE);
