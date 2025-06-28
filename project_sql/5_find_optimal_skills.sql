/* 
Here, queries 3 and 4 are combined to investigate the optimal skills to have for Data
Science jobs in the UK, based on both average salary, and demand.
*/

WITH skill_demand AS (
    WITH find_total_jobs AS ( -- This calculates the the total number of jobs (job_ids) in the job_postings_fact table.
    SELECT 
        COUNT(DISTINCT job_id) AS total_jobs
    FROM 
        job_postings_fact
    WHERE
        job_title_short = 'Data Scientist' AND
        job_location LIKE '%UK' AND
        salary_year_avg IS NOT NULL
)

    SELECT
        skills_dim.skill_id,
        skills,
        COUNT(skills_job_dim.*) AS number_of_demands,
        ROUND((COUNT(skills_job_dim.*)::NUMERIC / (SELECT total_jobs FROM find_total_jobs) * 100), 1) AS percentage
    FROM    
        job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Scientist' AND
        job_location LIKE '%UK' AND
        salary_year_avg IS NOT NULL
    GROUP BY
        skills_dim.skill_id
),

skill_pay_avg AS (
    SELECT
        skills_dim.skill_id,
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
        skills_dim.skill_id
)

SELECT
    skill_pay_avg.skills,
    skill_pay_avg.salary_avg,
    skill_demand.number_of_demands,
    skill_demand.percentage
FROM
    skill_pay_avg
INNER JOIN skill_demand ON skill_pay_avg.skill_id = skill_demand.skill_id
ORDER BY salary_avg DESC
