/* 
Задание 1.
Создайте таблицу logs типа Archive.
Пусть при каждом создании записи в таблицах users, catalogs и products в таблицу logs помещается время и дата создания записи,
название таблицы, идентификатор первичного ключа и содержимое поля name. 
*/

-- Для таблицы логов мы не будем использовать индексы. Мы от них откажемся, так как в таблицу постоянно будут добовляться логи
-- и индекс придется пересчитывать, что при больом количестве записей приведет к замедлению работы. 

USE shop;

DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
	created_at DATETIME NOT NULL,
	table_name VARCHAR(50) NOT NULL,
	primary_key BIGINT NOT NULL,
	name_value VARCHAR(100) NOT NULL)
ENGINE = ARCHIVE;



-- Создадим триггер который заносит данные в таблицу logs при добавлении запией в таблицу users.


DROP TRIGGER IF EXISTS users_log;
DELIMITER //
CREATE TRIGGER users_log AFTER INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, table_name, primary_key, name_value)
	VALUES (NOW(), 'users', NEW.id, NEW.name);
END//
DELIMITER ;

-- Добавим данные для примера:

INSERT INTO users (name, birthday_at, created_at, updated_at)
VALUES ('Ротибор', '1978-08-12', NOW(), NOW());

SELECT id, name, birthday_at, created_at, updated_at FROM users;
SELECT created_at, table_name, primary_key, name_value FROM logs;


-- Создадим триггер который заносит данные в таблицу logs при добавлении запией в таблицу catalogs.


DROP TRIGGER IF EXISTS catalogs_log;
DELIMITER //
CREATE TRIGGER catalogs_log AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, table_name, primary_key, name_value)
	VALUES (NOW(), 'catalogs', NEW.id, NEW.name);
END//
DELIMITER ;

-- Добавим данные для примера:

INSERT INTO catalogs (name)
VALUES ('Адаптеры');

SELECT id, name FROM catalogs;
SELECT created_at, table_name, primary_key, name_value FROM logs;


-- Создадим триггер который заносит данные в таблицу logs при добавлении запией в таблицу products.


DROP TRIGGER IF EXISTS products_log;
DELIMITER //
CREATE TRIGGER products_log AFTER INSERT ON products
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, table_name, primary_key, name_value)
	VALUES (NOW(), 'products', NEW.id, NEW.name);
END//
DELIMITER ;

-- Добавим данные для примера:

INSERT INTO products (name, description, price, catalog_id, created_at, updated_at)
VALUES ('Адаптер bluetooth', 'Адаптер bluetooth USB 2.0', 500, 6, NOW(), NOW());

SELECT id, name, description, price, catalog_id, created_at, updated_at FROM products;
SELECT created_at, table_name, primary_key, name_value FROM logs;

/* 
Задание 2.
Создайте SQL-запрос, который помещает в таблицу users миллион записей. 
*/

DROP PROCEDURE IF EXISTS million_note;
DELIMITER //
CREATE PROCEDURE million_note()
BEGIN
    DECLARE n INT DEFAULT 0;
    WHILE n < 1000000 DO
        INSERT INTO users (name, birthday_at, created_at, updated_at)
        VALUES ('Иван', '1999-09-25', NOW(), NOW());
        SET n = n + 1;
    END WHILE;
END//
DELIMITER ;

CALL million_note ();

-- Проверим:

SELECT id, name, birthday_at, created_at, updated_at FROM users;

