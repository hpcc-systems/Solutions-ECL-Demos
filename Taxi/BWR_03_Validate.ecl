IMPORT Taxi;
IMPORT Std;

#WORKUNIT('name', 'Taxi Data: Validate');

etlData := Taxi.Files.ETL.inFile;

validatedData := PROJECT
    (
        etlData,
        TRANSFORM
            (
                Taxi.Files.Validated.YellowLayout,
                SELF.bad_trip_distance := LEFT.trip_distance <= 0,
                SELF.bad_passenger_count := LEFT.passenger_count < 1 OR LEFT.passenger_count > 6,
                SELF.bad_pickup_coordinates := LEFT.pickup_longitude = 0 OR LEFT.pickup_latitude = 0,
                SELF.bad_dropoff_coordinates := LEFT.dropoff_longitude = 0 OR LEFT.dropoff_latitude = 0,
                SELF.bad_fare_amount := LEFT.fare_amount <= 0 OR LEFT.fare_amount >= 1000,
                SELF.bad_tip_amount := LEFT.tip_amount < 0,
                SELF.bad_tolls_amount := LEFT.tolls_amount < 0,
                SELF.bad_improvement_surcharge := LEFT.improvement_surcharge < 0,
                SELF.bad_total_amount := LEFT.total_amount < 0,
                SELF.is_valid_record := NOT (SELF.bad_trip_distance OR SELF.bad_passenger_count OR SELF.bad_pickup_coordinates OR SELF.bad_dropoff_coordinates OR SELF.bad_fare_amount OR SELF.bad_tip_amount OR SELF.bad_tolls_amount OR SELF.BAD_improvement_surcharge OR SELF.bad_total_amount),
                SELF := LEFT
            )
    );

OUTPUT(validatedData,,Taxi.Files.Validated.PATH,COMPRESSED,OVERWRITE);
OUTPUT(validatedData(NOT is_valid_record),,Taxi.Files.Validated.FAILED_PATH,COMPRESSED,OVERWRITE);
