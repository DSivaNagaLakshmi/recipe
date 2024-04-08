-- MySQL dump 10.13  Distrib 8.0.32, for Win64 (x86_64)
--
-- Host: localhost    Database: recipe_sharing
-- ------------------------------------------------------
-- Server version	8.0.32

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
-- Table structure for table `blog`
--

DROP TABLE IF EXISTS `blog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blog` (
  `blogid` int NOT NULL AUTO_INCREMENT,
  `blogtitle` tinytext,
  `blogdesc` longtext,
  `date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`blogid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blog`
--

LOCK TABLES `blog` WRITE;
/*!40000 ALTER TABLE `blog` DISABLE KEYS */;
/*!40000 ALTER TABLE `blog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blogs`
--

DROP TABLE IF EXISTS `blogs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blogs` (
  `blogid` int NOT NULL AUTO_INCREMENT,
  `name` varchar(30) DEFAULT NULL,
  `title` tinytext,
  `description` longtext,
  `date` datetime DEFAULT CURRENT_TIMESTAMP,
  `Categories` enum('vegfood','nonvegfood','pastry','icecreams','starters','soups') DEFAULT NULL,
  `imageid` varchar(9) DEFAULT NULL,
  PRIMARY KEY (`blogid`),
  KEY `name` (`name`),
  CONSTRAINT `blogs_ibfk_1` FOREIGN KEY (`name`) REFERENCES `details` (`name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blogs`
--

LOCK TABLES `blogs` WRITE;
/*!40000 ALTER TABLE `blogs` DISABLE KEYS */;
INSERT INTO `blogs` VALUES (15,'bhargavi','kulfi','1. In a heavy and wide pan or kadai (Indian wok), heat 3 cups milk on a low flame for at least 18 to 20 minutes. The milk will reduce and thicken in this period of time.\r\n2. Dissolve 1.5 tablespoons of rice flour or 1 tablespoon cornstarch with 3 tablespoons of milk. Mix very well. Set aside.\r\n3. Grate 75 to 80 grams of khoya (mawa) or crumble it very well to a fine texture. There should be no large pieces or lumps.\r\n4. After 18 to 20 minutes, add 3 tablespoons of sugar to the reduced milk and mix well. Keep scraping the milk solids from the sides and reincorporating them into the simmering milk.\r\n5. When the sugar has dissolved and after 3 to 4 minutes, add the rice flour or cornstarch paste. Keep stirring while adding the rice flour paste so that no lumps are formed.\r\n6. After 4 to 5 minutes, when the mixture has thickened, add the grated khoya (mawa), powdered almonds & pistachios, and ½ teaspoon cardamom powder (or about 4 green cardamoms crushed in a mortar-pestle).\r\n7. Stir very well and simmer for a minute or two on a low heat. Keep stirring so that the khoya (evaporated milk solids) is evenly distributed.\r\n8. Switch off the heat. Add 1 teaspoon rose water or kewra water (pandanus water) and crushed saffron – about 25 to 30 saffron strands that have been crushed.\r\nTaste test the mixture and add more sugar if needed according to your taste preferences.\r\n9. Let the mixture cool at room temperature, then pour the mixture in kulfi moulds, serving bowls, a tray or in shot glasses. Be sure to scrape the milk solids from the sides of the pan and add them to the mixture.\r\n10. Cover with lids or aluminum foil and freeze overnight or for a day until the kulfi is frozen and set.\r\n11. Once the kulfi is frozen solid, unmould it by sliding a butter knife at the edges, rubbing the mould between your palms or dipping the mould in warm water to loosen it.\r\n','2023-07-11 16:33:52','icecreams','Y3cQ0qH4o');
/*!40000 ALTER TABLE `blogs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `details`
--

DROP TABLE IF EXISTS `details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `details` (
  `name` varchar(30) NOT NULL,
  `email` varchar(30) DEFAULT NULL,
  `password` varchar(30) DEFAULT NULL,
  `gender` char(10) DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `details`
--

LOCK TABLES `details` WRITE;
/*!40000 ALTER TABLE `details` DISABLE KEYS */;
INSERT INTO `details` VALUES ('bhargavi','kondurinisitha@gmail.com','jaya','female'),('bhargavip','206114@siddharthamahila.ac.in','jaya','female'),('jayasri','jayasrichillapalli@gmail.com','jaya','female'),('mounika','206701@siddharthamahila.ac.in','mouni','female'),('sahithi','206110@siddharthamahila.ac.in','jaya','female'),('Visali','206156@siddharthamahila.ac.in','visali','female'),('xfcgvhbjnk','206105@siddharthamahila.ac.in','jaya','female');
/*!40000 ALTER TABLE `details` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-07-11 19:34:14
