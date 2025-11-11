-- Create table 
-- Insert data(Import for now)
-- EDA if the table 
Select * from netflix

-- Count rows: 8807
Select count(*) from netflix

-- View rows that has null values: 3475 
Select * from netflix where 
	show_id is Null OR	
	type is Null OR	
	title	is Null OR
	director	is Null OR
	casts	is Null OR
	country	is Null OR
	date_added	is Null OR
	release_year	is Null OR
	rating	is Null OR
	duration	is Null OR
	listed_in	is Null OR
	description is Null 

-- Business Queries 
--1. Count the number of Movies vs TV Shows
--Select * from netflix where rating ='84 min'
Select type,count(show_id) from netflix group by type

--2. Find the most common rating for movies and TV shows
-- Step 1: Create a temp table where I filtered type,rating and count of each ratings
-- Step 2: Use that temp table and Filter distinct types with max(count of each ratings)
CREATE TEMP table temp_rating_counts as 
Select type, rating, count(rating) as rate_count from netflix group by type,rating order by rate_count desc 
-- View that temp table 
Select * from temp_rate_counts
-- Used above table to filter the distinct types and their max ratings from the above counted list. 
Select Distinct type, max(rate_count) from temp_rating_counts group by type 


--List all movies released in a specific year (e.g., 2020)
Select * from netflix
Select distinct release_year from netflix order by release_year desc
Select * from netflix where type='Movie' and release_year=2020
-->> count=517, type=movies has been released on release year=2020


--4. Find the top 5 countries with the most content on Netflix
Select * from netflix where country is not null 

Select  country from netflix
-- Countries are repeated in array for a single movie, so we need to split them so that each country is listed as individual row
--Setp1: Split countries row wise and then list the countries with max contents

Select 
TRIM(UNNEST(STRING_TO_ARRAY(country,','))) as country,
count (*) as total_count
from netflix  group by country  Order by total_count desc Limit 5

With country_count as 
(
	Select 
	TRIM(UNNEST(STRING_TO_ARRAY(country,','))) as country,
	count (*) as total_count
	from netflix  group by country 
)
Select sum(total_count) from country_count 

--5. Identify the longest movie

Select * from netflix

Select * from netflix where type='Movie'
-- duration is in varchar type, so we need to split 1st and the convert that into int dataype to compare
With longest_movie as (
Select show_id,title,split_part(duration,' ',1)::INT as movie_duration from netflix where type='Movie'
) select   title, movie_duration from longest_movie where movie_duration=(select  max(movie_duration) from longest_movie)


-- OR Single line query 

Select show_id,title,split_part(duration,' ',1)::INT as movie_duration from netflix where type='Movie' AND duration is not null  order by movie_duration desc Limit 1 

--6. Find content added in the last 5 years
-- logic: get year from added date i.e from varchar data type, store in temp table and then
-- View datas, whose extracted Year >= current year -5 
Select * from netflix 
With temp_table as
(
	Select title,date_added,split_part(date_added,',',2)::int as date_added_new from netflix where date_added is not null order by date_added_new desc
)
Select title,date_added from temp_table where date_added_new >= Extract(Year from CURRENT_DATE)-5 ORDER by date_added_new asc

--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
Select * from netflix

Select * from netflix where director='Rajiv Chilaka' and director is not null

-- since there is list in director column, we need to convert string to array and UNesst  them 1st then get the desired output 
With temp_table as 
(
	Select show_id,type,title, TRIM(UNNEST(STRING_TO_ARRAY(director,','))) as director_new from netflix 
)
Select * from temp_table where director_new='Rajiv Chilaka'

--8. List all TV shows with more than 5 seasons
-- logic: Add a column in existing table where num part is extracted from duration column and then 
-- store in a temp table and now print values from that temp table that have duration_new>5 
With temp_table as
(
	Select *, split_part(duration,' ',1)::INT as new_duration from netflix where type='TV Show' 
) select * from temp_table where new_duration>5


--10. List all movies that are documentaries
With temp_table as 
(
	Select *,TRIM(UNNEST(STRING_to_ARRAY(listed_in,','))) as new_listed_in from netflix where type='Movie'  
) select * from temp_table where  new_listed_in='Documentaries'
--11. Find all content without a director
Select * from netflix where director is null

--12. Find how many movies actor 'Salman Khan' appeared in last 10 years!
Select * from netflix

With temp_table as 
(
	Select *,TRIM(UNNEST(STRING_to_ARRAY(casts,','))) as new_casts_in from netflix where type='Movie'  
) select * from temp_table where new_casts_in='Salman Khan' and release_year>=EXTRACT(YEAR from current_date)-10

--13. Find the top 10 actors who have appeared in the highest number of movies produced in India. 15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.
Select * from netflix

--logic Part 1: Repeat row for caste then repeat rows for country, now filter country India
-- Now from that table show distinct cast, count(*) as movie_count, order by movie count desc and limit 10
with t1 as 
(
	Select *,TRIM(UNNEST(string_to_array(casts,','))) as Cast_Wise from netflix 
),t2 as 
(
	Select *,TRIM(UNNEST(string_to_array(country,','))) as country_wise  from t1
),t3 as
( 
select * from t2 where country_wise='India'
) Select distinct Cast_Wise ,count(*) as movie_count from t3 group by Cast_Wise order by movie_count desc Limit 10
	
-- Logic Part 2: filter rows as good or Bad with CASE then count the output
--output
--"category"	"count"
--"Good"	8465
--"Bad"	342
With t1 as 
(
Select   
	CASE 
	 when description ilike'%Kill%' or description ilike '%violence%'  Then 'Bad'
	 Else 'Good'
	End as category
from netflix
)
select category, count(*) from t1 group by category

-- 9. Count the number of content items in each genre 10.Find each year and the average numbers of content release in India on netflix. return top 5 year with highest avg content release!
Select * from netflix

With temp_table as 
(
	Select *,TRIM(UNNEST(STRING_to_ARRAY(listed_in,','))) as new_listed_in from netflix where type='Movie'  
),t2 as (
	Select *,TRIM(UNNEST(STRING_to_ARRAY(country,','))) as new_country from temp_table
),t3 as(
select * from t2 where new_country='India'
)
SELECT 
    release_year,count(distinct show_id) AS total_movies   
    FROM t3
GROUP BY release_year




