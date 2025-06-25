-- Buisness Problems Solutions


--Q1  Count the number of Movies vs TV Shows
 select  type, count(*) as total_content
	 from netflix
group by type;

--Q2 Find the most common rating for movies and TV shows
select
	type,
	rating
	from
(
	select 
	type ,
	rating,
	count(*),
	Rank() over(partition by type order by count(*) DESC ) AS ranking
from netflix
group by 1,2
order by 1, 3 desc
) as t1
where ranking=1;

--Q3. List all movies released in a specific year (e.g., 2020)
select
	*
from netflix
	where type='Movie'
	AND
	release_year=2020


--Q4. Find the top 5 countries with the most content on Netflix
select * from netflix;

select 
	UNNEST (STRING_TO_ARRAY(country,','))as new_country ,
	count(show_id) as total_content
from netflix
group by 1 
order by 2 desc
limit 5;

--Q5. Identify the longest movie
select
	*
from netflix
where type='Movie'
	AND
	duration=(select max(duration) from netflix);

--Q6. Find content added in the last 5 years
select 
	*
from netflix 
where 
	TO_DATE(date_added,'Month DD,YYYY') >= Current_Date - Interval '5 years';  

--Q7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
SELECT title,Type,director from netflix
where director Ilike '%Rajiv Chilaka%';


--Q8. List all TV shows with more than 5 seasons
Select *
from netflix
where type='TV Show'
AND   SPLIT_PART(duration,' ',1) > '5 sessions'


--Q9. Count the number of content items in each genre
select * from netflix;

select  
	UNNEST(STRING_TO_ARRAY(listed_in,',')) as genre ,
	 count(show_id)
from netflix
group by 1;


--Q10.Find each year and the average numbers of content release in India on netflix. 
SELECT 
	country,
	release_year,
	COUNT(show_id) as total_release,
	ROUND(COUNT(show_id)::numeric/(SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100 ,2)as avg_release
FROM netflix
WHERE country = 'India' 
GROUP BY country, 2
ORDER BY avg_release DESC 
LIMIT 5

--Q11. List all movies that are documentaries

select * 
from netflix
where listed_in Ilike '%documentaries%'
	and Type='Movie'


--Q12. Find all content without a director
select show_id
from  Netflix
where director is Null;

--Q13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
select * 
from netflix
where casts ILIKE '%Salman Khan%'
AND release_year > Extract(Year from Current_Date)- 10


--Q14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

select 
	--show_id,casts,
	UNNEST(STRING_TO_ARRAY(casts,',')) AS actor,
	count(*) as total_content
 from netflix 
	where country ILIKE '%India%'
group by 1
order by 2 desc
limit 10;

/*
15.
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.

*/
select description from netflix;

with new_table
as (
select 
		*,
	case 
	when  description ILIKE '%Kill%' OR
		   description ILIKE '%Violence%' Then 'Bad Content'
		 else 'Good Comtent'
	End Category
From netflix
)
select category,
	count(*) as total_content
from new_table
group by 1;

















