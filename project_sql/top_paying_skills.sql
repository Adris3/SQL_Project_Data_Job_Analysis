/*
What are the highest paying skills for data engineers?
- Repeat process for most in demand skills
- This time, sort by salary
*/

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

-- REMOTE WORK

SELECT
    skills,
    ROUND(AVG(salary_year_avg), 2)AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Engineer'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25;

-- TORONTO

SELECT
    skills,
    ROUND(AVG(salary_year_avg), 2)AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Engineer'
    AND salary_year_avg IS NOT NULL
    AND job_location = 'Toronto, ON, Canada'
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25;

-- Insight
/*
- While SQL and Python are in the most demand, node and mongo are the highest paid
- In remote work Assembly is now the highest paying skill, and Rust is now in the top 5
    - This suggests that there are a lot of specialized skills that are rewarded in Data Engineering for remote jobs
- In Toronto, the highest paying skill is no-sql
- When expanding to include top 25, C, Go, C++, and Java are included for Toronto
    - These languages are not in the top 25 for the other two tables
*/