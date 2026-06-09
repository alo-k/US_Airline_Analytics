--- Phase 2 ---
ALTER TABLE flights
ADD FLIGHT_DATE DATE;

UPDATE flights
SET FLIGHT_DATE = DATEFROMPARTS(YEAR, MONTH, DAY);

SELECT TOP 10
YEAR,
MONTH,
DAY,
FLIGHT_DATE
FROM flights;

ALTER TABLE flights
ADD SCHEDULED_DEPARTURE_TIME TIME;

UPDATE flights
SET SCHEDULED_DEPARTURE_TIME =
TIMEFROMPARTS(
    SCHEDULED_DEPARTURE / 100,
    SCHEDULED_DEPARTURE % 100,
    0,0,0
)
WHERE SCHEDULED_DEPARTURE IS NOT NULL;

SELECT TOP 10
SCHEDULED_DEPARTURE,
SCHEDULED_DEPARTURE_TIME
FROM flights

ALTER TABLE flights
ADD DEPARTURE_TIME_CLEAN TIME(0);

-- Convert DEPARTURE_TIME from HHMM numeric format into proper TIME format.
-- The original column stores time as numbers (e.g., 2354, 530, 2).
-- Some values have fewer than 4 digits, so we first pad them with leading zeros.
-- Example: 2 → 0002, 530 → 0530.
-- Then we insert ':' to convert it into HH:MM format (e.g., 0530 → 05:30).
-- Finally, TRY_CONVERT is used to safely convert the formatted string into TIME datatype.
-- Invalid values (if any) will return NULL instead of causing an error.

UPDATE flights
SET DEPARTURE_TIME_CLEAN =
TRY_CONVERT(
    TIME(0),
    STUFF(RIGHT('0000' + CAST(DEPARTURE_TIME AS VARCHAR(4)),4),3,0,':')
)
WHERE DEPARTURE_TIME IS NOT NULL;

SELECT TOP 20
DEPARTURE_TIME,
DEPARTURE_TIME_CLEAN
FROM flights;

ALTER TABLE flights
ADD WHEELS_OFF_CLEAN TIME(0);

-- Convert numeric HHMM wheels-off time into SQL TIME format
-- Pads values with leading zeros and safely converts using TRY_CONVERT
UPDATE flights
SET WHEELS_OFF_CLEAN =
TRY_CONVERT(
    TIME(0),
    STUFF(RIGHT('0000' + CAST(WHEELS_OFF AS VARCHAR(4)),4),3,0,':')
)
WHERE WHEELS_OFF IS NOT NULL;

SELECT TOP 20
WHEELS_OFF,
WHEELS_OFF_CLEAN
FROM flights;

ALTER TABLE flights
ADD WHEELS_ON_CLEAN TIME(0);

-- Convert numeric HHMM wheels-on time into SQL TIME format
UPDATE flights
SET WHEELS_ON_CLEAN =
TRY_CONVERT(
    TIME(0),
    STUFF(RIGHT('0000' + CAST(WHEELS_ON AS VARCHAR(4)),4),3,0,':')
)
WHERE WHEELS_ON IS NOT NULL;

SELECT TOP 20
WHEELS_ON,
WHEELS_ON_CLEAN
FROM flights;

--- SCHEDULED_ARRIVAL ---
ALTER TABLE flights
ADD SCHEDULED_ARRIVAL_CLEAN TIME(0);

-- Convert numeric HHMM scheduled arrival time into SQL TIME format
-- Pads values with leading zeros and safely converts using TRY_CONVERT

UPDATE flights
SET SCHEDULED_ARRIVAL_CLEAN =
TRY_CONVERT(
    TIME(0),
    STUFF(RIGHT('0000' + CAST(SCHEDULED_ARRIVAL AS VARCHAR(4)),4),3,0,':')
)
WHERE SCHEDULED_ARRIVAL IS NOT NULL;

SELECT TOP 20
SCHEDULED_ARRIVAL,
SCHEDULED_ARRIVAL_CLEAN
FROM flights;

--- ARRIVAL_TIME ---
ALTER TABLE flights
ADD ARRIVAL_TIME_CLEAN TIME(0);

-- Convert numeric HHMM actual arrival time into SQL TIME format
-- Handles values with fewer than 4 digits and avoids errors using TRY_CONVERT
UPDATE flights
SET ARRIVAL_TIME_CLEAN =
TRY_CONVERT(
    TIME(0),
    STUFF(RIGHT('0000' + CAST(ARRIVAL_TIME AS VARCHAR(4)),4),3,0,':')
)
WHERE ARRIVAL_TIME IS NOT NULL;

SELECT TOP 20
ARRIVAL_TIME,
ARRIVAL_TIME_CLEAN
FROM flights;

-- Replace NULL values in delay-reason columns with 0
-- NULL indicates that the particular delay type did not occur
-- Converting to 0 allows accurate delay aggregation and analysis
UPDATE flights
SET 
AIR_SYSTEM_DELAY = ISNULL(AIR_SYSTEM_DELAY,0),
WEATHER_DELAY = ISNULL(WEATHER_DELAY,0),
SECURITY_DELAY = ISNULL(SECURITY_DELAY,0),
AIRLINE_DELAY = ISNULL(AIRLINE_DELAY,0),
LATE_AIRCRAFT_DELAY = ISNULL(LATE_AIRCRAFT_DELAY,0);

ALTER TABLE flights
ADD CANCELLATION_REASON_DESC VARCHAR(50);

-- Data Enrichment Step
-- Convert cancellation reason codes into descriptive business labels
-- A = Carrier / Airline Issue
-- B = Weather
-- C = National Air System (ATC / airport congestion)
-- D = Security
UPDATE flights
SET CANCELLATION_REASON_DESC =
CASE
    WHEN CANCELLATION_REASON = 'A' THEN 'Carrier / Airline Issue'
    WHEN CANCELLATION_REASON = 'B' THEN 'Weather'
    WHEN CANCELLATION_REASON = 'C' THEN 'National Air System'
    WHEN CANCELLATION_REASON = 'D' THEN 'Security'
    ELSE NULL
END;

SELECT TOP 10000
CANCELLED,
CANCELLATION_REASON,
CANCELLATION_REASON_DESC
FROM flights;

SELECT * FROM flights

SELECT TOP 10 * FROM airlines;
SELECT TOP 10 * FROM airports;
SELECT TOP 10 * FROM flights;

--- Integrated analytical dataset for analysis and Power BI
DROP VIEW IF EXISTS flight_analysis_view;
GO

CREATE VIEW flight_analysis_view AS
SELECT

-- Date information
f.FLIGHT_DATE,
f.YEAR,
f.MONTH,
f.DAY,
f.DAY_OF_WEEK,

-- Airline info
f.AIRLINE AS airline_code,
al.AIRLINE AS airline_name,

-- Flight info
f.FLIGHT_NUMBER,
f.TAIL_NUMBER,

-- Origin airport
f.ORIGIN_AIRPORT,
ao.AIRPORT AS origin_airport_name,
ao.CITY AS origin_city,
ao.STATE AS origin_state,

-- Destination airport
f.DESTINATION_AIRPORT,
ad.AIRPORT AS destination_airport_name,
ad.CITY AS destination_city,
ad.STATE AS destination_state,

-- Timing
f.SCHEDULED_DEPARTURE_TIME,
f.DEPARTURE_TIME_CLEAN,
f.SCHEDULED_ARRIVAL_CLEAN,
f.ARRIVAL_TIME_CLEAN,

-- Operational timing
f.WHEELS_OFF_CLEAN,
f.WHEELS_ON_CLEAN,
f.ELAPSED_TIME,
f.TAXI_OUT,
f.TAXI_IN,
f.AIR_TIME,

-- Delay metrics
f.DEPARTURE_DELAY,
f.ARRIVAL_DELAY,

-- Delay causes
f.AIRLINE_DELAY,
f.WEATHER_DELAY,
f.AIR_SYSTEM_DELAY,
f.SECURITY_DELAY,
f.LATE_AIRCRAFT_DELAY,

-- Distance
f.DISTANCE,

-- Flight status
f.CANCELLED,
f.CANCELLATION_REASON_DESC,
f.DIVERTED

FROM flights f

LEFT JOIN airlines al
ON f.AIRLINE = al.IATA_CODE

LEFT JOIN airports ao
ON f.ORIGIN_AIRPORT = ao.IATA_CODE

LEFT JOIN airports ad
ON f.DESTINATION_AIRPORT = ad.IATA_CODE;

SELECT TOP 10 *
FROM flight_analysis_view;