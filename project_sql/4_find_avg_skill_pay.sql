/* 
Here, the average salaries associated with all job postings containing a given skill are calculated,
and the top 10 skills are extracted as such.
*/

SELECT
    skills_dim.skills,
    ROUND(AVG(salary_year_avg), 2) AS salary_avg
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Scientist' AND
    job_location LIKE '%UK' AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skills
ORDER BY
    salary_avg DESC

