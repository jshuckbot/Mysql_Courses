USE vk;
-- select @@sql_mode;
 SET @@sql_mode = CONCAT (@@sql_mode, ',ONLY_FULL_GROUP_BY');
/*
Задача 1.
Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.
*/

SELECT 
	from_user_id,
	COUNT(*) AS cnt
FROM messages
WHERE (from_user_id IN (
	SELECT initiator_user_id FROM friend_requests WHERE target_user_id = 1 AND status = 'approved'
	UNION
	SELECT target_user_id FROM friend_requests	WHERE initiator_user_id = 1 AND status = 'approved')) AND to_user_id = 1

GROUP BY from_user_id
ORDER BY cnt DESC
LIMIT 1;

-- Сделал чтобы у отправителя было имя
SELECT 
	-- from_user_id,
	(SELECT firstname FROM users WHERE id = messages.from_user_id) AS from_user_name,
	COUNT(*) AS cnt
FROM messages
WHERE (from_user_id IN (
	SELECT initiator_user_id FROM friend_requests WHERE target_user_id = 1 AND status = 'approved'
	UNION
	SELECT target_user_id FROM friend_requests	WHERE initiator_user_id = 1 AND status = 'approved')) AND to_user_id = 1

GROUP BY from_user_id
ORDER BY cnt DESC
LIMIT 1;

/*
так как нам по задаче требовалось найти друзей любого пользователя, я выбрал 1 пользователя, и сделал выборку какие у него есть друзья.
потом, я добавил это вложенный запрос из таблицы messages в условии чтобы отсортировать пользователей которые обращались к 1 и были его друзья.
Поставил дополнительное условие, что получатель должен быть 1 пользователь как требовалось по условию задачи, и нужно было подсчитать кто чаще общался
с пользователем я реализовал это с помощью агрегатной функции COUNT, чтобы можно было сгруппировать по отправителю и получил нужный результат.
*/

/*
 Задача 2.
 Подсчитать общее количество лайков, которые получили пользователи младше 11 лет.
*/


SELECT 
	COUNT(*) AS cnt 
FROM likes
WHERE user_id IN (SELECT user_id FROM profiles WHERE TIMESTAMPDIFF(YEAR, birthday, NOW()) < '11');



/*
 Задача 3.
 Определить кто больше поставил лайков (всего): мужчины или женщины.
*/



-- (SELECT COUNT(*) AS gender_f FROM likes WHERE user_id IN ( SELECT user_id  FROM profiles WHERE gender = 'f'));
-- 
-- (SELECT COUNT(*) AS gender_m FROM likes WHERE user_id IN (SELECT user_id  FROM profiles WHERE gender = 'm'));


-- Нас просили вывести кого больше мужчин или женжин
-- Данная вборка демонстрирует нам подсчет и выводит в одной строке кого больше
SELECT 
	IF((SELECT COUNT(*) AS gender_f FROM likes WHERE user_id IN ( SELECT user_id  FROM profiles WHERE gender = 'f')) >
	(SELECT COUNT(*) AS gender_m FROM likes WHERE user_id IN (SELECT user_id  FROM profiles WHERE gender = 'm')), 'female', 'man') AS LIKES;

-- или так, тут сразу видно числа сколько мужчин или женщин и можно сделать и так правильный выбор если добавим LIMIT 1 
-- получим результат только цифрах
SELECT 
	(SELECT COUNT(*) AS gender_f FROM likes WHERE user_id IN ( SELECT user_id  FROM profiles WHERE gender = 'f')) AS female,
	(SELECT COUNT(*) AS gender_m FROM likes WHERE user_id IN (SELECT user_id  FROM profiles WHERE gender = 'm')) AS man;

























