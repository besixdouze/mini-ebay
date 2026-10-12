-- MySQL dump 10.13  Distrib 9.4.0, for Win64 (x86_64)
--
-- ------------------------------------------------------
-- Server version	9.4.0

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
-- Table structure for table `bid`
--

DROP TABLE IF EXISTS `bid`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bid` (
  `BidId` int NOT NULL AUTO_INCREMENT,
  `ProductId` int NOT NULL,
  `UserName` varchar(20) NOT NULL,
  `BidAmount` decimal(10,2) NOT NULL,
  `BidDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`BidId`),
  KEY `ProductId` (`ProductId`),
  KEY `UserName` (`UserName`),
  CONSTRAINT `bid_ibfk_1` FOREIGN KEY (`ProductId`) REFERENCES `product` (`ProductId`) ON DELETE CASCADE,
  CONSTRAINT `bid_ibfk_2` FOREIGN KEY (`UserName`) REFERENCES `usergood` (`UserName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bid`
--

LOCK TABLES `bid` WRITE;
/*!40000 ALTER TABLE `bid` DISABLE KEYS */;
/*!40000 ALTER TABLE `bid` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department`
--

DROP TABLE IF EXISTS `department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `department` (
  `DeptId` int NOT NULL AUTO_INCREMENT,
  `DeptName` varchar(50) NOT NULL,
  `Description` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`DeptId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department`
--

LOCK TABLES `department` WRITE;
/*!40000 ALTER TABLE `department` DISABLE KEYS */;
INSERT INTO `department` VALUES (1,'Electronics','Electronic devices and gadgets'),(2,'Computers','Computer hardware and accessories'),(3,'Books','Books and publications'),(4,'Clothing','Apparel and fashion items'),(6,'Sports','Sports equipment and accessories'),(7,'Toys','Toys and games'),(8,'Other','Miscellaneous items');
/*!40000 ALTER TABLE `department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menuelement`
--

DROP TABLE IF EXISTS `menuelement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `menuelement` (
  `menuID` int NOT NULL,
  `title` varchar(50) NOT NULL,
  `description` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`menuID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menuelement`
--

LOCK TABLES `menuelement` WRITE;
/*!40000 ALTER TABLE `menuelement` DISABLE KEYS */;
INSERT INTO `menuelement` VALUES (0,'General','General pages'),(1,'Products','Product management'),(2,'Bidding','Bidding operations'),(3,'Admin','Administrative functions');
/*!40000 ALTER TABLE `menuelement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `ProductId` int NOT NULL AUTO_INCREMENT,
  `ProductName` varchar(100) NOT NULL,
  `Description` text NOT NULL,
  `StartingBid` decimal(10,2) NOT NULL,
  `CurrentBid` decimal(10,2) NOT NULL,
  `ImagePath` varchar(255) DEFAULT NULL,
  `DueDate` date NOT NULL,
  `DeptId` int NOT NULL,
  `SellerUserName` varchar(20) NOT NULL,
  `DateCreated` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `IsActive` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`ProductId`),
  KEY `DeptId` (`DeptId`),
  KEY `SellerUserName` (`SellerUserName`),
  CONSTRAINT `product_ibfk_1` FOREIGN KEY (`DeptId`) REFERENCES `department` (`DeptId`),
  CONSTRAINT `product_ibfk_2` FOREIGN KEY (`SellerUserName`) REFERENCES `usergood` (`UserName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role` (
  `RoleId` varchar(20) NOT NULL,
  `RoleName` varchar(50) NOT NULL,
  `Description` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`RoleId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES ('ADMIN','Administrator','Full system access'),('USER','Regular User','Can browse, bid, and sell products');
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roleuser`
--

DROP TABLE IF EXISTS `roleuser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roleuser` (
  `UserName` varchar(20) NOT NULL,
  `RoleId` varchar(20) NOT NULL,
  `dateAssign` date NOT NULL,
  PRIMARY KEY (`UserName`,`RoleId`),
  KEY `RoleId` (`RoleId`),
  CONSTRAINT `roleuser_ibfk_1` FOREIGN KEY (`UserName`) REFERENCES `usergood` (`UserName`) ON DELETE CASCADE,
  CONSTRAINT `roleuser_ibfk_2` FOREIGN KEY (`RoleId`) REFERENCES `role` (`RoleId`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roleuser`
--

LOCK TABLES `roleuser` WRITE;
/*!40000 ALTER TABLE `roleuser` DISABLE KEYS */;
/*!40000 ALTER TABLE `roleuser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rolewebpagegood`
--

DROP TABLE IF EXISTS `rolewebpagegood`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rolewebpagegood` (
  `RoleId` varchar(20) NOT NULL,
  `pageURL` varchar(100) NOT NULL,
  PRIMARY KEY (`RoleId`,`pageURL`),
  KEY `pageURL` (`pageURL`),
  CONSTRAINT `rolewebpagegood_ibfk_1` FOREIGN KEY (`RoleId`) REFERENCES `role` (`RoleId`) ON DELETE CASCADE,
  CONSTRAINT `rolewebpagegood_ibfk_2` FOREIGN KEY (`pageURL`) REFERENCES `webpagegood` (`pageURL`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rolewebpagegood`
--

LOCK TABLES `rolewebpagegood` WRITE;
/*!40000 ALTER TABLE `rolewebpagegood` DISABLE KEYS */;
INSERT INTO `rolewebpagegood` VALUES ('ADMIN','addDepartment.jsp'),('ADMIN','addUserAdmin.jsp'),('ADMIN','adminMenu.jsp'),('ADMIN','browseProducts.jsp'),('USER','browseProducts.jsp'),('ADMIN','deleteDepartment.jsp'),('ADMIN','deleteProduct.jsp'),('ADMIN','deleteUser.jsp'),('ADMIN','manageDepartments.jsp'),('ADMIN','manageProducts.jsp'),('ADMIN','manageUsers.jsp'),('ADMIN','myBids.jsp'),('USER','myBids.jsp'),('ADMIN','myProducts.jsp'),('USER','myProducts.jsp'),('ADMIN','placeBid.jsp'),('USER','placeBid.jsp'),('ADMIN','productDetail.jsp'),('USER','productDetail.jsp'),('ADMIN','searchProducts.jsp'),('USER','searchProducts.jsp'),('ADMIN','sellProduct_action.jsp'),('USER','sellProduct_action.jsp'),('ADMIN','sellProduct.jsp'),('USER','sellProduct.jsp'),('ADMIN','signout.jsp'),('USER','signout.jsp'),('ADMIN','welcomeMenu.jsp'),('USER','welcomeMenu.jsp');
/*!40000 ALTER TABLE `rolewebpagegood` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usergood`
--

DROP TABLE IF EXISTS `usergood`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usergood` (
  `UserName` varchar(20) NOT NULL,
  `hashing` mediumtext NOT NULL,
  `Name` varchar(100) NOT NULL,
  `Telephone` varchar(20) NOT NULL,
  PRIMARY KEY (`UserName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usergood`
--

LOCK TABLES `usergood` WRITE;
/*!40000 ALTER TABLE `usergood` DISABLE KEYS */;
/*!40000 ALTER TABLE `usergood` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `webpagegood`
--

DROP TABLE IF EXISTS `webpagegood`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `webpagegood` (
  `pageURL` varchar(100) NOT NULL,
  `pageTitle` varchar(100) NOT NULL,
  `pageDescription` varchar(200) DEFAULT NULL,
  `menuID` int NOT NULL,
  PRIMARY KEY (`pageURL`),
  KEY `menuID` (`menuID`),
  CONSTRAINT `webpagegood_ibfk_1` FOREIGN KEY (`menuID`) REFERENCES `menuelement` (`menuID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webpagegood`
--

LOCK TABLES `webpagegood` WRITE;
/*!40000 ALTER TABLE `webpagegood` DISABLE KEYS */;
INSERT INTO `webpagegood` VALUES ('addDepartment.jsp','Add Department','Add new department',3),('addUserAdmin.jsp','Add User','Add new user',3),('adminMenu.jsp','Admin Menu','Administrator dashboard',3),('browseProducts.jsp','Browse Products','View all products',1),('deleteDepartment.jsp','Delete Department','Remove department',3),('deleteProduct.jsp','Delete Product','Remove product',3),('deleteUser.jsp','Delete User','Remove user',3),('manageDepartments.jsp','Manage Departments','Department management',3),('manageProducts.jsp','Manage Products','Product management',3),('manageUsers.jsp','Manage Users','User management',3),('myBids.jsp','My Bids','View my bids',2),('myProducts.jsp','My Products','View my selling products',1),('placeBid.jsp','Place Bid','Place a bid on product',2),('productDetail.jsp','Product Details','View product details',1),('searchProducts.jsp','Search Results','Product search results',1),('sellProduct_action.jsp','Sell Product Action','Process new product',1),('sellProduct.jsp','Sell Product','Register new product',1),('signout.jsp','Sign Out','Logout from system',0),('welcomeMenu.jsp','Welcome','Main menu page',0);
/*!40000 ALTER TABLE `webpagegood` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `webpageprevious`
--

DROP TABLE IF EXISTS `webpageprevious`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `webpageprevious` (
  `currentPageURL` varchar(100) NOT NULL,
  `previousPageURL` varchar(100) NOT NULL,
  PRIMARY KEY (`currentPageURL`,`previousPageURL`),
  CONSTRAINT `webpageprevious_ibfk_1` FOREIGN KEY (`currentPageURL`) REFERENCES `webpagegood` (`pageURL`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webpageprevious`
--

LOCK TABLES `webpageprevious` WRITE;
/*!40000 ALTER TABLE `webpageprevious` DISABLE KEYS */;
INSERT INTO `webpageprevious` VALUES ('addDepartment.jsp','manageDepartments.jsp'),('addUserAdmin.jsp','manageUsers.jsp'),('adminMenu.jsp','welcomeMenu.jsp'),('browseProducts.jsp','welcomeMenu.jsp'),('deleteDepartment.jsp','manageDepartments.jsp'),('deleteProduct.jsp','manageProducts.jsp'),('deleteUser.jsp','manageUsers.jsp'),('manageDepartments.jsp','adminMenu.jsp'),('manageProducts.jsp','adminMenu.jsp'),('manageUsers.jsp','adminMenu.jsp'),('myBids.jsp','welcomeMenu.jsp'),('myProducts.jsp','welcomeMenu.jsp'),('placeBid.jsp','productDetail.jsp'),('productDetail.jsp','browseProducts.jsp'),('productDetail.jsp','myBids.jsp'),('productDetail.jsp','myProducts.jsp'),('productDetail.jsp','searchProducts.jsp'),('searchProducts.jsp','browseProducts.jsp'),('signout.jsp','welcomeMenu.jsp');
/*!40000 ALTER TABLE `webpageprevious` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Seed data: roles, departments, menus, pages. No user data; create the first admin per README.
