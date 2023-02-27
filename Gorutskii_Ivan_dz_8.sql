USE vk;
-- select @@sql_mode;
 SET @@sql_mode = CONCAT (@@sql_mode, ',ONLY_FULL_GROUP_BY');
/*
Задача 1.
Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.
*/

SELECT 
	m.from_user_id,
	COUNT(*) AS cnt 
FROM users u
JOIN friend_requests fr ON fr.initiator_user_id = u.id OR fr.target_user_id = u.id
JOIN messages m ON m.from_user_id = fr.initiator_user_id  OR m.from_user_id = fr.target_user_id
WHERE u.id = 1 AND fr.status = 'approved' AND m.from_user_id != 1 AND m.to_user_id = 1 
GROUP BY m.from_user_id
ORDER BY cnt DESC
LIMIT 1;


/*
 Задача 2.
 Подсчитать общее количество лайков, которые получили пользователи младше 11 лет.
*/

SELECT 
	COUNT(*) AS total
FROM profiles p
JOIN media m  ON p.user_id = m.user_id
JOIN likes l ON l.media_id = m.id 
WHERE TIMESTAMPDIFF(YEAR, birthday, NOW()) < '11';

/*
 Задача 3.
 Определить кто больше поставил лайков (всего): мужчины или женщины.
*/

-- 1 решение
SELECT 
(SELECT COUNT(*) FROM users u
	JOIN profiles p ON u.id = p.user_id 
	JOIN likes l ON p.user_id = l.user_id 
WHERE p.gender = 'f') AS female,

(SELECT COUNT(*) FROM users u
	JOIN profiles p ON u.id = p.user_id 
	JOIN likes l ON p.user_id = l.user_id 
WHERE p.gender = 'm') AS man;



-- 2 решение
SELECT
	p.gender,
	COUNT(*) AS total
FROM profiles p

JOIN likes l ON p.user_id = l.user_id
 
WHERE p.gender = 'f' OR p.gender = 'm'
GROUP BY p.gender
ORDER by total DESC;












