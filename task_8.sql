USE sportmaster;

/*Хранимые процедуры*/
/*Задача 1.
 Написать хранимую процедуру которая проверяет сколько товара у выбранного пользователя в корзине и вернуть количество.
*/
DROP PROCEDURE IF EXISTS sp_total_user_basket;
DELIMITER //
CREATE PROCEDURE sp_total_user_basket(IN client_id INT, OUT total INT)
BEGIN
	SELECT 
	SUM(b.total_products) AS total_products
	INTO total
	FROM users u 
	JOIN baskets b ON  u.id = b.client_id
	WHERE u.id = client_id;
	END//
DELIMITER ;

/*Задача 2.
 Написать хранимую процедуру которая проверяет какие кроссовки определенного размера есть в таблице products.
*/
CALL sp_total_user_basket(3, @total);
SELECT @total;


DROP PROCEDURE IF EXISTS sp_products_sneaker_size;
DELIMITER //
CREATE PROCEDURE sp_products_sneaker_size(IN sneaker_size INT)
BEGIN
	SELECT 
		p.name,
		p.company,
		p.model,
		p.size_at,
		p.total 
	FROM products p
	WHERE p.name = 'Кроссовки' AND p.size_at = sneaker_size;
END//
DELIMITER ;


CALL sp_products_sneaker_size(41);


/*Триггеры*/

/*Задача 1.
 Написать триггер который при добавлении нового пользователя выдает исключение когда дата больше текущей.
*/
DROP TRIGGER IF EXISTS user_age_before_insert;
DELIMITER //
CREATE TRIGGER user_age_before_insert
BEFORE INSERT 
ON users FOR EACH ROW 
BEGIN
	IF NEW.birthday_at > CURRENT_DATE() THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = ' Не корректно введена дата рождения';
	END IF;
END//
DELIMITER ;

-- при добавлении будет сообщении что не корректно ввели данные,
-- если поменять на текущую дату или ниже, запрос выполниться
INSERT INTO users
(fisrt_name, second_name, surname, gender, birthday_at, phone, email)
VALUES
	('Иван', 'Иванович', 'Иванов', 'М', '3001-09-25', 9131001311, 'example_15@mail.ru');

/*Задача 2.
 Написать триггер который при добавлении товара считает сколько позиций в таблице protucts
*/

DROP TRIGGER IF EXISTS total_products_after_insert;
DELIMITER // 
CREATE TRIGGER total_products_after_insert
AFTER INSERT 
ON products FOR EACH ROW 
BEGIN
	 SET @total_products = (SELECT COUNT(*) FROM products);
END//
DELIMITER ;

-- заносим данные и счетчик обновиться
INSERT INTO products
(name, company, model, season , price, size_at, color_at, total, gender, catalog_id)
VALUES
	('Кроссовки', 'adidas', 'модель 1', 'Зима', 18000.00, 46, 'white', 1, 'M', 1);


-- Выводим общее количество товара в таблице
SELECT @total_products;
 
















