-- Movies Data Analysis using SQL

### to view tables

### right click moviesdb to set it as default schema

SELECT * FROM actors;
SELECT * FROM financials;
SELECT * FROM languages;
SELECT * FROM movie_actor;
SELECT * FROM movies;

### get title and industry 

SELECT title, industry from movies;

### get only Bollywood titles

SELECT * from movies where industry="Bollywood";

### get number of Bollywood titles 

SELECT COUNT(*) from movies where industry="bollywood";

### what are the industries?

SELECT DISTINCT industry from movies;

### get the titles with ‘THOR’ in them

SELECT * from movies where title LIKE 'THOR%';

### get rows where studio is blank

SELECT * FROM movies WHERE studio='';

### get titles where imdb_rating is between 6 and  8 including 6 and 8

SELECT * from movies where imdb_rating>=6 and imdb_rating <=8;

### get titles where release year is 2018 or 2019 or 2022

SELECT * from movies where release_year IN (2018,2019,2022);

### get titles where imdb_rating is null

SELECT * from movies where imdb_rating IS NULL;

### get only Bollywood  titles where imdb_rating is highest from 2nd onwards and only show 5 titles

SELECT * 
        from movies WHERE industry = "bollywood"
        ORDER BY imdb_rating DESC LIMIT 5 OFFSET 1;

### Retrieve Data Using Numeric Query

### get titles where release_year=2022 ordered by the highest imdb_rating
select * from movies where release_year>2020
order by imdb_rating desc

### get titles with the thor word and ordered by their release year

select title, release_year from movies
where title like '%thor%' order by release_year asc

### get movies that are not from marvel studios
select * from movies where studio!="marvel studios"

### get movies that are by marvel studios and hombale films
select * from movies where studio in ("marvel studios", "hombale films")

-- Summary Analytics

### get the lowest rating of all bollywood movies 
SELECT min(imdb_rating) FROM movies where industry ="bollywood"

### get the average rating of movies from Marvel studios and round it to 2 decimal places
SELECT round(avg(imdb_rating),2) FROM movies where studio ="Marvel studios"

### get the industry and their number of movies and the average rating of these movies 

SELECT 
industry, count(industry) as cnt,
avg(imdb_rating) as avg_rating
FROM movies 
group by industry

### get all the studios, their number of movies and the average rating 

SELECT 
studio, count(studio) as cnt,
round(avg(imdb_rating),1) as avg_rating
FROM movies 
where studio !=''
group by studio
order by avg_rating desc

### How many movies were released between 2015 and 2022

SELECT count(*) as cnt
FROM movies
where release_year<=2022 and release_year>=2015

### Print the max and min movie release year

SELECT min(release_year), max(release_year)
FROM movies

### Print a year and how many movies were released in that year starting with the latest year

SELECT release_year, count(*) as num_of_movies_in_that_year 
FROM movies
group by release_year 
order by release_year desc

-- HAVING Clause

### get all the years where more than 2 movies were released

select release_year, count(*) as movies_count
FROM movies 
group by release_year
having movies_count>2
order by movies_count desc

-- Calculated Columns (IF, CASE, YEAR, CURYEAR)

### get all the ages of the actors

SELECT *,
year(curdate())-birth_year as age from actors

### get profit (revenue-budget) from financials table

SELECT *, (revenue-budget) as profit FROM financials

### make a column, revenue_inr, to convert all revenue to INR

SELECT *, 
if (currency='usd', revenue*77,revenue) as revenue_inr
FROM financials

### Print profit % for all the movies

SELECT *,
ROUND((revenue-budget),2) as profit,
ROUND(((revenue-budget)*100/budget),2) as 'profit %'
FROM financials

### join movies tables and financials table using movie_id

SELECT
	movies.movie_id, title, budget, revenue, currency, unit
FROM movies
join financials
on movies.movie_id= financials.movie_id

### left join movies tables and financials table using movie_id
### left join show all movies but not the financials details and those shows as null.

SELECT
	f.movie_id, title, budget, revenue, currency, unit
FROM movies m
left join financials f
on m.movie_id= f.movie_id

### right join movies tables and financials table using movie_id
### right join show all financials but not the movies and those shows as null.

SELECT
	f.movie_id, title, budget, revenue, currency, unit
FROM movies m
right join financials f
on m.movie_id= f.movie_id

### get all Telugu movie names

SELECT title
FROM movies m
left join language l
on m.language_id=l.language_id
where l.language_id='Telugu'

### get number of movies for each language

select
l.name, count(m.movie_id) as no_movies

from movies m
left join language l using (language_id)
group by language_id
order by no_movies des

-- Analytics on Tables

### get bollywood movies and ordered based on amount of profit made

SELECT 
	m.movie_id, title, budget, revenue, currency, unit,
	(revenue-budget) as profit
from movies m
join financials f
on m.movie_id=f.movie_id
where industry ='bollywood'
order by profit desc

### get all titles and the number of movies with the same actor in them

SELECT a.name, group_concat(m.title separator " | ") as movies,
count(m.title) as movie_count

from actors a
join movie_actor ma on ma.actor_id= a.actor_id
join movies m on m.movie_id= ma.movie_id
group by a.actor_id
order by movie_count desc

-- Subqueries

### get the top 5 most popular titles based on rating

select *
from movies
order by imdb_rating desc
limit 5

### get the titles with rating 8.4 and 9.3

select *
from movies
where imdb_rating in (1.2,9.3) 

### get the actors whose age is between 75 and 85

select * from
(select 
name, year(curdate())-birth_year as age
from actors) as actor_age_table
where age >75 and age <85

### get number of movies each actor is in

select actor_id, name, 
(select count(*) 
from movie_actor where
actor_id=actors.actor_id) as movies_count
from actors
order by movies_count desc

### get all the rows from movies table whose imdb_rating is higher than the average rating

select * from movies where
imdb_rating> (select avg(imdb_rating) from movies)
 
 ### get actor name and age whose age >75 and age <85
 
 with actor_age as(
select
name as actor_name,
year(curdate()) - birth_year as age
from actors

)
select actor_name,age from actor_age where
age >75 and age <85

### get all hollywood movies released after year 2000 that made more than 500 millions $ profit 

with cte as (select title, release_year, (revenue-budget) as profit
		from movies m
		join financials f
		on m.movie_id=f.movie_id
		where release_year>2000 and industry="hollywood"
)
select * from cte where profit>500


