/*
 Navicat Premium Data Transfer

 Source Server         : rezervator_docker
 Source Server Type    : MySQL
 Source Server Version : 80012
 Source Host           : localhost:3306
 Source Schema         : rezervator

 Target Server Type    : MySQL
 Target Server Version : 80012
 File Encoding         : 65001

 Date: 06/03/2019 02:26:04
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for carsuser
-- ----------------------------
DROP TABLE IF EXISTS `cars`;
CREATE TABLE `cars` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `mileage` int(11) DEFAULT NULL,
  `enabled` tinyint(1) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `licence_plate` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `pricePerDay` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  FULLTEXT KEY `SEARCH_CARS` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

-- ----------------------------
-- Records of cars
-- ----------------------------
BEGIN;
INSERT INTO `cars` VALUES (1, 'Fabia', 0, 1, '2018-11-08 21:08:28', '2018-12-16 17:28:25', '7AA8022', 499.99);
INSERT INTO `cars` VALUES (2, 'BMW 3', 0, 1, '2018-11-22 21:43:22', '2018-12-16 17:28:36', '7AH8060', 899.99);
COMMIT;

-- ----------------------------
-- Table structure for documentData
-- ----------------------------
DROP TABLE IF EXISTS `documentData`;
CREATE TABLE `documentData` (
  `id` int(16) unsigned NOT NULL AUTO_INCREMENT,
  `confidence` double(16,2) DEFAULT NULL,
  `driving_license_expiration` date DEFAULT NULL,
  `driving_license_issued` date DEFAULT NULL,
  `driving_license_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `id_expiration` date DEFAULT NULL,
  `id_issued` date DEFAULT NULL,
  `id_mrz_valid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `id_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

-- ----------------------------
-- Records of documentData
-- ----------------------------
BEGIN;
INSERT INTO `documentData` VALUES (5, 29.00, '2026-11-30', '2016-11-30', 'EK786000', '2026-06-29', '2016-06-29', 'false', '206838768', '2019-02-25 07:40:07');
INSERT INTO `documentData` VALUES (6, 29.00, '2026-11-30', '2016-11-30', 'EK786000', '2026-06-29', '2016-06-29', 'false', '206838768', '2019-02-25 08:55:15');
INSERT INTO `documentData` VALUES (7, 92.00, '2026-11-30', '2016-11-30', 'EK786000', '2026-06-29', '2016-06-29', 'true', '206838768', '2019-03-01 13:10:09');
INSERT INTO `documentData` VALUES (8, 92.00, '2026-11-30', '2016-11-30', 'EK786000', '2026-06-29', '2016-06-29', 'true', '206838768', '2019-03-01 13:18:27');
INSERT INTO `documentData` VALUES (9, 92.00, '2026-11-30', '2016-11-30', 'EK786000', '2026-06-29', '2016-06-29', 'true', '206838768', '2019-03-01 13:20:35');
INSERT INTO `documentData` VALUES (10, 92.00, '2026-11-30', '2016-11-30', 'EK786000', '2026-06-29', '2016-06-29', 'true', '206838768', '2019-03-01 13:23:48');
INSERT INTO `documentData` VALUES (11, 92.00, '2026-11-30', '2016-11-30', 'EK786000', '2026-06-29', '2016-06-29', 'true', '206838768', '2019-03-05 18:23:32');
COMMIT;

-- ----------------------------
-- Table structure for emailTemplate
-- ----------------------------
DROP TABLE IF EXISTS `emailTemplate`;
CREATE TABLE `emailTemplate` (
  `id` int(16) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `code` varchar(10000) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `version` int(16) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

-- ----------------------------
-- Records of emailTemplate
-- ----------------------------
BEGIN;
INSERT INTO `emailTemplate` VALUES (3, 'registration_done', '<!DOCTYPE html>\n<html xmlns=\"http://www.w3.org/1999/xhtml\" xmlns:o=\"urn:schemas-microsoft-com:office:office\"\n      xmlns:v=\"urn:schemas-microsoft-com:vml\">\n<head><title></title>\n    <meta content=\"IE=edge\" http-equiv=\"X-UA-Compatible\">\n    <meta content=\"text/html; charset=UTF-8\" http-equiv=\"Content-Type\">\n    <meta content=\"width=device-width, initial-scale=1.0\" name=\"viewport\">\n    <style type=\"text/css\"> #outlook a {\n        padding: 0;\n    }\n\n    .ReadMsgBody {\n        width: 100%;\n    }\n\n    .ExternalClass {\n        width: 100%;\n    }\n\n    .ExternalClass * {\n        line-height: 100%;\n    }\n\n    body {\n        margin: 0;\n        padding: 0;\n        -webkit-text-size-adjust: 100%;\n        -ms-text-size-adjust: 100%;\n    }\n\n    table, td {\n        border-collapse: collapse;\n        mso-table-lspace: 0pt;\n        mso-table-rspace: 0pt;\n    }\n\n    img {\n        border: 0;\n        height: auto;\n        line-height: 100%;\n        outline: none;\n        text-decoration: none;\n        -ms-interpolation-mode: bicubic;\n    }\n\n    p {\n        display: block;\n        margin: 13px 0;\n    }</style>\n    <style type=\"text/css\"> @media only screen and (max-width: 480px) {\n        @-ms-viewport {\n            width: 320px;\n        }@viewport {\n            width: 320px;\n        }\n    }</style>\n    <!--[if mso]>\n    <xml>\n        <o:OfficeDocumentSettings>\n            <o:AllowPNG/>\n            <o:PixelsPerInch>96</o:PixelsPerInch>\n        </o:OfficeDocumentSettings>\n    </xml><![endif]--><!--[if lte mso 11]>\n    <style type=\"text/css\"> .outlook-group-fix {\n        width: 100% !important;\n    }</style><![endif]-->\n    <link href=\"https://fonts.googleapis.com/css?family=Ubuntu:300,400,500,700\" rel=\"stylesheet\" type=\"text/css\">\n    <style type=\"text/css\"> @import url(https://fonts.googleapis.com/css?family=Ubuntu:300,400,500,700); </style>\n    <style type=\"text/css\"> @media only screen and (min-width: 480px) {\n        .mj-column-per-100 {\n            width: 100% !important;\n        }\n    }</style>\n</head>\n<body style=\"background: #FFFFFF;\">\n<div class=\"mj-container\" style=\"background-color:#FFFFFF;\"><!--[if mso | IE]>\n    <table role=\"presentation\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"600\" align=\"center\"\n           style=\"width:600px;\">\n        <tr>\n            <td style=\"line-height:0px;font-size:0px;mso-line-height-rule:exactly;\"><![endif]-->\n    <div style=\"margin:0px auto;max-width:600px;\">\n        <table align=\"center\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" role=\"presentation\"\n               style=\"font-size:0px;width:100%;\">\n            <tbody>\n            <tr>\n                <td style=\"text-align:center;vertical-align:top;direction:ltr;font-size:0px;padding:19px 0px 19px 0px;\">\n                    <!--[if mso | IE]>\n                    <table role=\"presentation\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n                        <tr>\n                            <td style=\"vertical-align:top;width:600px;\"><![endif]-->\n                    <div class=\"mj-column-per-100 outlook-group-fix\"\n                         style=\"vertical-align:top;display:inline-block;direction:ltr;font-size:13px;text-align:left;width:100%;\">\n                        <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" role=\"presentation\"\n                               style=\"vertical-align:top;\" width=\"100%\">\n                            <tbody>\n                            <tr>\n                                <td align=\"left\" style=\"word-wrap:break-word;font-size:0px;padding:0px 0px 0px 0px;\">\n                                    <table align=\"left\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" role=\"presentation\"\n                                           style=\"border-collapse:collapse;border-spacing:0px;\">\n                                        <tbody>\n                                        <tr>\n                                            <td style=\"width:48px;\"><img alt=\"\" height=\"auto\"\n                                                                         src=\"/static/images/1551033746.jpg\"\n                                                                         style=\"border:none;border-radius:0px;display:block;font-size:13px;outline:none;text-decoration:none;width:100%;height:auto;\"\n                                                                         width=\"48\"></td>\n                                        </tr>\n                                        </tbody>\n                                    </table>\n                                </td>\n                            </tr>\n                            <tr>\n                                <td align=\"left\"\n                                    style=\"word-wrap:break-word;font-size:0px;padding:17px 17px 17px 17px;\">\n                                    <div style=\"cursor:auto;color:#000000;font-family:Ubuntu, Helvetica, Arial, sans-serif;font-size:11px;line-height:1.5;text-align:left;\">\n                                        <p><span style=\"font-size:16px;\">Dobr&#xFD; den ${vokativ},</span></p>\n                                        <p><span\n                                                style=\"font-size:14px;\">Jmenuji se <strong>Vojt&#x11B;ch Posp&#xED;chal</strong> a pracuji pro carsharing REZERVATOR. Jsem nesm&#xED;rn&#x11B; pot&#x11B;&#x161;en, &#x17E;e jste vlo&#x17E;il svou d&#x16F;v&#x11B;ru pr&#xE1;v&#x11B; v n&#xE1;s. V p&#x159;&#xED;pad&#x11B; jak&#xE9;hokoli dotazu se na m&#x11B; nev&#xE1;hejte obr&#xE1;tit na telefonn&#xED;m &#x10D;&#xED;sle{{phone}}nebo odpov&#x11B;d&#xED; na tento email.</span>\n                                        </p>\n                                        <p><span style=\"font-size:14px;\">V&#xE1;&#x161; &#xFA;&#x10D;et v tuto chv&#xED;li je&#x161;t&#x11B; bohu&#x17E;el nen&#xED; aktivn&#xED;, mus&#xED;me je&#x161;t&#x11B; ov&#x11B;&#x159;it n&#x11B;kolik drobnost&#xED;, ale pevn&#x11B; v&#x11B;&#x159;&#xED;m v to, &#x17E;e bude v&#x161;e b&#x11B;hem n&#x11B;kolika minut vy&#x159;&#xED;zeno. Budeme V&#xE1;s kontaktovat ihned pot&#xE9;, co bude v&#x161;e vy&#x159;&#xED;zeno.</span>\n                                        </p>\n                                        <p></p>\n                                        <p><span style=\"font-size:14px;\">Vojt&#x11B;ch Posp&#xED;chal<br>vedouc&#xED; odd&#x11B;len&#xED; komunikace<br>Underholding s.r.o.</span>\n                                        </p></div>\n                                </td>\n                            </tr>\n                            </tbody>\n                        </table>\n                    </div>\n                </td>\n            </tr>\n            </tbody>\n        </table>\n    </div>\n</div>\n</body>\n</html>', 1);
COMMIT;

-- ----------------------------
-- Table structure for ocrResult
-- ----------------------------
DROP TABLE IF EXISTS `ocrResult`;
CREATE TABLE `ocrResult` (
  `id` int(16) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(16) DEFAULT NULL,
  `ocr_result_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `started` datetime(6) DEFAULT NULL,
  `finished` datetime(6) DEFAULT NULL,
  `ocr_parsed_data` varchar(10000) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

-- ----------------------------
-- Records of ocrResult
-- ----------------------------
BEGIN;
INSERT INTO `ocrResult` VALUES (20, 10, 'b5b20626-5338-41dd-87f0-df8041f1897c', '2019-02-24 14:58:38.000000', '2019-02-24 14:59:05.000000', '{\"started\":\"2019-02-24T14:58:36.968Z\",\"finished\":\"2019-02-24T14:58:45.748Z\",\"confidence\":29.0,\"result\":{\"academic_title\":\"\",\"address_city\":\"PRAHA\",\"address_city_part\":\"LIBEŇ\",\"address_district\":\"PRAHA 9\",\"address_number\":\"871/15\",\"address_street\":\"ČIHÁKOVA\",\"birthday\":\"25.07.1998\",\"birthplace\":\"PRAHA\",\"birthplace_district\":\"PRAHA 10\",\"driving_license_expiration\":\"30.11.2026\",\"driving_license_issued\":\"30.11.2016\",\"driving_license_number\":\"EK786000\",\"passport_expiration\":null,\"passport_issued\":null,\"passport_number\":null,\"id_expiration\":\"29.06.2026\",\"id_issued\":\"29.06.2016\",\"id_mrz_valid\":\"false\",\"id_number\":\"206838768\",\"marital_status\":\"\",\"name\":\"VOJTĚCH\",\"pdf417\":\"206838768\",\"personal_number\":\"9807250486\",\"sex\":\"M\",\"surname\":\"POSPÍCHAL\",\"issued_by\":null,\"name_at_birth\":null,\"confidence\":29.0,\"debug_data\":null},\"type\":\"success\",\"error\":null}');
INSERT INTO `ocrResult` VALUES (21, 10, '3fc8ffd8-29f3-4e8d-a5f8-ba96b91a4773', '2019-02-24 20:03:37.000000', '2019-02-24 20:03:47.000000', '{\"started\":\"2019-02-24T20:03:35.797Z\",\"finished\":\"2019-02-24T20:03:43.544Z\",\"confidence\":29.0,\"result\":{\"academic_title\":\"\",\"address_city\":\"PRAHA\",\"address_city_part\":\"LIBEŇ\",\"address_district\":\"PRAHA 9\",\"address_number\":\"871/15\",\"address_street\":\"ČIHÁKOVA\",\"birthday\":\"25.07.1998\",\"birthplace\":\"PRAHA\",\"birthplace_district\":\"PRAHA 10\",\"driving_license_expiration\":\"30.11.2026\",\"driving_license_issued\":\"30.11.2016\",\"driving_license_number\":\"EK786000\",\"passport_expiration\":null,\"passport_issued\":null,\"passport_number\":null,\"id_expiration\":\"29.06.2026\",\"id_issued\":\"29.06.2016\",\"id_mrz_valid\":\"false\",\"id_number\":\"206838768\",\"marital_status\":\"\",\"name\":\"VOJTĚCH\",\"pdf417\":\"206838768\",\"personal_number\":\"9807250486\",\"sex\":\"M\",\"surname\":\"POSPÍCHAL\",\"issued_by\":null,\"name_at_birth\":null,\"confidence\":29.0,\"debug_data\":null},\"type\":\"success\",\"error\":null}');
INSERT INTO `ocrResult` VALUES (22, 10, '2fe707bb-9546-4e21-8c81-9b58931bbf95', '2019-02-24 20:05:28.000000', '2019-02-24 20:05:38.000000', '{\"started\":\"2019-02-24T20:05:28.049Z\",\"finished\":\"2019-02-24T20:05:36.456Z\",\"confidence\":29.0,\"result\":{\"academic_title\":\"\",\"address_city\":\"PRAHA\",\"address_city_part\":\"LIBEŇ\",\"address_district\":\"PRAHA 9\",\"address_number\":\"871/15\",\"address_street\":\"ČIHÁKOVA\",\"birthday\":\"25.07.1998\",\"birthplace\":\"PRAHA\",\"birthplace_district\":\"PRAHA 10\",\"driving_license_expiration\":\"30.11.2026\",\"driving_license_issued\":\"30.11.2016\",\"driving_license_number\":\"EK786000\",\"passport_expiration\":null,\"passport_issued\":null,\"passport_number\":null,\"id_expiration\":\"29.06.2026\",\"id_issued\":\"29.06.2016\",\"id_mrz_valid\":\"false\",\"id_number\":\"206838768\",\"marital_status\":\"\",\"name\":\"VOJTĚCH\",\"pdf417\":\"206838768\",\"personal_number\":\"9807250486\",\"sex\":\"M\",\"surname\":\"POSPÍCHAL\",\"issued_by\":null,\"name_at_birth\":null,\"confidence\":29.0,\"debug_data\":null},\"type\":\"success\",\"error\":null}');
INSERT INTO `ocrResult` VALUES (23, 10, 'a2ab423d-e6df-4fc3-89a4-41728e5def36', '2019-02-25 08:55:04.000000', '2019-02-25 08:55:13.000000', '{\"started\":\"2019-02-25T08:55:03.259Z\",\"finished\":\"2019-02-25T08:55:12.709Z\",\"confidence\":29.0,\"result\":{\"academic_title\":\"\",\"address_city\":\"PRAHA\",\"address_city_part\":\"LIBEŇ\",\"address_district\":\"PRAHA 9\",\"address_number\":\"871/15\",\"address_street\":\"ČIHÁKOVA\",\"birthday\":\"25.07.1998\",\"birthplace\":\"PRAHA\",\"birthplace_district\":\"PRAHA 10\",\"driving_license_expiration\":\"30.11.2026\",\"driving_license_issued\":\"30.11.2016\",\"driving_license_number\":\"EK786000\",\"passport_expiration\":null,\"passport_issued\":null,\"passport_number\":null,\"id_expiration\":\"29.06.2026\",\"id_issued\":\"29.06.2016\",\"id_mrz_valid\":\"false\",\"id_number\":\"206838768\",\"marital_status\":\"\",\"name\":\"VOJTĚCH\",\"pdf417\":\"206838768\",\"personal_number\":\"9807250486\",\"sex\":\"M\",\"surname\":\"POSPÍCHAL\",\"issued_by\":null,\"name_at_birth\":null,\"confidence\":29.0,\"debug_data\":null},\"type\":\"success\",\"error\":null}');
INSERT INTO `ocrResult` VALUES (24, 10, '45ea2ad8-700e-4da1-be21-b366d00a3905', '2019-03-01 13:10:01.000000', '2019-03-01 13:10:07.000000', '{\"started\":\"2019-03-01T13:09:57.749Z\",\"finished\":\"2019-03-01T13:10:04.876Z\",\"confidence\":92.0,\"result\":{\"academic_title\":\"\",\"address_city\":\"PRAHA\",\"address_city_part\":\"LIBEŇ\",\"address_district\":\"PRAHA 9\",\"address_number\":\"871/15\",\"address_street\":\"ČIHÁKOVA\",\"birthday\":\"25.07.1998\",\"birthplace\":\"PRAHA\",\"birthplace_district\":\"PRAHA 10\",\"driving_license_expiration\":\"30.11.2026\",\"driving_license_issued\":\"30.11.2016\",\"driving_license_number\":\"EK786000\",\"passport_expiration\":null,\"passport_issued\":null,\"passport_number\":null,\"id_expiration\":\"29.06.2026\",\"id_issued\":\"29.06.2016\",\"id_mrz_valid\":\"true\",\"id_number\":\"206838768\",\"marital_status\":\"\",\"name\":\"VOJTĚCH\",\"pdf417\":\"206838768\",\"personal_number\":\"9807250486\",\"sex\":\"M\",\"surname\":\"POSPÍCHAL\",\"issued_by\":null,\"name_at_birth\":null,\"confidence\":92.0,\"debug_data\":null},\"type\":\"success\",\"error\":null}');
INSERT INTO `ocrResult` VALUES (25, 10, 'c416cc67-e0b1-4e42-9478-fe17dccbc175', '2019-03-01 13:18:15.000000', '2019-03-01 13:18:25.000000', '{\"started\":\"2019-03-01T13:18:14.248Z\",\"finished\":\"2019-03-01T13:18:21.348Z\",\"confidence\":92.0,\"result\":{\"academic_title\":\"\",\"address_city\":\"PRAHA\",\"address_city_part\":\"LIBEŇ\",\"address_district\":\"PRAHA 9\",\"address_number\":\"871/15\",\"address_street\":\"ČIHÁKOVA\",\"birthday\":\"25.07.1998\",\"birthplace\":\"PRAHA\",\"birthplace_district\":\"PRAHA 10\",\"driving_license_expiration\":\"30.11.2026\",\"driving_license_issued\":\"30.11.2016\",\"driving_license_number\":\"EK786000\",\"passport_expiration\":null,\"passport_issued\":null,\"passport_number\":null,\"id_expiration\":\"29.06.2026\",\"id_issued\":\"29.06.2016\",\"id_mrz_valid\":\"true\",\"id_number\":\"206838768\",\"marital_status\":\"\",\"name\":\"VOJTĚCH\",\"pdf417\":\"206838768\",\"personal_number\":\"9807250486\",\"sex\":\"M\",\"surname\":\"POSPÍCHAL\",\"issued_by\":null,\"name_at_birth\":null,\"confidence\":92.0,\"debug_data\":null},\"type\":\"success\",\"error\":null}');
INSERT INTO `ocrResult` VALUES (26, 10, 'c62d2f77-93d3-48c7-9050-3dddd9be7a4b', '2019-03-01 13:20:24.000000', '2019-03-01 13:20:34.000000', '{\"started\":\"2019-03-01T13:20:22.840Z\",\"finished\":\"2019-03-01T13:20:29.813Z\",\"confidence\":92.0,\"result\":{\"academic_title\":\"M.A.\",\"address_city\":\"PRAHA\",\"address_city_part\":\"LIBEŇ\",\"address_district\":\"PRAHA 9\",\"address_number\":\"871/15\",\"address_street\":\"ČIHÁKOVA\",\"birthday\":\"25.07.1998\",\"birthplace\":\"PRAHA\",\"birthplace_district\":\"PRAHA 10\",\"driving_license_expiration\":\"30.11.2026\",\"driving_license_issued\":\"30.11.2016\",\"driving_license_number\":\"EK786000\",\"passport_expiration\":null,\"passport_issued\":null,\"passport_number\":null,\"id_expiration\":\"29.06.2026\",\"id_issued\":\"29.06.2016\",\"id_mrz_valid\":\"true\",\"id_number\":\"206838768\",\"marital_status\":\"\",\"name\":\"VOJTĚCH\",\"pdf417\":\"206838768\",\"personal_number\":\"9807250486\",\"sex\":\"M\",\"surname\":\"POSPÍCHAL\",\"issued_by\":null,\"name_at_birth\":null,\"confidence\":92.0,\"debug_data\":null},\"type\":\"success\",\"error\":null}');
INSERT INTO `ocrResult` VALUES (27, 10, '8ff99d1d-6f3b-4291-a045-8035676b4a3c', '2019-03-01 13:23:33.000000', '2019-03-01 13:23:46.000000', '{\"started\":\"2019-03-01T13:23:32.455Z\",\"finished\":\"2019-03-01T13:23:39.900Z\",\"confidence\":92.0,\"result\":{\"academic_title\":\"M.A.\",\"address_city\":\"PRAHA\",\"address_city_part\":\"LIBEŇ\",\"address_district\":\"PRAHA 9\",\"address_number\":\"871/15\",\"address_street\":\"ČIHÁKOVA\",\"birthday\":\"25.07.1998\",\"birthplace\":\"PRAHA\",\"birthplace_district\":\"PRAHA 10\",\"driving_license_expiration\":\"30.11.2026\",\"driving_license_issued\":\"30.11.2016\",\"driving_license_number\":\"EK786000\",\"passport_expiration\":null,\"passport_issued\":null,\"passport_number\":null,\"id_expiration\":\"29.06.2026\",\"id_issued\":\"29.06.2016\",\"id_mrz_valid\":\"true\",\"id_number\":\"206838768\",\"marital_status\":\"\",\"name\":\"VOJTĚCH\",\"pdf417\":\"206838768\",\"personal_number\":\"9807250486\",\"sex\":\"M\",\"surname\":\"POSPÍCHAL\",\"issued_by\":null,\"name_at_birth\":null,\"confidence\":92.0,\"debug_data\":null},\"type\":\"success\",\"error\":null}');
INSERT INTO `ocrResult` VALUES (28, NULL, NULL, '2019-03-01 16:34:52.000000', NULL, NULL);
INSERT INTO `ocrResult` VALUES (29, 10, '621661c8-b2be-4abd-9a0a-f94ae6dc4733', '2019-03-05 18:23:23.000000', '2019-03-05 18:23:32.000000', '{\"started\":\"2019-03-05T18:23:21.877Z\",\"finished\":\"2019-03-05T18:23:30.954Z\",\"confidence\":92.0,\"result\":{\"academic_title\":\"\",\"address_city\":\"PRAHA\",\"address_city_part\":\"LIBEŇ\",\"address_district\":\"PRAHA 9\",\"address_number\":\"871/15\",\"address_street\":\"ČIHÁKOVA\",\"birthday\":\"25.07.1998\",\"birthplace\":\"PRAHA\",\"birthplace_district\":\"PRAHA 10\",\"driving_license_expiration\":\"30.11.2026\",\"driving_license_issued\":\"30.11.2016\",\"driving_license_number\":\"EK786000\",\"passport_expiration\":null,\"passport_issued\":null,\"passport_number\":null,\"id_expiration\":\"29.06.2026\",\"id_issued\":\"29.06.2016\",\"id_mrz_valid\":\"true\",\"id_number\":\"206838768\",\"marital_status\":\"\",\"name\":\"VOJTĚCH\",\"pdf417\":\"206838768\",\"personal_number\":\"9807250486\",\"sex\":\"M\",\"surname\":\"POSPÍCHAL\",\"issued_by\":null,\"name_at_birth\":null,\"confidence\":92.0,\"debug_data\":null},\"type\":\"success\",\"error\":null}');
COMMIT;

-- ----------------------------
-- Table structure for rents
-- ----------------------------
DROP TABLE IF EXISTS `rents`;
CREATE TABLE `rents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `car` int(11) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `user` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `active` tinyint(1) DEFAULT '1',
  `transaction` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fkRentTransaction` (`transaction`),
  KEY `fkRentCar` (`car`),
  KEY `fkRentUser` (`user`),
  CONSTRAINT `fkRentCar` FOREIGN KEY (`car`) REFERENCES `cars` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fkRentTransaction` FOREIGN KEY (`transaction`) REFERENCES `transactions` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fkRentUser` FOREIGN KEY (`user`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

-- ----------------------------
-- Records of rents
-- ----------------------------
BEGIN;
INSERT INTO `rents` VALUES (43, '2019-03-02 00:00:00', 2, 16.99, 10, '2019-03-01 17:52:16', '2019-03-01 17:56:39', 1, 23);
COMMIT;

-- ----------------------------
-- Table structure for smsCode
-- ----------------------------
DROP TABLE IF EXISTS `smsCode`;
CREATE TABLE `smsCode` (
  `id` int(16) unsigned NOT NULL AUTO_INCREMENT,
  `code` int(4) DEFAULT NULL,
  `user` int(16) DEFAULT NULL,
  `created` datetime(6) DEFAULT NULL,
  `used` int(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

-- ----------------------------
-- Table structure for smsTemplate
-- ----------------------------
DROP TABLE IF EXISTS `smsTemplate`;
CREATE TABLE `smsTemplate` (
  `id` int(16) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `code` varchar(10000) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `version` int(16) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

-- ----------------------------
-- Records of smsTemplate
-- ----------------------------
BEGIN;
INSERT INTO `smsTemplate` VALUES (4, 'ocr-done', 'Dobrý den ${vokativ},\\n Váš účet byl právě schválen, nyní se můžete přihlásit a užít si svou první jízdu.\\n Váš REEZ 🚗', 1);
COMMIT;

-- ----------------------------
-- Table structure for token
-- ----------------------------
DROP TABLE IF EXISTS `token`;
CREATE TABLE `token` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user` int(11) DEFAULT NULL,
  `token` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `device_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fkTokenUser` (`user`),
  CONSTRAINT `fkTokenUser` FOREIGN KEY (`user`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

-- ----------------------------
-- Table structure for transactions
-- ----------------------------
DROP TABLE IF EXISTS `transactions`;
CREATE TABLE `transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `amount` decimal(20,2) DEFAULT NULL,
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `extId` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `currency` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `created` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

-- ----------------------------
-- Records of transactions
-- ----------------------------
BEGIN;
INSERT INTO `transactions` VALUES (23, 16.00, 'positive', 'UbJa8k0h0mbL1Kz7ssJLpwMSrIM2', 'EUR', '2019-03-01 17:56:38.482364', 'submitted_for_settlement');
COMMIT;

-- ----------------------------
-- Table structure for userDetail
-- ----------------------------
DROP TABLE IF EXISTS `userDetail`;
CREATE TABLE `userDetail` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `surname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `personal_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `sex` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `academic_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `address_city` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `address_city_part` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `address_district` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `address_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `address_street` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `birthplace` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `birthplace_district` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `document_data` int(16) unsigned DEFAULT NULL,
  `user_id` int(16) DEFAULT NULL,
  `vokativ` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fkUserDetailUser` (`user_id`),
  KEY `fkUserDoc` (`document_data`),
  CONSTRAINT `fkUserDetailUser` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fkUserDoc` FOREIGN KEY (`document_data`) REFERENCES `documentData` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

-- ----------------------------
-- Records of userDetail
-- ----------------------------
BEGIN;
INSERT INTO `userDetail` VALUES (5, 'VOJTĚCH', 'POSPÍCHAL', '9807250486', 'M', '', 'PRAHA', 'LIBEŇ', 'PRAHA 9', '871/15', 'ČIHÁKOVA', '1998-07-25', 'PRAHA', 'PRAHA 10', 5, 10, 'Vojtěchu', '2019-02-25 07:39:18');
INSERT INTO `userDetail` VALUES (6, 'VOJTĚCH', 'POSPÍCHAL', '9807250486', 'M', '', 'PRAHA', 'LIBEŇ', 'PRAHA 9', '871/15', 'ČIHÁKOVA', '1998-07-25', 'PRAHA', 'PRAHA 10', 6, 10, 'Vojtěchu', '2019-02-25 08:55:17');
INSERT INTO `userDetail` VALUES (7, 'VOJTĚCH', 'POSPÍCHAL', '9807250486', 'M', '', 'PRAHA', 'LIBEŇ', 'PRAHA 9', '871/15', 'ČIHÁKOVA', '1998-07-25', 'PRAHA', 'PRAHA 10', 7, 10, 'Vojtěchu', '2019-03-01 13:10:11');
INSERT INTO `userDetail` VALUES (8, 'VOJTĚCH', 'POSPÍCHAL', '9807250486', 'M', '', 'PRAHA', 'LIBEŇ', 'PRAHA 9', '871/15', 'ČIHÁKOVA', '1998-07-25', 'PRAHA', 'PRAHA 10', 8, 10, 'Vojtěchu', '2019-03-01 13:18:29');
INSERT INTO `userDetail` VALUES (9, 'VOJTĚCH', 'POSPÍCHAL', '9807250486', 'M', 'M.A.', 'PRAHA', 'LIBEŇ', 'PRAHA 9', '871/15', 'ČIHÁKOVA', '1998-07-25', 'PRAHA', 'PRAHA 10', 9, 10, 'Vojtěchu', '2019-03-01 13:20:37');
INSERT INTO `userDetail` VALUES (10, 'VOJTĚCH', 'POSPÍCHAL', '9807250486', 'M', 'M.A.', 'PRAHA', 'LIBEŇ', 'PRAHA 9', '871/15', 'ČIHÁKOVA', '1998-07-25', 'PRAHA', 'PRAHA 10', 10, 10, 'Vojtěchu', '2019-03-01 13:23:50');
INSERT INTO `userDetail` VALUES (11, 'VOJTĚCH', 'POSPÍCHAL', '9807250486', 'M', '', 'PRAHA', 'LIBEŇ', 'PRAHA 9', '871/15', 'ČIHÁKOVA', '1998-07-25', 'PRAHA', 'PRAHA 10', 11, 10, NULL, '2019-03-05 18:23:32');
COMMIT;

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `displayName` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `email` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `photoUrl` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `provider` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `paymentId` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `scope` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `active` tinyint(1) DEFAULT '0',
  `confidence` double(16,2) DEFAULT '0.00',
  `phone_number` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

-- ----------------------------
-- Records of users
-- ----------------------------
BEGIN;
INSERT INTO `users` VALUES (3, 'Admin', 'pospichal@underholding.cz', '', 'local', '0', NULL, 'ROLE_ADMIN', 1, NULL, NULL);
INSERT INTO `users` VALUES (10, 'Vojta Pospíchal', 'reinolde@seznam.cz', 'https://graph.facebook.com/2133650036666707/picture', 'Firebase', 'UbJa8k0h0mbL1Kz7ssJLpwMSrIM2', 'UbJa8k0h0mbL1Kz7ssJLpwMSrIM2', 'ROLE_ADMIN', 1, 23.57, '+420773042895');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
