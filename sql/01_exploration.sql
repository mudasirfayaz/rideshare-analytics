USE rideshare;

SELECT * FROM trips LIMIT 5;

-- 1. Status Distribution
SELECT 
    COUNT(*) AS total_trips,
    COUNT(CASE WHEN status = 'completed' THEN 1 END) AS completed_trips,
    COUNT(CASE WHEN status = 'cancelled' THEN 1 END) AS cancelled_trips,
    ROUND(COUNT(CASE WHEN status = 'completed' THEN 1 END) * 100.0 / COUNT(*), 2) AS completion_rate,
    ROUND(COUNT(CASE WHEN status = 'cancelled' THEN 1 END) * 100.0 / COUNT(*), 2) AS cancellation_rate
FROM trips;

-- 2. Date Coverage
SELECT 
    DATE_FORMAT(MIN(requested_at), "%Y-%m-%d") AS start_date,
    DATE_FORMAT(MAX(requested_at), "%Y-%m-%d") AS end_date,
    TIMESTAMPDIFF(MONTH, MIN(requested_at), MAX(requested_at)) + 1 AS total_months
FROM trips;

-- 3. Fare Distribution
SELECT 
    ROUND(AVG(total_fare), 2) AS avg_fare,
    ROUND(STDDEV(total_fare), 2) AS std_dev,
    COUNT(*) AS total_completed_trips
FROM trips
WHERE status = 'completed';

SELECT * FROM trips WHERE total_fare IS NULL;