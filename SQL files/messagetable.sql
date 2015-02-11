message.sql

create database chat;
CREATE TABLE IF NOT EXISTS messageTable (
  messageID int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  sender varchar(50) NOT NULL,
  receiver varchar(50) NOT NULL,
  message varchar(255)
) ;