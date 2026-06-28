# Introduction
An analysis of high demand skills in the data job market in 2023. 

This project focuses on data engineering roles both remote and located in Toronto, ON, Canada, and focuses on in-demand skills, highpaying roles, and what are the optimal skills to learn to do well in the data engineering job market

All SQL queries are here: [project_sql folder](/project_sql/)

# Background
This project was made as way to better understand the data engineering job market. Specifically, it was used to understand which skills were most in demand, and highest paid.

### The questions this project answered
1. What are the top paying data engineering jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data engineers?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

I answered these questions for both remote jobs, and jobs located in Toronto, Canada. 

# Tools Used
For this analysis the following tools were used:

- **SQL** was the main tool used in the analysis to query the database and reveal insights about the job market
- **PostgreSQL** was the chosen database management system for handling the job posting data
- **Visual Studio Code** was the IDE in which this analysis was conducted
- **Git & Github** were used as version control 

# Analysis
Each query for this project investigated a specific aspect of the data engineering job market. 

Here's how I approached in question:

- For each query I looked at remote jobs AND jobs in Toronto by changing the job_location field

### 1. What are the top paying data engineering jobs?
I filtered data engineering positions by average yearly salary and location. I focused on both remote jobs and jobs in Toronto.

```sql
-- Top paying remote jobs
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_title_short = 'Data Engineer' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;

-- Top paying jobs in Toronto, ON, Canada

SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_title_short = 'Data Engineer' AND
    job_location = 'Toronto, ON, Canada' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```

Findings
- The top 3 highest paying remote jobs were all labelled "Data Engineer"
- The top 3 highest paying jobs in Toronto had titles like "Director of Engineering" meaning they are highly technical senior roles
    - This makes sense because a senior role is higher paying


### 2. What skills are required for these top-paying jobs?
I joined the skills dataset wtih the job postings data set to see which skills are highly valued by employers. 

```sql
-- Top paying remote skills

WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE 
        job_title_short = 'Data Engineer' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
        salary_year_avg DESC;
```
*I conducted the same analysis on Toronto just by changing the job location*

Findings
- In remote roles, Python was ranked number one
- For roles located in Toronto, Databricks was ranked number one
*NOTE: These are the skills for the top paying jobs, NOT the highest paying skills*



### 3. What skills are most in demand for data engineers?
This query aimed to identify the top 5 in demand skills for data engineering overall, for remote positions, and for positions in Toronto. 

For this query, I counted the frequency of each skill, then joined the postings table ot the skills_job_dim table, then the skills_job_dim table to the skills_dim table. 

```sql
SELECT
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Engineer'
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;

```

Findings
- SQL and Python are topping the list making them the most in demand skills over all
- This is the case for remote jobs and jobs in Toronto as well
- The next 3 jobs do change but SQL and Python are common in first and second place respectively

### 4. Which skills are associated with higher salaries?
Selected the skills and the associated average salary with all of those skills. I joined the tables the exact same way as the previous query. 

```sql
SELECT
    skills,
    ROUND(AVG(salary_year_avg), 2)AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Engineer'
    AND salary_year_avg IS NOT NULL
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25;
```

Findings
- While SQL and Python are in the most demand, node and mongo are the highest paid
- In remote work Assembly is now the highest paying skill, and Rust is now in the top 5
    - This suggests that there are a lot of specialized skills that are rewarded in Data Engineering for remote jobs
- In Toronto, the highest paying skill is no-sql
- When expanding to include top 25, C, Go, C++, and Java are included for Toronto
    - These languages are not in the top 25 for the other two tables

### 5. What are the most optimal skills to learn?
I selected each skill, it's demand count (how many positions mentioned it), the average salary, and sorted by demand. I only included skills that showed up more than 10 times. 

```sql
-- REMOTE JOBS 
WITH skills_demand AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Engineer'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = True
    GROUP BY
        skills_dim.skill_id
), average_salary AS ( -- Looking at remote jobs first
    SELECT
        skills_job_dim.skill_id,
        ROUND(AVG(job_postings_fact.salary_year_avg), 2) AS avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Engineer'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = True
    GROUP BY
        skills_job_dim.skill_id
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM
    skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE
    demand_count > 100
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 20;
```

Findings
- For remote jobs, kubernetes was the most optimal skill to learn, followed by numpy, cassandra, kafka, and golang
- For jobs in Toronto, the optimal skill is redshift, followed by databricks, java, kafka, and spark
- When I raised each of the queries' demand counts to >100, Toronto had no data, which made sense because the number jobs based in Toronto would be lower compared to the number of jobs that are remote
- When the demand count was >100 for remote jobs, kafka became the most optimal skill to learn 
    - Rarer skills like kafka tend to have a higher salary, while skills that are more popular like Python have a lower salary 
    - This makes sense because if less people know a skill, anyone who knows that skill is a greater asset
- When ordering by demand before salary, Python and SQL are in the top two for both list (Python is 1st in Toronto, while SQL is 1st in remote jobs)
    - While the pay for these languages is relatively low, their higher demand makes them more attractive skills to learn

# What I Learned

- **Complex Queries for Data Analysis:** I learned how to make complex SQL queries and use those queries for data analysis, by manipulating tables in a way that tells me something useful about the data
- **Data Analysis Skills:** I learned how to ask the right questions as step one, then turn them into actionable queries

# Conclusions

### Insights
- **Python for Data Engineering:** Python was a very common skill for the highest paying jobs
- **Skills for Data Engineering:** Both SQL and Python were considered skills with high demand for Data Engineering, and they were the highest paying skills overall
- This study shows clearly that Python and SQL are the skills to learn if someone wants to get a career in data engineering

### Closing thoughts
This project showed me how to use SQL in a way that wasn't just sorting and building. I learned how to critically examine and investigate data using SQL and I even learned something about the data engineering job market in 2023.

I learned how to read and debug complex SQL queries that manipulate large sets of data.
