-- Q3. Who are the top-performing drivers, and who is underperforming?

WITH t1 AS (
		SELECT 
			u.name AS driver_name,
			d.rating AS avg_rating,
			d.driver_id AS driver_id
		FROM users u
		INNER JOIN drivers d ON u.user_id = d.user_id
		WHERE u.is_driver = 1
	),
	t2 AS (
		SELECT 
			t.driver_name,
			t.avg_rating,
			COUNT(CASE WHEN ts.status = "completed" THEN 1 END) as completed_trips,
			COUNT(CASE WHEN ts.status = "cancelled" THEN 1 END ) AS cancelled_trips,
            COUNT(ts.trip_id) AS total_trips,
			ROUND(SUM(ts.total_fare), 1) AS total_revenue,
			ts.trip_id AS trip_id
		FROM t1 t
		JOIN trips ts
			ON t.driver_id = ts.driver_id
		GROUP BY t.driver_name
		HAVING COUNT(ts.trip_id) > 10
	)
SELECT 
	driver_name,
    completed_trips,
    avg_rating,
    ROUND(cancelled_trips / total_trips * 100, 1) AS cancellation_rate,
    total_revenue,
    RANK() OVER(ORDER BY total_revenue DESC) AS revenue_rank
FROM t2;