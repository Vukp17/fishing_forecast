-- --------------------------------------------------------
-- Host:                         164.8.67.107
-- Server version:               8.0.26 - Source distribution
-- Server OS:                    Linux
-- HeidiSQL Version:             12.5.0.6677
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Dumping structure for table fishingapp.failed_jobs
CREATE TABLE  failed_jobs (
  id bigint  NOT NULL ,
  uuid varchar(255)   NOT NULL,
  connection text   NOT NULL,
  queue text   NOT NULL,
  payload longtext   NOT NULL,
  exception longtext   NOT NULL,
  failed_at timestamp NOT NULL  ,
  PRIMARY KEY (id)
) 

-- Data exporting was unselected.

-- Dumping structure for table fishingapp.languages
CREATE TABLE  languages (
  id bigint  NOT NULL ,
  name varchar(255)   NOT NULL,
  PRIMARY KEY (id)
) 

-- Data exporting was unselected.

-- Dumping structure for table fishingapp.migrations
CREATE TABLE  migrations (
  id int  NOT NULL ,
  migration varchar(255)   NOT NULL,
  batch int NOT NULL,
  PRIMARY KEY (id)
) 

-- Data exporting was unselected.

-- Dumping structure for table fishingapp.password_reset_tokens
CREATE TABLE  password_reset_tokens (
  email varchar(255)   NOT NULL,
  token varchar(255)   NOT NULL,
  created_at timestamp NULL  ,
  PRIMARY KEY (email)
) 

-- Data exporting was unselected.

-- Dumping structure for table fishingapp.personal_access_tokens
CREATE TABLE  personal_access_tokens (
  id bigint  NOT NULL ,
  tokenable_type varchar(255)   NOT NULL,
  tokenable_id bigint  NOT NULL,
  name varchar(255)   NOT NULL,
  token varchar(64)   NOT NULL,
  abilities text  ,
  last_used_at timestamp NULL  ,
  expires_at timestamp NULL  ,
  created_at timestamp NULL  ,
  updated_at timestamp NULL  ,
  PRIMARY KEY (id)
  KEY personal_access_tokens_tokenable_type_tokenable_id_index (tokenable_type,tokenable_id)
) 

-- Data exporting was unselected.

-- Dumping structure for table fishingapp.spots
CREATE TABLE  spots (
  id bigint  NOT NULL ,
  name varchar(255)   NOT NULL,
  description varchar(255)   NOT NULL,
  lng varchar(255)   NOT NULL,
  lat varchar(255)   NOT NULL,
  user_id int NOT NULL,
  image_id varchar(255)   NOT NULL,
  updated_at varchar(255)   NOT NULL,
  created_at varchar(255)   NOT NULL,
  PRIMARY KEY (id)
) 

-- Data exporting was unselected.

-- Dumping structure for table fishingapp.users
CREATE TABLE  users (
  id bigint  NOT NULL ,
  username varchar(255)   NOT NULL,
  email varchar(255)   NOT NULL,
  email_verified_at timestamp NULL  ,
  password varchar(255)    NULL,
  remember_token varchar(100)    NULL,
  created_at timestamp NULL  ,
  updated_at timestamp NULL  ,
  language_id varchar(255)    NULL, 
  PRIMARY KEY (id)
) 

-- Data exporting was unselected.

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
