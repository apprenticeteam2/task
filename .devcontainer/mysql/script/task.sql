-- データベース作成

DROP DATABASE IF EXISTS task_app;
CREATE DATABASE IF NOT EXISTS task_app;
USE task_app;

SELECT 'CREATING DATABASE STRUCTURE' as 'INFO';

DROP TABLE IF EXISTS tasks;
                    --  users;

-- テーブル作成

-- CREATE TABLE users (
--     id BIGINT AUTO_INCREMENT PRIMARY KEY,
--     username VARCHAR(30) NOT NULL,
--     mail VARCHAR(260) NOT NULL,
--     password VARCHAR(50) NOT NULL,
--     role INT NOT NULL,
--     created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
--     updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
-- );

CREATE TABLE tasks (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    name VARCHAR(50) NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    completed BOOLEAN DEFAULT NULL,
    fine INT NOT NULL DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    -- FOREIGN KEY (user_id) REFERENCES users(id)
);

insert into tasks ( user_id, name, start_time, end_time, completed, fine) values (
    1,
    'a',
    '2024-11-08 13:40',
    '2024-11-08 13:50',
    1,
    100
);