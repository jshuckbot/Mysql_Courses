DROP DATABASE IF EXISTS sportmaster;
CREATE DATABASE sportmaster;
USE sportmaster;

DROP TABLE IF EXISTS users;
CREATE TABLE users(
	id SERIAL PRIMARY KEY,
	fisrt_name VARCHAR(255),
	second_name VARCHAR(255),
	surname VARCHAR(255),
	gender CHAR(1), -- оставил char один символ, можно конечно сделать с помощью enum и указать пол
	birthday_at DATE,
	phone BIGINT,
	email VARCHAR(255) UNIQUE
	
) COMMENT = 'Пользователи';

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs(
	id SERIAL PRIMARY KEY,
	name VARCHAR(255),
	UNIQUE unique_name(name) -- должны быть уникальные каталоги (UNIQUE создает индекс по имени)
) COMMENT = 'Каталоги';


DROP TABLE IF EXISTS products;
CREATE TABLE products(
	id SERIAL PRIMARY KEY,
	name VARCHAR(255),
	company VARCHAR(255),
	model VARCHAR(255),
	season TEXT COMMENT 'сезон',
	price DECIMAL (11,2) COMMENT 'Цена',
	size_at TINYINT,
	color_at VARCHAR(255),
	total INT UNSIGNED DEFAULT 1,
	gender CHAR(1) COMMENT 'Пол',
	catalog_id BIGINT UNSIGNED,
	FOREIGN KEY (catalog_id) REFERENCES catalogs(id) ON UPDATE CASCADE ON DELETE SET NULL 
) COMMENT = 'Товары';

DROP TABLE IF EXISTS album_images;
CREATE TABLE album_images(
	product_id SERIAL PRIMARY KEY,
	name VARCHAR(255),
	company VARCHAR(255),
	model VARCHAR(255),
	FOREIGN KEY (product_id) REFERENCES products(id) ON UPDATE CASCADE ON DELETE CASCADE
) COMMENT = 'Альбомы';


DROP TABLE IF EXISTS images;
CREATE TABLE images(
	id SERIAL PRIMARY KEY,
	file_name VARCHAR(255),
	path_image TEXT,
	album_id BIGINT UNSIGNED NOT NULL,
	FOREIGN KEY (album_id) REFERENCES album_images(product_id) ON UPDATE CASCADE ON DELETE CASCADE
) COMMENT = 'Картинки для альбомов';

DROP TABLE IF EXISTS baskets;
CREATE TABLE baskets(
	
	client_id BIGINT UNSIGNED NOT NULL,
	product_id BIGINT UNSIGNED NOT NULL,
	total_products INT UNSIGNED NOT NULL DEFAULT 1,
	PRIMARY KEY (client_id, product_id),
	FOREIGN KEY (client_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE, 
	FOREIGN KEY (product_id) REFERENCES products(id) ON UPDATE CASCADE ON DELETE CASCADE
) COMMENT = 'Корзина';

DROP TABLE IF EXISTS orders;
CREATE TABLE orders(
	id SERIAL PRIMARY KEY,
	status ENUM('Оплачено', 'Не оплачено'),
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  	client_id  BIGINT UNSIGNED NOT NULL,
  	FOREIGN KEY (client_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
  ) COMMENT = 'Заказы';
 
 
-- 1-M
DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products (
  -- id SERIAL PRIMARY KEY,
  order_id BIGINT UNSIGNED NOT NULL,
  product_id BIGINT UNSIGNED NOT NULL,
  total INT UNSIGNED DEFAULT 1 COMMENT 'Количество заказанных товарных позиций',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (order_id, product_id),
  FOREIGN KEY (order_id) REFERENCES orders(id) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(id) ON UPDATE CASCADE ON DELETE CASCADE
  
) COMMENT = 'Состав заказа';

 









