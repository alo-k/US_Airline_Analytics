SELECT TOP 10 *
FROM flight_analysis_view;

--- Total Cancellations ---
SELECT  
COUNT(*) AS total_flights,  
SUM(CAST(CANCELLED AS INT)) AS total_cancelled_flights  
FROM flight_analysis_view;

--- Cancellation Rate ---
SELECT 
COUNT(*) AS total_flights,
SUM(CAST(CANCELLED AS INT)) AS cancelled_flights,
ROUND(100.0 * SUM(CAST(CANCELLED AS INT))  / COUNT(*),2) AS cancellation_rate_percent
FROM flight_analysis_view;

--- Cancellation by Reason ---
SELECT 
CANCELLATION_REASON_DESC,
COUNT(*) AS total_cancelled
FROM flight_analysis_view
WHERE CANCELLED = 1
GROUP BY CANCELLATION_REASON_DESC
ORDER BY total_cancelled DESC;

--- Basic Delay Statistics ---
--- Arrival delay stats: ---
SELECT 
CANCELLATION_REASON_DESC,
COUNT(*) AS total_cancelled
FROM flight_analysis_view
WHERE CANCELLED = 1
GROUP BY CANCELLATION_REASON_DESC
ORDER BY total_cancelled DESC;

--- Departure delay: ---
SELECT 
AVG(DEPARTURE_DELAY) AS avg_departure_delay,
MIN(DEPARTURE_DELAY) AS min_delay,
MAX(DEPARTURE_DELAY) AS max_delay
FROM flight_analysis_view
WHERE DEPARTURE_DELAY IS NOT NULL;

--- On-Time Performance ---
SELECT 
COUNT(*) AS total_flights,
SUM(CASE WHEN ARRIVAL_DELAY <= 15 THEN 1 ELSE 0 END) AS on_time_flights,
ROUND(
100.0 * SUM(CASE WHEN ARRIVAL_DELAY <= 15 THEN 1 ELSE 0 END) / COUNT(*),
2
) AS otp_rate_percent
FROM flight_analysis_view
WHERE CANCELLED = 0;

--- Delay Type Distribution ---
SELECT
SUM(AIRLINE_DELAY) AS airline_delay,
SUM(WEATHER_DELAY) AS weather_delay,
SUM(AIR_SYSTEM_DELAY) AS nas_delay,
SUM(SECURITY_DELAY) AS security_delay,
SUM(LATE_AIRCRAFT_DELAY) AS late_aircraft_delay
FROM flight_analysis_view;

--- Total Diversions ---
SELECT COUNT(*) AS diverted_flights
FROM flight_analysis_view
WHERE DIVERTED = 1;

--- Departure Delay Statistics ---
SELECT
AVG(departure_delay) AS avg_departure_delay,
MIN(departure_delay) AS min_departure_delay,
MAX(departure_delay) AS max_departure_delay
FROM flight_analysis_view;

--- Arrival Delay Statistics ---
SELECT
AVG(arrival_delay) AS avg_arrival_delay,
MIN(arrival_delay) AS min_arrival_delay,
MAX(arrival_delay) AS max_arrival_delay
FROM flight_analysis_view;

--- On-Time Performance ---
SELECT
COUNT(CASE WHEN arrival_delay <= 15 THEN 1 END) * 100.0 / COUNT(*) AS otp_rate
FROM flight_analysis_view;

--- Average Delay --- 
SELECT
AVG(arrival_delay) AS avg_arrival_delay,
AVG(departure_delay) AS avg_departure_delay
FROM flight_analysis_view;

--- Cancellation Rate ---
SELECT
SUM(CAST(cancelled AS INT)) * 100.0 / COUNT(*) AS cancellation_rate
FROM flight_analysis_view;

--- Aggregations ---
--- By Airline ---
SELECT
airline_name,
AVG(arrival_delay) AS avg_arrival_delay
FROM flight_analysis_view
GROUP BY airline_name
ORDER BY avg_arrival_delay DESC;

--- By Month ---
SELECT
month,
COUNT(*) AS total_flights
FROM flight_analysis_view
GROUP BY month
ORDER BY month;

--- By Day of Week ---
SELECT
DAY_OF_WEEK,
AVG(arrival_delay) AS avg_delay
FROM flight_analysis_view
GROUP BY DAY_OF_WEEK;

--- By Airport ---
SELECT
origin_airport,
COUNT(*) AS total_flights
FROM flight_analysis_view
GROUP BY origin_airport
ORDER BY total_flights DESC;
