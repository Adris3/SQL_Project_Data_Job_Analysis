/*
Question: What skills are required for the top-paying data engineer jobs?
- Use the top 10 highest-paying Data Enineer jobs from the first query 
- Add the specific skills required for these roles
- Shows a detailed look at which skills are required for each high-paying job, helping 
  job seekers better understand what to practice  
- Conduct this for both remote jobs and jobs located in Toronto, ON, Canada
*/

-- Top paying remote jobs

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

SELECT * FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id;



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