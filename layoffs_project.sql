
--									DATA CLEANING

select * from test_project..layoffs;

-- 1. Instead of working on the raw_data. It is a good parctice to ceate a new table and
--		copy the the whole data from the raw_data into a new table
SELECT *
INTO layoffs_staging
FROM test_project..layoffs;

select * from test_project..layoffs_staging;

-- 2. Remove Duplicates
WITH CTE_layoffs AS
	(Select *,
		ROW_NUMBER() Over(Partition by company, location, industry, total_laid_off,
					percentage_laid_off, date, stage, country, funds_raised_millions Order by company) as row_num
	From test_project..layoffs_staging)

DELETE From CTE_layoffs
Where row_num > 1;

-- 3. Standardizing the data
-- (i) Some data in the company's company has white spaces.
UPDATE layoffs_staging
SET company = TRIM(company);

-- (ii) Give the data in the Industry column a distict name, sO as to not have an effect when carrying out EDA
--	E.g Crypto industry and Cryptocurrency industry are thesame.
Select DISTINCT(industry) From test_project..layoffs_staging;
UPDATE layoffs_staging
SET industry = 'Crypto'
Where industry LIKE 'Crypto%';

-- (iii) Give the data in the Country column a distict name, sO as to not have an effect when carrying out EDA
--	E.g 'United States' and 'United States.' are thesame.
Select DISTINCT(country) From test_project..layoffs_staging;
UPDATE layoffs_staging
SET country = TRIM(Trailing '.' from country);

-- (iv) format the date column and then alter it datatype from text to datetime
UPDATE layoffs_staging
SET [date] = CONVERT(DATE, [date], 101);
ALTER TABLE layoffs_staging
ALTER COLUMN [date] DATE;

-- 4. Fix NULL and BLANK SPACES
UPDATE layoffs_staging
SET industry = NULL
WHERE industry = '';

Select a.company, a.country, a.industry, b.industry
From test_project..layoffs_staging a
	JOIN test_project..layoffs_staging b
		ON a.company = b.company AND a.location = b.location
Where a.industry IS NULL AND b.industry IS NOT NULL

UPDATE a
SET a.industry = b.industry
		From test_project..layoffs_staging a
	JOIN test_project..layoffs_staging b
		ON a.company = b.company AND a.location = b.location
Where a.industry IS NULL AND b.industry IS NOT NULL;


--								EXPLORATORY DATA ANALYSIS (EDA)

Select * From test_project..layoffs_staging

-- 1. The sum of total laid_off by company
Select company, SUM(total_laid_off)
From test_project..layoffs_staging
Group by company
Order by 2 DESC;

-- 2. The Sum of total laid_off in each year
Select YEAR(date), SUM(total_laid_off)
From test_project..layoffs_staging
Group by YEAR(date)
Order by 1 DESC;

-- 3. The Sum of total_laid_off by stage
Select stage, SUM(total_laid_off)
From test_project..layoffs_staging
Group by stage
Order by 2 DESC;

-- 4. The Sum of total laid_off in each month of the year
Select
    LEFT(CONVERT(VARCHAR(10), [date], 23), 7) AS Month, 
    SUM(total_laid_off) AS TotalLaidOff
From
    test_project..layoffs_staging
Where
    [date] IS NOT NULL
Group by
    LEFT(CONVERT(VARCHAR(10), [date], 23), 7)
Order by 
    Month ASC;


-- 5. Total layoffs per month
-- (i) I used CTE
WITH Rolling_Total AS
(
    Select 
        LEFT(CONVERT(VARCHAR(10), [date], 23), 7) AS Month, 
        SUM(total_laid_off) AS total_off
    From 
        test_project..layoffs_staging
    Where 
        [date] IS NOT NULL
    Group by 
        LEFT(CONVERT(VARCHAR(10), [date], 23), 7)
)
Select
    Month, 
    total_off, 
    SUM(total_off) OVER (ORDER BY Month) AS rolling_total
From 
    Rolling_Total
Order by 
    Month ASC;


-- 5. Rankings of company each year that has the most lay_offs
WITH Company_Year AS 
(
    Select 
        company, 
        YEAR(date) AS years, 
        SUM(total_laid_off) AS total_laid_off
    From 
        test_project..layoffs_staging
    Group by
        company, 
        YEAR(date)
), 
Company_Year_Rank AS
(
    Select 
        company, 
        years, 
        total_laid_off,
        DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
    From 
        Company_Year
    Where 
        years IS NOT NULL
)
Select 
    company, 
    years, 
    total_laid_off, 
    Ranking
From 
    Company_Year_Rank
Order by 
    years, 
    Ranking;


