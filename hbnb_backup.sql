-- MySQL dump 10.13  Distrib 9.3.0, for macos13.7 (x86_64)
--
-- Host: localhost    Database: hbnb_db
-- ------------------------------------------------------
-- Server version	9.3.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `amenities`
--

DROP TABLE IF EXISTS `amenities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `amenities` (
  `id` varchar(60) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `name` varchar(50) NOT NULL,
  `description` varchar(100) NOT NULL,
  `number` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `amenities`
--

LOCK TABLES `amenities` WRITE;
/*!40000 ALTER TABLE `amenities` DISABLE KEYS */;
INSERT INTO `amenities` VALUES ('c48d45ba-9b95-4f9a-b62a-6d4901c02d4b','2025-10-22 07:08:26','2025-10-22 07:08:26','WiFi','High-speed internet',NULL),('e1d6cdaf-4147-4c5d-9676-32e48c7a6a5b','2025-10-22 07:08:26','2025-10-22 07:08:26','Parking','Free parking available',NULL),('e631593b-af91-4ef4-8e7f-dc245b5dc8dc','2025-10-22 07:08:26','2025-10-22 07:08:26','Pool','Swimming pool',NULL);
/*!40000 ALTER TABLE `amenities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bookings`
--

DROP TABLE IF EXISTS `bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bookings` (
  `place_id` varchar(60) NOT NULL,
  `guest_id` varchar(60) NOT NULL,
  `check_in_date` date NOT NULL,
  `check_out_date` date NOT NULL,
  `total_price` float NOT NULL,
  `status` enum('pending','confirmed','cancelled','completed') NOT NULL,
  `id` varchar(60) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `place_id` (`place_id`),
  KEY `guest_id` (`guest_id`),
  CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`place_id`) REFERENCES `places` (`id`),
  CONSTRAINT `bookings_ibfk_2` FOREIGN KEY (`guest_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookings`
--

LOCK TABLES `bookings` WRITE;
/*!40000 ALTER TABLE `bookings` DISABLE KEYS */;
INSERT INTO `bookings` VALUES ('0ba1f8da-87ef-47d1-a5f7-8abf203ed1f9','292682b7-6572-4c0f-a6d2-c26468fc1b4e','2025-11-17','2025-11-20',5550,'pending','09ba45cb-2507-425b-8d5f-8cd36694db8c','2025-11-16 08:08:23','2025-11-16 08:08:23'),('f33010b9-118d-4acd-84f4-cbc0247d2f81','b9b95ebf-f685-408b-81f1-c4600c0e5e19','2025-11-25','2025-11-27',4400,'cancelled','15f560b6-9ee1-445f-8831-858daaf42409','2025-11-16 09:34:23','2025-11-16 09:34:35'),('04274cf7-013d-44a6-bc2a-73fdb058c669','292682b7-6572-4c0f-a6d2-c26468fc1b4e','2025-11-16','2025-11-17',1600,'confirmed','aa765659-5509-4341-91be-eeb282385a59','2025-11-16 09:17:37','2025-11-16 09:31:59'),('d057a7fd-2101-4999-818a-cc2569438d71','292682b7-6572-4c0f-a6d2-c26468fc1b4e','2025-11-18','2025-11-20',3500,'cancelled','b54dc3c1-fc48-4396-84fe-22dba23891f9','2025-11-16 08:02:27','2025-11-16 08:05:29'),('0ba1f8da-87ef-47d1-a5f7-8abf203ed1f9','292682b7-6572-4c0f-a6d2-c26468fc1b4e','2025-11-23','2025-11-25',3700,'pending','f0e12b4e-1bd8-4476-b22d-3a0321f7e204','2025-11-22 11:53:55','2025-11-22 11:53:55');
/*!40000 ALTER TABLE `bookings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `place_amenity`
--

DROP TABLE IF EXISTS `place_amenity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `place_amenity` (
  `place_id` varchar(60) NOT NULL,
  `amenity_id` varchar(60) NOT NULL,
  PRIMARY KEY (`place_id`,`amenity_id`),
  KEY `amenity_id` (`amenity_id`),
  CONSTRAINT `place_amenity_ibfk_1` FOREIGN KEY (`place_id`) REFERENCES `places` (`id`) ON DELETE CASCADE,
  CONSTRAINT `place_amenity_ibfk_2` FOREIGN KEY (`amenity_id`) REFERENCES `amenities` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `place_amenity`
--

LOCK TABLES `place_amenity` WRITE;
/*!40000 ALTER TABLE `place_amenity` DISABLE KEYS */;
/*!40000 ALTER TABLE `place_amenity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `places`
--

DROP TABLE IF EXISTS `places`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `places` (
  `id` varchar(60) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `title` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `price` float NOT NULL,
  `latitude` float NOT NULL,
  `longitude` float NOT NULL,
  `owner_id` varchar(60) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `owner_id` (`owner_id`),
  CONSTRAINT `places_ibfk_1` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `places`
--

LOCK TABLES `places` WRITE;
/*!40000 ALTER TABLE `places` DISABLE KEYS */;
INSERT INTO `places` VALUES ('04274cf7-013d-44a6-bc2a-73fdb058c669','2025-11-16 06:01:34','2025-11-16 09:12:40','Mirror House Sud','Mirror Houses are two small houses immersed in apple orchards with Dolomites views. Enjoy contemporary architecture and nature at once.',1600,46.4983,11.3548,'b9b95ebf-f685-408b-81f1-c4600c0e5e19'),('0ba1f8da-87ef-47d1-a5f7-8abf203ed1f9','2025-11-16 06:01:34','2025-11-16 09:12:40','Malibu Beach House','Beachfront modern hideaway in Malibu featuring ocean deck, salt-air mornings, and sunset silhouettes.',1850,34.0259,-118.78,'26d45bc3-dc36-4507-a00f-b1b4f61f38d9'),('68ff13c8-de7e-4e98-9b61-e92173a62495','2025-11-16 06:01:34','2025-11-16 09:12:40','Palm Springs Desert Retreat','Sculptural desert home with private pool, spa, and mountain vistas—perfect for slow, sun-soaked days.',1450,33.8303,-116.545,'b9b95ebf-f685-408b-81f1-c4600c0e5e19'),('a3b29d3d-0d82-4b99-a7fb-51fca3cdeec8','2025-11-16 06:01:34','2025-11-16 09:12:40','Forest Cabin Portland','Cozy Douglas-fir cabin just outside Portland with wraparound windows, fireplace, and trail access.',950,45.5152,-122.678,'301abe6a-12ad-4efd-83f9-53f73e0c5e34'),('d057a7fd-2101-4999-818a-cc2569438d71','2025-11-16 06:01:34','2025-11-16 09:12:40','Lake Tahoe Modern Lakehouse','Glassy lakefront stay with private dock on Tahoe\'s north shore, blending indoor comfort with alpine air.',1750,39.0968,-120.032,'b9b95ebf-f685-408b-81f1-c4600c0e5e19'),('f33010b9-118d-4acd-84f4-cbc0247d2f81','2025-11-16 06:01:34','2025-11-16 09:12:40','Mountain Villa Aspen','Luxurious mountain villa near Aspen peaks with panoramic views and instant access to skiing and alpine adventures.',2200,39.1911,-106.818,'26d45bc3-dc36-4507-a00f-b1b4f61f38d9');
/*!40000 ALTER TABLE `places` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reviews` (
  `id` varchar(60) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `text` text NOT NULL,
  `rating` int NOT NULL,
  `place_id` varchar(60) NOT NULL,
  `user_id` varchar(60) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `place_id` (`place_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`place_id`) REFERENCES `places` (`id`) ON DELETE CASCADE,
  CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
INSERT INTO `reviews` VALUES ('33ca339a-fa87-42e6-9600-27a582347dee','2025-11-16 09:06:42','2025-11-16 09:06:42','Modern desert oasis! The pool and spa were amazing after hiking. Architecture is stunning and the mountain vistas are breathtaking. John thought of everything!',5,'68ff13c8-de7e-4e98-9b61-e92173a62495','ba8559f3-5ff0-402e-827d-ae96d0472873'),('81139999-67be-424e-80ce-f52775e053f9','2025-11-16 09:06:42','2025-11-16 09:06:42','Absolutely stunning property! The mirror architecture blends beautifully with the apple orchards. Perfect for a peaceful getaway in the Dolomites. Would definitely stay again!',5,'04274cf7-013d-44a6-bc2a-73fdb058c669','3431a21e-e928-4747-b083-e855c25634d1'),('d29c5287-2593-4d0a-873a-4cb8a5328e7c','2025-11-16 09:06:42','2025-11-16 09:06:42','Cozy cabin surrounded by nature! Perfect for disconnecting and enjoying the forest. The fireplace made evenings so relaxing. Great value for the price.',5,'a3b29d3d-0d82-4b99-a7fb-51fca3cdeec8','3431a21e-e928-4747-b083-e855c25634d1'),('d6a26e39-cfab-4446-abfd-94db2a4dbc3d','2025-11-16 09:06:42','2025-11-16 09:06:42','Lakefront paradise! Waking up to Tahoe views was magical. The private dock made kayaking easy. Clean, modern, and perfectly located. Will be back next summer!',5,'d057a7fd-2101-4999-818a-cc2569438d71','ccfdd028-9536-459c-8230-ac07f07a4140'),('e3f3d35a-fe6f-4a15-add7-c28d048a03b3','2025-11-16 09:06:42','2025-11-16 09:06:42','Beautiful beachfront location with amazing ocean views. The deck is perfect for morning coffee and sunset watching. Only minor issue was some traffic noise, but overall a fantastic stay.',4,'0ba1f8da-87ef-47d1-a5f7-8abf203ed1f9','ccfdd028-9536-459c-8230-ac07f07a4140'),('fba1a4b5-0ccc-4dca-82a9-fe8e45e185c6','2025-11-16 09:06:42','2025-11-16 09:06:42','Dream ski vacation! The villa offers incredible mountain views and easy access to the slopes. Sarah was a wonderful host. Highly recommended for winter sports enthusiasts.',5,'f33010b9-118d-4acd-84f4-cbc0247d2f81','ba8559f3-5ff0-402e-827d-ae96d0472873');
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` varchar(60) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(120) NOT NULL,
  `password` varchar(128) NOT NULL,
  `is_admin` tinyint(1) DEFAULT '0',
  `phone_number` varchar(30) DEFAULT NULL,
  `home_location` varchar(120) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('26d45bc3-dc36-4507-a00f-b1b4f61f38d9','2025-11-16 09:06:40','2025-11-16 09:12:40','Sarah','Chen','sarah.chen@example.com','$2b$12$yjMWPj.R0DMb.j/EE7D.MOqWQpxt3ljjdAcOTq8m.gOvD3W4Lo9SC',0,'+1 (555) 234-5678','Seattle, WA'),('292682b7-6572-4c0f-a6d2-c26468fc1b4e','2025-11-16 08:02:05','2025-11-16 08:02:54','XIAOLING','CUI','cxlcxl0111@gmail.com','$2b$12$iOkt2TRlC1U4c1qbQLA6Z.hljB2K1.eOItKYZxASUZbx1cVkSSGF.',0,'0493729321','Melbourne, Australia'),('301abe6a-12ad-4efd-83f9-53f73e0c5e34','2025-11-16 09:06:41','2025-11-16 09:12:40','Mike','Johnson','mike.johnson@example.com','$2b$12$t81p4TEfqs.i/Rp7nteuMeN4rKfz7dciRZfD0uhQ1vkuYf1j696Xq',0,'+1 (555) 876-5432','Portland, OR'),('3431a21e-e928-4747-b083-e855c25634d1','2025-11-16 09:06:41','2025-11-16 09:12:41','Emma','Wilson','emma.wilson@example.com','$2b$12$rWgmw8WP32RrmHnAiB1yJuypwG29inXjWQTFnXZbpL9SJm4noqw0C',0,NULL,NULL),('762f8522-efd1-43df-967e-1d9765515e00','2025-10-22 07:08:25','2025-10-22 07:08:25','Alice','Smith','alice@example.com','$2b$12$j1OmGAlzvfOms0juCi9/ueaUSy3b9ntCNrghdl4GWwYTcCwZ0MdcW',0,NULL,NULL),('8b7af809-7d39-4408-a861-102abd7dbc2e','2025-10-22 07:08:26','2025-10-22 07:08:26','Bob','Johnson','bob@example.com','$2b$12$qlRt2BAbUqfMEybBKMD9JON7mhlpPMP/2PRh74igpchPdaoVgkv3a',0,NULL,NULL),('b9b95ebf-f685-408b-81f1-c4600c0e5e19','2025-11-16 06:01:34','2025-11-16 09:12:40','John','Doe','john.doe@example.com','$2b$12$u./AjlF3UgZocYHTCZnSLOGQAAXFSf2eTA4MOM3HdVeeEMlnhlgxG',0,'+1 (555) 987-6543','San Francisco, CA'),('ba8559f3-5ff0-402e-827d-ae96d0472873','2025-11-16 09:06:42','2025-11-16 09:12:41','Alex','Martinez','alex.martinez@example.com','$2b$12$0hZVjv4eHXGl.6waNKjnvunR3A2.XHCA69yai8R7mWlFGmag3v6Ye',0,NULL,NULL),('ccfdd028-9536-459c-8230-ac07f07a4140','2025-11-16 09:06:42','2025-11-16 09:12:41','Lisa','Anderson','lisa.anderson@example.com','$2b$12$.Gx38aUlK4.cyd7YCwzm1eCurDIAADSPRDT0WaBs9hhZqEcvi82DK',0,NULL,NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-20  3:11:12
