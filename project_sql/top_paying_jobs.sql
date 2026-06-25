/*
What are the top-paying Data Engineer jobs?
- Identify the top 10 highest-paying roles that are available remotely
- Remove job postings with null salaries
*/

SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM
    job_postings_fact
WHERE 
    job_title_short = 'Data Engineer' AND
    job_location = 'Anywhere';