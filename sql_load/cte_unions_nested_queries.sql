SELECT *
FROM (Select * from job_postings_fact
WHERE EXTRACT(month FROM job_posted_date) = 1) AS january_jobs;


WITH january_jobs AS (
  SELECT *
  FROM job_postings_fact
  WHERE EXTRACT(month FROM job_posted_date) = 1
)

SELECT * from january_jobs;








with company_job_count AS (
SELECT company_id, COUNT(*) AS total_jobs
FROM job_postings_fact
GROUP BY company_id
)


SELECT company_dim.name AS company_name,
  company_job_count.total_jobs
FROM company_dim
JOIN company_job_count
ON company_job_count.company_id = company_dim.company_id
ORDER BY total_jobs DESC


 
with remote_job_skills AS (
  SELECT skill_id,
  count(*) as skill_count
  FROM skills_job_dim as skills_to_job
  INNER join job_postings_fact as job_postings ON job_postings.job_id = skills_to_job.job_id
  WHERE job_postings.job_work_from_home = TRUE AND job_postings.job_title_short = 'Data Analyst'
  group by skill_id
)

select skills.skill_id,
 skills as skill_name,
 skill_count
from remote_job_skills
INNER JOIN skills_dim as skills ON skills.skill_id = remote_job_skills.skill_id
ORDER by skill_count DESC
limit 5;


SELECT
  job_title_short,
  company_id,
  job_location
  FROM
  january_job

UNION ALL

SELECT
  job_title_short,
  company_id,
  job_location
  FROM
  february_job

  UNION ALL

  SELECT
  job_title_short,
  company_id,
  job_location
  FROM
  march_job;



SELECT 
quarter1_job_postings.job_title_short,
quarter1_job_postings.job_location,
quarter1_job_postings.job_via,
quarter1_job_postings.job_posted_date::date
 FROM (
SELECT
*
FROM january_job

UNION ALL

SELECT
*
FROM february_job

UNION ALL

SELECT
* 
FROM march_job
) as quarter1_job_postings
where 
 quarter1_job_postings.salary_year_avg > 70000 AND
 job_title_short = 'Data Analyst' 
 order BY quarter1_job_postings.salary_year_avg DESC