-- Selecting all the posts where user_id is 1
SELECT * FROM posts WHERE user_id= 1;

-- Selecting all the posts and ordering them by created_at in descending order

SELECT * FROM posts ORDER BY created_at DESC ; 

-- Counting the number of likes for each post and showing only the posts with more than 2 likes


SELECT P.post_id , COUNT(L.like_id) FROM 
posts P LEFT JOIN likes L ON P.post_id =L.post_id 
GROUP BY P.post_id
HAVING COUNT(L.like_id) > 2 ;

-- Finding the total number of likes for all posts
SELECT COUNT(like_id) FROM likes;

-- Finding all the users who have commented on post_id 1
-- SELECT * FROM comments 

SELECT user_id , name , email FROM users WHERE user_id IN (
SELECT user_id  FROM comments 
WHERE post_id =1  );

-- Ranking the posts based on the number of likes

WITH posts_like_count as ( 
SELECT P.post_id , COUNT(L.like_id) AS like_count FROM
posts P LEFT JOIN likes L ON P.post_id =L.post_id 
GROUP BY P.post_id) 
SELECT * , RANK() OVER(ORDER BY like_count DESC ) AS posts_rank
FROM posts_like_count ;

-- Finding all the posts and their comments using a Common Table Expression (CTE)

-- 1. just get the comments one by one 
SELECT post_id , comment_text FROM comments ORDER BY post_id;

-- 2. get the comments in an array
SELECT post_id , ARRAY_AGG(comment_text) FROM comments 
GROUP BY post_id
ORDER BY post_id;

-- Categorizing the posts based on the number of likes
WITH posts_like_count as ( 
SELECT P.post_id , COUNT(L.like_id) AS like_count FROM
posts P LEFT JOIN likes L ON P.post_id =L.post_id 
GROUP BY P.post_id) 
SELECT * , 
	CASE 
		WHEN like_count =0 THEN 'No Likes' 
		WHEN like_count <5 THEN 'Few Likes'
		WHEN like_count <10 THEN 'Some Likes'
		ELSE 'Lots of Likes' 
		END AS like_catg		
FROM posts_like_count  

-- Finding all the posts created in the last month
1. for last month we have to check if its jan then we have to check for last years dec data 



SELECT *  FROM posts 
WHERE created_at >= DATE_TRUNC('month' , CURRENT_TIMESTAMP ) - INTERVAL '1 month' 
AND created_at < DATE_TRUNC('month' , CURRENT_TIMESTAMP );

-- Which users have liked post_id 2


SELECT * FROM users WHERE user_id IN ( 
SELECT user_id FROM likes
WHERE post_id = 2 
)

-- Which posts have no comments?

SELECT *  FROM posts P
LEFT JOIN comments C ON  P.post_id = C.post_id 
WHERE C.post_id IS NULL 

-- Which posts were created by users who have no followers?

SELECT P.post_id , P.caption ,  P.image_url
FROM posts P LEFT JOIN followers  F 
ON P.user_id = F.user_id 
WHERE F.user_id IS NULL 

-- How many likes does each post have 

SELECT P.post_id , COUNT(L.like_id) FROM 
posts P LEFT JOIN likes L 
ON P.post_id = L.post_id 
GROUP BY P.post_id


-- What is the average number of likes per post

SELECT COUNT(like_id) / COUNT(DISTINCT post_id) FROM 
likes ;

-- Which user has the most followers

SELECT * FROM followers

SELECT user_id , COUNT(followers_user_id ) follower_count FROM 
followers 
GROUP BY user_id 
ORDER BY follower_count DESC LIMIT 1;


-- Rank the users by the number of posts they have created

WITH number_of_posts AS (
SELECT U.user_id , COUNT(P.post_id) post_count FROM 
users U LEFT JOIN posts P 
	ON U.user_id = P.user_id 
GROUP BY U.user_id
)
SELECT * , RANK() OVER(ORDER BY post_count DESC  ) ranks_by_posts
FROM number_of_posts ; 

-- Rank the posts based on the number of likes

SELECT * FROM likes

WITH number_of_likes AS (
SELECT P.post_id , COUNT(P.post_id) like_count FROM 
posts P LEFT JOIN likes L 
	ON P.post_id = L.post_id 
GROUP BY P.post_id
)
SELECT * , RANK() OVER(ORDER BY like_count DESC  ) ranks_by_likes
FROM number_of_likes ; 

-- Find the cumulative number of likes for each pos
SELECT P.post_id , COUNT(P.post_id) like_count FROM 
posts P LEFT JOIN likes L 
	ON P.post_id = L.post_id 
GROUP BY P.post_id

-- Find all the comments and their users using a Common Table Expression (CTE).

WITH users_comments AS (
SELECT U.name , C.comment_text FROM comments C 
LEFT JOIN users U ON U.user_id = C.user_id
)
SELECT name , ARRAY_AGG(comment_text) FROM users_comments
GROUP BY 1 ORDER BY 1 

-- Find all the followers and their follower users using a CTE.

WITH follower_details AS ( 
SELECT F.user_id , F.followers_user_id , U.name 
FROM followers F LEFT JOIN users U 
ON F.followers_user_id = U.user_id 
)
SELECT user_id , ARRAY_AGG(name) FROM follower_details
GROUP BY 1 ORDER BY 1 DESC 

-- Find all the posts and their comments using a CTE

WITH posts_comments AS ( 
SELECT P.post_id , C.comment_text
FROM posts P  LEFT JOIN comments C 
ON P.post_id = C.post_id WHERE C.post_id IS NOT NULL 
)
SELECT post_id , ARRAY_AGG(comment_text) FROM posts_comments
GROUP BY 1 ORDER BY 1 DESC 

-- Categorize the posts based on the number of likes

WITH posts_likes_count AS ( 
SELECT P.post_id , COUNT(L.like_id) like_count
FROM posts P  LEFT JOIN likes L 
ON P.post_id = L.post_id 
GROUP BY 1 
)
SELECT post_id , 
	CASE WHEN like_count =0 THEN 'No Likes'
		WHEN like_count < 5 THEN 'Few Likes'
		WHEN like_count < 10 THEN 'More Likes'
		ELSE 'Lots Of Likes'
		END AS like_catg
FROM posts_likes_count;


-- Categorize the users based on the number of comments they have made

WITH user_comments_count AS (
SELECT user_id , COUNT(comments_id) comments_count FROM comments 
GROUP BY 1 
)
SELECT user_id , 
	CASE WHEN comments_count =0 THEN 'No comments'
		WHEN comments_count < 5 THEN 'Few comments'
		WHEN comments_count < 10 THEN 'More comments'
		ELSE 'Lots Of comments'
		END AS comm_catg
FROM user_comments_count;

-- Categorize the posts based on their age

SELECT * FROM posts

WITH posts_age AS (
SELECT post_id , (CURRENT_DATE - DATE(created_at))  AS  posts_age
FROM posts )
SELECT post_id , posts_age , 
		CASE WHEN posts_age <= 7 THEN 'New Posts'
		WHEN posts_age >7 THEN 'Old Posts'
		ELSE 'Very Old Posts'
		END AS posts_cal_by_age 
		FROM posts_age ORDER BY posts_age




