# Caso #1 - Entregable 2 ![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
## Payment Assistant
Imagina un asistente personal que no solo recuerda tus pagos recurrentes, sino que también los ejecuta por ti con solo confirmar un recordatorio. Con tecnología de inteligencia artificial de vanguardia, nuestra app te permite registrar y programar pagos de servicios como luz, agua, renta y más, usando simplemente tu voz. Olvídate de fechas vencidas, multas o estrés financiero. Además, con planes flexibles que se adaptan a tus necesidades, disfrutas de una experiencia gratuita para un pago mensual y opciones premium para múltiples transacciones.

#### Notas Importantes:
Para la revisión de los archivos adjuntos, se recomienda descargar el PDF para mejorar su visualización.

## Lista de Entidades
A continuación se listan todas las entidades relevantes a la creación de las tablas en MySQL Workbench.
- Usuarios y sus perfiles respectivos:
    * Nombre y apellido
    * Información de contacto adicional (numero telefónico, Instagram, correo, etc)
- Permisos administrativos y de consumidor (incluyendo accesos, grants y denies)
- Almacenamiento de archivos (attachments, media files, documentos, URLs bancarios, etc)
- Transacciones y pagos
    * Monto
    * Moneda
    * Fecha
    * Resultado
    * Autenticador
    * Descriptión
    * Manejo de errores
    * Tipo de transacción
- Suscripciones, planes y sus costo/límites/features respectivos
- Bitácora
    * Pagos intentados, fallidos y exitosos
    * Montos, métodos de pago, fechas y cuenta de origen
- Scheduling
- Internacionalización
- Manejo de cambios entre sistemas monetarios (dólar, colones, pesos, etc.)


## Scripts

### Creación de Base de Datos

<details>
<summary>
	Creación de Base de Datos
</summary>

<br>

```sql

-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema paymentAssistant
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema paymentAssistant
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `paymentAssistant` DEFAULT CHARACTER SET utf8 ;
USE `paymentAssistant` ;

-- -----------------------------------------------------
-- Table `paymentAssistant`.`payment_users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentAssistant`.`payment_users` (
  `userid` INT NOT NULL AUTO_INCREMENT,
  `firstName` VARCHAR(30) NOT NULL,
  `lastName` VARCHAR(35) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `country` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`userid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentAssistant`.`payment_mediaFiles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentAssistant`.`payment_mediaFiles` (
  `mediafileid` INT NOT NULL AUTO_INCREMENT,
  `userid` INT NOT NULL,
  `url` VARCHAR(200) NULL,
  `deleted` VARCHAR(45) NULL,
  `lastupdate` DATETIME NULL,
  PRIMARY KEY (`mediafileid`),
  INDEX `fk_payment_mediaFiles_payment_users1_idx` (`userid` ASC) VISIBLE,
  CONSTRAINT `fk_payment_mediaFiles_payment_users1`
    FOREIGN KEY (`userid`)
    REFERENCES `paymentAssistant`.`payment_users` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentAssistant`.`payment_mediaTypes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentAssistant`.`payment_mediaTypes` (
  `mediatype` TINYINT(3) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  `playerimpl` VARCHAR(100) NULL COMMENT 'no se que es',
  `mediafileid` INT NOT NULL,
  PRIMARY KEY (`mediatype`),
  INDEX `fk_payment_mediaTypes_payment_mediaFiles1_idx` (`mediafileid` ASC) VISIBLE,
  CONSTRAINT `fk_payment_mediaTypes_payment_mediaFiles1`
    FOREIGN KEY (`mediafileid`)
    REFERENCES `paymentAssistant`.`payment_mediaFiles` (`mediafileid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentAssistant`.`payment_roles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentAssistant`.`payment_roles` (
  `roleid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`roleid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentAssistant`.`payment_usersroles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentAssistant`.`payment_usersroles` (
  `roleid` INT NOT NULL,
  `userid` INT NOT NULL,
  `lastupdate` DATETIME NOT NULL DEFAULT NOW(),
  `username` VARCHAR(50) NOT NULL,
  `checksum` VARBINARY(250) NOT NULL,
  `enabled` BIT(1) NOT NULL DEFAULT 1,
  `deleted` BIT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`roleid`, `userid`),
  INDEX `fk_payment_usersroles_payment_roles1_idx` (`roleid` ASC) VISIBLE,
  INDEX `fk_payment_usersroles_payment_users1_idx` (`userid` ASC) VISIBLE,
  CONSTRAINT `fk_payment_usersroles_payment_roles10`
    FOREIGN KEY (`roleid`)
    REFERENCES `paymentAssistant`.`payment_roles` (`roleid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_usersroles_payment_users10`
    FOREIGN KEY (`userid`)
    REFERENCES `paymentAssistant`.`payment_users` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentAssistant`.`payment_modules`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentAssistant`.`payment_modules` (
  `moduleid` TINYINT(8) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`moduleid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentAssistant`.`payment_permissions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentAssistant`.`payment_permissions` (
  `permissionid` INT NOT NULL AUTO_INCREMENT,
  `moduleid` TINYINT(8) NOT NULL,
  `description` VARCHAR(60) NOT NULL,
  `code` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`permissionid`),
  INDEX `fk_payment_permissions_copy1_payment_modules_copy11_idx` (`moduleid` ASC) VISIBLE,
  CONSTRAINT `fk_payment_permissions_copy1_payment_modules_copy11`
    FOREIGN KEY (`moduleid`)
    REFERENCES `paymentAssistant`.`payment_modules` (`moduleid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentAssistant`.`payment_rolespermissions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentAssistant`.`payment_rolespermissions` (
  `rolepermissionid` INT NOT NULL AUTO_INCREMENT,
  `roleid` INT NOT NULL,
  `permissionid` INT NOT NULL,
  `enabled` BIT(1) NOT NULL DEFAULT 1,
  `deleted` BIT(1) NOT NULL DEFAULT 0,
  `lastupdate` DATETIME NOT NULL DEFAULT NOW(),
  `username` VARCHAR(50) NOT NULL,
  `checksum` VARBINARY(250) NOT NULL,
  PRIMARY KEY (`rolepermissionid`),
  INDEX `fk_payment_rolespermissions_payment_roles_copy11_idx` (`roleid` ASC) VISIBLE,
  INDEX `fk_payment_rolespermissions_copy1_payment_permissions_copy1_idx` (`permissionid` ASC) VISIBLE,
  CONSTRAINT `fk_payment_rolespermissions_payment_roles_copy110`
    FOREIGN KEY (`roleid`)
    REFERENCES `paymentAssistant`.`payment_roles` (`roleid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_rolespermissions_copy1_payment_permissions_copy11`
    FOREIGN KEY (`permissionid`)
    REFERENCES `paymentAssistant`.`payment_permissions` (`permissionid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentAssistant`.`payment_userspermissions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentAssistant`.`payment_userspermissions` (
  `rolepermissionid` INT NOT NULL AUTO_INCREMENT,
  `userid` INT NOT NULL,
  `permissionid` INT NOT NULL,
  `enabled` BIT(1) NOT NULL DEFAULT 1,
  `deleted` BIT(1) NOT NULL DEFAULT 0,
  `lastupdate` DATETIME NOT NULL DEFAULT NOW(),
  `username` VARCHAR(50) NOT NULL,
  `checksum` VARBINARY(250) NOT NULL,
  PRIMARY KEY (`rolepermissionid`),
  INDEX `fk_payment_userspermissions_payment_users1_idx` (`userid` ASC) VISIBLE,
  INDEX `fk_payment_userspermissions_copy1_payment_permissions_copy1_idx` (`permissionid` ASC) VISIBLE,
  CONSTRAINT `fk_payment_userspermissions_payment_users10`
    FOREIGN KEY (`userid`)
    REFERENCES `paymentAssistant`.`payment_users` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_userspermissions_copy1_payment_permissions_copy11`
    FOREIGN KEY (`permissionid`)
    REFERENCES `paymentAssistant`.`payment_permissions` (`permissionid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentAssistant`.`contactInfoTypes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentAssistant`.`contactInfoTypes` (
  `contactInfoTypesid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`contactInfoTypesid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentAssistant`.`contactInfoPerPerson`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentAssistant`.`contactInfoPerPerson` (
  `userid` INT NOT NULL,
  `contactInfoTypesid` INT NOT NULL,
  `value` VARCHAR(100) NOT NULL,
  `enabled` BIT(1) NOT NULL,
  `lastUpdate` DATETIME NOT NULL,
  PRIMARY KEY (`userid`, `contactInfoTypesid`),
  INDEX `fk_payment_users_has_contactInfoTypes_contactInfoTypes1_idx` (`contactInfoTypesid` ASC) VISIBLE,
  INDEX `fk_payment_users_has_contactInfoTypes_payment_users1_idx` (`userid` ASC) VISIBLE,
  CONSTRAINT `fk_payment_users_has_contactInfoTypes_payment_users1`
    FOREIGN KEY (`userid`)
    REFERENCES `paymentAssistant`.`payment_users` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_users_has_contactInfoTypes_contactInfoTypes1`
    FOREIGN KEY (`contactInfoTypesid`)
    REFERENCES `paymentAssistant`.`contactInfoTypes` (`contactInfoTypesid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentAssistant`.`metodoDePago`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentAssistant`.`metodoDePago` (
  `MetodoDePagoid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(20) NOT NULL,
  `ApiURL` VARCHAR(150) NOT NULL,
  `secretKey` VARCHAR(60) NOT NULL,
  `key` VARCHAR(60) NOT NULL,
  `logoIconVal` VARCHAR(100) NULL,
  `enabled` BIT(1) NOT NULL,
  PRIMARY KEY (`MetodoDePagoid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentAssistant`.`mediosDisponibles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentAssistant`.`mediosDisponibles` (
  `MediosDisponiblesid` INT NOT NULL AUTO_INCREMENT,
  `MetodoDePagoid` INT NOT NULL,
  `userid` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `token` VARCHAR(60) NOT NULL,
  `expTokenDate` DATETIME NOT NULL,
  `maskAccount` VARCHAR(60) NULL,
  PRIMARY KEY (`MediosDisponiblesid`),
  INDEX `fk_MetodosDisponibles_MetodoDePago1_idx` (`MetodoDePagoid` ASC) VISIBLE,
  INDEX `fk_metodosDisponibles_payment_users1_idx` (`userid` ASC) VISIBLE,
  CONSTRAINT `fk_MetodosDisponibles_MetodoDePago1`
    FOREIGN KEY (`MetodoDePagoid`)
    REFERENCES `paymentAssistant`.`metodoDePago` (`MetodoDePagoid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_metodosDisponibles_payment_users1`
    FOREIGN KEY (`userid`)
    REFERENCES `paymentAssistant`.`payment_users` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentAssistant`.`moneda`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentAssistant`.`moneda` (
  `monedaid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(20) NOT NULL,
  `acronym` VARCHAR(3) NOT NULL,
  PRIMARY KEY (`monedaid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentAssistant`.`pagos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentAssistant`.`pagos` (
  `pagosid` BIGINT NOT NULL AUTO_INCREMENT,
  `metodoDePagoid` INT NOT NULL,
  `mediosDisponiblesid` INT NOT NULL,
  `userid` INT NOT NULL,
  `monedaid` INT NOT NULL,
  `monto` DECIMAL(12,2) NOT NULL,
  `actualMonto` DECIMAL(12,2) NOT NULL,
  `payDateTime` VARCHAR(45) NOT NULL,
  `auth` VARCHAR(500) NOT NULL,
  `reference` VARCHAR(45) NOT NULL,
  `chargeToken` VARCHAR(6) NOT NULL,
  `description` VARCHAR(50) NULL,
  `error` VARCHAR(50) NULL,
  `checkSum` VARBINARY(250) NOT NULL,
  PRIMARY KEY (`pagosid`),
  INDEX `fk_pagos_MetodoDePago1_idx` (`metodoDePagoid` ASC) VISIBLE,
  INDEX `fk_pagos_MetodosDisponibles1_idx` (`mediosDisponiblesid` ASC) VISIBLE,
  INDEX `fk_pagos_payment_users1_idx` (`userid` ASC) VISIBLE,
  INDEX `fk_pagos_moneda1_idx` (`monedaid` ASC) VISIBLE,
  CONSTRAINT `fk_pagos_MetodoDePago1`
    FOREIGN KEY (`metodoDePagoid`)
    REFERENCES `paymentAssistant`.`metodoDePago` (`MetodoDePagoid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pagos_MetodosDisponibles1`
    FOREIGN KEY (`mediosDisponiblesid`)
    REFERENCES `paymentAssistant`.`mediosDisponibles` (`MediosDisponiblesid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pagos_payment_users1`
    FOREIGN KEY (`userid`)
    REFERENCES `paymentAssistant`.`payment_users` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pagos_moneda1`
    FOREIGN KEY (`monedaid`)
    REFERENCES `paymentAssistant`.`moneda` (`monedaid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentAssistant`.`transTypes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentAssistant`.`transTypes` (
  `transTypesid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`transTypesid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentAssistant`.`exchange`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentAssistant`.`exchange` (
  `exchangeid` INT NOT NULL AUTO_INCREMENT,
  `monedaid` INT NOT NULL,
  `startDate` DATE NOT NULL,
  `endDate` DATE NOT NULL,
  `exchangeRate` DECIMAL(12,6) NOT NULL,
  `enabled` BIT(1) NOT NULL,
  `currentExchangeRate` BIT(1) NOT NULL,
  PRIMARY KEY (`exchangeid`),
  INDEX `fk_exchange_moneda1_idx` (`monedaid` ASC) VISIBLE,
  CONSTRAINT `fk_exchange_moneda1`
    FOREIGN KEY (`monedaid`)
    REFERENCES `paymentAssistant`.`moneda` (`monedaid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentAssistant`.`transacciones`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentAssistant`.`transacciones` (
  `idTransaciones` BIGINT NOT NULL AUTO_INCREMENT,
  `pagosid` BIGINT NULL,
  `transTypesid` INT NOT NULL,
  `monedaid` INT NOT NULL,
  `exchangeid` INT NOT NULL,
  `userid` INT NULL,
  `amount` DECIMAL(12,2) NOT NULL,
  `description` VARCHAR(50) NOT NULL,
  `transDateTime` DATETIME NOT NULL,
  `postTime` TIME NOT NULL,
  `refNumber` VARCHAR(15) NOT NULL,
  `checkSum` VARBINARY(250) NOT NULL,
  PRIMARY KEY (`idTransaciones`),
  INDEX `fk_Transaciones_pagos1_idx` (`pagosid` ASC) VISIBLE,
  INDEX `fk_transacciones_transTypes1_idx` (`transTypesid` ASC) VISIBLE,
  INDEX `fk_transacciones_moneda1_idx` (`monedaid` ASC) VISIBLE,
  INDEX `fk_transacciones_exchange1_idx` (`exchangeid` ASC) VISIBLE,
  INDEX `fk_transacciones_payment_users1_idx` (`userid` ASC) VISIBLE,
  CONSTRAINT `fk_Transaciones_pagos1`
    FOREIGN KEY (`pagosid`)
    REFERENCES `paymentAssistant`.`pagos` (`pagosid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_transacciones_transTypes1`
    FOREIGN KEY (`transTypesid`)
    REFERENCES `paymentAssistant`.`transTypes` (`transTypesid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_transacciones_moneda1`
    FOREIGN KEY (`monedaid`)
    REFERENCES `paymentAssistant`.`moneda` (`monedaid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_transacciones_exchange1`
    FOREIGN KEY (`exchangeid`)
    REFERENCES `paymentAssistant`.`exchange` (`exchangeid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_transacciones_payment_users1`
    FOREIGN KEY (`userid`)
    REFERENCES `paymentAssistant`.`payment_users` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentAssistant`.`schedules`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentAssistant`.`schedules` (
  `schedulesid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  `recoveryType` BIT(3) NOT NULL,
  `endType` BIT(3) NOT NULL,
  `repetitions` INT(2) NOT NULL,
  `endDate` DATE NULL,
  PRIMARY KEY (`schedulesid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentAssistant`.`scheduleDetails`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentAssistant`.`scheduleDetails` (
  `scheduleDetailsid` INT NOT NULL AUTO_INCREMENT,
  `schedulesid` INT NOT NULL,
  `deleted` BIT(1) NOT NULL,
  `baseDate` DATE NOT NULL,
  `datePart` DATE NOT NULL,
  `lastExecutedDateTime` DATETIME NOT NULL,
  `nextExecutedDateTime` DATETIME NOT NULL,
  PRIMARY KEY (`scheduleDetailsid`),
  INDEX `fk_scheduleDetails_schedules1_idx` (`schedulesid` ASC) VISIBLE,
  CONSTRAINT `fk_scheduleDetails_schedules1`
    FOREIGN KEY (`schedulesid`)
    REFERENCES `paymentAssistant`.`schedules` (`schedulesid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentAssistant`.`subscriptions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentAssistant`.`subscriptions` (
  `subscriptionsid` INT NOT NULL AUTO_INCREMENT,
  `description` VARCHAR(50) NOT NULL,
  `logoURL` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`subscriptionsid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentAssistant`.`planPrices`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentAssistant`.`planPrices` (
  `planPricesid` INT NOT NULL AUTO_INCREMENT,
  `subscriptionsid` INT NOT NULL,
  `monedaid` INT NOT NULL,
  `amount` DECIMAL(3,2) NOT NULL,
  `recurrencyType` BIT(3) NOT NULL,
  `postTime` TIME NOT NULL,
  `endDate` DATE NOT NULL,
  `current` BIT(1) NOT NULL,
  PRIMARY KEY (`planPricesid`),
  INDEX `fk_planPrices_subscriptions1_idx` (`subscriptionsid` ASC) VISIBLE,
  INDEX `fk_planPrices_moneda1_idx` (`monedaid` ASC) VISIBLE,
  CONSTRAINT `fk_planPrices_subscriptions1`
    FOREIGN KEY (`subscriptionsid`)
    REFERENCES `paymentAssistant`.`subscriptions` (`subscriptionsid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_planPrices_moneda1`
    FOREIGN KEY (`monedaid`)
    REFERENCES `paymentAssistant`.`moneda` (`monedaid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentAssistant`.`planFeatures`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentAssistant`.`planFeatures` (
  `planFeaturesid` INT NOT NULL AUTO_INCREMENT,
  `description` VARCHAR(50) NOT NULL,
  `enabled` VARCHAR(45) NOT NULL,
  `dataType` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`planFeaturesid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentAssistant`.`featuresPerPlans`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentAssistant`.`featuresPerPlans` (
  `planFeaturesid` INT NOT NULL,
  `subscriptionsid` INT NOT NULL,
  `value` VARCHAR(45) NOT NULL,
  `enabled` BIT(1) NOT NULL,
  PRIMARY KEY (`planFeaturesid`, `subscriptionsid`),
  INDEX `fk_planFeatures_has_subscriptions_subscriptions1_idx` (`subscriptionsid` ASC) VISIBLE,
  INDEX `fk_planFeatures_has_subscriptions_planFeatures1_idx` (`planFeaturesid` ASC) VISIBLE,
  CONSTRAINT `fk_planFeatures_has_subscriptions_planFeatures1`
    FOREIGN KEY (`planFeaturesid`)
    REFERENCES `paymentAssistant`.`planFeatures` (`planFeaturesid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_planFeatures_has_subscriptions_subscriptions1`
    FOREIGN KEY (`subscriptionsid`)
    REFERENCES `paymentAssistant`.`subscriptions` (`subscriptionsid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentAssistant`.`planPerPerson`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentAssistant`.`planPerPerson` (
  `planPricesid` INT NOT NULL,
  `userid` INT NOT NULL,
  `schedulesid` INT NOT NULL,
  `aquiredDate` DATE NOT NULL,
  `enabled` BIT(1) NOT NULL,
  PRIMARY KEY (`planPricesid`, `userid`),
  INDEX `fk_planPrices_has_payment_users_payment_users1_idx` (`userid` ASC) VISIBLE,
  INDEX `fk_planPrices_has_payment_users_planPrices1_idx` (`planPricesid` ASC) VISIBLE,
  INDEX `fk_planPerPerson_schedules1_idx` (`schedulesid` ASC) VISIBLE,
  CONSTRAINT `fk_planPrices_has_payment_users_planPrices1`
    FOREIGN KEY (`planPricesid`)
    REFERENCES `paymentAssistant`.`planPrices` (`planPricesid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_planPrices_has_payment_users_payment_users1`
    FOREIGN KEY (`userid`)
    REFERENCES `paymentAssistant`.`payment_users` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_planPerPerson_schedules1`
    FOREIGN KEY (`schedulesid`)
    REFERENCES `paymentAssistant`.`schedules` (`schedulesid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentAssistant`.`personPlanLimits`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentAssistant`.`personPlanLimits` (
  `personPlanLimitsid` INT NOT NULL AUTO_INCREMENT,
  `planpricesid` INT NOT NULL,
  `userid` INT NOT NULL,
  `schedulesid` INT NOT NULL,
  `planFeaturesid` INT NOT NULL,
  `limit` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`personPlanLimitsid`),
  INDEX `fk_personPlanLimits_planPerPerson1_idx` (`planpricesid` ASC, `userid` ASC, `schedulesid` ASC) VISIBLE,
  INDEX `fk_personPlanLimits_planFeatures1_idx` (`planFeaturesid` ASC) VISIBLE,
  CONSTRAINT `fk_personPlanLimits_planPerPerson1`
    FOREIGN KEY (`planpricesid` , `userid`)
    REFERENCES `paymentAssistant`.`planPerPerson` (`planPricesid` , `userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_personPlanLimits_planFeatures1`
    FOREIGN KEY (`planFeaturesid`)
    REFERENCES `paymentAssistant`.`planFeatures` (`planFeaturesid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentAssistant`.`logTypes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentAssistant`.`logTypes` (
  `logTypesid` INT NOT NULL,
  `name` VARCHAR(45) NULL,
  `ref1Desc` VARCHAR(50) NULL,
  `ref2Desc` VARCHAR(50) NULL,
  `val1Desc` VARCHAR(50) NULL,
  `val2Desc` VARCHAR(50) NULL,
  PRIMARY KEY (`logTypesid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentAssistant`.`logSources`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentAssistant`.`logSources` (
  `logSourcesid` INT NOT NULL,
  `name` VARCHAR(45) NULL,
  PRIMARY KEY (`logSourcesid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentAssistant`.`logSeverity`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentAssistant`.`logSeverity` (
  `logSeverityid` INT NOT NULL,
  `name` VARCHAR(45) NULL,
  PRIMARY KEY (`logSeverityid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentAssistant`.`logs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentAssistant`.`logs` (
  `logsid` INT NOT NULL,
  `description` VARCHAR(45) NULL,
  `postTime` TIME NULL,
  `computer` VARCHAR(25) NULL,
  `userName` VARCHAR(25) NULL,
  `trace` VARCHAR(45) NULL,
  `referenceID1` BIGINT NULL,
  `referenceID2` BIGINT NULL,
  `value1` VARCHAR(180) NULL,
  `value2` VARCHAR(180) NULL,
  `checkSum` VARBINARY(250) NULL,
  `logTypesid` INT NOT NULL,
  `logSourcesid` INT NOT NULL,
  `logSeverityid` INT NOT NULL,
  PRIMARY KEY (`logsid`),
  INDEX `fk_logs_logTypes1_idx` (`logTypesid` ASC) VISIBLE,
  INDEX `fk_logs_logSources1_idx` (`logSourcesid` ASC) VISIBLE,
  INDEX `fk_logs_logSeverity1_idx` (`logSeverityid` ASC) VISIBLE,
  CONSTRAINT `fk_logs_logTypes1`
    FOREIGN KEY (`logTypesid`)
    REFERENCES `paymentAssistant`.`logTypes` (`logTypesid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_logs_logSources1`
    FOREIGN KEY (`logSourcesid`)
    REFERENCES `paymentAssistant`.`logSources` (`logSourcesid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_logs_logSeverity1`
    FOREIGN KEY (`logSeverityid`)
    REFERENCES `paymentAssistant`.`logSeverity` (`logSeverityid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentAssistant`.`languages`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentAssistant`.`languages` (
  `languagesid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(20) NULL,
  `culture` VARCHAR(5) NULL,
  PRIMARY KEY (`languagesid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentAssistant`.`modules`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentAssistant`.`modules` (
  `modulesid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  PRIMARY KEY (`modulesid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentAssistant`.`translations`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentAssistant`.`translations` (
  `translationsid` INT NOT NULL AUTO_INCREMENT,
  `languagesid` INT NOT NULL,
  `modulesid` INT NOT NULL,
  `code` INT NULL,
  `caption` VARCHAR(50) NULL,
  `enabled` BIT(1) NULL,
  PRIMARY KEY (`translationsid`),
  INDEX `fk_translations_languages1_idx` (`languagesid` ASC) VISIBLE,
  INDEX `fk_translations_modules1_idx` (`modulesid` ASC) VISIBLE,
  CONSTRAINT `fk_translations_languages1`
    FOREIGN KEY (`languagesid`)
    REFERENCES `paymentAssistant`.`languages` (`languagesid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_translations_modules1`
    FOREIGN KEY (`modulesid`)
    REFERENCES `paymentAssistant`.`modules` (`modulesid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentAssistant`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentAssistant`.`user` (
  `username` VARCHAR(16) NOT NULL,
  `email` VARCHAR(255) NULL,
  `password` VARCHAR(32) NOT NULL,
  `create_time` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP);


-- -----------------------------------------------------
-- Table `paymentAssistant`.`timestamps`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentAssistant`.`timestamps` (
  `create_time` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` TIMESTAMP NULL);


-- -----------------------------------------------------
-- Table `paymentAssistant`.`user_1`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentAssistant`.`user_1` (
  `username` VARCHAR(16) NOT NULL,
  `email` VARCHAR(255) NULL,
  `password` VARCHAR(32) NOT NULL,
  `create_time` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP);


-- -----------------------------------------------------
-- Table `paymentAssistant`.`category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentAssistant`.`category` (
  `category_id` INT NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`category_id`));


-- -----------------------------------------------------
-- Table `paymentAssistant`.`category_1`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentAssistant`.`category_1` (
  `category_id` INT NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`category_id`));


-- -----------------------------------------------------
-- Table `paymentAssistant`.`conversation`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentAssistant`.`conversation` (
  `queryid` INT NOT NULL AUTO_INCREMENT,
  `userid` INT NOT NULL,
  `type` VARCHAR(100) NOT NULL COMMENT 'Asumiendo que ya se paso a texto',
  `status` VARCHAR(30) NOT NULL,
  `prompttime` DATETIME NOT NULL,
  `starrating` INT NULL,
  `review` VARCHAR(40) NULL,
  PRIMARY KEY (`queryid`),
  INDEX `fk_query_payment_users1_idx` (`userid` ASC) VISIBLE,
  CONSTRAINT `fk_query_payment_users1`
    FOREIGN KEY (`userid`)
    REFERENCES `paymentAssistant`.`payment_users` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentAssistant`.`interaction`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentAssistant`.`interaction` (
  `interactionid` INT NOT NULL AUTO_INCREMENT,
  `conversationid` INT NOT NULL,
  `audioURL` VARCHAR(100) NOT NULL,
  `transcript` VARCHAR(100) NOT NULL,
  `specificresponse` VARCHAR(100) NOT NULL,
  `requestTime` INT NOT NULL,
  `responseTime` INT NOT NULL,
  `key` VARCHAR(50) NOT NULL,
  `version` VARCHAR(45) NOT NULL,
  `maxToken` INT NOT NULL,
  `returnContent` VARCHAR(50) NOT NULL,
  `error` VARCHAR(45) NULL,
  PRIMARY KEY (`interactionid`),
  INDEX `fk_interaction_query1_idx` (`conversationid` ASC) VISIBLE,
  CONSTRAINT `fk_interaction_query1`
    FOREIGN KEY (`conversationid`)
    REFERENCES `paymentAssistant`.`conversation` (`queryid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentAssistant`.`interactionDataTypes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentAssistant`.`interactionDataTypes` (
  `interactiondatatypeid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`interactiondatatypeid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentAssistant`.`statusType`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentAssistant`.`statusType` (
  `statusTypeid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`statusTypeid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentAssistant`.`dataPerInteraction`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentAssistant`.`dataPerInteraction` (
  `interactiondatatypeid` INT NOT NULL,
  `interactionid` INT NOT NULL,
  `statusTypeid` INT NOT NULL,
  `content` VARCHAR(100) NOT NULL,
  `certainty` DECIMAL(3,2) NOT NULL,
  `checksum` VARCHAR(250) NOT NULL,
  `generalresponse` VARCHAR(45) NULL,
  INDEX `fk_interactionDataTypes_has_interaction_interaction1_idx` (`interactionid` ASC) VISIBLE,
  INDEX `fk_interactionDataTypes_has_interaction_interactionDataType_idx` (`interactiondatatypeid` ASC) VISIBLE,
  INDEX `fk_dataPerInteraction_statusType1_idx` (`statusTypeid` ASC) VISIBLE,
  CONSTRAINT `fk_interactionDataTypes_has_interaction_interactionDataTypes1`
    FOREIGN KEY (`interactiondatatypeid`)
    REFERENCES `paymentAssistant`.`interactionDataTypes` (`interactiondatatypeid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_interactionDataTypes_has_interaction_interaction1`
    FOREIGN KEY (`interactionid`)
    REFERENCES `paymentAssistant`.`interaction` (`interactionid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_dataPerInteraction_statusType1`
    FOREIGN KEY (`statusTypeid`)
    REFERENCES `paymentAssistant`.`statusType` (`statusTypeid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


```
</details>

<details>
<summary>
	Llenado de Datos
</summary>

<br>

```sql

use paymentAssistant;

DROP TEMPORARY TABLE IF EXISTS tempNames;
CREATE TEMPORARY TABLE tempNames (indivName varchar(30));
INSERT INTO tempNames
VALUES ("Carlos"), ("María"), ("José"), ("Ana"), ("Juan"), ("Gabriela"), ("Luis"), ("Fernanda"), ("Miguel"), ("Valeria"),
("Antonio"), ("Camila"), ("Fernando"), ("Daniela"), ("Javier"), ("Lucía"), ("Ricardo"), ("Sofía"), ("Andrés"), ("Isabela"),
("Manuel"), ("Carla"), ("Hugo"), ("Elena"), ("Emilio"), ("Paula"), ("Raúl"), ("Beatriz"), ("Diego"), ("Patricia"),
("Santiago"), ("Adriana"), ("Ángel"), ("Rocío"), ("Martín"), ("Verónica"), ("Pablo"), ("Cecilia"), ("Héctor"), ("Lorena"),
("Esteban"), ("Clara"), ("Rubén"), ("Alejandra"), ("Sebastián"), ("Mónica"), ("Gustavo"), ("Julieta"), ("Ramón"), ("Ximena");

DROP TEMPORARY TABLE IF EXISTS tempLastNames;
CREATE TEMPORARY TABLE tempLastNames (indivName varchar(35));
INSERT INTO tempLastNames (indivName)
VALUES ("García"), ("Martínez"), ("Rodríguez"), ("López"), ("González"), ("Pérez"), ("Hernández"), ("Sánchez"), ("Ramírez"), ("Torres"),
("Flores"), ("Rivera"), ("Gómez"), ("Díaz"), ("Mendoza"), ("Vargas"), ("Castillo"), ("Ortega"), ("Silva"), ("Guerrero"),
("Rojas"), ("Cruz"), ("Delgado"), ("Morales"), ("Reyes"), ("Fuentes"), ("Jiménez"), ("Navarro"), ("Paredes"), ("Suárez"),
("Villanueva"), ("Mejía"), ("Cabrera"), ("Cárdenas"), ("Salazar"), ("Valenzuela"), ("Ramos"), ("Álvarez"), ("Medina"), ("Aguilar"),
("Pacheco"), ("Bermúdez"), ("Zamora"), ("Esquivel"), ("Campos"), ("Montoya"), ("Peralta"), ("Peña"), ("Ibarra"), ("Miranda");

DROP TEMPORARY TABLE IF EXISTS tempCont;
CREATE TEMPORARY TABLE tempCont (indivName varchar(45));
INSERT INTO tempCont (indivName)
VALUES ("Argentina"), ("Bolivia"), ("Brazil"), ("Chile"), ("Colombia"), ("Costa Rica"), ("Cuba"), ("Dominican Republic"), ("Ecuador"), ("El Salvador"),
("Guatemala"), ("Honduras"), ("Mexico"), ("Nicaragua"), ("Panama"), ("Paraguay"), ("Peru"), ("Puerto Rico"), ("Uruguay"), ("Venezuela"),
("Spain"), ("Portugal"), ("France"), ("Italy"), ("Germany"), ("Canada"), ("United States"), ("United Kingdom"), ("Australia"), ("New Zealand"),
("China"), ("Japan"), ("South Korea"), ("India"), ("Russia"), ("South Africa"), ("Egypt"), ("Morocco"), ("Nigeria"), ("Kenya"),
("Thailand"), ("Vietnam"), ("Philippines"), ("Indonesia"), ("Malaysia"), ("Turkey"), ("Greece"), ("Sweden"), ("Norway"), ("Finland");

DROP PROCEDURE IF EXISTS LlenarDeUsers;
DELIMITER //

CREATE PROCEDURE LlenarDeUsers()
BEGIN
	set @countUsers = 30;
	while @countUsers > 0 do

		set @tempNameHolder = "This_is_temporary_va";
        set @tempLastNameHolder = "This_is_temporary_va";
		set @tempContHolder = "This_is_temporary_va";
        
		select indivName from tempNames
		order by RAND()
		limit 1 into @tempNameHolder;
    
		select indivName from tempLastNames
		order by RAND()
		limit 1 into @tempLastNameHolder;
        
        select indivName from tempCont
		order by RAND()
		limit 1 into @tempContHolder;
    
		insert into paymentAssistant.payment_users (firstName, lastName, email, country)
        values (@tempNameHolder, 
        @tempLastNameHolder, 
        concat(@tempNameHolder, floor(RAND()*999), "@gmail.com"), 
        @tempContHolder);
    
		set @countUsers = @countUsers - 1;
    
    end while;

END //

call LlenarDeUsers;
select * from payment_users;

insert into moneda (name, acronym)
values ("Costa Rican Colón", "CRC"), ("US Dollar", "USD"), ("Euro", "EUR"), ("British Pound", "GBP"), ("Japanese Yen", "JPY"),
("Mexican Peso", "MXN"), ("Brazilian Real", "BRL"), ("Argentine Peso", "ARS"), ("Canadian Dollar", "CAD"), ("Swiss Franc", "CHF");
select * from moneda;

insert into exchange (monedaid, startDate, endDate, exchangeRate, enabled, currentExchangeRate)
values (1, CURDATE(), DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND() * 30) DAY), 1, 1, 1),
(2, CURDATE(), DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND() * 30) DAY), 0.002, 1, 1),
(3, CURDATE(), DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND() * 30) DAY), 0.0018, 1, 1),
(4, CURDATE(), DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND() * 30) DAY), 0.0015, 1, 1),
(5, CURDATE(), DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND() * 30) DAY), 0.3, 1, 1),
(6, CURDATE(), DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND() * 30) DAY), 0.04, 1, 1),
(7, CURDATE(), DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND() * 30) DAY), 0.0114, 1, 1),
(8, CURDATE(), DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND() * 30) DAY), 2.14, 1, 1),
(9, CURDATE(), DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND() * 30) DAY), 0.00287, 1, 1),
(10, CURDATE(), DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND() * 30) DAY), 0.0018, 1, 1);

select * from exchange;

insert into metodoDePago (name, ApiURL, secretKey, metodoDePago.key, logoIconVal, enabled)
values ('Stripe', 'https://api.stripe.com/v1/charges/', SHA2(RAND(), 224), SHA2(RAND(), 224), null, 1),
('Authorize.net', 'https://www.sandbox.paypal.com', SHA2(RAND(), 224), SHA2(RAND(), 224), null, 1),
('PayPal', 'https://api-m.sandbox.paypal.com', SHA2(RAND(), 224), SHA2(RAND(), 224), null, 1),
('Adyen', 'https://checkout-test.adyen.com/', SHA2(RAND(), 224), SHA2(RAND(), 224), null, 1),
('Braintree', 'https://payments.braintree-api.com', SHA2(RAND(), 224), SHA2(RAND(), 224), null, 1);

select * from metodoDePago;

DROP PROCEDURE IF EXISTS LlenarDeMediosDisponibles;
DELIMITER //

CREATE PROCEDURE LlenarDeMediosDisponibles()
BEGIN

	set @countUsers = NULL;
    set @countMedios = NULL; 
    
	select count(*) from payment_users into @countUsers;
    select count(*) from metodoDePago into @countMedios;
    
	while @countUsers > 0 do
    
		set @methodNumber = FLOOR(RAND()*2) + 1;
        
        set @username = NULL;
		select firstName from payment_users where userid = @countUsers into @username;
        
        while @methodNumber > 0 do
            
            set @tempToken = NULL;
            select SHA2(RAND(), 224) into @tempToken;
            
            insert into mediosDisponibles (MetodoDePagoid, userid, name, token, expTokenDate, maskAccount)
			values (FLOOR(RAND() * @countMedios)+1, 
            @countUsers, 
            concat(@username, FLOOR(RAND()*99)), 
            @tempToken, 
            DATE_ADD(CURDATE(), 
            INTERVAL FLOOR(RAND()*31)+1 DAY), 
            lpad(right(@tempToken, 5), char_length(@tempToken) - 5, '*'));
            
			set @methodNumber = @methodNumber - 1;
			end while;
            
		set @countUsers = @countUsers - 1;
    end while;

END //

call LlenarDeMediosDisponibles;
select * from mediosDisponibles

insert into transTypes (name)
values ("Credit"), ("Debit"), ("BitCoin"), ("Bank Transfer"), ("Digital Wallet"), ("SIMPE");

select * from transTypes;

DROP PROCEDURE IF EXISTS LlenarDePagos;
DELIMITER //

CREATE PROCEDURE LlenarDePagos()
BEGIN

	set @countUsers = NULL;
    
	select count(*) from payment_users into @countUsers;
    
	while @countUsers > 0 do
    
		set @payNumber = FLOOR(RAND()*3);
        
        while @payNumber > 0 do
            
            set @metodoTemp = NULL;
            set @medioTemp = NULL;
            set @montoTemp = FLOOR(RAND()*1000000) + 1;
			select metodoDePagoid, mediosDisponiblesid from mediosDisponibles where mediosDisponibles.userid = @countUsers order by RAND() limit 1 into @metodoTemp, @medioTemp;
        
            insert into pagos (metodoDePagoid, mediosDisponiblesid, userid, monedaid, monto, actualMonto, payDateTime,
			auth, pagos.reference, chargeToken, pagos.description, error, pagos.checkSum)
            values (@metodoTemp, @medioTemp, @countUsers, 1, @montoTemp, @montoTemp, 
            DATE_ADD(NOW(), INTERVAL FLOOR(RAND()*720) HOUR),
            SHA2(RAND(), 224), FLOOR(RAND()*9999999999) + 1, LEFT(UUID(), 6), null, null, FLOOR(RAND()*99999999));
            
			set @payNumber = @payNumber - 1;
			end while;
            
		set @countUsers = @countUsers - 1;
        
    end while;

END //

call LlenarDePagos;
select * from pagos

DROP PROCEDURE IF EXISTS LlenarDeTrans;
DELIMITER //

CREATE PROCEDURE LlenarDeTrans()
BEGIN

	set @countPagos = NULL;
    set @transTypesTemp = NULL;
    
	select count(*) from pagos into @countPagos;
    select count(*) from transTypes into @transTypesTemp;
    
	while @countPagos > 0 do
    
		set @payNumber = FLOOR(RAND()*2);
        
        while @payNumber > 0 do
            
            set @pagosidtemp = NULL;
            set @useridtemp = NULL;
            set @montotemp = NULL;
            set @dateTimeTemp = NULL;
            
            select DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 360) + 1 HOUR) into @dateTimeTemp;
			select pagosid, userid, monto from pagos where pagos.pagosid = @countPagos 
            limit 1 into @pagosidtemp, @useridtemp, @montotemp;
        
            insert into transacciones (pagosid, transTypesid, monedaid, exchangeid, userid, amount, 
            transacciones.description, transDateTime, postTime, refNumber, transacciones.checkSum)
            values (@pagosidtemp, FLOOR(RAND() * @transTypesTemp) + 1, 1, 1, @useridtemp, @montotemp, 
            'pago', @dateTimeTemp, @dateTimeTemp, 
            FLOOR(RAND()*99999999), FLOOR(RAND()*99999999));
            
			set @payNumber = @payNumber - 1;
			end while;
            
		set @countPagos = @countPagos - 1;
        
    end while;

END //

call LlenarDeTrans;
select * from transacciones

DROP TEMPORARY TABLE IF EXISTS tempRequests;
CREATE TEMPORARY TABLE tempRequests (indivName varchar(30));
INSERT INTO tempRequests
VALUES ("Create new payment method"), ("Create new monthly payment"), ("Change personal information"), 
("Check current contact info"), ("Upgrade my plan");

DROP PROCEDURE IF EXISTS LlenarDeConv;
DELIMITER //

CREATE PROCEDURE LlenarDeConv()
BEGIN

	set @countUsers = NULL;
    
	select count(*) from payment_users into @countUsers;
    
	while @countUsers > 0 do
    
		set @convNumber = FLOOR(RAND()*2) + 1;
        
        while @convNumber > 0 do
        
			set @convTypeTemp = NULL;
            set @score = FLOOR(RAND() * 6);
            select indivName from tempRequests
			order by RAND()
			limit 1 into @convTypeTemp;
            
            insert into conversation (userid, conversation.type, conversation.status, prompttime, starrating, review)
            values (@countUsers, @convTypeTemp, 'Finished', DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 360) HOUR), 
            @score, IF(@score >= 4, 'The assistant was very helpful', 'I found the help lacking'));
            
			set @convNumber = @convNumber - 1;
			end while;
            
		set @countUsers = @countUsers - 1;
        
    end while;

END //

call LlenarDeConv;
select * from conversation

insert into statusType (statusType.name)
values ("New Entry"), ("Changed Entry"), ("Deleted Entry");

insert into interactionDataTypes (interactionDataTypes.name)
values ("Phone Number"), ("Email"), ("Account Name"), ("Transaction"), ("User alias"), ("Date & Time")

DROP PROCEDURE IF EXISTS LlenarDeInter;
DELIMITER //

CREATE PROCEDURE LlenarDeInter()
BEGIN

	set @countConv = NULL;
    
	select count(*) from payment_users into @countConv;
    
	while @countConv > 0 do
    
		set @convNumber = FLOOR(RAND()*3) + 1;
        
        while @convNumber > 0 do
            
            insert into interaction (conversationid, audioURL, transcript, specificresponse, requestTime, responseTime,
            interaction.key, interaction.version, maxToken, returnContent, interaction.error)
            values (@countConv, concat('https://www.', LEFT(UUID(), 20), '.com'), 'User Input', 
            'Hello, how may I help today?', FLOOR(RAND()*5) + 1, FLOOR(RAND()*5) + 1, LEFT(UUID(), 20), 
            '2025-03-11', 1024, 'Full AI Response', null);
            
			set @convNumber = @convNumber - 1;
			end while;
            
		set @countConv = @countConv - 1;
        
    end while;

END //

call LlenarDeInter;
select * from interaction

DROP PROCEDURE IF EXISTS LlenarDeDPInter;
DELIMITER //

CREATE PROCEDURE LlenarDeDPInter()
BEGIN

	set @countInter = NULL;
    set @datypeMaxTemp = NULL;
    set @interTemp = NULL;
            
	select count(*) from interaction into @countInter;
    select count(*) from interactionDataTypes into @datypeMaxTemp;
    select count(*) from statusType into @interTemp;
    
	while @countInter > 0 do
    
		
		set @interNumber = FLOOR(RAND()*3);
        
        while @interNumber > 0 do
            
			set @datypeTemp = FLOOR(RAND() * @datypeMaxTemp) + 1;
            
            set @contentTemp = NULL;
            
            select case
				when @datypeTemp = 1 then FLOOR(RAND()*99999999)
                when @datypeTemp = 2 then concat(left(SHA2(RAND(), 224), 15), "@gmail.com")
                when @datypeTemp = 3 then left(SHA2(RAND(), 224), 20)
                when @datypeTemp = 4 then FLOOR(RAND()*99999999)
                when @datypeTemp = 5 then 'Honey'
                else DATE_ADD(NOW(), INTERVAL FLOOR(RAND() * 720) HOUR)
			end
            into @contentTemp;
            
            insert into dataPerInteraction (interactiondatatypeid, interactionid, statustypeid, 
            content, certainty, dataPerInteraction.checksum, generalresponse)
            values (@datypeTemp, @countInter, FLOOR(RAND() * @interTemp) + 1, 
            @contentTemp, ROUND(RAND(), 2), FLOOR(RAND()*99999999), 'Here is what I think about this information');
            
			set @interNumber = @interNumber - 1;
			end while;
        
		set @countInter = @countInter - 1;
        
    end while;

END //

call LlenarDeDPInter;
select * from dataPerInteraction

alter table planFeatures auto_increment = 1;
insert into planFeatures (description, enabled, dataType)
values ("10 pagos al mes", "enabled", "Varchar"),
("15 pagos al mes", "enabled", "INT"),
("20+ pagos al mes", "enabled", "Varchar");

select * from planFeatures;


```
</details>

[//]: <> (--------------------------------------------------------------CONSULTA 1--------------------------------------------------------------)

### Consultas

<details>
<summary>
	Consulta 4.1
</summary>

<br>

```sql
INSERT
```
</details>

[//]: <> (----------------------------------------------------CONSULTA 2-------------------------------------------------------------------------)

<details>
<summary>
	Consulta 4.2
</summary>

<br>

```sql
INSERT
```
</details>


[//]: <> (-----------------------------------------------------------CONSULTA 3----------------------------------------------------------)


<details>
<summary>
	Consulta 4.3
</summary>

<br>

```sql
INSERT
```
</details>


[//]: <> (-------------------------------------------------------CONSULTA 4-------------------------------------------------------------)


<details>
<summary>
	Consulta 4.4
</summary>

<br>

```sql
INSERT
```
</details>

[//]: <> (-----------------------------------------------ESTUDIANTES-----------------------------------------------------)

### Estudiantes
- Victor Andrés Fung Chiong
- Giovanni Esquivel Cortés
  
 ### IC 4301 - Bases de Datos I
