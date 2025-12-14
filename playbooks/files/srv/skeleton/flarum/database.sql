/*M!999999\- enable the sandbox mode */ 
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `access_tokens`
--

DROP TABLE IF EXISTS `access_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `access_tokens` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `token` varchar(40) NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `last_activity_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `type` varchar(100) NOT NULL,
  `title` varchar(150) DEFAULT NULL,
  `last_ip_address` varchar(45) DEFAULT NULL,
  `last_user_agent` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `access_tokens_token_unique` (`token`),
  KEY `access_tokens_user_id_foreign` (`user_id`),
  KEY `access_tokens_type_index` (`type`),
  CONSTRAINT `access_tokens_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `access_tokens`
--

LOCK TABLES `access_tokens` WRITE;
/*!40000 ALTER TABLE `access_tokens` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `access_tokens` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `api_keys`
--

DROP TABLE IF EXISTS `api_keys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `api_keys` (
  `key` varchar(100) NOT NULL,
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `allowed_ips` varchar(255) DEFAULT NULL,
  `scopes` varchar(255) DEFAULT NULL,
  `user_id` int(10) unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `last_activity_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `api_keys_key_unique` (`key`),
  KEY `api_keys_user_id_foreign` (`user_id`),
  CONSTRAINT `api_keys_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_keys`
--

LOCK TABLES `api_keys` WRITE;
/*!40000 ALTER TABLE `api_keys` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `api_keys` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `discussion_tag`
--

DROP TABLE IF EXISTS `discussion_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `discussion_tag` (
  `discussion_id` int(10) unsigned NOT NULL,
  `tag_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`discussion_id`,`tag_id`),
  KEY `discussion_tag_tag_id_foreign` (`tag_id`),
  CONSTRAINT `discussion_tag_discussion_id_foreign` FOREIGN KEY (`discussion_id`) REFERENCES `discussions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `discussion_tag_tag_id_foreign` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `discussion_tag`
--

LOCK TABLES `discussion_tag` WRITE;
/*!40000 ALTER TABLE `discussion_tag` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `discussion_tag` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `discussion_user`
--

DROP TABLE IF EXISTS `discussion_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `discussion_user` (
  `user_id` int(10) unsigned NOT NULL,
  `discussion_id` int(10) unsigned NOT NULL,
  `last_read_at` datetime DEFAULT NULL,
  `last_read_post_number` int(10) unsigned DEFAULT NULL,
  `subscription` enum('follow','ignore') DEFAULT NULL,
  PRIMARY KEY (`user_id`,`discussion_id`),
  KEY `discussion_user_discussion_id_foreign` (`discussion_id`),
  CONSTRAINT `discussion_user_discussion_id_foreign` FOREIGN KEY (`discussion_id`) REFERENCES `discussions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `discussion_user_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `discussion_user`
--

LOCK TABLES `discussion_user` WRITE;
/*!40000 ALTER TABLE `discussion_user` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `discussion_user` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `discussions`
--

DROP TABLE IF EXISTS `discussions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `discussions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `comment_count` int(11) NOT NULL DEFAULT 1,
  `participant_count` int(10) unsigned NOT NULL DEFAULT 0,
  `post_number_index` int(10) unsigned NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL,
  `user_id` int(10) unsigned DEFAULT NULL,
  `first_post_id` int(10) unsigned DEFAULT NULL,
  `last_posted_at` datetime DEFAULT NULL,
  `last_posted_user_id` int(10) unsigned DEFAULT NULL,
  `last_post_id` int(10) unsigned DEFAULT NULL,
  `last_post_number` int(10) unsigned DEFAULT NULL,
  `hidden_at` datetime DEFAULT NULL,
  `hidden_user_id` int(10) unsigned DEFAULT NULL,
  `slug` varchar(255) NOT NULL,
  `is_private` tinyint(1) NOT NULL DEFAULT 0,
  `is_approved` tinyint(1) NOT NULL DEFAULT 1,
  `is_sticky` tinyint(1) NOT NULL DEFAULT 0,
  `is_locked` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `discussions_hidden_user_id_foreign` (`hidden_user_id`),
  KEY `discussions_first_post_id_foreign` (`first_post_id`),
  KEY `discussions_last_post_id_foreign` (`last_post_id`),
  KEY `discussions_last_posted_at_index` (`last_posted_at`),
  KEY `discussions_last_posted_user_id_index` (`last_posted_user_id`),
  KEY `discussions_created_at_index` (`created_at`),
  KEY `discussions_user_id_index` (`user_id`),
  KEY `discussions_comment_count_index` (`comment_count`),
  KEY `discussions_participant_count_index` (`participant_count`),
  KEY `discussions_hidden_at_index` (`hidden_at`),
  KEY `discussions_is_sticky_created_at_index` (`is_sticky`,`created_at`),
  KEY `discussions_is_sticky_last_posted_at_index` (`is_sticky`,`last_posted_at`),
  KEY `discussions_is_locked_index` (`is_locked`),
  FULLTEXT KEY `title` (`title`),
  CONSTRAINT `discussions_first_post_id_foreign` FOREIGN KEY (`first_post_id`) REFERENCES `posts` (`id`) ON DELETE SET NULL,
  CONSTRAINT `discussions_hidden_user_id_foreign` FOREIGN KEY (`hidden_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `discussions_last_post_id_foreign` FOREIGN KEY (`last_post_id`) REFERENCES `posts` (`id`) ON DELETE SET NULL,
  CONSTRAINT `discussions_last_posted_user_id_foreign` FOREIGN KEY (`last_posted_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `discussions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `discussions`
--

LOCK TABLES `discussions` WRITE;
/*!40000 ALTER TABLE `discussions` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `discussions` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `email_tokens`
--

DROP TABLE IF EXISTS `email_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `email_tokens` (
  `token` varchar(100) NOT NULL,
  `email` varchar(254) NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`token`),
  KEY `email_tokens_user_id_foreign` (`user_id`),
  CONSTRAINT `email_tokens_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `email_tokens`
--

LOCK TABLES `email_tokens` WRITE;
/*!40000 ALTER TABLE `email_tokens` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `email_tokens` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `flags`
--

DROP TABLE IF EXISTS `flags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `flags` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `post_id` int(10) unsigned NOT NULL,
  `type` varchar(255) NOT NULL,
  `user_id` int(10) unsigned DEFAULT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `reason_detail` text DEFAULT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `flags_post_id_foreign` (`post_id`),
  KEY `flags_user_id_foreign` (`user_id`),
  KEY `flags_created_at_index` (`created_at`),
  CONSTRAINT `flags_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `flags_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flags`
--

LOCK TABLES `flags` WRITE;
/*!40000 ALTER TABLE `flags` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `flags` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `group_permission`
--

DROP TABLE IF EXISTS `group_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `group_permission` (
  `group_id` int(10) unsigned NOT NULL,
  `permission` varchar(100) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`group_id`,`permission`),
  CONSTRAINT `group_permission_group_id_foreign` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `group_permission`
--

LOCK TABLES `group_permission` WRITE;
/*!40000 ALTER TABLE `group_permission` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `group_permission` VALUES
(2,'viewForum',NULL),
(3,'discussion.flagPosts',NOW()),
(3,'discussion.likePosts',NOW()),
(3,'discussion.reply',NULL),
(3,'discussion.replyWithoutApproval',NOW()),
(3,'discussion.startWithoutApproval',NOW()),
(3,'searchUsers',NULL),
(3,'startDiscussion',NULL),
(4,'discussion.approvePosts',NOW()),
(4,'discussion.editPosts',NULL),
(4,'discussion.hide',NULL),
(4,'discussion.hidePosts',NULL),
(4,'discussion.lock',NOW()),
(4,'discussion.rename',NULL),
(4,'discussion.sticky',NOW()),
(4,'discussion.tag',NOW()),
(4,'discussion.viewFlags',NOW()),
(4,'discussion.viewIpsPosts',NULL),
(4,'user.suspend',NOW()),
(4,'user.viewLastSeenAt',NULL);
/*!40000 ALTER TABLE `group_permission` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `group_user`
--

DROP TABLE IF EXISTS `group_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `group_user` (
  `user_id` int(10) unsigned NOT NULL,
  `group_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`user_id`,`group_id`),
  KEY `group_user_group_id_foreign` (`group_id`),
  CONSTRAINT `group_user_group_id_foreign` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `group_user_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `group_user`
--

LOCK TABLES `group_user` WRITE;
/*!40000 ALTER TABLE `group_user` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `group_user` VALUES
(1,1,NOW());
/*!40000 ALTER TABLE `group_user` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `groups`
--

DROP TABLE IF EXISTS `groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `groups` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name_singular` varchar(100) NOT NULL,
  `name_plural` varchar(100) NOT NULL,
  `color` varchar(20) DEFAULT NULL,
  `icon` varchar(100) DEFAULT NULL,
  `is_hidden` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groups`
--

LOCK TABLES `groups` WRITE;
/*!40000 ALTER TABLE `groups` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `groups` VALUES
(1,'Admin','Admins','#B72A2A','fas fa-wrench',0,NULL,NULL),
(2,'Guest','Guests',NULL,NULL,0,NULL,NULL),
(3,'Member','Members',NULL,NULL,0,NULL,NULL),
(4,'Mod','Mods','#80349E','fas fa-bolt',0,NULL,NULL);
/*!40000 ALTER TABLE `groups` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `login_providers`
--

DROP TABLE IF EXISTS `login_providers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `login_providers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `provider` varchar(100) NOT NULL,
  `identifier` varchar(100) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `last_login_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `login_providers_provider_identifier_unique` (`provider`,`identifier`),
  KEY `login_providers_user_id_foreign` (`user_id`),
  CONSTRAINT `login_providers_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_providers`
--

LOCK TABLES `login_providers` WRITE;
/*!40000 ALTER TABLE `login_providers` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `login_providers` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) NOT NULL,
  `extension` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=141 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `migrations` VALUES
(1,'2015_02_24_000000_create_access_tokens_table',NULL),
(2,'2015_02_24_000000_create_api_keys_table',NULL),
(3,'2015_02_24_000000_create_config_table',NULL),
(4,'2015_02_24_000000_create_discussions_table',NULL),
(5,'2015_02_24_000000_create_email_tokens_table',NULL),
(6,'2015_02_24_000000_create_groups_table',NULL),
(7,'2015_02_24_000000_create_notifications_table',NULL),
(8,'2015_02_24_000000_create_password_tokens_table',NULL),
(9,'2015_02_24_000000_create_permissions_table',NULL),
(10,'2015_02_24_000000_create_posts_table',NULL),
(11,'2015_02_24_000000_create_users_discussions_table',NULL),
(12,'2015_02_24_000000_create_users_groups_table',NULL),
(13,'2015_02_24_000000_create_users_table',NULL),
(14,'2015_09_15_000000_create_auth_tokens_table',NULL),
(15,'2015_09_20_224327_add_hide_to_discussions',NULL),
(16,'2015_09_22_030432_rename_notification_read_time',NULL),
(17,'2015_10_07_130531_rename_config_to_settings',NULL),
(18,'2015_10_24_194000_add_ip_address_to_posts',NULL),
(19,'2015_12_05_042721_change_access_tokens_columns',NULL),
(20,'2015_12_17_194247_change_settings_value_column_to_text',NULL),
(21,'2016_02_04_095452_add_slug_to_discussions',NULL),
(22,'2017_04_07_114138_add_is_private_to_discussions',NULL),
(23,'2017_04_07_114138_add_is_private_to_posts',NULL),
(24,'2018_01_11_093900_change_access_tokens_columns',NULL),
(25,'2018_01_11_094000_change_access_tokens_add_foreign_keys',NULL),
(26,'2018_01_11_095000_change_api_keys_columns',NULL),
(27,'2018_01_11_101800_rename_auth_tokens_to_registration_tokens',NULL),
(28,'2018_01_11_102000_change_registration_tokens_rename_id_to_token',NULL),
(29,'2018_01_11_102100_change_registration_tokens_created_at_to_datetime',NULL),
(30,'2018_01_11_120604_change_posts_table_to_innodb',NULL),
(31,'2018_01_11_155200_change_discussions_rename_columns',NULL),
(32,'2018_01_11_155300_change_discussions_add_foreign_keys',NULL),
(33,'2018_01_15_071700_rename_users_discussions_to_discussion_user',NULL),
(34,'2018_01_15_071800_change_discussion_user_rename_columns',NULL),
(35,'2018_01_15_071900_change_discussion_user_add_foreign_keys',NULL),
(36,'2018_01_15_072600_change_email_tokens_rename_id_to_token',NULL),
(37,'2018_01_15_072700_change_email_tokens_add_foreign_keys',NULL),
(38,'2018_01_15_072800_change_email_tokens_created_at_to_datetime',NULL),
(39,'2018_01_18_130400_rename_permissions_to_group_permission',NULL),
(40,'2018_01_18_130500_change_group_permission_add_foreign_keys',NULL),
(41,'2018_01_18_130600_rename_users_groups_to_group_user',NULL),
(42,'2018_01_18_130700_change_group_user_add_foreign_keys',NULL),
(43,'2018_01_18_133000_change_notifications_columns',NULL),
(44,'2018_01_18_133100_change_notifications_add_foreign_keys',NULL),
(45,'2018_01_18_134400_change_password_tokens_rename_id_to_token',NULL),
(46,'2018_01_18_134500_change_password_tokens_add_foreign_keys',NULL),
(47,'2018_01_18_134600_change_password_tokens_created_at_to_datetime',NULL),
(48,'2018_01_18_135000_change_posts_rename_columns',NULL),
(49,'2018_01_18_135100_change_posts_add_foreign_keys',NULL),
(50,'2018_01_30_112238_add_fulltext_index_to_discussions_title',NULL),
(51,'2018_01_30_220100_create_post_user_table',NULL),
(52,'2018_01_30_222900_change_users_rename_columns',NULL),
(55,'2018_09_15_041340_add_users_indicies',NULL),
(56,'2018_09_15_041828_add_discussions_indicies',NULL),
(57,'2018_09_15_043337_add_notifications_indices',NULL),
(58,'2018_09_15_043621_add_posts_indices',NULL),
(59,'2018_09_22_004100_change_registration_tokens_columns',NULL),
(60,'2018_09_22_004200_create_login_providers_table',NULL),
(61,'2018_10_08_144700_add_shim_prefix_to_group_icons',NULL),
(62,'2019_10_12_195349_change_posts_add_discussion_foreign_key',NULL),
(63,'2020_03_19_134512_change_discussions_default_comment_count',NULL),
(64,'2020_04_21_130500_change_permission_groups_add_is_hidden',NULL),
(65,'2021_03_02_040000_change_access_tokens_add_type',NULL),
(66,'2021_03_02_040500_change_access_tokens_add_id',NULL),
(67,'2021_03_02_041000_change_access_tokens_add_title_ip_agent',NULL),
(68,'2021_04_18_040500_change_migrations_add_id_primary_key',NULL),
(69,'2021_04_18_145100_change_posts_content_column_to_mediumtext',NULL),
(70,'2018_07_21_000000_seed_default_groups',NULL),
(71,'2018_07_21_000100_seed_default_group_permissions',NULL),
(72,'2021_05_10_000000_rename_permissions',NULL),
(73,'2022_05_20_000000_add_timestamps_to_groups_table',NULL),
(74,'2022_05_20_000001_add_created_at_to_group_user_table',NULL),
(75,'2022_05_20_000002_add_created_at_to_group_permission_table',NULL),
(76,'2022_07_14_000000_add_type_index_to_posts',NULL),
(77,'2022_07_14_000001_add_type_created_at_composite_index_to_posts',NULL),
(78,'2022_08_06_000000_change_access_tokens_last_activity_at_to_nullable',NULL),
(79,'2024_11_18_000000_increase_email_field_length',NULL),
(80,'2024_11_22_000000_increase_email_field_length_in_email_tokens',NULL),
(81,'2015_09_02_000000_add_flags_read_time_to_users_table','flarum-flags'),
(82,'2015_09_02_000000_create_flags_table','flarum-flags'),
(83,'2017_07_22_000000_add_default_permissions','flarum-flags'),
(84,'2018_06_27_101500_change_flags_rename_time_to_created_at','flarum-flags'),
(85,'2018_06_27_101600_change_flags_add_foreign_keys','flarum-flags'),
(86,'2018_06_27_105100_change_users_rename_flags_read_time_to_read_flags_at','flarum-flags'),
(87,'2018_09_15_043621_add_flags_indices','flarum-flags'),
(88,'2019_10_22_000000_change_reason_text_col_type','flarum-flags'),
(89,'2015_09_21_011527_add_is_approved_to_discussions','flarum-approval'),
(90,'2015_09_21_011706_add_is_approved_to_posts','flarum-approval'),
(91,'2017_07_22_000000_add_default_permissions','flarum-approval'),
(92,'2015_02_24_000000_create_discussions_tags_table','flarum-tags'),
(93,'2015_02_24_000000_create_tags_table','flarum-tags'),
(94,'2015_02_24_000000_create_users_tags_table','flarum-tags'),
(95,'2015_02_24_000000_set_default_settings','flarum-tags'),
(96,'2015_10_19_061223_make_slug_unique','flarum-tags'),
(97,'2017_07_22_000000_add_default_permissions','flarum-tags'),
(98,'2018_06_27_085200_change_tags_columns','flarum-tags'),
(99,'2018_06_27_085300_change_tags_add_foreign_keys','flarum-tags'),
(100,'2018_06_27_090400_rename_users_tags_to_tag_user','flarum-tags'),
(101,'2018_06_27_100100_change_tag_user_rename_read_time_to_marked_as_read_at','flarum-tags'),
(102,'2018_06_27_100200_change_tag_user_add_foreign_keys','flarum-tags'),
(103,'2018_06_27_103000_rename_discussions_tags_to_discussion_tag','flarum-tags'),
(104,'2018_06_27_103100_add_discussion_tag_foreign_keys','flarum-tags'),
(105,'2019_04_21_000000_add_icon_to_tags_table','flarum-tags'),
(106,'2022_05_20_000003_add_timestamps_to_tags_table','flarum-tags'),
(107,'2022_05_20_000004_add_created_at_to_discussion_tag_table','flarum-tags'),
(108,'2023_03_01_000000_create_post_mentions_tag_table','flarum-tags'),
(109,'2015_05_11_000000_add_suspended_until_to_users_table','flarum-suspend'),
(110,'2015_09_14_000000_rename_suspended_until_column','flarum-suspend'),
(111,'2017_07_22_000000_add_default_permissions','flarum-suspend'),
(112,'2018_06_27_111400_change_users_rename_suspend_until_to_suspended_until','flarum-suspend'),
(113,'2021_10_27_000000_add_suspend_reason_and_message','flarum-suspend'),
(114,'2015_05_11_000000_add_subscription_to_users_discussions_table','flarum-subscriptions'),
(115,'2015_02_24_000000_add_sticky_to_discussions','flarum-sticky'),
(116,'2017_07_22_000000_add_default_permissions','flarum-sticky'),
(117,'2018_09_15_043621_add_discussions_indices','flarum-sticky'),
(118,'2021_01_13_000000_add_discussion_last_posted_at_indices','flarum-sticky'),
(119,'2015_05_11_000000_create_mentions_posts_table','flarum-mentions'),
(120,'2015_05_11_000000_create_mentions_users_table','flarum-mentions'),
(121,'2018_06_27_102000_rename_mentions_posts_to_post_mentions_post','flarum-mentions'),
(122,'2018_06_27_102100_rename_mentions_users_to_post_mentions_user','flarum-mentions'),
(123,'2018_06_27_102200_change_post_mentions_post_rename_mentions_id_to_mentions_post_id','flarum-mentions'),
(124,'2018_06_27_102300_change_post_mentions_post_add_foreign_keys','flarum-mentions'),
(125,'2018_06_27_102400_change_post_mentions_user_rename_mentions_id_to_mentions_user_id','flarum-mentions'),
(126,'2018_06_27_102500_change_post_mentions_user_add_foreign_keys','flarum-mentions'),
(127,'2021_04_19_000000_set_default_settings','flarum-mentions'),
(128,'2022_05_20_000005_add_created_at_to_post_mentions_post_table','flarum-mentions'),
(129,'2022_05_20_000006_add_created_at_to_post_mentions_user_table','flarum-mentions'),
(130,'2022_10_21_000000_create_post_mentions_group_table','flarum-mentions'),
(131,'2021_03_25_000000_default_settings','flarum-markdown'),
(132,'2015_02_24_000000_add_locked_to_discussions','flarum-lock'),
(133,'2017_07_22_000000_add_default_permissions','flarum-lock'),
(134,'2018_09_15_043621_add_discussions_indices','flarum-lock'),
(135,'2015_05_11_000000_create_posts_likes_table','flarum-likes'),
(136,'2015_09_04_000000_add_default_like_permissions','flarum-likes'),
(137,'2018_06_27_100600_rename_posts_likes_to_post_likes','flarum-likes'),
(138,'2018_06_27_100700_change_post_likes_add_foreign_keys','flarum-likes'),
(139,'2021_05_10_094200_add_created_at_to_post_likes_table','flarum-likes'),
(140,'2018_09_29_060444_replace_emoji_shorcuts_with_unicode','flarum-emoji');
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `from_user_id` int(10) unsigned DEFAULT NULL,
  `type` varchar(100) NOT NULL,
  `subject_id` int(10) unsigned DEFAULT NULL,
  `data` blob DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `read_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `notifications_from_user_id_foreign` (`from_user_id`),
  KEY `notifications_user_id_index` (`user_id`),
  CONSTRAINT `notifications_from_user_id_foreign` FOREIGN KEY (`from_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `notifications_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `password_tokens`
--

DROP TABLE IF EXISTS `password_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_tokens` (
  `token` varchar(100) NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`token`),
  KEY `password_tokens_user_id_foreign` (`user_id`),
  CONSTRAINT `password_tokens_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_tokens`
--

LOCK TABLES `password_tokens` WRITE;
/*!40000 ALTER TABLE `password_tokens` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `password_tokens` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `post_likes`
--

DROP TABLE IF EXISTS `post_likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `post_likes` (
  `post_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`post_id`,`user_id`),
  KEY `post_likes_user_id_foreign` (`user_id`),
  CONSTRAINT `post_likes_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `post_likes_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post_likes`
--

LOCK TABLES `post_likes` WRITE;
/*!40000 ALTER TABLE `post_likes` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `post_likes` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `post_mentions_group`
--

DROP TABLE IF EXISTS `post_mentions_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `post_mentions_group` (
  `post_id` int(10) unsigned NOT NULL,
  `mentions_group_id` int(10) unsigned NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`post_id`,`mentions_group_id`),
  KEY `post_mentions_group_mentions_group_id_foreign` (`mentions_group_id`),
  CONSTRAINT `post_mentions_group_mentions_group_id_foreign` FOREIGN KEY (`mentions_group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `post_mentions_group_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post_mentions_group`
--

LOCK TABLES `post_mentions_group` WRITE;
/*!40000 ALTER TABLE `post_mentions_group` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `post_mentions_group` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `post_mentions_post`
--

DROP TABLE IF EXISTS `post_mentions_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `post_mentions_post` (
  `post_id` int(10) unsigned NOT NULL,
  `mentions_post_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`post_id`,`mentions_post_id`),
  KEY `post_mentions_post_mentions_post_id_foreign` (`mentions_post_id`),
  CONSTRAINT `post_mentions_post_mentions_post_id_foreign` FOREIGN KEY (`mentions_post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `post_mentions_post_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post_mentions_post`
--

LOCK TABLES `post_mentions_post` WRITE;
/*!40000 ALTER TABLE `post_mentions_post` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `post_mentions_post` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `post_mentions_tag`
--

DROP TABLE IF EXISTS `post_mentions_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `post_mentions_tag` (
  `post_id` int(10) unsigned NOT NULL,
  `mentions_tag_id` int(10) unsigned NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`post_id`,`mentions_tag_id`),
  KEY `post_mentions_tag_mentions_tag_id_foreign` (`mentions_tag_id`),
  CONSTRAINT `post_mentions_tag_mentions_tag_id_foreign` FOREIGN KEY (`mentions_tag_id`) REFERENCES `tags` (`id`) ON DELETE CASCADE,
  CONSTRAINT `post_mentions_tag_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post_mentions_tag`
--

LOCK TABLES `post_mentions_tag` WRITE;
/*!40000 ALTER TABLE `post_mentions_tag` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `post_mentions_tag` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `post_mentions_user`
--

DROP TABLE IF EXISTS `post_mentions_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `post_mentions_user` (
  `post_id` int(10) unsigned NOT NULL,
  `mentions_user_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`post_id`,`mentions_user_id`),
  KEY `post_mentions_user_mentions_user_id_foreign` (`mentions_user_id`),
  CONSTRAINT `post_mentions_user_mentions_user_id_foreign` FOREIGN KEY (`mentions_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `post_mentions_user_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post_mentions_user`
--

LOCK TABLES `post_mentions_user` WRITE;
/*!40000 ALTER TABLE `post_mentions_user` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `post_mentions_user` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `post_user`
--

DROP TABLE IF EXISTS `post_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `post_user` (
  `post_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`post_id`,`user_id`),
  KEY `post_user_user_id_foreign` (`user_id`),
  CONSTRAINT `post_user_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `post_user_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post_user`
--

LOCK TABLES `post_user` WRITE;
/*!40000 ALTER TABLE `post_user` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `post_user` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `posts`
--

DROP TABLE IF EXISTS `posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `posts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `discussion_id` int(10) unsigned NOT NULL,
  `number` int(10) unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `user_id` int(10) unsigned DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,
  `content` mediumtext DEFAULT NULL COMMENT ' ',
  `edited_at` datetime DEFAULT NULL,
  `edited_user_id` int(10) unsigned DEFAULT NULL,
  `hidden_at` datetime DEFAULT NULL,
  `hidden_user_id` int(10) unsigned DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `is_private` tinyint(1) NOT NULL DEFAULT 0,
  `is_approved` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `posts_discussion_id_number_unique` (`discussion_id`,`number`),
  KEY `posts_edited_user_id_foreign` (`edited_user_id`),
  KEY `posts_hidden_user_id_foreign` (`hidden_user_id`),
  KEY `posts_discussion_id_number_index` (`discussion_id`,`number`),
  KEY `posts_discussion_id_created_at_index` (`discussion_id`,`created_at`),
  KEY `posts_user_id_created_at_index` (`user_id`,`created_at`),
  KEY `posts_type_index` (`type`),
  KEY `posts_type_created_at_index` (`type`,`created_at`),
  FULLTEXT KEY `content` (`content`),
  CONSTRAINT `posts_discussion_id_foreign` FOREIGN KEY (`discussion_id`) REFERENCES `discussions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `posts_edited_user_id_foreign` FOREIGN KEY (`edited_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `posts_hidden_user_id_foreign` FOREIGN KEY (`hidden_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `posts_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posts`
--

LOCK TABLES `posts` WRITE;
/*!40000 ALTER TABLE `posts` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `posts` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `registration_tokens`
--

DROP TABLE IF EXISTS `registration_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `registration_tokens` (
  `token` varchar(100) NOT NULL,
  `payload` text DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `provider` varchar(255) NOT NULL,
  `identifier` varchar(255) NOT NULL,
  `user_attributes` text DEFAULT NULL,
  PRIMARY KEY (`token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `registration_tokens`
--

LOCK TABLES `registration_tokens` WRITE;
/*!40000 ALTER TABLE `registration_tokens` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `registration_tokens` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `settings` (
  `key` varchar(100) NOT NULL,
  `value` text DEFAULT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings`
--

LOCK TABLES `settings` WRITE;
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `settings` VALUES
('allow_hide_own_posts','reply'),
('allow_post_editing','reply'),
('allow_renaming','10'),
('allow_sign_up','1'),
('custom_less',''),
('default_locale','en'),
('default_route','/all'),
('display_name_driver','username'),
('extensions_enabled','[\"flarum-flags\",\"flarum-approval\",\"flarum-tags\",\"flarum-suspend\",\"flarum-subscriptions\",\"flarum-sticky\",\"flarum-statistics\",\"flarum-mentions\",\"flarum-markdown\",\"flarum-lock\",\"flarum-likes\",\"flarum-lang-english\",\"flarum-emoji\",\"flarum-bbcode\"]'),
('flarum-markdown.mdarea','1'),
('flarum-mentions.allow_username_format','1'),
('flarum-tags.max_primary_tags','1'),
('flarum-tags.max_secondary_tags','3'),
('flarum-tags.min_primary_tags','1'),
('flarum-tags.min_secondary_tags','0'),
('forum_description','A no-cost forum'),
('forum_title','{{ tenant_tag | replace("_", " ") | title }}'),
('mail_driver','smtp'),
('mail_from','noreply@{{ main_domain }}'),
('mail_host','localhost'),
('mail_port','25'),
('slug_driver_Flarum\\Discussion\\Discussion','default'),
('slug_driver_Flarum\\User\\User','default'),
('theme_colored_header','0'),
('theme_dark_mode','0'),
('theme_primary_color','#4D698E'),
('theme_secondary_color','#4D698E'),
('version','1.8.10'),
('welcome_message','Enjoy your new forum! See the <a href=\"https://support.{{ main_domain }}\">support.{{ main_domain }}</a> forum for questions related to our hosting service, or hop over to <a href=\"https://discuss.flarum.org\">discuss.flarum.org</a> if you have any questions about the Flarum software.'),
('welcome_title','Welcome to {{ tenant_tag | replace("_", " ") | title }}');
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `tag_user`
--

DROP TABLE IF EXISTS `tag_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tag_user` (
  `user_id` int(10) unsigned NOT NULL,
  `tag_id` int(10) unsigned NOT NULL,
  `marked_as_read_at` datetime DEFAULT NULL,
  `is_hidden` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`user_id`,`tag_id`),
  KEY `tag_user_tag_id_foreign` (`tag_id`),
  CONSTRAINT `tag_user_tag_id_foreign` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tag_user_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tag_user`
--

LOCK TABLES `tag_user` WRITE;
/*!40000 ALTER TABLE `tag_user` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `tag_user` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `tags`
--

DROP TABLE IF EXISTS `tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tags` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `slug` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `color` varchar(50) DEFAULT NULL,
  `background_path` varchar(100) DEFAULT NULL,
  `background_mode` varchar(100) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `parent_id` int(10) unsigned DEFAULT NULL,
  `default_sort` varchar(50) DEFAULT NULL,
  `is_restricted` tinyint(1) NOT NULL DEFAULT 0,
  `is_hidden` tinyint(1) NOT NULL DEFAULT 0,
  `discussion_count` int(10) unsigned NOT NULL DEFAULT 0,
  `last_posted_at` datetime DEFAULT NULL,
  `last_posted_discussion_id` int(10) unsigned DEFAULT NULL,
  `last_posted_user_id` int(10) unsigned DEFAULT NULL,
  `icon` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `tags_slug_unique` (`slug`),
  KEY `tags_parent_id_foreign` (`parent_id`),
  KEY `tags_last_posted_user_id_foreign` (`last_posted_user_id`),
  KEY `tags_last_posted_discussion_id_foreign` (`last_posted_discussion_id`),
  CONSTRAINT `tags_last_posted_discussion_id_foreign` FOREIGN KEY (`last_posted_discussion_id`) REFERENCES `discussions` (`id`) ON DELETE SET NULL,
  CONSTRAINT `tags_last_posted_user_id_foreign` FOREIGN KEY (`last_posted_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `tags_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `tags` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tags`
--

LOCK TABLES `tags` WRITE;
/*!40000 ALTER TABLE `tags` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `tags` VALUES
(1,'General','general',NULL,'#888',NULL,NULL,0,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `tags` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_email_confirmed` tinyint(1) NOT NULL DEFAULT 0,
  `password` varchar(100) NOT NULL,
  `avatar_url` varchar(100) DEFAULT NULL,
  `preferences` blob DEFAULT NULL,
  `joined_at` datetime DEFAULT NULL,
  `last_seen_at` datetime DEFAULT NULL,
  `marked_all_as_read_at` datetime DEFAULT NULL,
  `read_notifications_at` datetime DEFAULT NULL,
  `discussion_count` int(10) unsigned NOT NULL DEFAULT 0,
  `comment_count` int(10) unsigned NOT NULL DEFAULT 0,
  `read_flags_at` datetime DEFAULT NULL,
  `suspended_until` datetime DEFAULT NULL,
  `suspend_reason` text DEFAULT NULL,
  `suspend_message` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_username_unique` (`username`),
  UNIQUE KEY `users_email_unique` (`email`),
  KEY `users_joined_at_index` (`joined_at`),
  KEY `users_last_seen_at_index` (`last_seen_at`),
  KEY `users_discussion_count_index` (`discussion_count`),
  KEY `users_comment_count_index` (`comment_count`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `users` VALUES
(1,'admin','{{ tenant_admin_email | default(postfix.forward_mail_to) }}',1,'{{ tenant_admin_password }}',NULL,NULL,NOW(),NOW(),NULL,NULL,0,0,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
commit;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;
