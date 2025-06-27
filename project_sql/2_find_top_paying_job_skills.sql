/* 
Here, the 50 top-paying Data Scientist jobs based in the UK are identified,
and the skills required for these high-paying jobs are found. From the arising table,
the top 10 frequently-appearing skills are found, along with their percentage of frequency among these postings.
*/

WITH top_data_science_jobs_skills AS ( -- This adds to top_data_science_jobs, records about all skills corresponding to each job posting.

    WITH top_data_science_jobs AS ( -- This extracts the key desired info about the top-paying jobs from job_postings_fact, with conditions on job title and job location.
        SELECT
            job_id,
            job_title,
            job_location,
            salary_year_avg,
            job_posted_date
        FROM
            job_postings_fact
        WHERE
            salary_year_avg IS NOT NULL AND
            job_title_short = 'Data Scientist' AND
            job_location LIKE '%UK'
        ORDER BY salary_year_avg DESC
        LIMIT 50
    )

    SELECT 
            top_data_science_jobs.*,
            skills_dim.skills
    FROM top_data_science_jobs
    INNER JOIN skills_job_dim ON top_data_science_jobs.job_id = skills_job_dim.job_id
    LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id

),


total_job_count AS ( -- This calculates the the total number of jobs (job_ids) in the top_data_science_jobs_skills table.
    SELECT COUNT(DISTINCT job_id) AS total_jobs
    FROM top_data_science_jobs_skills
)


SELECT 
    top_data_science_jobs_skills.skills,
    COUNT(*) AS skill_count,
    ROUND(((COUNT(*)::FLOAT / (SELECT total_jobs FROM total_job_count)) * 100)::numeric, 1) AS skill_percentage
FROM
    top_data_science_jobs_skills
GROUP BY 
    skills
ORDER BY 
    skill_percentage DESC
LIMIT 10