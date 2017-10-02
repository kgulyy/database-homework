-- №1 Найти названия всех фильмов снятых ‘Steven Spielberg’, отсортировать по алфавиту.
SELECT title FROM movie
WHERE director = 'Steven Spielberg'
ORDER BY title;

-- №2 Найти года в которых были фильмы с рейтингом 4 или 5, и отсортировать по возрастанию.
SELECT DISTINCT m.year
FROM movie m, rating r
WHERE m.mid = r.mid
      AND r.stars BETWEEN 4 AND 5
ORDER BY 1;

-- №3 Найти названия всех фильмов которые не имеют рейтинга, отсортировать по алфавиту.
SELECT m.title
FROM movie m
  LEFT JOIN rating r ON m.mid = r.mid
WHERE r.mid IS NULL
ORDER BY title;

-- №4 Некоторые оценки не имеют даты.
-- Найти имена всех экспертов, имеющих оценки без даты, отсортировать по алфавиту.
SELECT DISTINCT rev.name
FROM reviewer rev, rating rat
WHERE rev.rid = rat.rid
      AND rat.ratingdate IS NULL
ORDER BY 1;

-- №5 Напишите запрос возвращающий информацию о рейтингах в более читаемом формате:
-- имя эксперта, название фильма, оценка и дата оценки.
-- Отсортируйте данные по имени эксперта, затем названию фильма и наконец оценка.
SELECT rev.name, m.title, rat.stars, rat.ratingdate
FROM movie m, reviewer rev, rating rat
WHERE m.mid = rat.mid AND rev.rid = rat.rid
ORDER BY name, title, stars;

-- №6 Для каждого фильма, выбрать название и “разброс оценок”, то есть,
-- разницу между самой высокой и самой низкой оценками для этого фильма.
-- Сортировать по “разбросу оценок” от высшего к низшему, и по названию фильма.
SELECT m.title, MAX(r.stars) - MIN(r.stars) "dif"
FROM rating r, movie m
WHERE r.mid = m.mid
GROUP BY m.mid
ORDER BY dif DESC, title;

-- №7 Найти разницу между средней оценкой фильмов выпущенных до 1980 года,
-- и средней оценкой фильмов выпущенных после 1980 года (фильмы выпущенные в 1980 году не учитываются).
-- Убедитесь, что для расчета используете среднюю оценку для каждого фильма.
-- Не просто среднюю оценку фильмов до и после 1980 года.
SELECT
  AVG(CASE WHEN year < 1980 THEN avg_stars ELSE NULL END) -
  AVG(CASE WHEN year > 1980 THEN avg_stars ELSE NULL END) AS result
FROM (
       SELECT m.mid, m.year, AVG(r.stars) AS avg_stars
       FROM movie m
         JOIN rating r USING (mid)
       GROUP BY m.mid, m.year
     ) AS avg_rating;

-- №8 Найти имена всех экспертов, кто оценил “Gone with the Wind”, отсортировать по алфавиту.
SELECT DISTINCT rev.name
FROM reviewer rev
  JOIN rating rat USING (rid)
  JOIN movie m USING (mid)
WHERE m.title = 'Gone with the Wind'
ORDER BY name;

-- №9 Для каждой оценки, где эксперт тот же человек что и режиссер,
-- выбрать имя, название фильма и оценку, отсортировать по имени, названию фильма и оценке.
SELECT rev.name, m.title, rat.stars
FROM reviewer rev, movie m, rating rat
WHERE m.mid = rat.mid AND rev.rid = rat.rid
      AND rev.name = m.director
ORDER BY 1, 2, 3;

-- №10 Выберите всех экспертов и названия фильмов в едином списке в алфавитном порядке.
SELECT rev.name
FROM reviewer rev
UNION ALL
SELECT m.title
FROM movie m
ORDER BY 1;

-- №11 Выберите названия всех фильмов, по алфавиту, которым не поставил оценку ‘Chris Jackson’.
SELECT m.title
FROM movie m
  LEFT JOIN (
                rating rat
                JOIN reviewer rev ON rat.rid = rev.rid
                                     AND rev.name = 'Chris Jackson'
            ) AS ids
    ON ids.mid = m.mid
WHERE ids.mid IS NULL
ORDER BY 1;

-- №12 Для всех пар экспертов, если оба оценили один и тот же фильм, выбрать имена обоих.
-- Устранить дубликаты, проверить отсутствие пар самих с собой и включать каждую пару только 1 раз.
-- Выбрать имена в паре в алфавитном порядке и отсортировать по именам.
SELECT DISTINCT v1.name, v2.name
FROM reviewer v1
  JOIN rating r1 ON v1.rid = r1.rid
  JOIN rating r2 ON r1.mid = r2.mid
  JOIN reviewer v2 ON v2.rid = r2.rid
WHERE v1.name < v2.name
ORDER BY 1;

-- №13 Выбрать список названий фильмов и средний рейтинг, от самого низкого до самого высокого.
-- Если два или более фильмов имеют одинаковый средний балл, перечислить их в алфавитном порядке.
SELECT m.title, AVG(r.stars)
FROM rating r
  JOIN movie m ON m.mid = r.mid
GROUP BY m.mid
ORDER BY 2, 1;

-- №14 Найти имена всех экспертов, которые поставили три или более оценок, сортировка по алфавиту.
SELECT rev.name
FROM rating rat
  JOIN reviewer rev ON rat.rid = rev.rid
GROUP BY rev.rid
HAVING COUNT(rat.stars) > 2
ORDER BY 1;

-- №15 Некоторые режиссеры сняли более чем один фильм.
-- Для всех таких режиссеров, выбрать названия всех фильмов режиссера, его имя. Сортировка по имени режиссера.
-- Пример: Avatar,Titanic | James Cameron
SELECT string_agg(title, ',' ORDER BY title), director
FROM movie
GROUP BY director
HAVING COUNT(director) > 1
ORDER BY 2;

-- №16 Для всех случаев когда один эксперт оценивал фильм более одного раза и указал лучший рейтинг второй раз,
-- выведите имя эксперта и название фильма, отсортировав по имени, затем по названию фильма.
SELECT rev.name, m.title
FROM rating r1
  JOIN rating r2 ON r1.mid = r2.mid AND r1.rid = r2.rid
  JOIN movie m ON m.mid = r1.mid
  JOIN reviewer rev ON rev.rid = r1.rid
WHERE r1.ratingdate > r2.ratingdate AND r1.stars > r2.stars
ORDER BY 1, 2;

-- №17. Для каждого фильма, который имеет по крайней мере одну оценку, найти
-- наибольшее количество звезд, которые фильм получил. Выбрать название фильма и
-- количество звезд. Сортировать по названию фильма.
SELECT title, MAX(stars)
FROM rating r
  JOIN movie m ON m.mid=r.mid
GROUP BY title
ORDER BY title;
