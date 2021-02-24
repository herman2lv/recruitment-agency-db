CREATE DATABASE recruitment_agency; --create database for recruitment agency

CREATE TABLE services_for_candidates --create table which contains list of packages of services for candidates and their description
    (package_of_services_id serial PRIMARY KEY NOT NULL, --primary key, used as foreign key in table candidates
    package_of_services_name TEXT NOT NULL,
    personal_assistant boolean NOT NULL, --boolean has been chosen because this column describes whether this service included in the package or not
    preparing_for_interview boolean NOT NULL, --boolean has been chosen because this column describes whether this service included in the package or not
    priority_level SMALLINT NOT NULL CHECK (priority_level IN (1, 2, 3, 4, 5)), --level of priority of candidate using the certain package, ranges from 1 to 5
    duration SMALLINT NOT NULL CHECK (duration > 0), --length of the contract according to a package conditions, measured in months
    cost numeric(7,2)); --cost of the package, USD, floating number because of cents

CREATE TABLE candidates
    (candidate_id serial PRIMARY KEY NOT null, --primary key for this table and foreign key for several tables
    first_name TEXT NOT NULL, 
    last_name TEXT NOT NULL,
    date_of_birth date,
    location TEXT NOT NULL, --just city, of course, it's better to create a separate table for the address but it's just training database))
    nationality TEXT, --just nationality (citizenship), of course, it's better to create a separate table but it's just training database
    education TEXT CHECK (education IN ('high', 'incomplete high', 'high school', 'other')), --describes candidates education according to the classification adopted in the agency
    sex char CHECK (sex IN ('M', 'F')), --gets only two values - M (stands for male) and F (for female)
    email TEXT,
    contact_phone TEXT,
    package_of_services_id integer REFERENCES services_for_candidates, --references on the primary key of the services_for_candidates table
    additinal_info TEXT);

CREATE TABLE education
    (education_record_id serial PRIMARY KEY NOT NULL,
    candidate_id integer NOT NULL REFERENCES candidates,
    name_of_organization text,
    start_date date CHECK (start_date < current_date), --table contains data only about actual education, that's why it can't get start date after current date
    end_date date CHECK (end_date > start_date), --if end date after start date of studing it's nonsens and it means that sombody made a mistake
    diploma_no text,
    department_faculty text,
    field_of_study text,
    education_level TEXT CHECK (education_level IN ('high', 'incomplete high', 'high school', 'other')), --describes candidates education according to the classification adopted in the agency
    average_grade numeric(5,2), --average grade, floating number for more precise values
    degree TEXT CHECK (degree IN ('PhD', 'MD', 'bachelor', 'master', 'specialist', 'other')), --describes candidates dergree according to the classification adopted in the agency
    additinal_info text);

CREATE TABLE work_experience
    (work_record_id serial PRIMARY KEY NOT NULL,
    candidate_id integer NOT NULL REFERENCES candidates,
    name_of_organization text,
    job_title TEXT NOT NULL,
    start_date date CHECK (start_date < current_date), --table contains data only about actual work experience, that's why it can't get start date after current date
    end_date date CHECK (end_date > start_date), --if end date after start date of studing it's nonsens and it means that sombody made a mistake
    responsibilities_description text,
    additinal_info text);

CREATE TABLE skills --list of skills and theit IDs
    (skill_id serial PRIMARY KEY NOT NULL,
    name text NOT NULL);

CREATE TABLE candidates_skills --associative table created to implement many-to-many relationship between candidates and skills
    (candidate_id integer NOT NULL REFERENCES candidates,
    skill_id integer NOT NULL REFERENCES skills);

CREATE TABLE areas --list of areas and their IDs
    (area_id serial PRIMARY KEY NOT NULL,
    name text NOT NULL);

CREATE TABLE candidates_areas --associative table created to implement many-to-many relationship between candidates and areas
    (candidate_id integer NOT NULL REFERENCES candidates,
    area_id integer NOT NULL REFERENCES areas);

CREATE TABLE services_for_companies --table which contains list of packages of services for companies and their description
    (package_of_services_id serial PRIMARY KEY NOT NULL, --primary key, used as foreign key in table companies
    package_of_services_name TEXT NOT NULL,
    preinterviewing_of_candidates boolean NOT NULL, --boolean has been chosen because this column describes whether this service included in the package or not
    internal_estimation_of_candidates boolean NOT NULL, --boolean has been chosen because this column describes whether this service included in the package or not
    priority_level SMALLINT NOT NULL CHECK (priority_level IN (1, 2, 3, 4, 5)), --level of priority of company using the certain package, ranges from 1 to 5
    duration SMALLINT NOT NULL CHECK (duration > 0), --length of the contract according to a package conditions, measured in months
    cost numeric(7,2)); --cost of the package, USD, floating number because of cents

CREATE TABLE companies --list of companies
    (company_id serial PRIMARY KEY NOT NULL,
    name text NOT NULL,
    hq_location text,
    email text,
    contact_phone text,
    package_of_services_id integer REFERENCES services_for_companies,
    additioanl_info text);

CREATE TABLE jobs --list of jobs
    (job_id serial PRIMARY KEY NOT NULL,
    title text NOT NULL,
    employment_type text,
    company_id integer REFERENCES companies,
    office_location text NOT NULL,
    required_education text NOT NULL,
    salary integer,
    resposibilities_description text,
    social_package text);

CREATE TABLE jobs_skills --an associative table created to implement many-to-many relationship between jobs and skills
    (job_id integer NOT NULL REFERENCES jobs,
    skill_id integer NOT NULL REFERENCES skills);

CREATE TABLE jobs_areas --an associative table created to implement many-to-many relationship between jobs and areas
    (job_ib integer NOT NULL REFERENCES jobs,
    area_id integer NOT NULL REFERENCES areas);

INSERT INTO areas (name) --insert only names because ID column will be filled itself
VALUES  ('Management'),
        ('Engineering'),
        ('Medicine'),
        ('Design'),
        ('Law'),
        ('Art'),
        ('Sport'),
        ('Agriculture');

INSERT INTO skills (name) --insert only names because ID column will be filled itself
VALUES  ('Team work'),
        ('Analytical skills'),
        ('SQL'),
        ('Leadership'),
        ('Communication'),
        ('Problem solving'),
        ('PostgreSQL'),
        ('Core Java'),
        ('Git'),
        ('JIRA'),
        ('Atlassian products'),
        ('English'),
        ('Russian'),
        ('Tractor driver license'),
        ('German');

INSERT INTO services_for_candidates (package_of_services_name, personal_assistant, preparing_for_interview, priority_level, duration, cost) --insert data without ID, because this column will be filled itself
VALUES  ('Basic', FALSE, FALSE, 1, 1, 99.99),
        ('Standard', FALSE, TRUE, 3, 3, 149.99),
        ('Premium', TRUE, TRUE, 5, 6, 299.99);

INSERT INTO services_for_companies (package_of_services_name, preinterviewing_of_candidates, internal_estimation_of_candidates, priority_level, duration, COST) --insert data without ID, because this column will be filled itself
VALUES  ('Enterprise standard', FALSE, FALSE, 1, 3, 9990.00),
        ('Enterprise full set', TRUE, TRUE, 3, 6, 35490.00),
        ('Enterprise premium', TRUE, TRUE, 5, 12, 49999.99);

--insert data about candidates  
INSERT INTO candidates (first_name, last_name, date_of_birth, LOCATION, nationality, education, sex, email, contact_phone, package_of_services_id)
SELECT 'Alexander', 'Showsenko', date '1954-08-30', 'Minsk', 'Belarus', 'high', 'M', NULL, +375630081954, services_for_candidates.package_of_services_id
FROM services_for_candidates
WHERE services_for_candidates.package_of_services_name = 'Basic';

INSERT INTO candidates (first_name, last_name, date_of_birth, LOCATION, nationality, education, sex, email, contact_phone, package_of_services_id)
SELECT 'Elizabeth', 'Windsor', date '1926-04-21', 'London', 'United kingdom', 'high', 'F', NULL, +44721041926, services_for_candidates.package_of_services_id
FROM services_for_candidates
WHERE services_for_candidates.package_of_services_name = 'Premium';

--inser data about candidates skills and areas of interest
INSERT INTO candidates_areas 
SELECT candidates.candidate_id, (SELECT area_id FROM areas WHERE name = 'Agriculture')
FROM candidates 
WHERE candidates.last_name = 'Showsenko' AND candidates.first_name = 'Alexander';

INSERT INTO candidates_areas 
SELECT candidates.candidate_id, (SELECT area_id FROM areas WHERE name = 'Mangement')
FROM candidates 
WHERE candidates.last_name = 'Showsenko' AND candidates.first_name = 'Alexander';

INSERT INTO candidates_areas 
SELECT candidates.candidate_id, (SELECT area_id FROM areas WHERE name = 'Mangement')
FROM candidates 
WHERE candidates.last_name = 'Windsor' AND candidates.first_name = 'Elizabeth';

INSERT INTO candidates_areas 
SELECT candidates.candidate_id, (SELECT area_id FROM areas WHERE name = 'Art')
FROM candidates 
WHERE candidates.last_name = 'Windsor' AND candidates.first_name = 'Elizabeth';

INSERT INTO candidates_skills 
SELECT candidates.candidate_id, (SELECT skill_id FROM skills WHERE name = 'Leadership')
FROM candidates 
WHERE candidates.last_name = 'Windsor' AND candidates.first_name = 'Elizabeth';

INSERT INTO candidates_skills 
SELECT candidates.candidate_id, (SELECT skill_id FROM skills WHERE name = 'Communication')
FROM candidates 
WHERE candidates.last_name = 'Windsor' AND candidates.first_name = 'Elizabeth';

INSERT INTO candidates_skills 
SELECT candidates.candidate_id, (SELECT skill_id FROM skills WHERE name = 'Problem solving')
FROM candidates 
WHERE candidates.last_name = 'Windsor' AND candidates.first_name = 'Elizabeth';

INSERT INTO candidates_skills 
SELECT candidates.candidate_id, (SELECT skill_id FROM skills WHERE name = 'Tractor driver license')
FROM candidates 
WHERE candidates.last_name = 'Showsenko' AND candidates.first_name = 'Alexander';

--inser data about companies
INSERT INTO companies (name, hq_location, email, contact_phone, package_of_services_id)
SELECT 'Vova & Friends', 'Moscow', 'gangster@kremlin.ru', NULL, services_for_companies.package_of_services_id 
FROM services_for_companies 
WHERE services_for_companies.package_of_services_name = 'Enterprise premium';

INSERT INTO companies (name, hq_location, email, contact_phone, package_of_services_id)
SELECT 'St Duda Church', 'Warsaw', 'nationalist@polska.pl', NULL, services_for_companies.package_of_services_id 
FROM services_for_companies 
WHERE services_for_companies.package_of_services_name = 'Enterprise standard';

--insert data about jobs
INSERT INTO jobs (title, employment_type, company_id, office_location, required_education, salary, resposibilities_description, social_package)
SELECT 'Governor', 'full', companies.company_id, 'Minsk', 'high school', 500, NULL, 'According to the federal law "About the status of government service"'
FROM companies 
WHERE companies."name" = 'Vova & Friends';

INSERT INTO jobs (title, employment_type, company_id, office_location, required_education, salary, resposibilities_description, social_package)
SELECT 'Bishop', 'part-time', companies.company_id, 'Minsk', 'incomplete high', 1500, NULL, NULL
FROM companies 
WHERE companies."name" = 'St Duda Church';

--insert info abput jobs required skills and related areas
INSERT INTO jobs_areas 
SELECT jobs.job_id, (SELECT area_id FROM areas WHERE name = 'Agriculture')
FROM jobs 
WHERE jobs.title = 'Governor';

INSERT INTO jobs_areas 
SELECT jobs.job_id, (SELECT area_id FROM areas WHERE name = 'Management')
FROM jobs 
WHERE jobs.title = 'Bishop';

INSERT INTO jobs_skills 
SELECT jobs.job_id, (SELECT skill_id FROM skills WHERE name = 'Problem solving')
FROM jobs 
WHERE jobs.title = 'Bishop';

INSERT INTO jobs_skills 
SELECT jobs.job_id, (SELECT skill_id FROM skills WHERE name = 'Team work')
FROM jobs 
WHERE jobs.title = 'Bishop';

INSERT INTO jobs_skills 
SELECT jobs.job_id, (SELECT skill_id FROM skills WHERE name = 'Tractor driver license')
FROM jobs 
WHERE jobs.title = 'Governor';

--insert detailed data about candidates education 
INSERT INTO education (candidate_id, name_of_organization, start_date, end_date, diploma_no, department_faculty, field_of_study, education_level, average_grade, "degree")
SELECT candidates.candidate_id, 'Agriculture academy', date '1981-09-01', date '1985-06-25', 'AGL12313', NULL, 'Agriculture', 'high', 3.0, 'specialist'
FROM candidates 
WHERE candidates.last_name = 'Showsenko' AND candidates.first_name = 'Alexander';

INSERT INTO education (candidate_id, name_of_organization, start_date, end_date, diploma_no, department_faculty, field_of_study, education_level, average_grade, "degree")
SELECT candidates.candidate_id, 'Oxford', date '1944-09-01', date '1950-05-06', NULL, 'St Geogre college', 'Martial arts', 'high', 4.97, 'master'
FROM candidates 
WHERE candidates.last_name = 'Windsor' AND candidates.first_name = 'Elizabeth';

--insert detailed data about candidates work experience 
INSERT INTO work_experience (candidate_id, name_of_organization, job_title, start_date, end_date)
SELECT candidates.candidate_id, 'Kolhoz im.Lenina', 'Supreme chairman', date '1994-07-20', date '2020-09-23'
FROM candidates 
WHERE candidates.last_name = 'Showsenko' AND candidates.first_name = 'Alexander';

INSERT INTO work_experience (candidate_id, name_of_organization, job_title, start_date)
SELECT candidates.candidate_id, 'British monarchy', 'Queen', date '1952-02-06'
FROM candidates 
WHERE candidates.last_name = 'Windsor' AND candidates.first_name = 'Elizabeth';

--add column "record_ts" with default value of current date to all tables
ALTER TABLE services_for_candidates 
ADD COLUMN record_ts date NOT NULL DEFAULT current_date;

ALTER TABLE education 
ADD COLUMN record_ts date NOT NULL DEFAULT current_date;

ALTER TABLE work_experience 
ADD COLUMN record_ts date NOT NULL DEFAULT current_date;

ALTER TABLE candidates 
ADD COLUMN record_ts date NOT NULL DEFAULT current_date;

ALTER TABLE candidates_skills 
ADD COLUMN record_ts date NOT NULL DEFAULT current_date;

ALTER TABLE candidates_areas 
ADD COLUMN record_ts date NOT NULL DEFAULT current_date;

ALTER TABLE skills 
ADD COLUMN record_ts date NOT NULL DEFAULT current_date;

ALTER TABLE areas 
ADD COLUMN record_ts date NOT NULL DEFAULT current_date;

ALTER TABLE jobs_areas 
ADD COLUMN record_ts date NOT NULL DEFAULT current_date;

ALTER TABLE jobs_skills 
ADD COLUMN record_ts date NOT NULL DEFAULT current_date;

ALTER TABLE jobs 
ADD COLUMN record_ts date NOT NULL DEFAULT current_date;

ALTER TABLE companies 
ADD COLUMN record_ts date NOT NULL DEFAULT current_date;

ALTER TABLE services_for_companies 
ADD COLUMN record_ts date NOT NULL DEFAULT current_date;