# Layoffs_Data_Cleaning_and_Analysis

## Description

This repository contains SQL scripts and documentation for cleaning and analyzing a layoffs dataset. The project involves creating a staging table, removing duplicates, standardizing data, fixing null and blank values, and performing exploratory data analysis (EDA). The EDA includes summarizing total layoffs by company, year, stage, and month, as well as generating rolling totals and company rankings by layoffs.

## Project Structure

- `data_cleaning.sql`: SQL script for data cleaning, including creating a staging table, removing duplicates, standardizing data, and fixing null and blank values.
- `eda.sql`: SQL script for exploratory data analysis, including various summary statistics and rankings.
- `README.md`: Project documentation.

## Getting Started

### Prerequisites

- SQL Server or any compatible SQL database management system.
- Basic knowledge of SQL.

### Installation

1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/Layoffs_Data_Cleaning_and_Analysis.git
    ```
2. Open the SQL scripts in your SQL database management tool.

### Usage

1. **Data Cleaning**:
    - Run the `data_cleaning.sql` script to create the `layoffs_staging` table, remove duplicates, standardize data, and fix null and blank values.
    - Example command:
        ```sql
        -- Execute the script
        :r data_cleaning.sql
        ```

2. **Exploratory Data Analysis (EDA)**:
    - Run the `eda.sql` script to perform various analyses on the cleaned data.
    - Example command:
        ```sql
        -- Execute the script
        :r eda.sql
        ```

## Data Cleaning Steps

1. **Create Staging Table**:
    - Copy data from the raw table `test_project..layoffs` to a new table `layoffs_staging`.

2. **Remove Duplicates**:
    - Use a CTE with `ROW_NUMBER()` to identify and delete duplicate records.

3. **Standardize Data**:
    - Trim white spaces from the `company` column.
    - Standardize industry names (e.g., 'Crypto' and 'Cryptocurrency').
    - Trim trailing periods from country names.
    - Convert the `date` column to a proper date format.

4. **Fix Null and Blank Values**:
    - Replace blank `industry` values with `NULL`.
    - Propagate non-null `industry` values where possible using a self-join.

## Exploratory Data Analysis (EDA) Steps

1. **Total Layoffs by Company**:
    - Summarize total layoffs grouped by company.

2. **Total Layoffs by Year**:
    - Summarize total layoffs grouped by year.

3. **Total Layoffs by Stage**:
    - Summarize total layoffs grouped by stage.

4. **Total Layoffs by Month**:
    - Summarize total layoffs grouped by month.

5. **Rolling Total of Layoffs by Month**:
    - Calculate the rolling total of layoffs for each month.

6. **Company Rankings by Layoffs Each Year**:
    - Rank companies by total layoffs each year using `DENSE_RANK()`.

## Contributing

Contributions are welcome! Please fork this repository and submit a pull request with your changes. Ensure your contributions align with the project goals and adhere to the existing coding style.


- Thanks to all contributors and users for their valuable input and feedback.
# Layoffs_Data_Cleaning_and_Analysis
This repository contains SQL scripts and documentation for cleaning and analyzing a layoffs dataset. The project involves creating a staging table, removing duplicates, standardizing data, fixing null and blank values, and performing exploratory data analysis (EDA).
