USE sportmaster;

/*
Задание 1.
Вывести цену со скидкой 20% на каждый товар который находится в корзине клиента в его день рождения
*/

SELECT 
	CONCAT(u.fisrt_name, ' ', u.second_name, ' ', u.surname) AS name,
	CONCAT(p.name, ' ', p.company, ' ', p.model) AS product,
	(p.price - p.price * 0.2) * b.total_products  AS price
FROM users u
	JOIN baskets b ON u.id = b.client_id
	JOIN products p ON p.id = b.product_id 
WHERE DATE_FORMAT('2022-06-06', '%m-%d') = DATE_FORMAT(birthday_at, '%m-%d');


/*
Задание 2.
У какого клиента больше всего товара в корзине. Если таких клиентов несколько то вывести первого.
*/
SELECT 
	u.fisrt_name,
	SUM(b.total_products) AS total_products
FROM users u 
JOIN baskets b ON u.id = b.client_id
GROUP BY  u.id
ORDER BY total_products DESC
LIMIT 1;


/*
Задание 3.
Найти товар без каталога. Если он есть такой. 
*/
SELECT 
	p.catalog_id,
	p.name
FROM catalogs c 
RIGHT JOIN products p ON p.catalog_id = c.id
WHERE p.catalog_id IS NULL;

/*
Задание 4.
Сколько обуви 41 размера есть в наличии. на которые лежат в корзине
*/
-- предпочтительнее отдавать к JOIN конструкции, она работает очень быстро по сравнению с вложеннми запросами, существенный разность будет, если бд маштабировать.
SELECT COUNT(*) AS total 
FROM products p 
JOIN baskets b ON p.id = b.product_id AND p.size_at = 41;

-- решил задачу разбавить вложенным запросом
SELECT COUNT(*) AS total
FROM baskets 
WHERE product_id IN (SELECT p.id FROM products p WHERE p.size_at = 41);

/*
Задание 5.
Сколько заказов сделала каждая женщина за все время.
*/

SELECT 
	CONCAT(u.fisrt_name, ' ', u.surname) AS name,
	u.gender,
	COUNT(*) AS cnt
FROM users u 
JOIN orders o ON o.client_id = u.id
WHERE u.gender = 'Ж'
GROUP BY u.id
ORDER BY cnt DESC;

/*
Задание 6.
У каких пользователей не оплачен заказ. Вывести имя покупателя и товара и статус
*/
SELECT 
	u.fisrt_name,
	u.second_name,
	CONCAT(p.name, ' ', p.company, ' ', p.model) as name_model,
	o.status
FROM users u 
JOIN orders o ON u.id = o.client_id
JOIN orders_products op ON op.order_id = o.id
JOIN products p ON op.product_id = p.id 
WHERE o.status = 'Не оплачено';























