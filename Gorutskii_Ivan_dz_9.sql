USE shop;

/* Практическое задание по теме “Транзакции, переменные, представления”.
Задание 1.
В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных.
Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.
*/

START TRANSACTION;

INSERT INTO sample.users 
SELECT id, name 
FROM shop.users 
WHERE id = 1;

DELETE FROM shop.users
WHERE id=1; 

COMMIT;

/* Практическое задание по теме “Хранимые процедуры и функции, триггеры".
Задание 1.
Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток.
С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день",
с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".
*/

DELIMITER //

DROP FUNCTION IF EXISTS hello//
CREATE FUNCTION hello()
RETURNS TEXT DETERMINISTIC
BEGIN
	DECLARE `time` INT;
	SET `time` = HOUR(now());
	CASE
		WHEN `time` BETWEEN 0 AND 5 THEN 
			RETURN 'Доброй ночи!';
		WHEN `time` BETWEEN 6 AND 11 THEN 
			RETURN 'Доброе утро!';
		WHEN `time` BETWEEN 12 AND 17 THEN 
			RETURN 'Добрый день!';
		WHEN `time` BETWEEN 18 AND 23 THEN 
			RETURN 'Добрый вечер!';
	END CASE;
END//
DELIMITER ;
SELECT hello()

/* Практическое задание по теме Администрирование MySQL.
Задание 1.
Создайте двух пользователей которые имеют доступ к базе данных shop.
Первому пользователю shop_read должны быть доступны только запросы на чтение данных,
второму пользователю shop — любые операции в пределах базы данных shop.
*/

-- пользователю доступны только запросы на чтение данных
DROP USER IF EXISTS 'shop_reader'@'localhost';
CREATE USER 'shop_reader'@'localhost' IDENTIFIED WITH sha256_password BY '1q0pazsIVAN!#$';
GRANT SELECT ON shop.* TO 'shop_reader'@'localhost';

-- Проверяем вставит ли пользователь запись в catalogs 
-- Запись не вставилась, так как права у пользователя только на чтение
INSERT INTO catalogs(name)
VALUES('Test catalog');
 -- открыт доступ для чтения
SELECT * FROM catalogs;


-- shop - доступны любые операции в пределах базы данных shop
DROP USER IF EXISTS 'shop'@'localhost';
CREATE USER 'shop'@'localhost' IDENTIFIED WITH sha256_password BY '1q0pazsIVAN!#$';
GRANT ALL ON shop.* TO 'shop'@'localhost';
GRANT GRANT OPTION ON shop.* TO 'shop'@'localhost';

-- Доступ за запись в переделах shop
INSERT INTO catalogs(name)
VALUES(' Test catalog');
 -- Доступ на чтение в переделах shop
SELECT * FROM catalogs;

-- Доступ за запись закрыт вне БД shop
INSERT INTO vk.users(firstname, lastname, email)
VALUES('ivan', 'ivan', 'ivan@mail.ru');
 -- Доступ на чтение закрыт закрыт вне БД shop
SELECT * FROM vk.users;

/*
Проверял вставку и выборку проверял через консоль. Доступ соответствует каждому пользователю*/


