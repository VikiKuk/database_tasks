--Таблица для отображения значений музыкант, жанр, альбомы музыканта, год, трек и коллекция
SELECT m.name_pseudonym, mg.name AS genre_name, a.name AS album_name, a."year", t.name AS track_name, t.duration, 
c."name" AS collection_name
FROM musician m
LEFT JOIN musician_genre_link ml ON ml.musician_id = m.musician_id
LEFT JOIN musical_genre mg ON mg.genre_id = ml.genre_id
LEFT JOIN musician_album_link mal ON mal.musician_id = m.musician_id
LEFT JOIN album a ON a.album_id = mal.album_id
LEFT JOIN track t ON t.album_id = a.album_id
LEFT JOIN collection_track_link ctl ON ctl.track_id = t.track_id
LEFT JOIN collection c ON c.collection_id = ctl.collection_id



--Задание 2 
--1. Название и продолжительность самого длительного трека.
SELECT name, duration
FROM track t
WHERE duration = (SELECT max (duration) FROM track);

--2. Название треков, продолжительность которых не менее 3,5 минут.
SELECT name, duration
FROM track t
WHERE duration >= 210;

--3. Названия сборников, вышедших в период с 2018 по 2020 год включительно.
SELECT name AS name_collection, "year"
FROM collection c
WHERE YEAR >= 2018 AND YEAR <= 2020

--3. Additional. Названия сборников, в которые вошли альбомы, вышедшие в период с 2018 по 2020 год включительно.
SELECT a.name AS album_name, a.year AS album_year, a.album_id, t.*, ctl.*, c."name"
FROM album a
JOIN track t ON t.album_id = a.album_id
JOIN collection_track_link ctl ON ctl.track_id = t.track_id
JOIN collection c ON c.collection_id = ctl.collection_id
WHERE a.year >= 2018 AND a.year <= 2020

--4. Исполнители, чьё имя состоит из одного слова.
SELECT name_pseudonym
FROM musician m
WHERE name_pseudonym NOT LIKE '% %'

--5. Название треков, которые содержат слово «мой» или «my».
SELECT name FROM track t 
WHERE name ~* '(\mmy\M)' OR 
name ILIKE '% Мой' OR -- не нашла вариантов, когда ILIKE регистронезависимый с кириллицей
name ILIKE '% Мой %' OR 
name ILIKE 'Мой %' OR 
name ILIKE '% мой' OR
name ILIKE '% мой %' OR 
name ILIKE 'мой %'


--Задание 3.
--1. Количество исполнителей в каждом жанре.
SELECT mg.name, COUNT(musician_id) AS count_of_musician /* Имена жанров и количество айди исполнителей из промежуточной таблицы */
FROM musical_genre mg  /* Из таблицы жанров */
LEFT JOIN musician_genre_link mgl ON mgl.genre_id = mg.genre_id /* Объединяем с промежуточной таблицей между жанрами и исполнителями */
GROUP BY mg.genre_id /* Группируем по айди жанров */

--2. Количество треков, вошедших в альбомы 2019–2020 годов.
SELECT COUNT(DISTINCT(track_id))
FROM album a
JOIN track t ON
t.album_id = a.album_id
WHERE YEAR >= 2019 AND YEAR <= 2020

--3. Средняя продолжительность треков по каждому альбому.
SELECT a.name AS album_name, AVG(duration) AS avg_track_duration
FROM album a
JOIN track t ON t.album_id = a.album_id
GROUP BY a.name

--4. Все исполнители, которые не выпустили альбомы в 2020 году.
SELECT name_pseudonym /* Получаем имена исполнителей */
FROM musician m  /* Из таблицы исполнителей */
WHERE m.name_pseudonym NOT IN ( /* Где имя исполнителя не входит в вложенную выборку */
SELECT name_pseudonym /* Получаем имена исполнителей */
FROM musician m  /* Из таблицы исполнителей */
JOIN musician_album_link mal  ON mal.musician_id = m.musician_id /* Объединяем с промежуточной таблицей */
JOIN album a  ON a.album_id = mal.album_id /* Объединяем с таблицей альбомов */
WHERE year = 2020 /* Где год альбома равен 2020 */
);


--5. Названия сборников, в которых присутствует конкретный исполнитель (выберите его сами).
SELECT m.name_pseudonym, c."name"  FROM musician m 
JOIN musician_album_link mal ON mal.musician_id = m.musician_id 
JOIN album a ON a.album_id = mal.album_id 
JOIN track t ON t.album_id = a.album_id 
JOIN collection_track_link ctl ON ctl.track_id = t.track_id 
JOIN collection c ON c.collection_id = ctl.collection_id 
WHERE name_pseudonym = 'Metallica'


--Задание 4
--1. Названия альбомов, в которых присутствуют исполнители более чем одного жанра.
SELECT a.name FROM 
(SELECT musician_id, COUNT (genre_id) AS genre_count FROM musician_genre_link mgl 
GROUP BY musician_id
HAVING COUNT (genre_id) > 1
) AS kk
JOIN musician_album_link mal  ON mal.musician_id = kk.musician_id
JOIN album a ON a.album_id = mal.album_id

--2. Наименования треков, которые не входят в сборники.
SELECT t.name FROM track t
LEFT JOIN collection_track_link ctl ON ctl.track_id = t.track_id 
LEFT JOIN collection c ON c.collection_id = ctl.collection_id 
WHERE c.collection_id IS NULL 

--3. Исполнитель или исполнители, написавшие самый короткий по продолжительности трек, — теоретически таких треков может быть несколько.
;WITH duration_track AS 
 (SELECT min(duration) AS min_duration FROM track t)
SELECT DISTINCT m.name_pseudonym  FROM duration_track dt
JOIN track t ON t.duration = dt.min_duration
JOIN album a ON a.album_id = t.album_id 
JOIN musician_album_link mal ON mal.album_id = a.album_id 
JOIN musician m ON m.musician_id = mal.musician_id 

--4. Названия альбомов, содержащих наименьшее количество треков.
;WITH min_count AS 
(SELECT album_id, COUNT(*) AS count_of_values
FROM track t 
GROUP BY album_id)
SELECT a.name FROM min_count AS mn1
JOIN album a ON a.album_id  = mn1.album_id
WHERE mn1.count_of_values IN (
SELECT min(mn2.count_of_values) FROM min_count mn2)

--или короткий вариант
;WITH min_count AS 
(SELECT album_id, COUNT(*) AS count_of_values FROM track t 
GROUP BY album_id
ORDER BY COUNT(*)
FETCH NEXT 1 ROWS WITH TIES)
SELECT a.name FROM min_count AS mn1
JOIN album a ON a.album_id  = mn1.album_id