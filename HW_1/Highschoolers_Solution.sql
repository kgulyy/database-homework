-- №1 Найти имена всех студентов кто дружит с кем-то по имени Gabriel.
SELECT h2.name
FROM highschooler h1
  JOIN friend f ON h1.id = f.id1
  JOIN highschooler h2 ON h2.id = f.id2
WHERE h1.name = 'Gabriel';

-- №2 Для всех студентов, кому понравился кто-то на 2 или более классов младше,
-- чем он вывести имя этого студента и класс, а так же имя и класс студента который ему нравится.
SELECT h1.name, h1.grade, h2.name, h2.grade
FROM highschooler h1
  JOIN likes k ON k.id1 = h1.id
  JOIN highschooler h2 ON h2.id = k.id2
WHERE h1.grade - h2.grade > 1;

-- №3 Для каждой пары студентов, которые нравятся друг другу взаимно вывести имя и класс обоих студентов.
-- Включать каждую пару только 1 раз с именами в алфавитном порядке.
SELECT h1.name, h1.grade, h2.name, h2.grade
FROM likes k1
  JOIN likes k2 ON k1.id1 = k2.id2 AND k1.id2 = k2.id1
  JOIN highschooler h1 ON h1.id = k1.id1
  JOIN highschooler h2 ON h2.id = k1.id2
WHERE h1.name < h2.name
ORDER BY 1, 3;

-- №4 Найти всех студентов, которые не встречаются в таблице лайков
-- (никому не нравится и ему никто не нравится), вывести их имя и класс.
-- Отсортировать по классу, затем по имени в классе.
SELECT h.name, h.grade
FROM highschooler h
  LEFT JOIN likes k1 ON h.id = k1.id1
  LEFT JOIN likes k2 ON h.id = k2.id2
WHERE k1.id1 IS NULL AND k2.id2 IS NULL
ORDER BY 2, 1;

-- №5 Для каждой ситуации, когда студенту A нравится студент B, но B никто не нравится,
-- вывести имена и классы A и B.
SELECT a.name, a.grade, b.name, b.grade
FROM highschooler a
  JOIN likes k1 ON a.id = k1.id1
  LEFT JOIN likes k2 ON k1.id2 = k2.id1
  JOIN highschooler b ON b.id = k1.id2
WHERE k2.id1 IS NULL
ORDER BY 1, 3;

-- №6 Найти имена и классы, которые имеют друзей только в том же классе.
-- Вернуть результат, отсортированный по классу, затем имени в классе.
SELECT h.name, h.grade
FROM highschooler h
  JOIN friend f ON h.id = f.id1
  LEFT JOIN highschooler o
    ON f.id2 = o.id AND h.grade <> o.grade
GROUP BY h.id, h.name, h.grade
HAVING COUNT(o.id) = 0
ORDER BY h.grade, h.name;

-- №7 Для каждого студента A, которому нравится студент B, и они не друзья,
-- найти есть ли у них общий друг.
-- Для каждой такой тройки вернуть имя и класс A, B, и C.
SELECT a.name, a.grade, b.name, b.grade, c.name, c.grade
FROM highschooler a
  JOIN likes lab ON a.id = lab.id1
  LEFT JOIN friend notfr ON notfr.id1 = lab.id1 AND notfr.id2 = lab.id2
  JOIN friend fac ON fac.id1 = lab.id1 -- AND fac.id2 <> lab.id2
  JOIN friend fbc ON fbc.id1 = lab.id2 AND fac.id2 = fbc.id2
  JOIN highschooler b ON b.id = lab.id2
  JOIN highschooler c ON c.id = fac.id2
WHERE notfr.id1 IS NULL
ORDER BY 1, 3, 5;

-- №8 Найти разницу между числом учащихся и числом различных имен.
SELECT COUNT(*) - COUNT(DISTINCT name) "dif"
FROM highschooler;

-- №9 Найти имя и класс студентов, которые нравятся более чем 1 другому студенту.
SELECT h.name, h.grade
FROM highschooler h
  JOIN likes k ON k.id2 = h.id
GROUP BY h.id
HAVING COUNT(k.id1) > 1
ORDER BY 1, 2;

-- №10 Если два школьника - А и В - друзья и А нравится В, но не наоборот,
-- то удалите соответствующую строку из Likes.
DELETE FROM likes res
USING friend fab, likes lab
  LEFT JOIN likes lba ON lba.id1 = lab.id2 AND lba.id2 = lab.id1
WHERE res.id1 = lab.id1 AND res.id2 = lab.id2 AND lba.id1 IS NULL
      AND fab.id1 = lab.id1 AND fab.id2 = lab.id2;

-- Выборка, на основе которой строится DELETE
SELECT lab.id1, lab.id2
FROM likes lab
  LEFT JOIN likes lba ON lba.id1 = lab.id2 AND lba.id2 = lab.id1
  JOIN friend fab ON fab.id1 = lab.id1 AND fab.id2 = lab.id2
WHERE lba.id1 IS NULL;

-- №11 Для всех случаев, когда А нравится В, а В нравится С
-- получите имена и классы А, В и С.
SELECT a.name, a.grade, b.name, b.grade, c.name, c.grade
FROM highschooler a
  JOIN likes lab ON lab.id1 = a.id
  JOIN highschooler b ON b.id = lab.id2
  JOIN likes lbc ON lbc.id1 = b.id
  JOIN highschooler c ON c.id = lbc.id2 -- AND c.id <> a.id
ORDER BY 1, 3, 5;

-- №12 Найдите всех студентов, у которых все друзья в других классах.
-- Получите имена и классы таких студентов.
SELECT h.name, h.grade
FROM highschooler h
  JOIN friend f ON h.id = f.id1
  LEFT JOIN highschooler o
    ON f.id2 = o.id AND h.grade = o.grade
GROUP BY h.grade, h.name, h.id
HAVING COUNT(o.id) = 0
ORDER BY h.grade, h.name;

-- №13 Каково среднее число друзей у студента? (Вы должны получить одно число).
SELECT AVG(res.cnt)
FROM (
       SELECT COUNT(id1) AS cnt
       FROM friend
       GROUP BY id1
     ) AS res;

-- №14 Найдите всех студентов, которые являются друзьями Cassandra,
-- либо друзьями друзей Кассандра. Только не считайте саму Кассандру.
(
  SELECT s.name, s.grade
  FROM highschooler cas
    JOIN friend f ON f.id1 = cas.id
    JOIN highschooler s ON s.id = f.id2
  WHERE cas.name = 'Cassandra'
)
UNION
(
  SELECT ffs.name, ffs.grade
  FROM highschooler cas
    JOIN friend f ON f.id1 = cas.id
    JOIN highschooler s ON s.id = f.id2
    JOIN friend ff ON ff.id1 = s.id AND ff.id2 <> cas.id
    JOIN highschooler ffs ON ffs.id = ff.id2
  WHERE cas.name = 'Cassandra'
)
ORDER BY 1, 2;

-- №15 Найдите имена и классы студентов(-а) с наибольшим количеством друзей.
SELECT res.name, res.grade
FROM (
       SELECT frd_cnt.*, MAX(frd_cnt.cnt) OVER () AS max
       FROM (
              SELECT h.*, COUNT(f.id2) AS cnt
              FROM highschooler h
                LEFT JOIN friend f ON f.id1 = h.id
              GROUP BY h.id
            ) AS frd_cnt
     ) AS res
WHERE res.cnt = res.max
ORDER BY 1, 2;
