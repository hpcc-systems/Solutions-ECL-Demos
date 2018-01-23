IMPORT Taxi;

#WORKUNIT('name', 'Taxi Data: Analyze Pickups');

theData := Taxi.Files.Enriched.inFile(is_valid_record);

// Base aggregation
baseAggregation := TABLE
    (
        theData,
        {
            pickup_day_of_week,
            pickup_time_hour,
            UNSIGNED4   cnt := COUNT(GROUP),
            DECIMAL10_2 total_trip_distance := SUM(GROUP, trip_distance)
        },
        pickup_day_of_week, pickup_time_hour
    );

//==============================================================================

// Pickups per hour by day of week
perHourPerDayCount := TABLE
    (
        baseAggregation,
        {
            pickup_time_hour,
            UNSIGNED4   cnt_total := SUM(GROUP, cnt),
            UNSIGNED4   cnt_sunday := SUM(GROUP, IF(pickup_day_of_week = 1, cnt, 0)),
            UNSIGNED4   cnt_monday := SUM(GROUP, IF(pickup_day_of_week = 2, cnt, 0)),
            UNSIGNED4   cnt_tuesday := SUM(GROUP, IF(pickup_day_of_week = 3, cnt, 0)),
            UNSIGNED4   cnt_wednesday := SUM(GROUP, IF(pickup_day_of_week = 4, cnt, 0)),
            UNSIGNED4   cnt_thursday := SUM(GROUP, IF(pickup_day_of_week = 5, cnt, 0)),
            UNSIGNED4   cnt_friday := SUM(GROUP, IF(pickup_day_of_week = 6, cnt, 0)),
            UNSIGNED4   cnt_saturday := SUM(GROUP, IF(pickup_day_of_week = 7, cnt, 0)),
        },
        pickup_time_hour
    );

OUTPUT(SORT(perHourPerDayCount, pickup_time_hour), NAMED('perHourPerDayCount'), ALL);

//------------------------------------------------------------------------------

// Average trip distance per hour by day of week
perHourPerDayAveDistance := TABLE
    (
        baseAggregation,
        {
            pickup_time_hour,
            DECIMAL10_2 dist_total := SUM(GROUP, total_trip_distance) / SUM(GROUP, cnt),
            DECIMAL10_2 dist_sunday := SUM(GROUP, IF(pickup_day_of_week = 1, total_trip_distance / cnt, 0)),
            DECIMAL10_2 dist_monday := SUM(GROUP, IF(pickup_day_of_week = 2, total_trip_distance / cnt, 0)),
            DECIMAL10_2 dist_tuesday := SUM(GROUP, IF(pickup_day_of_week = 3, total_trip_distance / cnt, 0)),
            DECIMAL10_2 dist_wednesday := SUM(GROUP, IF(pickup_day_of_week = 4, total_trip_distance / cnt, 0)),
            DECIMAL10_2 dist_thursday := SUM(GROUP, IF(pickup_day_of_week = 5, total_trip_distance / cnt, 0)),
            DECIMAL10_2 dist_friday := SUM(GROUP, IF(pickup_day_of_week = 6, total_trip_distance / cnt, 0)),
            DECIMAL10_2 cnt_saturday := SUM(GROUP, IF(pickup_day_of_week = 7, total_trip_distance / cnt, 0)),
        },
        pickup_time_hour
    );
OUTPUT(SORT(perHourPerDayAveDistance, pickup_time_hour), NAMED('perHourPerDayAveDistance'), ALL);

//==============================================================================

// Pickups per day by hour
perDayPerHourCount := TABLE
    (
        baseAggregation,
        {
            pickup_day_of_week,
            STRING      pickup_day := Taxi.Util.DescribeDayOfWeek(pickup_day_of_week),
            UNSIGNED4   cnt_total := SUM(GROUP, cnt),
            UNSIGNED4   cnt_00 := SUM(GROUP, IF(pickup_time_hour = 0, cnt, 0)),
            UNSIGNED4   cnt_01 := SUM(GROUP, IF(pickup_time_hour = 1, cnt, 0)),
            UNSIGNED4   cnt_02 := SUM(GROUP, IF(pickup_time_hour = 2, cnt, 0)),
            UNSIGNED4   cnt_03 := SUM(GROUP, IF(pickup_time_hour = 3, cnt, 0)),
            UNSIGNED4   cnt_04 := SUM(GROUP, IF(pickup_time_hour = 4, cnt, 0)),
            UNSIGNED4   cnt_05 := SUM(GROUP, IF(pickup_time_hour = 5, cnt, 0)),
            UNSIGNED4   cnt_06 := SUM(GROUP, IF(pickup_time_hour = 6, cnt, 0)),
            UNSIGNED4   cnt_07 := SUM(GROUP, IF(pickup_time_hour = 7, cnt, 0)),
            UNSIGNED4   cnt_08 := SUM(GROUP, IF(pickup_time_hour = 8, cnt, 0)),
            UNSIGNED4   cnt_09 := SUM(GROUP, IF(pickup_time_hour = 9, cnt, 0)),
            UNSIGNED4   cnt_10 := SUM(GROUP, IF(pickup_time_hour = 10, cnt, 0)),
            UNSIGNED4   cnt_11 := SUM(GROUP, IF(pickup_time_hour = 11, cnt, 0)),
            UNSIGNED4   cnt_12 := SUM(GROUP, IF(pickup_time_hour = 12, cnt, 0)),
            UNSIGNED4   cnt_13 := SUM(GROUP, IF(pickup_time_hour = 13, cnt, 0)),
            UNSIGNED4   cnt_14 := SUM(GROUP, IF(pickup_time_hour = 14, cnt, 0)),
            UNSIGNED4   cnt_15 := SUM(GROUP, IF(pickup_time_hour = 15, cnt, 0)),
            UNSIGNED4   cnt_16 := SUM(GROUP, IF(pickup_time_hour = 16, cnt, 0)),
            UNSIGNED4   cnt_17 := SUM(GROUP, IF(pickup_time_hour = 17, cnt, 0)),
            UNSIGNED4   cnt_18 := SUM(GROUP, IF(pickup_time_hour = 18, cnt, 0)),
            UNSIGNED4   cnt_19 := SUM(GROUP, IF(pickup_time_hour = 19, cnt, 0)),
            UNSIGNED4   cnt_20 := SUM(GROUP, IF(pickup_time_hour = 20, cnt, 0)),
            UNSIGNED4   cnt_21 := SUM(GROUP, IF(pickup_time_hour = 21, cnt, 0)),
            UNSIGNED4   cnt_22 := SUM(GROUP, IF(pickup_time_hour = 22, cnt, 0)),
            UNSIGNED4   cnt_23 := SUM(GROUP, IF(pickup_time_hour = 23, cnt, 0))
        },
        pickup_day_of_week
    );

OUTPUT(SORT(perDayPerHourCount, pickup_day_of_week), NAMED('perDayPerHourCount'), ALL);

//------------------------------------------------------------------------------

// Pickups per hour by day
perDayPerHourAveDistance := TABLE
    (
        baseAggregation,
        {
            pickup_day_of_week,
            STRING      pickup_day := Taxi.Util.DescribeDayOfWeek(pickup_day_of_week),
            DECIMAL10_2 dist_total := SUM(GROUP, total_trip_distance) / SUM(GROUP, cnt),
            DECIMAL10_2 dist_00 := SUM(GROUP, IF(pickup_time_hour = 0, total_trip_distance / cnt, 0)),
            DECIMAL10_2 dist_01 := SUM(GROUP, IF(pickup_time_hour = 1, total_trip_distance / cnt, 0)),
            DECIMAL10_2 dist_02 := SUM(GROUP, IF(pickup_time_hour = 2, total_trip_distance / cnt, 0)),
            DECIMAL10_2 dist_03 := SUM(GROUP, IF(pickup_time_hour = 3, total_trip_distance / cnt, 0)),
            DECIMAL10_2 dist_04 := SUM(GROUP, IF(pickup_time_hour = 4, total_trip_distance / cnt, 0)),
            DECIMAL10_2 dist_05 := SUM(GROUP, IF(pickup_time_hour = 5, total_trip_distance / cnt, 0)),
            DECIMAL10_2 dist_06 := SUM(GROUP, IF(pickup_time_hour = 6, total_trip_distance / cnt, 0)),
            DECIMAL10_2 dist_07 := SUM(GROUP, IF(pickup_time_hour = 7, total_trip_distance / cnt, 0)),
            DECIMAL10_2 dist_08 := SUM(GROUP, IF(pickup_time_hour = 8, total_trip_distance / cnt, 0)),
            DECIMAL10_2 dist_09 := SUM(GROUP, IF(pickup_time_hour = 9, total_trip_distance / cnt, 0)),
            DECIMAL10_2 dist_10 := SUM(GROUP, IF(pickup_time_hour = 10, total_trip_distance / cnt, 0)),
            DECIMAL10_2 dist_11 := SUM(GROUP, IF(pickup_time_hour = 11, total_trip_distance / cnt, 0)),
            DECIMAL10_2 dist_12 := SUM(GROUP, IF(pickup_time_hour = 12, total_trip_distance / cnt, 0)),
            DECIMAL10_2 dist_13 := SUM(GROUP, IF(pickup_time_hour = 13, total_trip_distance / cnt, 0)),
            DECIMAL10_2 dist_14 := SUM(GROUP, IF(pickup_time_hour = 14, total_trip_distance / cnt, 0)),
            DECIMAL10_2 dist_15 := SUM(GROUP, IF(pickup_time_hour = 15, total_trip_distance / cnt, 0)),
            DECIMAL10_2 dist_16 := SUM(GROUP, IF(pickup_time_hour = 16, total_trip_distance / cnt, 0)),
            DECIMAL10_2 dist_17 := SUM(GROUP, IF(pickup_time_hour = 17, total_trip_distance / cnt, 0)),
            DECIMAL10_2 dist_18 := SUM(GROUP, IF(pickup_time_hour = 18, total_trip_distance / cnt, 0)),
            DECIMAL10_2 dist_19 := SUM(GROUP, IF(pickup_time_hour = 19, total_trip_distance / cnt, 0)),
            DECIMAL10_2 dist_20 := SUM(GROUP, IF(pickup_time_hour = 20, total_trip_distance / cnt, 0)),
            DECIMAL10_2 dist_21 := SUM(GROUP, IF(pickup_time_hour = 21, total_trip_distance / cnt, 0)),
            DECIMAL10_2 dist_22 := SUM(GROUP, IF(pickup_time_hour = 22, total_trip_distance / cnt, 0)),
            DECIMAL10_2 dist_23 := SUM(GROUP, IF(pickup_time_hour = 23, total_trip_distance / cnt, 0))
        },
        pickup_day_of_week
    );

OUTPUT(SORT(perDayPerHourAveDistance, pickup_day_of_week), NAMED('perDayPerHourAveDistance'), ALL);
