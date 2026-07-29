-- =====================================================================
-- SQL Project: Exploratory Data Analysis (EDA)
-- Dataset: Layoffs 2022 (cleaned in a previous project)
-- Goal: Explore the cleaned layoffs dataset to answer key business
--       questions - which companies, industries, countries, and time
--       periods were hit hardest by layoffs.
-- =====================================================================

SELECT *
FROM layoffs_staging1;


-- ---------------------------------------------------------------------
-- 1. Overall Overview
-- ---------------------------------------------------------------------

-- Total number of records in the dataset
SELECT COUNT(*) AS total_records 
FROM layoffs_staging1;

-- Date range covered by the dataset
SELECT MIN(`date`) AS earliest_layoff,
       MAX(`date`) AS latest_layoff
FROM layoffs_staging1;

-- Total number of people laid off across all companies
SELECT SUM(total_laid_off) AS total_people_laid_off 
FROM layoffs_staging1;


-- ---------------------------------------------------------------------
-- 2. Layoffs by Year
-- Did layoffs get worse or better over time?
-- ---------------------------------------------------------------------
SELECT YEAR(`date`) AS `year`, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging1
WHERE `date` IS NOT NULL
GROUP BY YEAR(`date`)
ORDER BY `year` ASC;


-- ---------------------------------------------------------------------
-- 3. Top Companies With Most Layoffs
-- ---------------------------------------------------------------------
SELECT company, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging1
GROUP BY company
ORDER BY total_laid_off DESC
LIMIT 10;


-- ---------------------------------------------------------------------
-- 4. Layoffs by Industry
-- Which industry got hit hardest?
-- ---------------------------------------------------------------------
SELECT industry, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging1
GROUP BY industry
ORDER BY total_laid_off DESC;


-- ---------------------------------------------------------------------
-- 5. Layoffs by Country
-- ---------------------------------------------------------------------
SELECT country, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging1
GROUP BY country
ORDER BY total_laid_off DESC
LIMIT 10;


-- ---------------------------------------------------------------------
-- 6. Layoffs by Company Stage
-- (e.g. Seed, Series A/B/C, Post-IPO, etc.)
-- ---------------------------------------------------------------------
SELECT stage, SUM(total_laid_off) AS total_laid_off,
       COUNT(*) AS number_of_companies
FROM layoffs_staging1
GROUP BY stage
ORDER BY total_laid_off DESC;


-- ---------------------------------------------------------------------
-- 7. Worst Month for Layoffs
-- ---------------------------------------------------------------------
SELECT SUBSTRING(`date`, 1, 7) AS `month`, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging1
WHERE `date` IS NOT NULL
GROUP BY `month`
ORDER BY total_laid_off DESC
LIMIT 10;


-- ---------------------------------------------------------------------
-- 8. Companies With 100% Layoffs
-- (i.e. companies that shut down entirely)
-- ---------------------------------------------------------------------
SELECT company, location, total_laid_off, percentage_laid_off
FROM layoffs_staging1
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;


-- ---------------------------------------------------------------------
-- 9. Correlation: Funding vs Layoffs
-- Did companies that raised more funding still lay off large numbers
-- of employees?
-- ---------------------------------------------------------------------
SELECT company, funds_raised_millions, total_laid_off
FROM layoffs_staging1
WHERE funds_raised_millions > 0
ORDER BY funds_raised_millions DESC
LIMIT 15;
