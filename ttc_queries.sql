-- TTC Subway Delay Analysis 2024: SQL queries (SQLite)
-- Tables: delays (26,450 rows after removing 17 exact duplicates), codes (140 rows)

-- 1. Top 10 stations by total delay minutes
SELECT station, COUNT(*) AS incidents, SUM(min_delay) AS total_delay_min,
       ROUND(100.0 * SUM(min_delay) / (SELECT SUM(min_delay) FROM delays), 1) AS pct_of_total
FROM delays
GROUP BY station
ORDER BY total_delay_min DESC
LIMIT 10;

-- 2. Peak vs Off-peak (Peak = before 9:00 or 15:00-18:59)
SELECT peak_period, COUNT(*) AS incidents, SUM(min_delay) AS total_delay_min,
       ROUND(AVG(min_delay), 2) AS avg_min_per_incident
FROM delays
GROUP BY peak_period;

-- 3. Top 10 delay causes by total minutes (with descriptions)
SELECT d.code, COALESCE(c.description, 'Review code') AS description,
       COUNT(*) AS incidents, SUM(d.min_delay) AS total_delay_min,
       ROUND(AVG(d.min_delay), 2) AS avg_min
FROM delays d
LEFT JOIN codes c ON c.code = d.code
GROUP BY d.code, c.description
ORDER BY total_delay_min DESC
LIMIT 10;

-- 4. Delay by hour of day
SELECT hour, COUNT(*) AS incidents, SUM(min_delay) AS total_delay_min
FROM delays
GROUP BY hour
ORDER BY hour;

-- 5. Delay by month
SELECT month, COUNT(*) AS incidents, SUM(min_delay) AS total_delay_min
FROM delays
GROUP BY month
ORDER BY month;

-- 6. Delay by line (cleaned labels)
SELECT line_clean, COUNT(*) AS incidents, SUM(min_delay) AS total_delay_min,
       ROUND(100.0 * SUM(min_delay) / (SELECT SUM(min_delay) FROM delays), 1) AS pct_of_total
FROM delays
GROUP BY line_clean
ORDER BY total_delay_min DESC;

-- 7. Data quality: codes with no description
SELECT d.code, COUNT(*) AS incidents
FROM delays d
LEFT JOIN codes c ON c.code = d.code
WHERE c.code IS NULL
GROUP BY d.code;
