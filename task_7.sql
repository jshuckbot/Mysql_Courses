USE sportmaster;

/*Представления*/
/*Задача 1.
 Создать представление которое выводит цену со скидкой 20% 
 на каждый товар который находится в корзине клиента в его день рождения
*/

-- Вставим пользователя с текущей датой рождения
INSERT INTO users
(fisrt_name, second_name, surname, gender, birthday_at, phone, email)
VALUES
	('Сергей', 'Сергевич', 'Серггев', 'М', DATE_FORMAT(NOW(), '%Y-%m-%d'), 9836154461, 'example_777@mail.ru');

INSERT INTO baskets
(client_id, product_id, total_products)
VALUES
	(LAST_INSERT_ID(), 3, 1),
	(LAST_INSERT_ID(), 5, 1);

CREATE OR REPLACE VIEW v_birthday_discount(name, product, price) AS
SELECT 
	CONCAT(u.fisrt_name, ' ', u.surname) AS name,
	CONCAT(p.name, ' ', p.company, ' ', p.model) AS product,
	(p.price - p.price * 0.2) * b.total_products  AS price
FROM users u
	JOIN baskets b ON u.id = b.client_id
	JOIN products p ON p.id = b.product_id 
WHERE DATE_FORMAT(NOW(), '%m-%d') = DATE_FORMAT(birthday_at, '%m-%d');


SELECT * FROM v_birthday_discount;


/*Задача 2.
 Создать представление которая хранит кроссовки и вывести максимальную цену из них.
*/
CREATE OR REPLACE VIEW v_sneakers_product(company, model, size_at, price) AS
SELECT 
	company,
	model,
	size_at,
	price
FROM products;

-- Находим максимальную цену на кроссовки
SET @MAX_PRICE = (SELECT MAX(price) FROM v_sneakers_product);

-- SELECT  @MAX_PRICE;
-- из представления находим кроссовки с максимальной ценой
SELECT * FROM v_sneakers_product v_sp
WHERE v_sp.price  = @MAX_PRICE;




























