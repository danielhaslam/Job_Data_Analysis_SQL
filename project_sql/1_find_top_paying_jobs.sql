/* 
Here, the highest-paying Data Scientist jobs are found, alongside the names of the companies corresponding to the company_id values in 
those records.
*/

SELECT
    job_postings_fact.job_id AS job_id,
    company_dim.name AS company_name,
    job_location,
    salary_year_avg::INT,
    job_posted_date
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Scientist' AND
    (job_location LIKE '%UK' OR job_location = 'United Kingdom')
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 50
