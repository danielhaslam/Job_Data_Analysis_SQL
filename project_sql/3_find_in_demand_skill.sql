/* 
Here, the top 10 skills most-sought after, among all Data Science jobs based in the UK, are identified, and their frequency of appearance
in job postings is calculated.
*/

WITH find_total_jobs AS ( -- This calculates the the total number of jobs (job_ids) in the job_postings_fact table.
    SELECT 
        COUNT(DISTINCT job_id) AS total_jobs
    FROM 
        job_postings_fact
    WHERE
        job_title_short = 'Data Scientist' AND
        job_location LIKE '%UK'
)

SELECT
    skills,
    COUNT(skills_job_dim.*) AS number_of_demands,
    ROUND((COUNT(skills_job_dim.*)::NUMERIC / (SELECT total_jobs FROM find_total_jobs) * 100), 1) AS percentage
FROM    
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Scientist' AND
    job_location LIKE '%UK'
GROUP BY
    skills
ORDER BY
    number_of_demands DESC
LIMIT 10 