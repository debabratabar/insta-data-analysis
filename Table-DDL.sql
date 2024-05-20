-- drop schema instagram;
DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS likes;
DROP TABLE IF EXISTS followers;
DROP TABLE IF EXISTS posts;
DROP TABLE IF EXISTS users;

CREATE  TABLE users (
    user_id SERIAL  PRIMARY KEY NOT NULL,
    name VARCHAR(40) NOT NULL,
    email VARCHAR(20) NOT NULL,
    phone_no VARCHAR(20) NOT NULL
);

-- select * from followers;

CREATE   TABLE posts (
    post_id SERIAL PRIMARY KEY NOT NULL ,
    user_id  INTEGER NOT NULL,
    caption TEXT , 
    image_url VARCHAR(200) ,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
    FOREIGN KEY ( user_id ) REFERENCES  users(user_id) 
);

CREATE   TABLE likes (
      like_id SERIAL PRIMARY KEY NOT NULL,
      post_id INTEGER NOT NULL ,
      user_id INTEGER NOT NULL, 
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
      FOREIGN KEY ( user_id ) REFERENCES users(user_id) ,
      FOREIGN KEY ( post_id ) REFERENCES posts(post_id) 
);

CREATE   TABLE followers (
    follower_id SERIAL PRIMARY KEY NOT NULL , 
    user_id INTEGER NOT NULL , 
    followers_user_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY ( user_id ) REFERENCES users(user_id) ,
    FOREIGN KEY ( followers_user_id ) REFERENCES users(user_id) 
);

CREATE   TABLE comments (
    comments_id SERIAL PRIMARY KEY NOT NULL, 
    post_id INTEGER NOT NULL, 
    user_id INTEGER NOT NULL , 
    comment_text VARCHAR(40),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY ( user_id ) REFERENCES users(user_id) ,
    FOREIGN KEY ( post_id ) REFERENCES posts(post_id) 
);

