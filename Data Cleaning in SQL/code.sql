select * 
from layoffs;

-- 1. remove duplicates

 
select *,row_number() over (partition by company,location,industry,total_laid_off,
	percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
from layoffs
order by row_num desc;

-- creating a duplicate table 

create table layoffs_staging
like layoffs;



-- inserting values

insert into layoffs_staging
select *
from layoffs;


select * , row_number()  over (partition by company, location, industry,
 total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
from layoffs_staging
order by row_num desc;

-- creating a CTE 

WITH duplicate_cte as (

select * , row_number()  over (partition by company, location, industry,
 total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
from layoffs_staging
)
select *
from duplicate_cte
where  row_num >1;

select * 
from layoffs
where company = "Casper";

-- creating another table to store the row_num


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- insrting row_num column as well

insert into layoffs_staging2
select * , row_number()  over (partition by company, location, industry,
 total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
from layoffs_staging;


select * 
from layoffs_staging2;

-- delete the duplicates 

delete 
from layoffs_staging2
where row_num >1;

-- standardizing data 

select company, trim(company)
from layoffs_staging2;

-- removing whitespaces before and after company

update  layoffs_staging2
set company = trim(company);

select * 
from layoffs_staging2;

select  *
from layoffs_staging2
where industry like "Crypto%"
;

update layoffs_staging2
set industry = "Crypto"
where industry like "Crypto%";

-- checking other cloumns, united states is repeated

select distinct country 
from layoffs_staging2
order by 1;

select distinct country
from layoffs_staging2
where country like "United States%";


update layoffs_staging2
set country = "United States"
where country like 'United States%';

-- date is in str >> we need to covert it into date function
select * 
from layoffs_staging2;

select date, str_to_date(`date`,' %m/%d/%Y ' )
from layoffs_staging2;

update layoffs_staging2
set `date` = str_to_date(`date`,' %m/%d/%Y ' );

ALTER TABLE layoffs_staging2
MODIFY `date` date;


select *
from layoffs_staging2;

-- 3.working with nulls and blanks

select *
from layoffs_staging2
where industry is null or industry  = "";

select *
from layoffs_staging2
where company = "Airbnb";

-- we are update the industry nulls to the values that are already given

select t1.industry , t2.industry
from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company 
where (t1.industry is null or t1.industry = "" ) and t2.industry is not null ;

update layoffs_staging2
set industry = null
where industry = "";

update layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company 
set t1.industry = t2.industry 
where (t1.industry is null or t1.industry = "") 
and t2.industry is not null;

-- 4. removing unwanted rows and columns

select *
from layoffs_staging2
where total_laid_off is null and percentage_laid_off is null;


delete 
from layoffs_staging2
where total_laid_off is null and percentage_laid_off is null;

select * 
from layoffs_staging2;

-- dropping the row_num coulmn

alter table layoffs_staging2
drop column row_num;


select * 
from layoffs_staging2;



