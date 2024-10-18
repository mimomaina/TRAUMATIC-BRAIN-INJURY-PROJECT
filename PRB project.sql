CREATE DATABASE brain_injury;

USE brain_injury;

-- data cleaning
SELECT *
FROM tbi_military; 

SELECT *
FROM tbi_year; 

SELECT *
FROM tbi_age;

SELECT * FROM tbi_military LIMIT 10;

SELECT * FROM tbi_year LIMIT 10;
DESCRIBE tbi_military;

-- defining primary key
ALTER TABLE tbi_age ADD PRIMARY KEY (age_group);

-- joins
SELECT 
    tbi_military.service,
    tbi_year.year,
    SUM(tbi_year.number_est) AS total_injuries
FROM 
    tbi_military
JOIN 
    tbi_year ON tbi_military.year = tbi_year.year
GROUP BY 
    tbi_military.service, tbi_year.year
ORDER BY 
    tbi_year.year;

-- sample query
SELECT 
    tbi_year.year,
    tbi_age.age_group,
    tbi_military.service AS military_service,
    tbi_military.component AS military_component,
    tbi_year.injury_mechanism,
    SUM(tbi_age.number_est) AS total_injuries_age_group,
    SUM(tbi_year.number_est) AS total_injuries_year,
    AVG(tbi_year.rate_est) AS avg_injury_rate,
    tbi_military.severity AS injury_severity,
    COUNT(tbi_military.diagnosed) AS diagnosed_cases
FROM 
    tbi_year
LEFT JOIN 
    tbi_military ON tbi_year.year = tbi_military.year
LEFT JOIN 
    tbi_age ON tbi_year.injury_mechanism = tbi_age.injury_mechanism
    AND tbi_year.type = tbi_age.type
GROUP BY 
    tbi_year.year,
    tbi_age.age_group,
    tbi_military.service,
    tbi_military.component,
    tbi_year.injury_mechanism,
    tbi_military.severity
ORDER BY 
    tbi_year.year, tbi_age.age_group, total_injuries_year DESC;

-- data type and constraints
-- Create the tbi_age table
CREATE TABLE tbi_age (
    age_group VARCHAR(50),
    type VARCHAR(50),
    injury_mechanism VARCHAR(100),
    number_est INT,
    rate_est DECIMAL(5,2),
    PRIMARY KEY (age_group)
);

-- Create the tbi_year table
CREATE TABLE tbi_year (
    injury_mechanism VARCHAR(100),
    type VARCHAR(50),
    year INT,
    number_est INT,
    rate_est DECIMAL(5,2),
    PRIMARY KEY (year),
    FOREIGN KEY (injury_mechanism) REFERENCES tbi_age(injury_mechanism)
);

-- Create the tbi_military table
CREATE TABLE tbi_military (
    service VARCHAR(100),
    component VARCHAR(100),
    severity VARCHAR(50),
    diagnosed INT,
    year INT,
    PRIMARY KEY (service),
    FOREIGN KEY (year) REFERENCES tbi_year(year)
);

INSERT INTO tbi_year (year, type, injury_mechanism, number_est, rate_est)
VALUES 
(2009, 'Emergency Department Visit', 'Motor vehicle crashes', 270240, 88.7),
(2006, 'Emergency Department Visit', 'Unintentional falls', 625098, 208.8),
(2010, 'Emergency Department Visit', 'Intentional self-harm', 1807, 0.6);

INSERT INTO tbi_military (service, component, severity, diagnosed, year)
VALUES 
('Army', 'Active', 'Mild',5896, 2006),
('Navy', 'Active', 'Severe', 28, 2006),
('Air Force', 'Guard', 'Moderate', 20, 2006);

INSERT INTO tbi_age (age_group, type, injury_mechanism, number_est, rate_est)
VALUES 
('0-4', 'Emergency Department Visit', 'Assault', 674, 3.4),
('0-17', 'Deaths', 'Assault', 611, 0.8),
('65-74', 'Hospitalizations', 'Motor Vehicle Crashes', 4485, 17);






