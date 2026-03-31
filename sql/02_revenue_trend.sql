-- Q1. How is monthly revenue trending, and how volatile is it?

USE rideshare;

-- ==========================================
-- Q1. Monthly Revenue Trend
-- ==========================================

WITH monthly_revenue AS (
    SELECT 
        DATE_FORMAT(requested_at, "%Y-%m") AS month,
        SUM(total_fare) AS total_revenue
    FROM trips
    WHERE status = "completed"
    GROUP BY month
),
trend_calc AS (
    SELECT
        month,
        total_revenue,
        LAG(total_revenue) OVER (ORDER BY month) AS prev_month_revenue
    FROM monthly_revenue
)
SELECT
    month,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(prev_month_revenue, 2) AS prev_month_revenue,
    ROUND(total_revenue - prev_month_revenue, 2) AS mom_change,
    CASE 
        WHEN prev_month_revenue IS NOT NULL AND prev_month_revenue != 0 
        THEN ROUND((total_revenue - prev_month_revenue) / prev_month_revenue * 100, 2)
        ELSE NULL 
    END AS mom_pct_change,
    CASE
        WHEN total_revenue - prev_month_revenue > 0 THEN 'Growth'
        WHEN total_revenue - prev_month_revenue < 0 THEN 'Decline'
        WHEN total_revenue - prev_month_revenue = 0 THEN 'Flat'
        ELSE NULL
    END AS trend
FROM trend_calc
ORDER BY month;


-- ==========================================
-- Q1. Revenue Volatility 
-- ==========================================

WITH monthly_revenue AS (
    SELECT 
        DATE_FORMAT(requested_at, "%Y-%m") AS month,
        SUM(total_fare) AS total_revenue
    FROM trips
    WHERE status = "completed"
    GROUP BY month
)
SELECT
    ROUND(AVG(total_revenue), 2) AS avg_monthly_revenue,
    ROUND(STDDEV(total_revenue), 2) AS stddev_revenue,
    ROUND(STDDEV(total_revenue) / AVG(total_revenue), 4) AS coefficient_of_variation
FROM monthly_revenue;

-- ==============================
-- OBSERVATIONS
-- ==============================

-- 1. Revenue does not show sustained momentum, indicating the business lacks consistent growth drivers 
--    and may be sensitive to short-term demand fluctuations.

-- 2. Despite frequent month-to-month fluctuations, the low volatility (CV ~5.41%) indicates that 
--    revenue changes are relatively small in magnitude, suggesting a stable overall revenue base 
--    with minor short-term variations.

-- 3. The combination of low volatility and lack of sustained growth suggests the business is stable but not scaling, 
--    indicating a need for strategies focused on growth acceleration rather than stability.
