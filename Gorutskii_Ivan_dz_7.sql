USE shop;
/*
Задание 1.
	Составьте список пользователей users, которые осуществили хотя бы один заказ orders в
	интернет магазине.
*/
INSERT INTO orders 
	(user_id)
VALUES
	(1), (2), (1), (3), (4); 
	
-- сделал, вывод всех доступных полей
SELECT * 
FROM 
	users
JOIN
	orders
ON
	users.id  = orders.user_id;

-- использовал квалификационные имена 
SELECT 
	users.id, orders.id, orders.created_at, orders.updated_at 
FROM 
	users
JOIN
	orders
ON
	users.id  = orders.user_id;


/*
Задание 2.
	Выведите список товаров products и разделов catalogs, который соответствует товару.
*/
INSERT INTO products
(name, desription, price, catalog_id, created_at, updated_at)
VALUES('Intel® Core i5-3210M', 'Процессор Intel® Core i5-3210M', 5000.00, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


SELECT
	products.name, products.desription, products.catalog_id 
FROM 
	products
JOIN
	catalogs
ON
	products.catalog_id  = catalogs.id; 

/*
Задание 3.
	(по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label,
	name). Поля from, to и label содержат английские названия городов, поле name — русское.
	Выведите список рейсов flights с русскими названиями городов.
*/

DROP TABLE IF EXISTS flights;
CREATE TABLE flights(
	id SERIAL PRIMARY KEY,
	from_city VARCHAR(100),
	to_city VARCHAR(100)
);

DROP TABLE IF EXISTS cities;
CREATE TABLE cities(
	label VARCHAR(100),
	name VARCHAR(100)
);

INSERT INTO flights
(from_city, to_city)
VALUES
	('moscow', 'omsk'),
	('novgorod', 'kazan'),
	('irkutsk', 'moscow'),
	('omsk', 'irkutsk'),
	('moscow', 'kazan');


INSERT INTO cities
(label, name)
VALUES
	('moscow', 'Москва'),
	('irkutsk', 'Иркутск'),
	('novgorod', 'Новгород'),
	('kazan', 'Казань'),
	('omsk', 'Омск');


SELECT 
	from_citi.name AS from_city,
	to_citi.name AS to_city
FROM 
	flights
JOIN
	cities AS from_citi
ON
	flights.from_city = from_citi.label 
JOIN
	cities AS to_citi
ON
	to_citi.label = flights.to_city
ORDER BY from_city;
























