/*
1962 movies
=======================================
1. List the films where the yr is 1962 [Show id, title]
*/

SELECT id, title FROM movie
	WHERE yr=1962


/*
When was Citizen Kane released?
=======================================
2. Give year of 'Citizen Kane'.
*/

SELECT yr FROM movie
	WHERE title='Citizen Kane'


/*
Star Trek movies
=======================================
3. List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). Order results by year.
*/

SELECT id, title, yr FROM movie
	WHERE title LIKE '%Star%'
	AND title LIKE '%Trek%'


/*
id for actor Glenn Close
=======================================
4. What id number does the actor 'Glenn Close' have?
*/

SELECT id FROM actor
	WHERE name LIKE 'Glenn Close'


/*
id for Casablanca
=======================================
5. What is the id of the film 'Casablanca'
*/

SELECT id FROM movie
	WHERE title like 'Casablanca'


/*
Cast list for Casablanca
=======================================
6. Obtain the cast list for 'Casablanca'.
Use movieid=11768, (or whatever value you got from the previous question)
*/

SELECT name FROM casting JOIN actor ON id=actorid
	WHERE movieid=11768


/*
Alien cast list
=======================================
7. Obtain the cast list for the film 'Alien'
*/

SELECT name FROM casting JOIN actor ON id=actorid
	WHERE movieid=( SELECT id FROM movie WHERE title='Alien' )


/*
Harrison Ford movies
=======================================
8. List the films in which 'Harrison Ford' has appeared
*/

SELECT title FROM movie JOIN casting ON movieid=id
WHERE actorid = ( SELECT id FROM actor WHERE name='Harrison Ford' )


/*
Harrison Ford as a supporting actor
=======================================
9. List the films where 'Harrison Ford' has appeared - but not in the starring role. [Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role]
*/

SELECT title FROM movie JOIN casting ON movieid=id
	WHERE actorid = ( SELECT id FROM actor WHERE name='Harrison Ford' )
	AND ord<>1


/*
Lead actors in 1962 movies
=======================================
10. List the films together with the leading star for all 1962 films.
*/

SELECT (SELECT title FROM movie WHERE id=movieid) as title, name FROM casting JOIN actor ON id=actorid
	WHERE movieid IN ( SELECT id FROM movie WHERE yr = 1962 )
	AND ord=1


/*
Busy years for John Travolta
=======================================
11. Which were the busiest years for 'John Travolta', show the year and the number of movies he made each year for any year in which he made more than 2 movies.
*/

SELECT yr,COUNT(title) FROM
  movie JOIN casting ON movie.id=movieid
         JOIN actor   ON actorid=actor.id
where name='John Travolta'
GROUP BY yr
HAVING COUNT(title)=(SELECT MAX(c) FROM
(SELECT yr,COUNT(title) AS c FROM
   movie JOIN casting ON movie.id=movieid
         JOIN actor   ON actorid=actor.id
 where name='John Travolta'
 GROUP BY yr) AS t
)


/*
Lead actor in Julie Andrews movies
=======================================
12. List the film title and the leading actor for all of the films 'Julie Andrews' played in.
*/

SELECT DISTINCT title, 
(SELECT name FROM actor JOIN casting ON actor.id=casting.actorid WHERE movieid=m.id AND ord=1) AS name
FROM movie AS m JOIN casting ON casting.movieid = m.id JOIN actor ON actor.id = casting.actorid 
	WHERE actor.name='Julie Andrews'


/*
Actors with 30 leading roles
=======================================
13. Obtain a list, in alphabetical order, of actors who've had at least 30 starring roles.
*/

SELECT m.name FROM 
(SELECT name, COUNT(actorid) AS count FROM actor JOIN casting ON actor.id=casting.actorid AND casting.ord=1 GROUP BY name) AS m
	WHERE m.count >= 30


/*
14. List the films released in the year 1978 ordered by the number of actors in the cast, then by title.
*/

SELECT title, COUNT(actorid) AS count FROM movie JOIN casting ON movie.id = casting.movieid JOIN actor ON casting.actorid = actor.id
	WHERE movie.yr=1978
	GROUP BY title
	ORDER BY count DESC, title


/*
15. List all the people who have worked with 'Art Garfunkel'.
*/

SELECT name FROM actor  JOIN casting ON casting.actorid = actor.id 
	WHERE casting.movieid IN (SELECT DISTINCT movie.id 
		FROM movie JOIN casting ON movie.id = casting.movieid JOIN actor ON actor.id=casting.actorid
		WHERE actor.name='Art Garfunkel')
	AND name NOT LIKE 'Art Garfunkel'

