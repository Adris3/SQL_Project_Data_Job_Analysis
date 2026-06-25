/*
What are the most in-demand skills for data engineers?
- Join job postings to inner join table similar to query 2
- Identify the top 5 in-demand skills  for a data engineer
- Focus on all job postings (not just remote, or in Toronto)
*/

SELECT
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;

-- INSIGHT
/*
SQL and Python are topping the list making them
*/