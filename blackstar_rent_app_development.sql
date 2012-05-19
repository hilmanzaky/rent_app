-- phpMyAdmin SQL Dump
-- version 3.4.5deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: May 20, 2012 at 12:14 AM
-- Server version: 5.1.58
-- PHP Version: 5.3.6-13ubuntu3.3

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `blackstar_rent_app_development`
--

-- --------------------------------------------------------

--
-- Table structure for table `ordered_products`
--

CREATE TABLE IF NOT EXISTS `ordered_products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sub_total` decimal(10,0) DEFAULT NULL,
  `qty` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `price` decimal(10,0) DEFAULT NULL,
  `rent_price` decimal(10,0) DEFAULT NULL,
  `width` double DEFAULT NULL,
  `height` double DEFAULT NULL,
  `ori_sub_total` float DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=37 ;

--
-- Dumping data for table `ordered_products`
--

INSERT INTO `ordered_products` (`id`, `order_id`, `product_id`, `description`, `sub_total`, `qty`, `created_at`, `updated_at`, `user_id`, `price`, `rent_price`, `width`, `height`, `ori_sub_total`) VALUES
(30, 1, 22, 'test', '530000', NULL, '2012-04-28 03:18:37', '2012-05-05 09:23:45', 1, NULL, '15000', 4, 9, 540000),
(31, 1, 22, 'test', '750000', NULL, '2012-04-28 03:46:45', '2012-04-28 03:46:45', 1, NULL, '15000', 10, 5, 750000),
(32, 1, 5, '', '20000', 10, '2012-04-28 15:25:18', '2012-04-28 15:25:18', 1, NULL, '2000', NULL, NULL, 20000),
(34, 1, 22, '', '660000', NULL, '2012-04-28 15:36:56', '2012-04-28 15:36:56', 1, NULL, '15000', 11, 4, 660000),
(35, 1, 22, '', '750000', NULL, '2012-04-29 12:39:25', '2012-04-29 12:39:25', 1, NULL, '15000', 10, 5, 750000),
(36, 1, 1, '', '5000', 2, '2012-05-05 09:29:21', '2012-05-05 09:29:35', 1, '300000', '2500', NULL, NULL, 5000);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE IF NOT EXISTS `orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `customer` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `delivery_date` date DEFAULT NULL,
  `usage_date` date DEFAULT NULL,
  `duration_in_days` int(11) DEFAULT NULL,
  `total_price_per_day` decimal(10,0) DEFAULT NULL,
  `total_price` decimal(10,0) DEFAULT NULL,
  `payment_status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `delivery_cost` decimal(10,0) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=2 ;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `customer`, `address`, `phone`, `delivery_date`, `usage_date`, `duration_in_days`, `total_price_per_day`, `total_price`, `payment_status`, `user_id`, `created_at`, `updated_at`, `delivery_cost`) VALUES
(1, 'Hilman Zaky', 'Jl. Sidoluhur', '022 - 2222222', '2012-05-05', '2012-05-06', 3, '2715000', '8195000', 'Down Payment', 1, '2012-05-05 11:00:45', '2012-05-06 17:06:04', '50000');

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE IF NOT EXISTS `payments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) DEFAULT NULL,
  `amount` decimal(10,0) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=3 ;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`id`, `order_id`, `amount`, `created_at`, `updated_at`) VALUES
(1, 1, '1000000', '2012-05-06 17:06:04', '2012-05-06 17:06:04'),
(2, 1, '200000', '2012-05-06 17:06:35', '2012-05-06 17:06:35');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE IF NOT EXISTS `products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `price` decimal(10,0) DEFAULT NULL,
  `rent_price` decimal(10,0) DEFAULT NULL,
  `stock` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_package` tinyint(1) DEFAULT NULL,
  `is_rented` tinyint(1) DEFAULT NULL,
  `stock_out` int(11) DEFAULT '0',
  `is_dimensional` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=34 ;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `name`, `description`, `price`, `rent_price`, `stock`, `created_at`, `updated_at`, `is_package`, `is_rented`, `stock_out`, `is_dimensional`) VALUES
(1, 'Kursi Lipat', '', '300000', '2500', 10, '2012-01-14 23:27:13', '2012-05-05 09:29:35', 0, 1, 0, NULL),
(2, 'Sendok B/K Polos', '', '3000', '500', 215, '2012-01-15 05:01:26', '2012-04-28 15:25:18', 0, 1, 0, NULL),
(3, 'Garpu B/K Polos', '', '3000', '500', 105, '2012-01-15 05:02:00', '2012-04-28 15:25:18', 0, 1, 0, NULL),
(4, 'Piring CKG', '', '6000', '600', 104, '2012-01-15 05:03:15', '2012-04-28 15:25:18', 0, 1, 0, NULL),
(5, 'Set Alat Makan ( CKG )', '', NULL, '2000', 52, '2012-01-15 05:04:20', '2012-04-28 15:25:18', 1, 1, 0, NULL),
(6, 'Besi Kaki Meja', 'Komponen penyusun meja', '50000', NULL, 0, '2012-01-24 16:02:55', '2012-01-24 16:02:55', 0, 0, 0, NULL),
(16, 'a', '', NULL, '20000', 47, '2012-03-05 08:03:07', '2012-04-06 11:51:08', 1, 1, 0, NULL),
(18, 'y', 'test', '10000', NULL, 140, '2012-03-05 08:04:04', '2012-04-06 11:51:08', 0, 0, 0, NULL),
(19, 'x', 'asdf', '10000', NULL, 100, '2012-03-05 16:37:09', '2012-04-06 11:51:08', 0, 0, 0, NULL),
(21, 'z', '', '10000', NULL, 95, '2012-03-05 16:53:31', '2012-04-06 11:51:08', 0, 0, 0, NULL),
(22, 'Tenda Plafon', '', NULL, '15000', 0, '2012-04-25 04:34:24', '2012-04-25 04:34:24', 1, 1, 0, 1),
(23, 'Rusuk 3m', '', NULL, NULL, 96, '2012-04-25 04:38:57', '2012-04-29 12:39:25', 0, 0, 0, 0),
(24, 'Rusuk 4m', '', NULL, NULL, 97, '2012-04-25 04:39:19', '2012-04-29 14:36:52', 0, 0, 0, 0),
(25, 'Rusuk 6m', '', NULL, NULL, 96, '2012-04-25 04:39:43', '2012-04-29 14:36:52', 0, 0, 0, 0),
(26, 'Tiang 2.5m', '', NULL, NULL, 97, '2012-04-25 04:42:05', '2012-04-29 14:36:52', 0, 0, 0, 0),
(27, 'Tiang 3m', '', NULL, NULL, 0, '2012-04-25 04:42:19', '2012-04-25 04:42:19', 0, 0, 0, 0),
(28, 'Tiang 3.5m', '', NULL, NULL, 0, '2012-04-25 04:42:41', '2012-04-25 04:42:41', 0, 0, 0, 0),
(29, 'Tiang 4m', '', NULL, NULL, 0, '2012-04-25 04:42:57', '2012-04-25 04:42:57', 0, 0, 0, 0),
(30, 'Tiang 4.5m', '', NULL, NULL, 0, '2012-04-25 04:43:53', '2012-04-25 04:43:53', 0, 0, 0, 0),
(31, 'Tiang 5m', '', NULL, NULL, 0, '2012-04-25 04:44:26', '2012-04-25 04:44:26', 0, 0, 0, 0),
(32, 'Tiang 5.5m', '', NULL, NULL, 0, '2012-04-25 04:44:40', '2012-04-25 04:44:40', 0, 0, 0, 0),
(33, 'Tiang 6m', '', NULL, NULL, 0, '2012-04-25 04:45:12', '2012-04-25 04:45:12', 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `product_packages`
--

CREATE TABLE IF NOT EXISTS `product_packages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT NULL,
  `child_id` int(11) DEFAULT NULL,
  `reduced_stocks` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=29 ;

--
-- Dumping data for table `product_packages`
--

INSERT INTO `product_packages` (`id`, `parent_id`, `child_id`, `reduced_stocks`, `created_at`, `updated_at`) VALUES
(1, 5, 4, 1, '2012-01-15 05:04:46', '2012-01-15 05:04:46'),
(2, 5, 2, 2, '2012-01-23 07:29:34', '2012-01-23 07:29:34'),
(3, 5, 3, 2, '2012-01-23 07:29:44', '2012-01-23 07:29:44'),
(5, 7, 9, 1, '2012-03-04 10:30:05', '2012-03-04 10:30:05'),
(6, 7, 8, 2, '2012-03-04 10:30:26', '2012-03-04 10:30:26'),
(7, 10, 11, 2, '2012-03-04 10:38:30', '2012-03-04 10:38:30'),
(8, 10, 12, 1, '2012-03-04 10:38:39', '2012-03-04 10:38:39'),
(9, 13, 14, 2, '2012-03-04 11:05:55', '2012-03-04 11:05:55'),
(10, 13, 15, 1, '2012-03-04 11:06:04', '2012-03-04 11:06:04'),
(11, 16, 18, 1, '2012-03-05 08:04:24', '2012-03-05 08:04:24'),
(14, 16, 19, 1, '2012-03-05 16:39:32', '2012-03-05 16:39:32'),
(17, 16, 21, 2, '2012-03-11 14:59:51', '2012-03-11 14:59:51'),
(18, 22, 23, 1, '2012-04-25 04:51:08', '2012-04-25 04:51:08'),
(19, 22, 24, 1, '2012-04-25 04:51:26', '2012-04-25 04:51:26'),
(20, 22, 25, 1, '2012-04-25 04:51:47', '2012-04-25 04:51:47'),
(21, 22, 26, 1, '2012-04-25 04:52:27', '2012-04-25 04:52:27'),
(22, 22, 27, 1, '2012-04-25 04:52:47', '2012-04-25 04:52:47'),
(23, 22, 28, 1, '2012-04-25 04:53:12', '2012-04-25 04:53:12'),
(24, 22, 29, 1, '2012-04-25 04:53:22', '2012-04-25 04:53:22'),
(25, 22, 30, 1, '2012-04-25 04:53:29', '2012-04-25 04:53:29'),
(26, 22, 31, 1, '2012-04-25 04:53:35', '2012-04-25 04:53:35'),
(27, 22, 32, 1, '2012-04-25 04:53:44', '2012-04-25 04:53:44'),
(28, 22, 33, 1, '2012-04-25 04:53:55', '2012-04-25 04:53:55');

-- --------------------------------------------------------

--
-- Table structure for table `product_stocks`
--

CREATE TABLE IF NOT EXISTS `product_stocks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stock` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=29 ;

--
-- Dumping data for table `product_stocks`
--

INSERT INTO `product_stocks` (`id`, `stock`, `product_id`, `created_at`, `updated_at`) VALUES
(2, 5, 1, '2012-01-19 11:58:03', '2012-01-21 00:56:31'),
(3, 20, 1, '2012-01-19 11:59:43', '2012-01-19 11:59:43'),
(4, 15, 2, '2012-01-21 13:53:49', '2012-01-21 13:54:30'),
(5, 15, 3, '2012-01-23 04:22:31', '2012-01-23 04:22:31'),
(6, 20, 4, '2012-01-23 04:23:08', '2012-01-23 04:23:08'),
(7, 100, 4, '2012-01-23 07:57:35', '2012-01-23 07:57:35'),
(8, 150, 3, '2012-01-23 07:57:55', '2012-01-23 07:57:55'),
(9, 250, 2, '2012-01-23 07:58:11', '2012-01-23 07:58:11'),
(10, 10, 4, '2012-01-24 15:17:21', '2012-01-24 15:17:21'),
(11, 10, 4, '2012-01-29 07:09:48', '2012-01-29 07:09:48'),
(12, 0, 8, '2012-03-04 10:34:12', '2012-03-04 10:35:01'),
(13, 100, 11, '2012-03-04 10:38:54', '2012-03-04 10:38:54'),
(14, 50, 14, '2012-03-04 11:06:23', '2012-03-04 15:51:41'),
(15, 150, 15, '2012-03-04 11:06:39', '2012-03-04 15:52:42'),
(16, 100, 14, '2012-03-04 11:14:40', '2012-03-04 15:02:26'),
(17, 50, 18, '2012-03-05 08:05:33', '2012-03-05 16:36:42'),
(18, 100, 17, '2012-03-05 08:05:47', '2012-03-05 08:05:47'),
(19, 10, 19, '2012-03-05 16:37:25', '2012-03-05 16:37:25'),
(20, 5, 20, '2012-03-05 16:47:40', '2012-03-05 16:47:40'),
(21, 5, 21, '2012-03-05 16:53:41', '2012-03-05 16:53:41'),
(22, 100, 21, '2012-03-06 23:15:59', '2012-03-06 23:15:59'),
(23, 100, 19, '2012-03-06 23:16:13', '2012-03-06 23:16:13'),
(24, 100, 18, '2012-03-06 23:16:24', '2012-03-06 23:16:24'),
(25, 100, 23, '2012-04-28 15:34:56', '2012-04-28 15:34:56'),
(26, 100, 25, '2012-04-28 15:35:33', '2012-04-28 15:35:33'),
(27, 100, 24, '2012-04-28 15:35:54', '2012-04-28 15:35:54'),
(28, 100, 26, '2012-04-29 14:35:38', '2012-04-29 14:35:38');

-- --------------------------------------------------------

--
-- Table structure for table `rented_products`
--

CREATE TABLE IF NOT EXISTS `rented_products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ordered_product_id` int(11) DEFAULT NULL,
  `order_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `return_qty` int(11) DEFAULT '0',
  `rented_qty` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=13 ;

--
-- Dumping data for table `rented_products`
--

INSERT INTO `rented_products` (`id`, `ordered_product_id`, `order_id`, `product_id`, `return_qty`, `rented_qty`, `created_at`, `updated_at`) VALUES
(1, 32, NULL, 4, 0, 10, '2012-04-28 15:25:18', '2012-04-28 15:25:18'),
(2, 32, NULL, 2, 0, 20, '2012-04-28 15:25:18', '2012-04-28 15:25:18'),
(3, 32, NULL, 3, 0, 20, '2012-04-28 15:25:18', '2012-04-28 15:25:18'),
(5, 34, NULL, 23, 0, 1, '2012-04-28 15:36:56', '2012-04-28 15:36:56'),
(6, 34, NULL, 24, 0, 2, '2012-04-28 15:36:56', '2012-04-28 15:36:56'),
(7, 34, NULL, 25, 0, 3, '2012-04-28 15:36:56', '2012-04-28 15:36:56'),
(8, 35, NULL, 23, 0, 3, '2012-04-29 12:39:25', '2012-04-29 12:39:25'),
(9, 35, NULL, 24, 0, 1, '2012-04-29 12:39:25', '2012-04-29 14:36:52'),
(10, 35, NULL, 25, 0, 1, '2012-04-29 12:39:25', '2012-04-29 14:36:52'),
(11, 35, NULL, 26, 0, 3, '2012-04-29 14:36:52', '2012-04-29 14:36:52'),
(12, 36, NULL, 1, 0, 2, '2012-05-05 09:29:22', '2012-05-05 09:29:36');

-- --------------------------------------------------------

--
-- Table structure for table `returned_products`
--

CREATE TABLE IF NOT EXISTS `returned_products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `return_qty` int(11) DEFAULT NULL,
  `rented_product_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE IF NOT EXISTS `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=2 ;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`, `created_at`, `updated_at`) VALUES
(1, 'admin', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `roles_users`
--

CREATE TABLE IF NOT EXISTS `roles_users` (
  `user_id` int(11) DEFAULT NULL,
  `role_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `roles_users`
--

INSERT INTO `roles_users` (`user_id`, `role_id`) VALUES
(1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `schema_migrations`
--

CREATE TABLE IF NOT EXISTS `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `schema_migrations`
--

INSERT INTO `schema_migrations` (`version`) VALUES
('20111226080525'),
('20111231021706'),
('20111231021832'),
('20120102062245'),
('20120102062427'),
('20120102062731'),
('20120102063516'),
('20120103030552'),
('20120111071737'),
('20120118155510'),
('20120119114804'),
('20120121074507'),
('20120123081643'),
('20120130155012'),
('20120206231637'),
('20120213230421'),
('20120311041854'),
('20120415100826'),
('20120425042914'),
('20120427001005'),
('20120505073647');

-- --------------------------------------------------------

--
-- Table structure for table `stock_histories`
--

CREATE TABLE IF NOT EXISTS `stock_histories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `old` int(11) DEFAULT NULL,
  `new` int(11) DEFAULT NULL,
  `product_stock_id` int(11) DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=31 ;

--
-- Dumping data for table `stock_histories`
--

INSERT INTO `stock_histories` (`id`, `old`, `new`, `product_stock_id`, `description`, `created_at`, `updated_at`) VALUES
(15, 10, 5, 2, 'balik lagi', '2012-01-21 00:56:31', '2012-01-21 00:56:31'),
(16, 10, 15, 4, 'salah isi', '2012-01-21 13:54:30', '2012-01-21 13:54:30'),
(17, 100, 0, 12, '', '2012-03-04 10:35:01', '2012-03-04 10:35:01'),
(18, 100, 10, 14, '', '2012-03-04 11:14:06', '2012-03-04 11:14:06'),
(19, 10, 5, 14, '', '2012-03-04 14:48:57', '2012-03-04 14:48:57'),
(20, 5, 0, 14, '', '2012-03-04 14:49:14', '2012-03-04 14:49:14'),
(21, 100, 50, 16, '', '2012-03-04 14:50:32', '2012-03-04 14:50:32'),
(22, 0, 5, 14, '', '2012-03-04 15:02:03', '2012-03-04 15:02:03'),
(23, 50, 100, 16, '', '2012-03-04 15:02:26', '2012-03-04 15:02:26'),
(25, 5, 50, 14, '', '2012-03-04 15:51:41', '2012-03-04 15:51:41'),
(26, 100, 150, 15, '', '2012-03-04 15:52:06', '2012-03-04 15:52:06'),
(27, 150, 50, 15, '', '2012-03-04 15:52:32', '2012-03-04 15:52:32'),
(28, 50, 150, 15, '', '2012-03-04 15:52:42', '2012-03-04 15:52:42'),
(29, 100, 50, 17, '', '2012-03-05 16:36:42', '2012-03-05 16:36:42'),
(30, 5, 5, 21, '', '2012-03-06 22:39:32', '2012-03-06 22:39:32');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `password_digest` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=2 ;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password_digest`, `created_at`, `updated_at`) VALUES
(1, 'admin', 'admin@gmail.com', '$2a$10$JPPFvGv5W6Q.SqzImgukjOEHDB7ICyLTsIoo5sHGkId.k/x7nUK9e', '2012-01-14 23:26:10', '2012-01-14 23:26:10');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
