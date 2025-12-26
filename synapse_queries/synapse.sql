
-- 1. Use or create your database
CREATE DATABASE EarthquakeDB;
GO
USE EarthquakeDB;
GO
-- 2. Create external data source
CREATE EXTERNAL DATA SOURCE EarthquakeStorage
WITH (
    LOCATION = 'https://earthquakedata.dfs.core.windows.net/gold/'
);
GO

-- 3. Create external file format
CREATE EXTERNAL FILE FORMAT ParquetFormat
WITH (
    FORMAT_TYPE = PARQUET
);
GO

-- 4. Create external table
CREATE EXTERNAL TABLE earthquake_events_gold
(
    id NVARCHAR(50),
    longitude FLOAT,
    latitude FLOAT,
    elevation FLOAT,
    title NVARCHAR(200),
    place_description NVARCHAR(200),
    sig BIGINT,
    mag FLOAT,
    magType NVARCHAR(10),
    time DATETIME2,
    updated DATETIME2,
    country_code NVARCHAR(10),
    sig_class NVARCHAR(10),
    day_of_week INT,
    depth_category NVARCHAR(20),
    intensity NVARCHAR(20),
    mag_rounded FLOAT
)
WITH (
    LOCATION = 'earthquake_events_gold/',
    DATA_SOURCE = EarthquakeStorage,
    FILE_FORMAT = ParquetFormat
);
GO

-- Count earthquakes per country
SELECT country_code, COUNT(*) AS num_earthquakes
FROM earthquake_events_gold
GROUP BY country_code
ORDER BY num_earthquakes DESC;


-- Calculate average magnitude per depth category
SELECT depth_category, ROUND(AVG(mag), 2) AS avg_magnitude
FROM earthquake_events_gold
GROUP BY depth_category;


-- Find the strongest earthquake each day
SELECT CAST(time AS DATE) AS event_date,
       MAX(mag) AS max_magnitude
FROM earthquake_events_gold
GROUP BY CAST(time AS DATE)
ORDER BY event_date;

-- Number of earthquakes by intensity and country
SELECT country_code, intensity, COUNT(*) AS count
FROM earthquake_events_gold
GROUP BY country_code, intensity
ORDER BY country_code, intensity;



-- List of shallow earthquakes with magnitude >= 3.0
SELECT id, title, country_code, mag, depth_category, time
FROM earthquake_events_gold
WHERE depth_category = 'Shallow'
  AND mag >= 3.0
ORDER BY mag DESC;
