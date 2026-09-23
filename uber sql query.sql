1.View sample records
SELECT *
FROM uber_trips
LIMIT 10;

2. Total number of trips
SELECT COUNT(*) AS total_trips
FROM uber_trips;


3. Date range of the dataset
SELECT
    MIN(tpep_pickup_datetime) AS first_trip,
    MAX(tpep_pickup_datetime) AS last_trip
FROM uber_trips;

4. Overall KPI summary
SELECT
    COUNT(*) AS total_trips,
    ROUND(SUM(total_amount)::numeric, 2) AS total_revenue,
    ROUND(AVG(total_amount)::numeric, 2) AS avg_trip_value,
    ROUND(AVG(trip_distance)::numeric, 2) AS avg_distance,
    ROUND(AVG(trip_duration_min)::numeric, 2) AS avg_duration,
    ROUND(AVG(final_speed_mph)::numeric, 2) AS avg_speed
FROM uber_trips;

Revenue Analysis
5. Revenue by payment type
SELECT
    payment_type_name,
    COUNT(*) AS trips,
    ROUND(SUM(total_amount)::numeric, 2) AS revenue,
    ROUND(AVG(total_amount)::numeric, 2) AS avg_trip_value,
    ROUND(SUM(tip_amount)::numeric, 2) AS total_tips
FROM uber_trips
GROUP BY payment_type_name
ORDER BY trips DESC;

6. Revenue by pickup hour
SELECT
    pickup_hour,
    COUNT(*) AS trips,
    ROUND(SUM(total_amount)::numeric, 2) AS revenue,
    ROUND(AVG(total_amount)::numeric, 2) AS avg_trip_value
FROM uber_trips
GROUP BY pickup_hour
ORDER BY pickup_hour;

7. Revenue by date
SELECT
    DATE(tpep_pickup_datetime) AS trip_date,
    COUNT(*) AS trips,
    ROUND(SUM(total_amount)::numeric, 2) AS revenue,
    ROUND(AVG(total_amount)::numeric, 2) AS avg_trip_value,
    ROUND(AVG(trip_distance)::numeric, 2) AS avg_distance,
    ROUND(AVG(trip_duration_min)::numeric, 2) AS avg_duration
FROM uber_trips
GROUP BY DATE(tpep_pickup_datetime)
ORDER BY trip_date;

8. Revenue by vendor
SELECT
    VendorID,
    COUNT(*) AS trips,
    ROUND(SUM(total_amount)::numeric, 2) AS revenue,
    ROUND(AVG(total_amount)::numeric, 2) AS avg_trip_value
FROM uber_trips
GROUP BY VendorID
ORDER BY revenue DESC;

Trip Behavior
9. Passenger count analysis
SELECT
    passenger_count,
    COUNT(*) AS trips,
    ROUND(AVG(total_amount)::numeric, 2) AS avg_trip_value,
    ROUND(AVG(trip_distance)::numeric, 2) AS avg_distance,
    ROUND(AVG(trip_duration_min)::numeric, 2) AS avg_duration
FROM uber_trips
GROUP BY passenger_count
ORDER BY passenger_count;

10. Trip-distance analysis
SELECT
    CASE
        WHEN trip_distance = 0 THEN '0 miles'
        WHEN trip_distance < 2 THEN '0-2 miles'
        WHEN trip_distance < 5 THEN '2-5 miles'
        WHEN trip_distance < 10 THEN '5-10 miles'
        ELSE '10+ miles'
    END AS distance_band,
    COUNT(*) AS trips,
    ROUND(SUM(total_amount)::numeric, 2) AS revenue,
    ROUND(AVG(total_amount)::numeric, 2) AS avg_trip_value
FROM uber_trips
GROUP BY distance_band
ORDER BY trips DESC;
Location Analysis

11. Top pickup areas
SELECT
    pickup_area,
    COUNT(*) AS trips,
    ROUND(SUM(total_amount)::numeric, 2) AS revenue,
    ROUND(AVG(total_amount)::numeric, 2) AS avg_trip_value,
    ROUND(AVG(trip_distance)::numeric, 2) AS avg_distance
FROM uber_trips
WHERE pickup_area <> '0.0, 0.0'
GROUP BY pickup_area
ORDER BY trips DESC
LIMIT 10;

12. Top dropoff areas
SELECT
    dropoff_area,
    COUNT(*) AS trips,
    ROUND(SUM(total_amount)::numeric, 2) AS revenue,
    ROUND(AVG(total_amount)::numeric, 2) AS avg_trip_value,
    ROUND(AVG(trip_distance)::numeric, 2) AS avg_distance
FROM uber_trips
WHERE dropoff_area <> '0.0, 0.0'
GROUP BY dropoff_area
ORDER BY trips DESC
LIMIT 10;

13. Top routes by trip volume
SELECT
    pickup_area,
    dropoff_area,
    COUNT(*) AS trips,
    ROUND(SUM(total_amount)::numeric, 2) AS revenue,
    ROUND(AVG(total_amount)::numeric, 2) AS avg_trip_value,
    ROUND(AVG(trip_distance)::numeric, 2) AS avg_distance,
    ROUND(AVG(trip_duration_min)::numeric, 2) AS avg_duration
FROM uber_trips
WHERE pickup_area <> '0.0, 0.0'
  AND dropoff_area <> '0.0, 0.0'
GROUP BY pickup_area, dropoff_area
ORDER BY trips DESC
LIMIT 10;

14. Same-area vs different-area trips
SELECT
    CASE
        WHEN same_area_trip = 1 THEN 'Same Area'
        ELSE 'Different Area'
    END AS trip_type,
    COUNT(*) AS trips,
    ROUND(SUM(total_amount)::numeric, 2) AS revenue,
    ROUND(AVG(total_amount)::numeric, 2) AS avg_trip_value,
    ROUND(AVG(trip_distance)::numeric, 2) AS avg_distance,
    ROUND(AVG(trip_duration_min)::numeric, 2) AS avg_duration
FROM uber_trips
GROUP BY same_area_trip
ORDER BY trips DESC;
Advanced SQL

15. Top routes using a CTE

This is our first proper CTE-based business query.

WITH route_summary AS (
    SELECT
        pickup_area,
        dropoff_area,
        COUNT(*) AS trips,
        SUM(total_amount) AS revenue,
        AVG(total_amount) AS avg_trip_value
    FROM uber_trips
    WHERE pickup_area <> '0.0, 0.0'
      AND dropoff_area <> '0.0, 0.0'
    GROUP BY pickup_area, dropoff_area
)

SELECT
    pickup_area,
    dropoff_area,
    trips,
    ROUND(revenue::numeric, 2) AS revenue,
    ROUND(avg_trip_value::numeric, 2) AS avg_trip_value
FROM route_summary
ORDER BY revenue DESC
LIMIT 10;

Window Functions
16. Rank pickup areas by revenue
WITH pickup_revenue AS (
    SELECT
        pickup_area,
        COUNT(*) AS trips,
        SUM(total_amount) AS revenue
    FROM uber_trips
    WHERE pickup_area <> '0.0, 0.0'
    GROUP BY pickup_area
)

SELECT
    pickup_area,
    trips,
    ROUND(revenue::numeric, 2) AS revenue,
    RANK() OVER (ORDER BY revenue DESC) AS revenue_rank
FROM pickup_revenue
ORDER BY revenue_rank
LIMIT 10;

17. Hourly revenue ranking
WITH hourly_revenue AS (
    SELECT
        pickup_hour,
        COUNT(*) AS trips,
        SUM(total_amount) AS revenue
    FROM uber_trips
    GROUP BY pickup_hour
)

SELECT
    pickup_hour,
    trips,
    ROUND(revenue::numeric, 2) AS revenue,
    RANK() OVER (ORDER BY revenue DESC) AS revenue_rank
FROM hourly_revenue
ORDER BY revenue_rank;

18. Percentage contribution of each payment type
WITH payment_summary AS (
    SELECT
        payment_type_name,
        COUNT(*) AS trips,
        SUM(total_amount) AS revenue
    FROM uber_trips
    GROUP BY payment_type_name
)

SELECT
    payment_type_name,
    trips,
    ROUND(revenue::numeric, 2) AS revenue,
    ROUND(
        (revenue * 100.0 / SUM(revenue) OVER ())::numeric,
        2
    ) AS revenue_percentage
FROM payment_summary
ORDER BY revenue DESC;

19. Running cumulative revenue by hour
WITH hourly_revenue AS (
    SELECT
        pickup_hour,
        SUM(total_amount) AS revenue
    FROM uber_trips
    GROUP BY pickup_hour
)

SELECT
    pickup_hour,
    ROUND(revenue::numeric, 2) AS hourly_revenue,
    ROUND(
        SUM(revenue) OVER (
            ORDER BY pickup_hour
        )::numeric,
        2
    ) AS cumulative_revenue
FROM hourly_revenue
ORDER BY pickup_hour;
Business Intelligence Queries

20. Trips with above-average revenue
SELECT
    trip_id,
    pickup_area,
    dropoff_area,
    total_amount,
    trip_distance,
    trip_duration_min
FROM uber_trips
WHERE total_amount > (
    SELECT AVG(total_amount)
    FROM uber_trips
)
ORDER BY total_amount DESC
LIMIT 20;

21. High-value trips
SELECT
    trip_id,
    pickup_area,
    dropoff_area,
    total_amount,
    trip_distance,
    trip_duration_min,
    payment_type_name
FROM uber_trips
WHERE total_amount >= 40
ORDER BY total_amount DESC
LIMIT 20;

22. Trips with high tips
SELECT
    trip_id,
    payment_type_name,
    fare_amount,
    tip_amount,
    ROUND(tip_percentage::numeric, 2) AS tip_percentage,
    total_amount
FROM uber_trips
WHERE tip_percentage IS NOT NULL
ORDER BY tip_percentage DESC
LIMIT 20;

23. Average revenue per mile by payment type
SELECT
    payment_type_name,
    COUNT(*) AS trips,
    ROUND(AVG(revenue_per_mile)::numeric, 2) AS avg_revenue_per_mile
FROM uber_trips
WHERE revenue_per_mile IS NOT NULL
GROUP BY payment_type_name
ORDER BY avg_revenue_per_mile DESC;

24. Trips with data-quality issues
SELECT
    SUM(zero_duration_flag) AS zero_duration_trips,
    SUM(zero_distance_flag) AS zero_distance_trips,
    SUM(negative_fare_flag) AS negative_fare_trips,
    SUM(negative_tip_flag) AS negative_tip_trips,
    SUM(negative_total_flag) AS negative_total_trips
FROM uber_trips;