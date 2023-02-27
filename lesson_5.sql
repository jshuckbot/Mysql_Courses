/*
Практическое задание по теме «Операторы, фильтрация, сортировка и ограничение»
*/

USE shop;

/* Задача 1
Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их
текущими датой и временем.
*/
-- я изменил столбцы всех созданных записей в таблицу users на NULL
UPDATE users 
SET 
	created_at = NULL,
	updated_at = NULL;

-- Заполним теперь их текущей датой и временем
UPDATE users 
SET 
	created_at = NOW(),
	updated_at = NOW()
WHERE created_at IS NULL AND updated_at IS NULL; -- Условие поставил жесткое так как у нас по условию задачи не заполнены оба поля если бы одно из двух нужно изсользовать OR

-- Выведем результат
SELECT id, name, birthday_at, created_at, updated_at FROM users;



/* Задача 2
Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы
типом VARCHAR и в них долгое время помещались значения в формате 20.10.2017 8:10.
Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения.
*/
-- очистим и сбосим автоинкримент
TRUNCATE users;


# преобразуем таблицу users поле created_at которое имеет тип DATA в VARCHAR
ALTER TABLE users CHANGE created_at created_at VARCHAR(20);
ALTER TABLE users CHANGE updated_at updated_at VARCHAR(20);

-- заполним таблицу записями для задания
INSERT INTO users (name, birthday_at, created_at, updated_at)
VALUES
	('Геннадий', '1990-10-05', '20.10.2017 21:10', '20.10.2017 8:10'),
	('Наталья', '1984-11-12', '01.01.2019 5:5', '29.01.2021 4:15'),
	('Александр', '1985-05-20', '20.04.2010 2:40', '17.02.2016 1:1'),
	('Сергей', '1988-02-14', '13.05.2021 3:15', '25.10.2022 15:10'),
	('Мария', '1992-08-29', '01.01.2022 8:10', '02.01.2022 18:17');


-- Отформатируем столбец created_at
UPDATE users 
SET
	created_at = STR_TO_DATE(created_at, '%d.%m.%Y %H:%i'),
	updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %H:%i');

ALTER TABLE users CHANGE created_at created_at DATETIME;
ALTER TABLE users CHANGE updated_at updated_at DATETIME;

-- отобразим резулитат запросом
SELECT id, name,birthday_at, created_at, updated_at FROM users;


/* Задача 3
В таблице складских запасов storehouses_products в поле value могут встречаться самые
разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы.
Необходимо отсортировать записи таким образом, чтобы они выводились в порядке
увеличения значения value. Однако нулевые запасы должны выводиться в конце, после всех
записей.
*/
TRUNCATE storehouses_products;

-- Вставим значения для задания
INSERT INTO storehouses_products (value)
VALUES
	(0), (2500), (0), (30), (500), (1);

-- Сделаем вборку отсортерованных значений, где ноль у нас будет выводиться вконце
SELECT value FROM storehouses_products
  ORDER BY value = 0, value;

 
/* Задача 4
(по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и
мае. Месяцы заданы в виде списка английских названий (may, august)
*/
TRUNCATE users;

INSERT INTO users (name, birthday_at)
VALUES
	('Геннадий', '1990-10-05'),
	('Наталья', '1984-11-12'),
	('Александр', '1985-05-20'),
	('Сергей', '1988-02-14'),
	('Мария', '1992-08-29');

SELECT name, birthday_at

-- Извлек из списка, где хранились месяца на английском
-- ВОпрос как еще можно было реализовать это задание использовав alias case и список??
FROM users
WHERE 
	CASE 
		WHEN MONTH(birthday_at) = 5 THEN 'may'
		WHEN MONTH(birthday_at) = 8 THEN 'august'
	END IN ('may', 'august');


/* Задача 5
(по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM
catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN.
*/
-- используем функцию field чтобы пройтись по пользовательскому списку
SELECT * FROM catalogs
WHERE id IN (5, 1, 2)
ORDER BY FIELD(id, 5, 1, 2);



/*
 Практическое задание теме «Агрегация данных»
*/

/* Задача 1
Подсчитайте средний возраст пользователей в таблице users.
*/

SELECT ROUND(AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW()))) AS age FROM users;


/* Задача 2
Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели.
Следует учесть, что необходимы дни недели текущего года, а не года рождения.
*/
SELECT DATE_FORMAT(CONCAT_WS('.', YEAR(NOW()), MONTH(birthday_at), DAY(birthday_at)), '%W') AS days_of_week, COUNT(*) AS number_of_days
    FROM users 
    GROUP BY days_of_week; 

/* Задача 3
(по желанию) Подсчитайте произведение чисел в столбце таблицы.
*/
TRUNCATE storehouses_products;  

INSERT INTO storehouses_products (value)
VALUES
	(1),
	(2),
	(3),
	(4),
	(5);
   
SELECT EXP(SUM(LN(value))) AS composition_values FROM storehouses_products;


















