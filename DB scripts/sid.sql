-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 21, 2019 at 10:22 PM
-- Server version: 10.1.38-MariaDB
-- PHP Version: 7.3.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
create database sid2019;
use sid2019;
--
-- Database: `sid`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `altera_cultura` (IN `id` INT, IN `des` TEXT)  NO SQL
    SQL SECURITY INVOKER
BEGIN
if id in(select idcultura from cultura
 where current_user()=cultura.username) then
update cultura
set cultura.descricaocultura=des
 where cultura.idcultura=id;
end if;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `apaga_cultura` (IN `id` INT)  NO SQL
    SQL SECURITY INVOKER
BEGIN
if id in(select idcultura from cultura
 where current_user()=cultura.username) then
delete from cultura
where cultura.idcultura=id;
end if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `apaga_medicao` (IN `idcultura` INT, IN `id` INT)  NO SQL
    SQL SECURITY INVOKER
BEGIN
if idcultura in(select idcultura from cultura
 where current_user()=cultura.username) then
delete from medicao
where id=medicao.numeromedicao;
end if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `apaga_utilizador` (IN `nomeutilizador` VARCHAR(100))  NO SQL
BEGIN
 drop user if exists nomeutilizador;
 delete from utilizador
	where nomeutilizador=utilizador.username;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `apaga_variavel_medida` (IN `idvariavel` INT, IN `idcultura` INT)  NO SQL
    SQL SECURITY INVOKER
begin 
	if idcultura in (select idcultura from cultura where current_user()=username) THEN
    delete from variaveis_medidas WHERE
    idvariavel=variavel_idvariavel and idcultura=cultura_idcultura;
    end if;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cria_cultura` (IN `nome` VARCHAR(100), IN `descricao` TEXT)  NO SQL
    SQL SECURITY INVOKER
BEGIN
insert into cultura
values(null,nome,descricao,current_user());
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cria_utilizador` (IN `Email` VARCHAR(50), IN `Nome` VARCHAR(100), IN `CProf` VARCHAR(300), IN `p_Name` VARCHAR(100), IN `p_Passw` VARCHAR(100))  NO SQL
BEGIN
	SET @_HOST2 = "@localhost";
    SET @_HOST = "@'localhost'";
    SET @name = CONCAT('''', REPLACE(TRIM(p_Name), CHAR(39), CONCAT(CHAR(92), CHAR(39))), '''');
    SET @name2 = TRIM(p_Name);
    SET @pass = CONCAT('''', REPLACE(TRIM(p_Passw), CHAR(39), CONCAT(CHAR(92), CHAR(39))), '''');
    SET @sql = CONCAT('CREATE USER ', @name, @_HOST, ' IDENTIFIED BY ', @pass);
    
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
 
    DEALLOCATE PREPARE stmt;
    FLUSH PRIVILEGES;
       
SET @sql2 = CONCAT('GRANT ALL PRIVILEGES ON * . * TO ',@name,@_HOST);
    PREPARE stmt FROM @sql2;
    EXECUTE stmt;
 
    DEALLOCATE PREPARE stmt;
    FLUSH PRIVILEGES;

    INSERT INTO utilizador VALUES(Email, Nome, CProf, CONCAT(@name2, @_HOST2));
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cria_variaveis_medidas` (IN `culturaid` INT, IN `variavelid` INT, IN `limiteS` DECIMAL(8,2), IN `limiteI` DECIMAL(8,2), IN `margem` INT)  NO SQL
    SQL SECURITY INVOKER
begin
	if culturaid in (SELECT idcultura from cultura where current_user()=username) THEN
    INSERT into variaveis_medidas values (limiteI,limiteS,variavelid,culturaid,margem);
    end if;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getAlertasCultura` (IN `id` INT, IN `tim` TIMESTAMP)  NO SQL
    SQL SECURITY INVOKER
begin
	if id in (SELECT idCultura from cultura WHERE CURRENT_USER()=username) THEN 
	select * from alertavariavel
    WHERE cultura=id and tim=day(datahora);
    end if;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getAlertasGlobais` (IN `tim` DATE)  NO SQL
begin
	select * from alerta
    where day(datahora)=tim;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getInformacaoCultura` (IN `id` INT)  NO SQL
    SQL SECURITY INVOKER
BEGIN
	select NomeCultura,DescricaoCultura from cultura 
    WHERE idCultura=id and username=CURRENT_USER();
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getMedicoesLuminosidade` ()  NO SQL
begin
select * from medicoes_luminosidade where datahoramedicao > date_sub(now(), interval 5 minute);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getMedicoesTemperatura` ()  NO SQL
begin
	select datahoramedicao,valormedicaotemperatura from medicoes_temperatura where datahoramedicao > date_sub(now(), interval 5 minute);
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insere_medicao` (IN `valor` DECIMAL(8,2), IN `idCultura` INT, IN `idVariavel` INT)  NO SQL
    SQL SECURITY INVOKER
BEGIN

	IF idcultura IN (SELECT idcultura FROM cultura
	WHERE current_user() = cultura.username) 
    THEN
	INSERT INTO medicao
	VALUES (null, now(), valor, idCultura, idVariavel);
	END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `select_culturas` ()  NO SQL
    SQL SECURITY INVOKER
BEGIN
select * from cultura
 where current_user()=cultura.username;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `select_cv_disponiveis` ()  NO SQL
BEGIN

	SELECT idcultura, nomecultura, idvariavel, nomevariavel
    FROM cultura, variavel
    WHERE username = CURRENT_USER()
    AND NOT EXISTS
    (SELECT * FROM variaveis_medidas
    WHERE Variavel_IDVariavel = idvariavel
    AND Cultura_IDCultura = idcultura);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `select_limites` ()  NO SQL
    SQL SECURITY INVOKER
BEGIN

	SELECT limiteinferior, limitesuperior, variavel_idvariavel, cultura_idcultura, margem, nomevariavel, nomecultura FROM variaveis_medidas, cultura, variavel
    WHERE cultura_idcultura = IDcultura
    AND username = CURRENT_USER()
    AND variavel_idvariavel = idvariavel;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `select_medicoes` ()  NO SQL
    SQL SECURITY INVOKER
BEGIN

SELECT NumeroMedicao, datahoramedicao, valormedicao, VariaveisMedidas_IDCultura,VariaveisMedidas_IDVariavel, nomevariavel, nomecultura 
FROM medicao, cultura, variavel
WHERE VariaveisMedidas_IDCultura = IDcultura
AND VariaveisMedidas_IDVariavel = idvariavel
AND username = CURRENT_USER();

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `select_v_disponiveis` (IN `cultura` INT)  NO SQL
BEGIN

	SELECT idvariavel, nomevariavel
    FROM variavel
    WHERE NOT EXISTS 
    (SELECT * FROM variaveis_medidas
    WHERE cultura_idcultura = cultura
    AND variavel_idvariavel = idvariavel);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `test` ()  NO SQL
BEGIN

	SET @interval = (SELECT alertaintervalo FROM sistema);
    
	SELECT * FROM alerta, sistema
	WHERE alerta.valor <= sistema.MargemAlertaLuz
	AND alerta.valor >= sistema.MargemAlertaLuz
	AND alerta.datahora BETWEEN NOW() - INTERVAL @interval SECOND AND NOW();

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `alerta`
--

CREATE TABLE `alerta` (
  `id` int(11) NOT NULL,
  `tipo` varchar(45) NOT NULL,
  `datahora` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `valor` decimal(8,2) NOT NULL,
  `limiteInferior` decimal(8,2) NOT NULL,
  `limiteSuperior` decimal(8,2) NOT NULL,
  `Descricao` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `alerta`
--

INSERT INTO `alerta` (`id`, `tipo`, `datahora`, `valor`, `limiteInferior`, `limiteSuperior`, `Descricao`) VALUES
(1, 'luz', '2019-05-14 15:01:31', '23.00', '1.00', '10.00', 'maior'),
(2, 'luz', '2019-05-17 16:05:37', '0.00', '1200.00', '3500.00', 'valor abaixo do limite'),
(3, 'luz', '2019-05-17 16:05:43', '0.00', '1200.00', '3500.00', 'valor abaixo do limite'),
(4, 'luz', '2019-05-17 16:05:51', '0.00', '1200.00', '3500.00', 'valor abaixo do limite'),
(5, 'luz', '2019-05-17 16:05:57', '0.00', '1200.00', '3500.00', 'valor abaixo do limite'),
(6, 'luz', '2019-05-17 16:06:03', '0.00', '1200.00', '3500.00', 'valor abaixo do limite'),
(7, 'luz', '2019-05-17 16:06:10', '0.00', '1200.00', '3500.00', 'valor abaixo do limite'),
(8, 'luz', '2019-05-17 16:06:16', '0.00', '1200.00', '3500.00', 'valor abaixo do limite'),
(9, 'luz', '2019-05-17 16:06:22', '0.00', '1200.00', '3500.00', 'valor abaixo do limite'),
(10, 'luz', '2019-05-17 16:06:30', '0.00', '1200.00', '3500.00', 'valor abaixo do limite'),
(11, 'luz', '2019-05-17 16:06:36', '0.00', '1200.00', '3500.00', 'valor abaixo do limite'),
(12, 'luz', '2019-05-17 16:06:42', '0.00', '1200.00', '3500.00', 'valor abaixo do limite'),
(13, 'luz', '2019-05-17 16:06:48', '0.00', '1200.00', '3500.00', 'valor abaixo do limite'),
(14, 'luz', '2019-05-17 16:06:55', '0.00', '1200.00', '3500.00', 'valor abaixo do limite'),
(15, 'luz', '2019-05-17 16:07:03', '0.00', '1200.00', '3500.00', 'valor abaixo do limite'),
(16, 'luz', '2019-05-17 16:07:09', '0.00', '1200.00', '3500.00', 'valor abaixo do limite'),
(17, 'luz', '2019-05-17 16:07:15', '0.00', '1200.00', '3500.00', 'valor abaixo do limite'),
(18, 'luz', '2019-05-17 16:07:21', '0.00', '1200.00', '3500.00', 'valor abaixo do limite'),
(19, 'luz', '2019-05-17 16:07:27', '0.00', '1200.00', '3500.00', 'valor abaixo do limite'),
(20, 'luz', '2019-05-17 16:07:48', '0.00', '1200.00', '3500.00', 'valor abaixo do limite'),
(21, 'luz', '2019-05-17 16:07:48', '0.00', '1200.00', '3500.00', 'valor abaixo do limite'),
(22, 'luz', '2019-05-17 16:07:50', '0.00', '1200.00', '3500.00', 'valor abaixo do limite'),
(23, 'luz', '2019-05-17 16:07:56', '0.00', '1200.00', '3500.00', 'valor abaixo do limite'),
(24, 'luz', '2019-05-17 16:08:04', '0.00', '1200.00', '3500.00', 'valor abaixo do limite'),
(25, 'luz', '2019-05-17 16:08:10', '0.00', '1200.00', '3500.00', 'valor abaixo do limite'),
(26, 'luz', '2019-05-17 16:10:21', '0.00', '1200.00', '3500.00', 'valor abaixo do limite'),
(27, 'luz', '2019-05-17 16:10:28', '0.00', '1200.00', '3500.00', 'valor abaixo do limite'),
(28, 'luz', '2019-05-17 16:10:34', '0.00', '1200.00', '3500.00', 'valor abaixo do limite'),
(29, 'luz', '2019-05-17 16:10:40', '0.00', '1200.00', '3500.00', 'valor abaixo do limite'),
(30, 'luz', '2019-05-17 16:10:46', '0.00', '1200.00', '3500.00', 'valor abaixo do limite'),
(31, 'luz', '2019-05-17 16:10:54', '0.00', '1200.00', '3500.00', 'valor abaixo do limite'),
(32, 'luz', '2019-05-17 16:11:01', '0.00', '1200.00', '3500.00', 'valor abaixo do limite'),
(33, 'luz', '2019-05-17 16:11:07', '0.00', '1200.00', '3500.00', 'valor abaixo do limite'),
(34, 'luz', '2019-05-17 16:11:13', '0.00', '1200.00', '3500.00', 'valor abaixo do limite'),
(35, 'luz', '2019-05-17 16:11:19', '0.00', '1200.00', '3500.00', 'valor abaixo do limite'),
(36, 'luz', '2019-05-19 19:16:51', '100.00', '1200.00', '3500.00', 'valor abaixo do limite'),
(37, 'luz', '2019-05-19 19:17:05', '1100.00', '1200.00', '3500.00', 'valor abaixo do limite'),
(38, 'luz', '2019-05-19 19:17:06', '1090.00', '1200.00', '3500.00', 'valor abaixo do limite'),
(39, 'luz', '2019-05-19 19:17:49', '1100.00', '1200.00', '3500.00', 'valor abaixo do limite'),
(40, 'luz', '2019-05-19 19:17:49', '1090.00', '1200.00', '3500.00', 'valor abaixo do limite'),
(41, 'luz', '2019-05-19 19:19:39', '3600.00', '1200.00', '3500.00', 'valor acima do limite'),
(42, 'luz', '2019-05-19 19:19:40', '3550.00', '1200.00', '3500.00', 'valor acima do limite'),
(43, 'luz', '2019-05-19 19:22:26', '3600.00', '1200.00', '3500.00', 'valor acima do limite'),
(44, 'luz', '2019-05-19 19:22:27', '3550.00', '1200.00', '3500.00', 'valor acima do limite'),
(45, 'luz', '2019-05-19 19:23:18', '3600.00', '1200.00', '3500.00', 'valor acima do limite'),
(46, 'luz', '2019-05-19 19:23:18', '3550.00', '1200.00', '3500.00', 'valor acima do limite'),
(47, 'luz', '2019-05-19 19:26:06', '3625.00', '1200.00', '3500.00', 'valor acima do limite'),
(48, 'luz', '2019-05-19 19:26:07', '3650.00', '1200.00', '3500.00', 'valor acima do limite'),
(49, 'luz', '2019-05-19 19:31:49', '3625.00', '1200.00', '3500.00', 'valor acima do limite'),
(50, 'luz', '2019-05-19 19:31:49', '3650.00', '1200.00', '3500.00', 'valor acima do limite'),
(51, 'luz', '2019-05-19 20:54:33', '3600.00', '1200.00', '3500.00', 'valor acima do limite'),
(52, 'luz', '2019-05-19 20:55:03', '3600.00', '1200.00', '3500.00', 'valor acima do limite'),
(53, 'luz', '2019-05-19 20:54:33', '3650.00', '1200.00', '3500.00', 'valor acima do limite');

-- --------------------------------------------------------

--
-- Table structure for table `alertavariavel`
--

CREATE TABLE `alertavariavel` (
  `id` int(11) NOT NULL,
  `datahora` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `variavel` int(11) NOT NULL,
  `cultura` int(11) NOT NULL,
  `valor` decimal(8,2) NOT NULL,
  `limiteInferior` decimal(8,2) NOT NULL,
  `limiteSuperior` decimal(8,2) NOT NULL,
  `Descricao` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `alertavariavel`
--

INSERT INTO `alertavariavel` (`id`, `datahora`, `variavel`, `cultura`, `valor`, `limiteInferior`, `limiteSuperior`, `Descricao`) VALUES
(0, '2019-05-14 15:22:12', 7, 12, '23.00', '123.00', '123.00', 'descricao'),
(1, '2019-05-14 23:00:00', 7, 12, '2600.00', '9.60', '2400.00', 'descricao'),
(2, '2019-05-14 23:00:00', 7, 12, '2600.00', '9.60', '2400.00', 'descricao'),
(3, '2019-05-14 23:00:00', 7, 12, '2600.00', '-385.60', '2397.60', 'descricao'),
(4, '2019-05-15 16:34:27', 7, 12, '2600.00', '12.00', '2000.00', 'descricao'),
(5, '2019-05-17 13:18:03', 9, 20, '30.00', '10.00', '20.00', 'descricao'),
(6, '2019-05-17 13:22:11', 9, 20, '30.00', '10.00', '20.00', 'valor acima do limite'),
(7, '2019-05-17 13:22:26', 9, 20, '1.00', '10.00', '20.00', 'valor abaixo do limite'),
(8, '2019-05-17 13:54:24', 8, 21, '1.00', '4.00', '7.00', 'valor abaixo do limite'),
(9, '2019-05-17 14:01:52', 12, 22, '4.00', '1.00', '2.00', 'valor acima do limite'),
(10, '2019-05-17 14:07:52', 14, 23, '1.00', '5.00', '10.00', 'valor abaixo do limite'),
(11, '2019-05-17 14:08:27', 15, 23, '1.00', '0.00', '0.00', 'valor acima do limite'),
(12, '2019-05-17 14:09:37', 15, 23, '3.00', '0.00', '0.00', 'valor acima do limite'),
(13, '2019-05-17 14:30:00', 16, 24, '20.00', '15.00', '10.00', 'valor acima do limite'),
(14, '2019-05-17 14:30:50', 16, 24, '20.00', '10.00', '15.00', 'valor acima do limite');

-- --------------------------------------------------------

--
-- Table structure for table `cultura`
--

CREATE TABLE `cultura` (
  `IDcultura` int(11) NOT NULL,
  `NomeCultura` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `DescricaoCultura` text COLLATE utf8_bin,
  `username` varchar(100) COLLATE utf8_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `cultura`
--

INSERT INTO `cultura` (`IDcultura`, `NomeCultura`, `DescricaoCultura`, `username`) VALUES
(12, 'cultura1', 'descricao1', 'root@localhost'),
(13, 'cultura2', 'descricao2', 'root@localhost'),
(14, 'cultura3', 'descricao3', 'abcd@localhost'),
(15, 'cultura4', 'descricao4', 'xyz@localhost'),
(16, 'cultura5', 'descricao5', 'abcd@localhost'),
(17, 'cultura6', 'descricao6', 'xyz@localhost'),
(18, 'Tomates', 'De inverno', 'utilizador_a@localhost'),
(19, 'Batatas', 'De verão', 'abcdef@localhost'),
(20, 'Cebolas', 'De primavera', 'abcdef@localhost'),
(21, 'Arruda', 'arruda', 'toze@localhost'),
(22, 'weed', 'sativa', 'socio@localhost'),
(23, 'lean', 'no meu copo', 'sippin@localhost'),
(24, 'Cenouras', 'Verdes', 'user@localhost');

--
-- Triggers `cultura`
--
DELIMITER $$
CREATE TRIGGER `cultura_AFTER_DELETE` AFTER DELETE ON `cultura` FOR EACH ROW BEGIN

INSERT INTO cultura_log VALUES(NULL, 1, NOW(), 'D', current_user(), OLD.idcultura, OLD.nomecultura, OLD.descricaocultura, OLD.username);

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `cultura_AFTER_INSERT` AFTER INSERT ON `cultura` FOR EACH ROW BEGIN

INSERT INTO cultura_log VALUES(NULL, 1, NOW(), 'I', current_user(), NEW.idcultura, NEW.nomecultura, NEW.descricaocultura, NEW.username);

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `cultura_AFTER_UPDATE` AFTER UPDATE ON `cultura` FOR EACH ROW BEGIN

INSERT INTO cultura_log VALUES(NULL, 1, NOW(), 'U', current_user(), OLD.idcultura, OLD.nomecultura, OLD.descricaocultura, OLD.username);

INSERT INTO cultura_log VALUES(NULL, 2, NOW(), 'U', current_user(), NEW.idcultura, NEW.nomecultura, NEW.descricaocultura, NEW.username);

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `cultura_log`
--

CREATE TABLE `cultura_log` (
  `id` int(11) NOT NULL,
  `precedencia` int(11) NOT NULL,
  `datahora` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `operacao` varchar(45) NOT NULL,
  `utilizador` varchar(100) NOT NULL,
  `IDCultura` int(11) NOT NULL,
  `NomeCultura` varchar(100) NOT NULL,
  `DescricaoCultura` text NOT NULL,
  `utilizador_Email` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `cultura_log`
--

INSERT INTO `cultura_log` (`id`, `precedencia`, `datahora`, `operacao`, `utilizador`, `IDCultura`, `NomeCultura`, `DescricaoCultura`, `utilizador_Email`) VALUES
(1, 1, '2019-05-13 11:12:10', 'I', 'root@localhost', 4, 'cultura1', 'descricao1', '\'root\'@\'localhost\''),
(2, 1, '2019-05-13 11:12:10', 'I', 'root@localhost', 5, 'cultura2', 'descricao2', '\'root\'@\'localhost\''),
(3, 1, '2019-05-13 11:12:10', 'I', 'root@localhost', 6, 'cultura3', 'descricao3', '\'abc\'@\'localhost\''),
(4, 1, '2019-05-13 11:12:10', 'I', 'root@localhost', 7, 'cultura4', 'descricao4', '\'cba\'@\'localhost\''),
(5, 1, '2019-05-13 11:12:11', 'I', 'root@localhost', 8, 'cultura5', 'descricao5', '\'abc\'@\'localhost\''),
(6, 1, '2019-05-13 11:12:11', 'I', 'root@localhost', 9, 'cultura6', 'descricao6', '\'cba\'@\'localhost\''),
(7, 1, '2019-05-13 11:12:11', 'I', 'root@localhost', 10, 'cultura7', 'descricao7', '\'root\'@\'localhost\''),
(8, 1, '2019-05-13 11:29:03', 'I', 'root@localhost', 12, 'cultura1', 'descricao1', 'root@localhost'),
(9, 1, '2019-05-13 11:29:03', 'I', 'root@localhost', 13, 'cultura2', 'descricao2', 'root@localhost'),
(10, 1, '2019-05-13 11:29:04', 'I', 'root@localhost', 14, 'cultura3', 'descricao3', 'abcd@localhost'),
(11, 1, '2019-05-13 11:29:04', 'I', 'root@localhost', 15, 'cultura4', 'descricao4', 'xyz@localhost'),
(12, 1, '2019-05-13 11:29:04', 'I', 'root@localhost', 16, 'cultura5', 'descricao5', 'abcd@localhost'),
(13, 1, '2019-05-13 11:29:04', 'I', 'root@localhost', 17, 'cultura6', 'descricao6', 'xyz@localhost'),
(14, 1, '2019-05-13 11:29:04', 'I', 'root@localhost', 18, 'cultura7', 'descricao7', 'root@localhost'),
(15, 1, '2019-05-13 13:44:51', 'I', 'root@localhost', 19, 'cultura2321321321312', 'best', 'root@localhost'),
(16, 1, '2019-05-13 13:45:23', 'D', 'root@localhost', 19, 'cultura2321321321312', 'best', 'root@localhost'),
(17, 1, '2019-05-13 16:28:01', 'U', 'root@localhost', 18, 'cultura7', 'descricao7', 'root@localhost'),
(18, 2, '2019-05-13 16:28:01', 'U', 'root@localhost', 18, 'cultura8', 'lalalala', 'root@localhost'),
(19, 1, '2019-05-13 16:28:10', 'D', 'root@localhost', 18, 'cultura8', 'lalalala', 'root@localhost'),
(20, 1, '2019-05-13 16:28:23', 'I', 'root@localhost', 19, 'cultura 9', 'desc 9', 'root@localhost'),
(21, 1, '2019-05-13 16:50:41', 'D', 'root@localhost', 19, 'cultura 9', 'desc 9', 'root@localhost'),
(22, 1, '2019-05-13 17:13:29', 'I', 'root@localhost', 20, 'nova cultura', 'tomates', 'root@localhost'),
(23, 1, '2019-05-13 17:13:49', 'U', 'root@localhost', 20, 'nova cultura', 'tomates', 'root@localhost'),
(24, 2, '2019-05-13 17:13:49', 'U', 'root@localhost', 20, 'nova cultura', 'batatas', 'root@localhost'),
(25, 1, '2019-05-13 17:13:56', 'D', 'root@localhost', 20, 'nova cultura', 'batatas', 'root@localhost'),
(26, 1, '2019-05-13 17:14:03', 'I', 'root@localhost', 21, 'rrrr', 'rrrrr', 'root@localhost'),
(27, 1, '2019-05-13 17:14:10', 'U', 'root@localhost', 21, 'rrrr', 'rrrrr', 'root@localhost'),
(28, 2, '2019-05-13 17:14:10', 'U', 'root@localhost', 21, 'rrrreeeeeee', 'rrrrr', 'root@localhost'),
(29, 1, '2019-05-13 17:14:14', 'D', 'root@localhost', 21, 'rrrreeeeeee', 'rrrrr', 'root@localhost'),
(30, 1, '2019-05-17 13:01:33', 'I', 'root@localhost', 18, 'Tomates', 'De inverno', 'utilizador_a@localhost'),
(31, 1, '2019-05-17 13:14:08', 'I', 'root@localhost', 19, 'Batatas', 'De verão', 'abcdef@localhost'),
(32, 1, '2019-05-17 13:14:44', 'I', 'root@localhost', 20, 'Cebolas', 'De primavera', 'abcdef@localhost'),
(33, 1, '2019-05-17 13:52:30', 'I', 'root@localhost', 21, 'Arruda', 'arruda', 'toze@localhost'),
(34, 1, '2019-05-17 14:00:50', 'I', 'root@localhost', 22, 'weed', 'sativa', 'socio@localhost'),
(35, 1, '2019-05-17 14:05:40', 'I', 'root@localhost', 23, 'lean', 'no meu copo', 'sippin@localhost'),
(36, 1, '2019-05-17 14:28:50', 'I', 'root@localhost', 24, 'Cenouras', 'Verdes', 'user@localhost');

-- --------------------------------------------------------

--
-- Table structure for table `medicao`
--

CREATE TABLE `medicao` (
  `NumeroMedicao` int(11) NOT NULL,
  `DataHoraMedicao` timestamp(6) NULL DEFAULT NULL,
  `ValorMedicao` decimal(8,2) DEFAULT NULL,
  `VariaveisMedidas_IDCultura` int(11) DEFAULT NULL,
  `VariaveisMedidas_IDVariavel` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `medicao`
--

INSERT INTO `medicao` (`NumeroMedicao`, `DataHoraMedicao`, `ValorMedicao`, `VariaveisMedidas_IDCultura`, `VariaveisMedidas_IDVariavel`) VALUES
(25, '2019-05-17 11:25:17.000000', '13.00', 12, 8),
(26, '2019-05-17 13:04:06.000000', '333.00', 12, 8),
(27, '2019-05-17 13:18:03.000000', '30.00', 20, 9),
(28, '2019-05-17 13:22:11.000000', '30.00', 20, 9),
(29, '2019-05-17 13:22:26.000000', '1.00', 20, 9),
(30, '2019-05-17 13:54:24.000000', '1.00', 21, 8),
(31, '2019-05-17 14:01:52.000000', '4.00', 22, 12),
(35, '2019-05-17 14:30:00.000000', '20.00', 24, 16),
(36, '2019-05-17 14:30:50.000000', '20.00', 24, 16);

--
-- Triggers `medicao`
--
DELIMITER $$
CREATE TRIGGER `medicao_AFTER_DELETE` AFTER DELETE ON `medicao` FOR EACH ROW BEGIN

INSERT INTO medicao_log VALUES(NULL, 1, NOW(), 'D', current_user(), OLD.numeromedicao, OLD.datahoramedicao, OLD.valormedicao, OLD.variaveismedidas_idcultura, OLD.variaveismedidas_idvariavel);

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `medicao_AFTER_INSERT` AFTER INSERT ON `medicao` FOR EACH ROW BEGIN

INSERT INTO medicao_log VALUES(NULL, 1, NOW(), 'I', current_user(), NEW.numeromedicao, NEW.datahoramedicao, NEW.valormedicao, NEW.variaveismedidas_idcultura, NEW.variaveismedidas_idvariavel);

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `medicao_AFTER_UPDATE` AFTER UPDATE ON `medicao` FOR EACH ROW BEGIN

INSERT INTO medicao_log VALUES(NULL, 1, NOW(), 'U', current_user(), OLD.numeromedicao, OLD.datahoramedicao, OLD.valormedicao, OLD.variaveismedidas_idcultura, OLD.variaveismedidas_idvariavel);

INSERT INTO medicao_log VALUES(NULL, 2, NOW(), 'U', current_user(), NEW.numeromedicao, NEW.datahoramedicao, NEW.valormedicao, NEW.variaveismedidas_idcultura, NEW.variaveismedidas_idvariavel);

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `verificar_variavel` BEFORE INSERT ON `medicao` FOR EACH ROW BEGIN

	SET @id = null;
    set @margem = (SELECT margem FROM variaveis_medidas WHERE variavel_idvariavel = NEW.variaveismedidas_idvariavel AND cultura_idcultura = NEW.variaveismedidas_idcultura);
	SET @min = (SELECT limiteInferior FROM variaveis_medidas WHERE variavel_idvariavel = NEW.variaveismedidas_idvariavel AND cultura_idcultura = NEW.variaveismedidas_idcultura);
    SET @max = (SELECT limiteSuperior FROM variaveis_medidas WHERE variavel_idvariavel = NEW.variaveismedidas_idvariavel AND cultura_idcultura = NEW.variaveismedidas_idcultura);
    set @margem = (select (@max-@min)*@margem/100);
    set @maxtest = (select @max+(@margem));
    set @mintest= (SELECT @min-(@margem));
    
	IF NEW.valormedicao < @mintest THEN
    	INSERT INTO alertavariavel VALUES(@id, NEW.datahoramedicao, NEW.variaveismedidas_idvariavel, NEW.variaveismedidas_idcultura, NEW.valormedicao, @min, @max,"valor abaixo do limite");
    ELSEIF NEW.valormedicao > @maxtest THEN
    INSERT INTO alertavariavel VALUES(@id, NEW.datahoramedicao, NEW.variaveismedidas_idvariavel, NEW.variaveismedidas_idcultura, NEW.valormedicao, @min, @max,"valor acima do limite");
    END IF;
    
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `medicao_log`
--

CREATE TABLE `medicao_log` (
  `id` int(11) NOT NULL,
  `precedencia` int(11) NOT NULL,
  `datahora` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `operacao` varchar(45) NOT NULL,
  `utilizador` varchar(100) NOT NULL,
  `NumeroMedicao` int(11) NOT NULL,
  `DataHoraMedicao` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `valorMedicao` decimal(8,2) NOT NULL,
  `VariaveisMedidas_IDCultura` int(11) NOT NULL,
  `VariaveisMedidas_IDVariavel` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `medicao_log`
--

INSERT INTO `medicao_log` (`id`, `precedencia`, `datahora`, `operacao`, `utilizador`, `NumeroMedicao`, `DataHoraMedicao`, `valorMedicao`, `VariaveisMedidas_IDCultura`, `VariaveisMedidas_IDVariavel`) VALUES
(2, 1, '2019-05-13 17:30:02', 'I', 'root@localhost', 5, '2019-05-13 17:30:02', '15.00', 12, 7),
(3, 1, '2019-05-13 17:42:18', 'I', 'root@localhost', 6, '2019-05-13 17:42:18', '222.00', 12, 7),
(4, 1, '2019-05-13 17:47:50', 'I', 'root@localhost', 8, '2019-05-13 17:47:50', '222.00', 12, 7),
(5, 1, '2019-05-13 17:53:56', 'I', 'root@localhost', 9, '2019-05-13 17:53:56', '123.00', 12, 7),
(6, 1, '2019-05-13 18:04:18', 'I', 'root@localhost', 10, '2019-05-13 18:04:18', '22.00', 12, 7),
(7, 1, '2019-05-13 18:05:36', 'I', 'root@localhost', 11, '2019-05-13 18:05:36', '44.00', 12, 7),
(8, 1, '2019-05-13 18:05:42', 'I', 'root@localhost', 12, '2019-05-13 18:05:42', '55.00', 13, 7),
(9, 1, '2019-05-13 18:15:24', 'I', 'root@localhost', 14, '2019-05-13 18:15:24', '1231.00', 12, 7),
(10, 1, '2019-05-13 18:17:25', 'I', 'root@localhost', 15, '2019-05-13 18:17:25', '123.00', 12, 7),
(11, 1, '2019-05-13 18:22:16', 'I', 'root@localhost', 16, '2019-05-13 18:22:16', '123.00', 12, 7),
(12, 1, '2019-05-13 18:22:27', 'I', 'root@localhost', 17, '2019-05-13 18:22:27', '345.00', 13, 7),
(13, 1, '2019-05-13 18:49:02', 'D', 'root@localhost', 17, '2019-05-13 18:22:27', '345.00', 13, 7),
(14, 1, '2019-05-13 18:49:14', 'U', 'root@localhost', 16, '2019-05-13 18:22:16', '123.00', 12, 7),
(15, 2, '2019-05-13 18:49:14', 'U', 'root@localhost', 16, '2019-05-13 18:22:16', '4444.00', 12, 7),
(16, 1, '2019-05-15 15:27:17', 'I', 'root@localhost', 17, '2019-05-14 23:00:00', '2100.00', 12, 7),
(17, 1, '2019-05-15 15:27:34', 'I', 'root@localhost', 18, '2019-05-14 23:00:00', '2300.00', 12, 7),
(18, 1, '2019-05-15 15:35:11', 'I', 'root@localhost', 19, '2019-05-14 23:00:00', '2400.00', 12, 7),
(19, 1, '2019-05-15 15:35:16', 'I', 'root@localhost', 20, '2019-05-14 23:00:00', '2400.00', 12, 7),
(20, 1, '2019-05-15 15:38:31', 'I', 'root@localhost', 21, '2019-05-14 23:00:00', '2600.00', 12, 7),
(21, 1, '2019-05-15 15:38:33', 'I', 'root@localhost', 22, '2019-05-14 23:00:00', '2600.00', 12, 7),
(22, 1, '2019-05-15 16:32:10', 'I', 'root@localhost', 23, '2019-05-14 23:00:00', '2600.00', 12, 7),
(23, 1, '2019-05-15 16:34:27', 'I', 'root@localhost', 24, '2019-05-15 16:34:27', '2600.00', 12, 7),
(24, 1, '2019-05-17 11:25:17', 'I', 'root@localhost', 25, '2019-05-17 11:25:17', '13.00', 12, 8),
(25, 1, '2019-05-17 13:04:06', 'I', 'root@localhost', 26, '2019-05-17 13:04:06', '333.00', 12, 8),
(26, 1, '2019-05-17 13:18:03', 'I', 'root@localhost', 27, '2019-05-17 13:18:03', '30.00', 20, 9),
(27, 1, '2019-05-17 13:22:11', 'I', 'root@localhost', 28, '2019-05-17 13:22:11', '30.00', 20, 9),
(28, 1, '2019-05-17 13:22:26', 'I', 'root@localhost', 29, '2019-05-17 13:22:26', '1.00', 20, 9),
(29, 1, '2019-05-17 13:54:24', 'I', 'root@localhost', 30, '2019-05-17 13:54:24', '1.00', 21, 8),
(30, 1, '2019-05-17 14:01:52', 'I', 'root@localhost', 31, '2019-05-17 14:01:52', '4.00', 22, 12),
(31, 1, '2019-05-17 14:07:52', 'I', 'root@localhost', 32, '2019-05-17 14:07:52', '1.00', 23, 14),
(32, 1, '2019-05-17 14:08:27', 'I', 'root@localhost', 33, '2019-05-17 14:08:27', '1.00', 23, 15),
(33, 1, '2019-05-17 14:09:37', 'I', 'root@localhost', 34, '2019-05-17 14:09:37', '3.00', 23, 15),
(34, 1, '2019-05-17 14:30:00', 'I', 'root@localhost', 35, '2019-05-17 14:30:00', '20.00', 24, 16),
(35, 1, '2019-05-17 14:30:50', 'I', 'root@localhost', 36, '2019-05-17 14:30:50', '20.00', 24, 16);

-- --------------------------------------------------------

--
-- Table structure for table `medicoes_luminosidade`
--

CREATE TABLE `medicoes_luminosidade` (
  `IDMedicao` int(11) NOT NULL,
  `DataHoraMedicao` timestamp(6) NULL DEFAULT NULL,
  `ValorMedicaoLuminosidade` decimal(8,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `medicoes_luminosidade`
--

INSERT INTO `medicoes_luminosidade` (`IDMedicao`, `DataHoraMedicao`, `ValorMedicaoLuminosidade`) VALUES
(9, '2019-05-17 12:46:53.303000', '1657.00'),
(12, '2019-05-17 12:46:58.170000', '2982.00'),
(15, '2019-05-17 12:47:04.718000', '2999.00'),
(18, '2019-05-17 12:47:12.911000', '2992.00'),
(21, '2019-05-17 12:47:19.213000', '2994.00'),
(24, '2019-05-17 12:47:25.365000', '2995.00'),
(27, '2019-05-17 12:47:31.631000', '2994.00'),
(30, '2019-05-17 12:47:37.842000', '2971.00'),
(33, '2019-05-17 12:47:44.170000', '2958.00'),
(36, '2019-05-17 12:47:50.345000', '2995.00'),
(39, '2019-05-17 12:47:58.510000', '2997.00'),
(42, '2019-05-17 12:48:04.844000', '2998.00'),
(45, '2019-05-17 12:48:11.046000', '2970.00'),
(48, '2019-05-17 12:48:17.238000', '2972.00'),
(51, '2019-05-17 12:48:23.458000', '2973.00'),
(54, '2019-05-17 12:48:31.609000', '2987.00'),
(57, '2019-05-17 12:48:35.999000', '2993.00'),
(60, '2019-05-17 12:48:44.211000', '2984.00'),
(63, '2019-05-17 12:48:50.373000', '2962.00'),
(66, '2019-05-17 12:48:56.507000', '2983.00'),
(69, '2019-05-17 12:49:02.705000', '2986.00'),
(72, '2019-05-17 12:49:08.898000', '2982.00'),
(75, '2019-05-17 12:49:15.082000', '2981.00'),
(78, '2019-05-17 12:49:23.333000', '2980.00'),
(81, '2019-05-17 12:49:29.534000', '2992.00'),
(84, '2019-05-17 12:49:35.842000', '2990.00'),
(87, '2019-05-17 12:49:42.008000', '2966.00'),
(90, '2019-05-17 12:49:48.284000', '2985.00'),
(93, '2019-05-17 12:49:54.402000', '2988.00'),
(96, '2019-05-17 12:50:02.601000', '2998.00'),
(99, '2019-05-17 12:50:08.939000', '2970.00'),
(102, '2019-05-17 12:50:15.155000', '2973.00'),
(105, '2019-05-17 12:50:21.335000', '2977.00'),
(108, '2019-05-17 12:50:27.459000', '2995.00'),
(111, '2019-05-17 12:50:33.729000', '2974.00'),
(114, '2019-05-17 12:50:41.907000', '2966.00'),
(117, '2019-05-17 12:50:48.173000', '2968.00'),
(120, '2019-05-17 12:50:54.339000', '2991.00'),
(123, '2019-05-17 12:51:00.538000', '2975.00'),
(126, '2019-05-17 12:51:06.937000', '2985.00'),
(129, '2019-05-17 12:51:13.117000', '2985.00'),
(132, '2019-05-17 12:51:19.288000', '2958.00'),
(135, '2019-05-17 12:51:27.393000', '2964.00'),
(138, '2019-05-17 12:51:33.681000', '2982.00'),
(141, '2019-05-17 12:51:39.867000', '2980.00'),
(144, '2019-05-17 12:51:46.031000', '2982.00'),
(147, '2019-05-17 12:51:52.164000', '2989.00'),
(150, '2019-05-17 12:52:00.298000', '2987.00'),
(153, '2019-05-17 12:52:06.460000', '3000.00'),
(156, '2019-05-17 12:52:12.762000', '2976.00'),
(159, '2019-05-17 12:52:18.887000', '3001.00'),
(162, '2019-05-17 12:52:25.077000', '2976.00'),
(165, '2019-05-17 12:52:31.233000', '2970.00'),
(168, '2019-05-17 12:52:39.311000', '2926.00'),
(171, '2019-05-17 12:52:45.480000', '2880.00'),
(174, '2019-05-17 12:52:51.623000', '2858.00'),
(177, '2019-05-17 12:52:57.756000', '2869.00'),
(180, '2019-05-17 12:53:05.856000', '2961.00'),
(183, '2019-05-17 12:53:12.059000', '2965.00'),
(186, '2019-05-17 12:53:18.279000', '2954.00'),
(189, '2019-05-17 12:53:24.558000', '2970.00'),
(192, '2019-05-17 12:53:30.706000', '2968.00'),
(195, '2019-05-17 12:53:36.868000', '2959.00'),
(198, '2019-05-17 12:53:45.075000', '2970.00'),
(201, '2019-05-17 12:53:51.258000', '2955.00'),
(204, '2019-05-17 12:53:57.018000', '2933.00'),
(207, '2019-05-17 12:54:03.628000', '2944.00'),
(210, '2019-05-17 12:54:09.818000', '2943.00'),
(213, '2019-05-17 12:54:15.963000', '2973.00'),
(216, '2019-05-17 12:54:22.070000', '2968.00'),
(219, '2019-05-17 12:54:30.350000', '2950.00'),
(222, '2019-05-17 12:54:36.476000', '2949.00'),
(225, '2019-05-17 12:54:42.621000', '2964.00'),
(228, '2019-05-17 12:54:48.779000', '2967.00'),
(231, '2019-05-17 12:54:56.980000', '2955.00'),
(234, '2019-05-17 12:55:01.161000', '2942.00'),
(237, '2019-05-17 12:55:09.374000', '2934.00'),
(240, '2019-05-17 12:55:15.495000', '2962.00'),
(243, '2019-05-17 12:55:21.678000', '2972.00'),
(246, '2019-05-17 12:55:27.879000', '2952.00'),
(249, '2019-05-17 12:55:34.067000', '2968.00'),
(252, '2019-05-17 12:55:42.310000', '2951.00'),
(255, '2019-05-17 12:55:48.595000', '2934.00'),
(258, '2019-05-17 12:55:54.731000', '2934.00'),
(261, '2019-05-17 12:56:00.909000', '2053.00'),
(264, '2019-05-17 12:56:09.108000', '1217.00'),
(267, '2019-05-17 12:56:13.295000', '1222.00'),
(270, '2019-05-17 12:56:21.968000', '1187.00'),
(273, '2019-05-17 12:56:28.126000', '1287.00'),
(276, '2019-05-17 12:56:34.336000', '2151.00'),
(279, '2019-05-17 12:56:40.515000', '2943.00'),
(282, '2019-05-17 12:56:46.665000', '2967.00'),
(285, '2019-05-17 12:56:52.842000', '2931.00'),
(288, '2019-05-17 12:56:59.056000', '2933.00'),
(291, '2019-05-17 12:57:07.206000', '2927.00'),
(294, '2019-05-17 12:57:13.382000', '2956.00'),
(297, '2019-05-17 12:57:19.554000', '2976.00'),
(300, '2019-05-17 12:57:25.791000', '2971.00'),
(303, '2019-05-17 12:57:33.955000', '2975.00'),
(306, '2019-05-17 12:57:38.191000', '2975.00'),
(309, '2019-05-17 12:57:46.431000', '2956.00'),
(312, '2019-05-17 12:57:52.590000', '2955.00'),
(315, '2019-05-17 12:57:58.832000', '2826.00'),
(318, '2019-05-17 12:58:07.031000', '2922.00'),
(321, '2019-05-17 12:58:11.215000', '2971.00'),
(324, '2019-05-17 12:58:17.505000', '2935.00'),
(327, '2019-05-17 12:58:23.647000', '2961.00'),
(330, '2019-05-17 12:58:31.911000', '2941.00'),
(333, '2019-05-17 12:58:38.104000', '2940.00'),
(336, '2019-05-17 12:58:44.681000', '2963.00'),
(339, '2019-05-17 12:58:51.027000', '2971.00'),
(342, '2019-05-17 12:58:57.366000', '2953.00'),
(345, '2019-05-17 12:59:05.510000', '2959.00'),
(348, '2019-05-17 12:59:09.633000', '2936.00'),
(351, '2019-05-17 12:59:17.798000', '2176.00'),
(354, '2019-05-17 12:59:23.934000', '1094.00'),
(357, '2019-05-17 12:59:30.156000', '1103.00'),
(360, '2019-05-17 12:59:38.364000', '1124.00'),
(363, '2019-05-17 12:59:42.482000', '1037.00'),
(366, '2019-05-17 12:59:50.578000', '767.00'),
(369, '2019-05-17 12:59:56.699000', '2938.00'),
(372, '2019-05-17 13:00:02.905000', '2983.00'),
(375, '2019-05-17 13:00:08.997000', '2953.00'),
(378, '2019-05-17 13:00:15.184000', '2943.00'),
(381, '2019-05-17 13:00:21.459000', '2949.00'),
(384, '2019-05-17 13:00:29.558000', '2926.00'),
(387, '2019-05-17 13:00:35.739000', '2955.00'),
(390, '2019-05-17 13:00:41.884000', '2937.00'),
(393, '2019-05-17 13:00:47.986000', '2908.00'),
(396, '2019-05-17 13:00:54.130000', '912.00'),
(399, '2019-05-17 13:01:02.289000', '2950.00'),
(402, '2019-05-17 13:01:08.449000', '2945.00'),
(405, '2019-05-17 13:01:14.555000', '2949.00'),
(408, '2019-05-17 13:01:20.946000', '2958.00'),
(411, '2019-05-17 13:01:27.071000', '2944.00'),
(414, '2019-05-17 13:01:33.150000', '873.00'),
(417, '2019-05-17 13:01:41.589000', '854.00'),
(420, '2019-05-17 13:01:47.807000', '921.00'),
(423, '2019-05-17 13:01:55.900000', '1141.00'),
(426, '2019-05-17 13:01:59.987000', '1391.00'),
(429, '2019-05-17 13:02:08.150000', '1358.00'),
(432, '2019-05-17 13:02:14.340000', '1364.00'),
(435, '2019-05-17 13:02:20.429000', '1379.00'),
(438, '2019-05-17 13:02:26.568000', '1414.00'),
(441, '2019-05-17 13:02:32.692000', '1416.00'),
(444, '2019-05-17 13:02:38.846000', '1405.00'),
(447, '2019-05-17 13:02:46.928000', '1384.00'),
(450, '2019-05-17 13:02:53.013000', '1366.00'),
(453, '2019-05-17 13:02:59.131000', '2164.00'),
(456, '2019-05-17 13:03:05.286000', '2973.00'),
(459, '2019-05-17 13:03:11.377000', '2981.00'),
(462, '2019-05-17 13:03:19.497000', '2991.00'),
(465, '2019-05-17 13:03:25.563000', '2976.00'),
(468, '2019-05-17 13:03:31.767000', '2971.00'),
(471, '2019-05-17 13:03:37.848000', '2971.00'),
(474, '2019-05-17 13:03:44.005000', '2952.00'),
(477, '2019-05-17 13:03:52.337000', '2963.00'),
(480, '2019-05-17 13:03:58.439000', '2976.00'),
(483, '2019-05-17 13:04:04.515000', '2955.00'),
(486, '2019-05-17 13:04:10.612000', '2967.00'),
(489, '2019-05-17 13:04:16.739000', '2954.00'),
(492, '2019-05-17 13:04:24.831000', '2968.00'),
(495, '2019-05-17 13:04:30.948000', '2965.00'),
(498, '2019-05-17 13:04:37.069000', '2923.00'),
(501, '2019-05-17 13:04:43.139000', '2930.00'),
(504, '2019-05-17 13:04:49.401000', '2931.00'),
(507, '2019-05-17 13:04:57.533000', '2969.00'),
(510, '2019-05-17 13:05:03.637000', '2956.00'),
(513, '2019-05-17 13:05:09.736000', '2966.00'),
(516, '2019-05-17 13:05:15.864000', '2990.00'),
(519, '2019-05-17 13:05:23.996000', '2968.00'),
(522, '2019-05-17 13:05:30.163000', '1304.00'),
(525, '2019-05-17 13:05:36.469000', '1177.00'),
(528, '2019-05-17 13:05:42.570000', '1065.00'),
(531, '2019-05-17 13:05:48.765000', '891.00'),
(534, '2019-05-17 13:05:54.888000', '909.00'),
(537, '2019-05-17 13:06:01.094000', '917.00'),
(540, '2019-05-17 13:06:09.189000', '922.00'),
(543, '2019-05-17 13:06:15.302000', '916.00'),
(546, '2019-05-17 13:06:21.580000', '890.00'),
(549, '2019-05-17 13:06:27.809000', '898.00'),
(552, '2019-05-17 13:06:35.901000', '888.00'),
(555, '2019-05-17 13:06:41.990000', '866.00'),
(558, '2019-05-17 13:06:48.094000', '2206.00'),
(561, '2019-05-17 13:06:54.351000', '2995.00'),
(564, '2019-05-17 13:07:00.509000', '2962.00'),
(567, '2019-05-17 13:07:06.599000', '2955.00'),
(570, '2019-05-17 13:07:12.734000', '2977.00'),
(573, '2019-05-17 13:07:20.878000', '2971.00'),
(576, '2019-05-17 13:07:27.019000', '2975.00'),
(579, '2019-05-17 13:07:33.192000', '2978.00'),
(582, '2019-05-17 13:07:39.325000', '2984.00'),
(585, '2019-05-17 13:07:45.429000', '2983.00'),
(588, '2019-05-17 13:07:53.582000', '2988.00'),
(591, '2019-05-17 13:07:59.727000', '2985.00'),
(594, '2019-05-17 13:08:05.894000', '2992.00'),
(597, '2019-05-17 13:08:12.026000', '2991.00'),
(600, '2019-05-17 13:08:18.136000', '2988.00'),
(603, '2019-05-17 13:08:26.250000', '2998.00'),
(606, '2019-05-17 13:08:32.368000', '2973.00'),
(609, '2019-05-17 13:08:38.464000', '2965.00'),
(612, '2019-05-17 13:08:44.536000', '2977.00'),
(615, '2019-05-17 13:08:50.623000', '2970.00'),
(618, '2019-05-17 13:08:58.761000', '2961.00'),
(621, '2019-05-17 13:09:04.909000', '2976.00'),
(624, '2019-05-17 13:09:11.023000', '2967.00'),
(627, '2019-05-17 13:09:17.211000', '3006.00'),
(630, '2019-05-17 13:09:25.286000', '2982.00'),
(633, '2019-05-17 13:09:31.403000', '2974.00'),
(636, '2019-05-17 13:09:39.483000', '2950.00'),
(639, '2019-05-17 13:09:45.561000', '2941.00'),
(642, '2019-05-17 13:09:49.782000', '2968.00'),
(645, '2019-05-17 13:09:57.850000', '2993.00'),
(648, '2019-05-17 13:10:03.996000', '2994.00'),
(651, '2019-05-17 13:10:10.229000', '2989.00'),
(654, '2019-05-17 13:10:16.433000', '2976.00'),
(657, '2019-05-17 13:10:22.557000', '2987.00'),
(660, '2019-05-17 13:10:30.632000', '2958.00'),
(663, '2019-05-17 13:10:36.792000', '2967.00'),
(666, '2019-05-17 13:10:42.872000', '2973.00'),
(669, '2019-05-17 13:10:48.967000', '2948.00'),
(672, '2019-05-17 13:10:55.088000', '2951.00'),
(675, '2019-05-17 13:11:03.184000', '2971.00'),
(678, '2019-05-17 13:11:09.301000', '2973.00'),
(681, '2019-05-17 13:11:15.435000', '2981.00'),
(684, '2019-05-17 13:11:21.565000', '2982.00'),
(687, '2019-05-17 13:11:29.747000', '2960.00'),
(690, '2019-05-17 13:11:35.913000', '2949.00'),
(693, '2019-05-17 13:11:41.999000', '2938.00'),
(696, '2019-05-17 13:11:48.131000', '2983.00'),
(699, '2019-05-17 13:11:54.254000', '2951.00'),
(702, '2019-05-17 13:12:02.349000', '2945.00'),
(705, '2019-05-17 13:12:08.452000', '2949.00'),
(708, '2019-05-17 13:12:14.559000', '2962.00'),
(711, '2019-05-17 13:12:22.631000', '2964.00'),
(714, '2019-05-17 13:12:28.760000', '2968.00'),
(717, '2019-05-17 13:12:33.046000', '2984.00'),
(720, '2019-05-17 13:12:41.250000', '2956.00'),
(723, '2019-05-17 13:12:47.434000', '2951.00'),
(726, '2019-05-17 13:12:53.595000', '2959.00'),
(729, '2019-05-17 13:13:01.728000', '2969.00'),
(732, '2019-05-17 13:13:07.869000', '2957.00'),
(735, '2019-05-17 13:13:14.045000', '2947.00'),
(738, '2019-05-17 13:13:20.135000', '2958.00'),
(741, '2019-05-17 13:13:26.367000', '2970.00'),
(744, '2019-05-17 13:13:32.496000', '2975.00'),
(747, '2019-05-17 13:13:38.644000', '2971.00'),
(750, '2019-05-17 13:13:44.813000', '2971.00'),
(753, '2019-05-17 13:13:52.927000', '2979.00'),
(756, '2019-05-17 13:13:59.031000', '2975.00'),
(759, '2019-05-17 13:14:05.165000', '2981.00'),
(762, '2019-05-17 13:14:11.294000', '2996.00'),
(765, '2019-05-17 13:14:19.379000', '2961.00'),
(768, '2019-05-17 13:14:25.461000', '2960.00'),
(771, '2019-05-17 13:14:31.545000', '2977.00'),
(774, '2019-05-17 13:14:37.679000', '2990.00'),
(777, '2019-05-17 13:14:43.812000', '3013.00'),
(780, '2019-05-17 13:15:26.092000', '2719.00'),
(783, '2019-05-17 13:15:32.210000', '2448.00'),
(786, '2019-05-17 13:15:38.441000', '2486.00'),
(789, '2019-05-17 13:15:44.600000', '2488.00'),
(792, '2019-05-17 13:15:50.732000', '2610.00'),
(795, '2019-05-17 13:15:58.828000', '2627.00'),
(798, '2019-05-17 13:16:04.922000', '2610.00'),
(801, '2019-05-17 13:16:11.077000', '2540.00'),
(804, '2019-05-17 13:16:17.195000', '2531.00'),
(807, '2019-05-17 13:16:23.351000', '2572.00'),
(810, '2019-05-17 13:16:31.444000', '2514.00'),
(813, '2019-05-17 13:16:37.562000', '2489.00'),
(816, '2019-05-17 13:16:43.713000', '2397.00'),
(819, '2019-05-17 13:16:51.883000', '2364.00'),
(822, '2019-05-17 13:16:56.029000', '2343.00'),
(825, '2019-05-17 13:17:04.128000', '2350.00'),
(828, '2019-05-17 13:17:10.505000', '2333.00'),
(831, '2019-05-17 13:17:16.730000', '2327.00'),
(834, '2019-05-17 13:17:22.837000', '2340.00'),
(837, '2019-05-17 13:17:28.930000', '2334.00'),
(840, '2019-05-17 13:17:35.133000', '2392.00'),
(843, '2019-05-17 13:17:43.225000', '2543.00'),
(846, '2019-05-17 13:17:49.342000', '2594.00'),
(849, '2019-05-17 13:17:55.507000', '2625.00'),
(852, '2019-05-17 13:18:01.620000', '2624.00'),
(855, '2019-05-17 13:18:09.744000', '2623.00'),
(858, '2019-05-17 13:18:15.874000', '2620.00'),
(861, '2019-05-17 13:18:22.043000', '2618.00'),
(864, '2019-05-17 13:18:28.248000', '2623.00'),
(867, '2019-05-17 13:18:34.454000', '2620.00'),
(870, '2019-05-17 13:18:40.536000', '2623.00'),
(873, '2019-05-17 13:18:48.703000', '2626.00'),
(876, '2019-05-17 13:18:54.878000', '2581.00'),
(879, '2019-05-17 13:19:00.951000', '2500.00'),
(882, '2019-05-17 13:19:07.082000', '2386.00'),
(885, '2019-05-17 13:19:13.197000', '2379.00'),
(888, '2019-05-17 13:19:21.363000', '2419.00'),
(891, '2019-05-17 13:19:27.509000', '2507.00'),
(894, '2019-05-17 13:20:09.798000', '2559.00'),
(897, '2019-05-17 13:20:15.951000', '2552.00'),
(900, '2019-05-17 13:20:22.094000', '2538.00'),
(903, '2019-05-17 13:20:28.367000', '2459.00'),
(906, '2019-05-17 13:20:36.481000', '2399.00'),
(909, '2019-05-17 13:20:42.638000', '2377.00'),
(912, '2019-05-17 13:20:48.738000', '2366.00'),
(915, '2019-05-17 13:20:54.925000', '2356.00'),
(918, '2019-05-17 13:21:01.166000', '2359.00'),
(921, '2019-05-17 13:21:07.302000', '2373.00'),
(924, '2019-05-17 13:21:15.682000', '2372.00'),
(927, '2019-05-17 13:21:21.841000', '2373.00'),
(930, '2019-05-17 13:21:28.006000', '2385.00'),
(933, '2019-05-17 13:21:36.137000', '2395.00'),
(936, '2019-05-17 13:21:40.363000', '2420.00'),
(939, '2019-05-17 13:21:46.540000', '2433.00'),
(942, '2019-05-17 13:21:54.731000', '2437.00'),
(945, '2019-05-17 13:22:00.893000', '2437.00'),
(948, '2019-05-17 13:22:57.226000', '2509.00'),
(951, '2019-05-17 13:23:05.504000', '2485.00'),
(954, '2019-05-17 13:23:11.637000', '2375.00'),
(957, '2019-05-17 13:23:17.822000', '2427.00'),
(960, '2019-05-17 13:23:23.985000', '2462.00'),
(963, '2019-05-17 13:23:30.230000', '2495.00'),
(966, '2019-05-17 13:23:36.339000', '2554.00'),
(969, '2019-05-17 13:23:42.428000', '2440.00'),
(972, '2019-05-17 13:23:48.740000', '2045.00'),
(975, '2019-05-17 13:23:56.893000', '2207.00'),
(978, '2019-05-17 13:24:03.024000', '729.00'),
(981, '2019-05-17 13:24:09.306000', '736.00'),
(984, '2019-05-17 13:24:15.655000', '736.00'),
(987, '2019-05-17 13:24:21.808000', '2661.00'),
(990, '2019-05-17 13:24:29.978000', '2707.00'),
(993, '2019-05-17 13:24:36.122000', '3216.00'),
(996, '2019-05-17 13:24:42.310000', '2693.00'),
(999, '2019-05-17 13:24:48.479000', '2600.00'),
(1002, '2019-05-17 13:24:54.605000', '2505.00'),
(1005, '2019-05-17 13:25:00.777000', '2469.00'),
(1008, '2019-05-17 13:25:08.908000', '2471.00'),
(1011, '2019-05-17 13:25:15.074000', '2462.00'),
(1014, '2019-05-17 13:25:21.290000', '2454.00'),
(1017, '2019-05-17 13:25:27.378000', '2454.00'),
(1020, '2019-05-17 13:25:33.820000', '2465.00'),
(1023, '2019-05-17 13:25:39.952000', '2459.00'),
(1026, '2019-05-17 13:25:48.086000', '2471.00'),
(1029, '2019-05-17 13:25:54.390000', '2480.00'),
(1032, '2019-05-17 13:26:00.570000', '2443.00'),
(1035, '2019-05-17 13:26:08.701000', '2479.00'),
(1038, '2019-05-17 13:26:14.830000', '2512.00'),
(1041, '2019-05-17 13:26:20.927000', '2667.00'),
(1044, '2019-05-17 13:26:27.064000', '2659.00'),
(1047, '2019-05-17 13:26:33.175000', '2656.00'),
(1050, '2019-05-17 13:26:39.303000', '2670.00'),
(1053, '2019-05-17 13:26:45.421000', '2685.00'),
(1056, '2019-05-17 13:26:53.520000', '2667.00'),
(1059, '2019-05-17 13:26:59.689000', '2548.00'),
(1062, '2019-05-17 13:27:05.816000', '2386.00'),
(1065, '2019-05-17 13:27:11.961000', '686.00'),
(1068, '2019-05-17 13:27:18.105000', '734.00'),
(1071, '2019-05-17 13:27:26.240000', '647.00'),
(1074, '2019-05-17 13:27:32.323000', '573.00'),
(1077, '2019-05-17 13:27:38.423000', '738.00'),
(1080, '2019-05-17 13:27:44.563000', '996.00'),
(1083, '2019-05-17 13:28:28.765000', '960.00'),
(1086, '2019-05-17 13:28:33.903000', '1803.00'),
(1089, '2019-05-17 13:28:41.269000', '1001.00'),
(1092, '2019-05-17 13:28:47.705000', '1010.00'),
(1095, '2019-05-17 13:28:53.974000', '1068.00'),
(1098, '2019-05-17 13:29:01.542000', '1730.00'),
(1101, '2019-05-17 13:29:07.764000', '2465.00'),
(1104, '2019-05-17 13:29:14.558000', '2442.00'),
(1107, '2019-05-17 13:29:20.017000', '2432.00'),
(1110, '2019-05-17 13:29:26.902000', '2500.00'),
(1113, '2019-05-17 13:29:34.397000', '2586.00'),
(1116, '2019-05-17 13:29:40.967000', '2700.00'),
(1119, '2019-05-17 13:29:47.212000', '2696.00'),
(1122, '2019-05-17 13:29:53.466000', '2694.00'),
(1125, '2019-05-17 13:30:01.665000', '876.00'),
(1128, '2019-05-17 13:30:05.886000', '890.00'),
(1131, '2019-05-17 13:30:14.041000', '889.00'),
(1134, '2019-05-17 13:30:20.145000', '892.00'),
(1137, '2019-05-17 13:30:26.432000', '1145.00'),
(1140, '2019-05-17 13:30:34.554000', '2643.00'),
(1143, '2019-05-17 13:30:41.018000', '2622.00'),
(1146, '2019-05-17 13:30:47.984000', '2587.00'),
(1149, '2019-05-17 13:30:54.062000', '2544.00'),
(1152, '2019-05-17 13:31:00.373000', '2471.00'),
(1155, '2019-05-17 13:44:12.116000', '2457.00'),
(1158, '2019-05-17 13:44:18.406000', '2806.00'),
(1161, '2019-05-17 13:44:24.558000', '2824.00'),
(1164, '2019-05-17 13:44:30.705000', '2777.00'),
(1167, '2019-05-17 13:44:38.853000', '2753.00'),
(1170, '2019-05-17 13:44:45.075000', '2730.00'),
(1173, '2019-05-17 13:44:51.201000', '2760.00'),
(1176, '2019-05-17 13:44:57.303000', '2778.00'),
(1179, '2019-05-17 13:45:03.456000', '2772.00'),
(1182, '2019-05-17 13:45:09.567000', '2769.00'),
(1185, '2019-05-17 13:45:17.685000', '2749.00'),
(1188, '2019-05-17 13:45:23.941000', '2753.00'),
(1191, '2019-05-17 13:45:30.172000', '2724.00'),
(1194, '2019-05-17 13:45:38.344000', '2678.00'),
(1197, '2019-05-17 13:45:42.625000', '2113.00'),
(1200, '2019-05-17 13:45:50.803000', '2254.00'),
(1203, '2019-05-17 13:45:55.170000', '2651.00'),
(1206, '2019-05-17 13:46:01.892000', '2648.00'),
(1209, '2019-05-17 13:46:10.704000', '2671.00'),
(1212, '2019-05-17 13:46:14.894000', '2741.00'),
(1215, '2019-05-17 13:46:23.096000', '2738.00'),
(1218, '2019-05-17 13:46:29.348000', '2727.00'),
(1221, '2019-05-17 13:46:35.620000', '2736.00'),
(1224, '2019-05-17 13:46:41.908000', '2157.00'),
(1227, '2019-05-17 13:46:48.063000', '1109.00'),
(1230, '2019-05-17 13:46:54.242000', '1054.00'),
(1233, '2019-05-17 13:47:02.345000', '1016.00'),
(1236, '2019-05-17 13:47:08.496000', '962.00'),
(1239, '2019-05-17 13:47:14.649000', '968.00'),
(1242, '2019-05-17 13:47:20.776000', '962.00'),
(1245, '2019-05-17 13:47:28.940000', '2708.00'),
(1248, '2019-05-17 13:47:35.079000', '2665.00'),
(1251, '2019-05-17 13:47:41.217000', '2636.00'),
(1254, '2019-05-17 13:47:47.455000', '2648.00'),
(1257, '2019-05-17 13:47:55.566000', '2658.00'),
(1260, '2019-05-17 13:47:59.708000', '2687.00'),
(1263, '2019-05-17 13:48:05.842000', '2702.00'),
(1266, '2019-05-17 13:48:14.015000', '2757.00'),
(1269, '2019-05-17 13:48:20.140000', '2791.00'),
(1272, '2019-05-17 13:48:26.267000', '2792.00'),
(1275, '2019-05-17 13:48:32.401000', '2795.00'),
(1278, '2019-05-17 13:48:40.584000', '2792.00'),
(1281, '2019-05-17 13:48:46.717000', '2770.00'),
(1284, '2019-05-17 13:48:52.892000', '2801.00'),
(1287, '2019-05-17 13:49:00.993000', '2805.00'),
(1290, '2019-05-17 13:49:05.090000', '2805.00'),
(1293, '2019-05-17 13:49:11.246000', '2775.00'),
(1296, '2019-05-17 13:49:19.401000', '2779.00'),
(1299, '2019-05-17 13:49:25.500000', '2722.00'),
(1302, '2019-05-17 13:49:31.598000', '2709.00'),
(1305, '2019-05-17 13:49:37.761000', '2689.00'),
(1308, '2019-05-17 13:49:43.860000', '2705.00'),
(1311, '2019-05-17 13:49:51.987000', '2741.00'),
(1314, '2019-05-17 13:49:58.131000', '2771.00'),
(1317, '2019-05-17 13:50:04.285000', '2779.00'),
(1320, '2019-05-17 13:50:10.460000', '933.00'),
(1323, '2019-05-17 13:50:18.664000', '984.00'),
(1326, '2019-05-17 13:50:24.787000', '739.00'),
(1329, '2019-05-17 13:50:30.931000', '783.00'),
(1332, '2019-05-17 13:50:37.012000', '1756.00'),
(1335, '2019-05-17 13:50:45.416000', '2748.00'),
(1338, '2019-05-17 13:50:49.571000', '701.00'),
(1341, '2019-05-17 13:50:57.742000', '330.00'),
(1344, '2019-05-17 13:51:03.914000', '0.00'),
(1347, '2019-05-17 13:51:10.022000', '0.00'),
(1350, '2019-05-17 13:51:16.100000', '0.00'),
(1353, '2019-05-17 13:51:22.232000', '2783.00'),
(1356, '2019-05-17 13:51:28.345000', '1346.00'),
(1359, '2019-05-17 13:51:36.949000', '1385.00'),
(1362, '2019-05-17 13:51:43.026000', '2792.00'),
(1365, '2019-05-17 13:51:49.194000', '2774.00'),
(1368, '2019-05-17 13:51:55.367000', '2785.00'),
(1371, '2019-05-17 13:52:01.483000', '2786.00'),
(1374, '2019-05-17 13:52:09.580000', '2745.00'),
(1377, '2019-05-17 13:52:15.683000', '2749.00'),
(1380, '2019-05-17 13:52:23.818000', '2769.00'),
(1383, '2019-05-17 13:52:27.927000', '2781.00'),
(1386, '2019-05-17 13:52:34.075000', '2787.00'),
(1389, '2019-05-17 13:52:40.186000', '1862.00'),
(1392, '2019-05-17 13:52:48.398000', '2266.00'),
(1395, '2019-05-17 13:52:54.491000', '2790.00'),
(1398, '2019-05-17 13:53:00.579000', '2787.00'),
(1401, '2019-05-17 13:53:08.731000', '2766.00'),
(1404, '2019-05-17 13:53:14.861000', '2797.00'),
(1407, '2019-05-17 13:53:20.951000', '2800.00'),
(1410, '2019-05-17 13:53:27.099000', '2797.00'),
(1413, '2019-05-17 13:53:33.334000', '2799.00'),
(1416, '2019-05-17 13:53:39.473000', '2767.00'),
(1419, '2019-05-17 13:53:45.578000', '2500.00'),
(1422, '2019-05-17 13:53:53.747000', '2788.00'),
(1425, '2019-05-17 13:53:59.876000', '2775.00'),
(1428, '2019-05-17 13:54:08.011000', '2786.00'),
(1431, '2019-05-17 13:54:12.108000', '2783.00'),
(1434, '2019-05-17 13:54:18.264000', '2783.00'),
(1437, '2019-05-17 13:54:26.387000', '2800.00'),
(1440, '2019-05-17 13:54:32.533000', '2802.00'),
(1443, '2019-05-17 13:54:38.690000', '2800.00'),
(1446, '2019-05-17 13:54:44.795000', '2786.00'),
(1449, '2019-05-17 13:54:52.941000', '2762.00'),
(1452, '2019-05-17 13:54:59.040000', '2776.00'),
(1455, '2019-05-17 13:55:05.272000', '2758.00'),
(1458, '2019-05-17 13:55:11.592000', '2742.00'),
(1461, '2019-05-17 13:55:17.823000', '2743.00'),
(1464, '2019-05-17 13:55:24.107000', '2731.00'),
(1467, '2019-05-17 13:55:30.183000', '2717.00'),
(1470, '2019-05-17 13:55:38.307000', '2702.00'),
(1473, '2019-05-17 13:55:44.508000', '2671.00'),
(1476, '2019-05-17 13:55:50.626000', '2692.00'),
(1479, '2019-05-17 13:55:58.846000', '2713.00'),
(1482, '2019-05-17 13:56:06.969000', '2705.00'),
(1485, '2019-05-17 13:56:11.125000', '2703.00'),
(1488, '2019-05-17 13:56:17.232000', '2696.00'),
(1491, '2019-05-17 13:56:25.377000', '2696.00'),
(1494, '2019-05-17 13:56:31.490000', '2736.00'),
(1497, '2019-05-17 13:56:35.699000', '2744.00'),
(1500, '2019-05-17 13:56:43.908000', '2715.00'),
(1503, '2019-05-17 13:56:49.996000', '2711.00'),
(1506, '2019-05-17 13:56:56.218000', '2717.00'),
(1509, '2019-05-17 13:57:02.307000', '2720.00'),
(1512, '2019-05-17 13:57:08.454000', '2733.00'),
(1515, '2019-05-17 13:57:14.587000', '2763.00'),
(1518, '2019-05-17 13:57:22.750000', '2780.00'),
(1521, '2019-05-17 13:57:28.880000', '2783.00'),
(1524, '2019-05-17 13:57:37.020000', '2809.00'),
(1527, '2019-05-17 13:57:43.098000', '2801.00'),
(1530, '2019-05-17 13:57:49.249000', '2748.00'),
(1533, '2019-05-17 13:57:55.371000', '2774.00'),
(1536, '2019-05-17 13:58:01.476000', '2790.00'),
(1539, '2019-05-17 13:58:07.618000', '2800.00'),
(1542, '2019-05-17 13:58:15.721000', '2801.00'),
(1545, '2019-05-17 13:58:19.807000', '2781.00'),
(1548, '2019-05-17 13:58:28.004000', '2799.00'),
(1551, '2019-05-17 13:58:34.150000', '2812.00'),
(1554, '2019-05-17 13:58:40.257000', '2796.00'),
(1557, '2019-05-17 13:58:46.387000', '2775.00'),
(1560, '2019-05-17 13:58:52.488000', '2792.00'),
(1563, '2019-05-17 13:59:00.680000', '2790.00'),
(1566, '2019-05-17 13:59:06.803000', '2796.00'),
(1569, '2019-05-17 13:59:13.008000', '2812.00'),
(1572, '2019-05-17 13:59:19.100000', '2790.00'),
(1575, '2019-05-17 13:59:27.333000', '2810.00'),
(1578, '2019-05-17 13:59:33.457000', '2817.00'),
(1581, '2019-05-17 13:59:39.551000', '2825.00'),
(1584, '2019-05-17 13:59:45.726000', '2814.00'),
(1587, '2019-05-17 13:59:51.861000', '2822.00'),
(1590, '2019-05-17 13:59:58.177000', '2789.00'),
(1593, '2019-05-17 14:00:06.345000', '2767.00'),
(1596, '2019-05-17 14:00:12.509000', '2781.00'),
(1599, '2019-05-17 14:00:18.600000', '2780.00'),
(1602, '2019-05-17 14:00:24.748000', '2831.00'),
(1605, '2019-05-17 14:00:30.895000', '2827.00'),
(1608, '2019-05-17 14:00:37.089000', '2792.00'),
(1611, '2019-05-17 14:00:45.273000', '2800.00'),
(1614, '2019-05-17 14:00:51.609000', '2768.00'),
(1617, '2019-05-17 14:00:57.695000', '2733.00'),
(1620, '2019-05-17 14:01:05.869000', '2734.00'),
(1623, '2019-05-17 14:01:09.995000', '2807.00'),
(1626, '2019-05-17 14:01:20.154000', '2771.00'),
(1629, '2019-05-17 14:01:24.264000', '2812.00'),
(1632, '2019-05-17 14:01:30.510000', '2793.00'),
(1635, '2019-05-17 14:01:36.687000', '2795.00'),
(1638, '2019-05-17 14:01:42.881000', '2818.00'),
(1641, '2019-05-17 14:01:49.048000', '2754.00'),
(1644, '2019-05-17 14:01:57.213000', '2764.00'),
(1647, '2019-05-17 14:02:03.369000', '2768.00'),
(1650, '2019-05-17 14:02:09.558000', '2782.00'),
(1653, '2019-05-17 14:02:15.770000', '2805.00'),
(1656, '2019-05-17 14:02:22.385000', '2802.00'),
(1659, '2019-05-17 14:02:34.683000', '2790.00'),
(1662, '2019-05-17 14:02:36.814000', '2787.00'),
(1665, '2019-05-17 14:02:42.978000', '2791.00'),
(1668, '2019-05-17 14:02:49.138000', '2795.00'),
(1671, '2019-05-17 14:02:55.272000', '2810.00'),
(1674, '2019-05-17 14:03:01.360000', '2821.00'),
(1677, '2019-05-17 14:03:11.489000', '2829.00'),
(1680, '2019-05-17 14:03:15.672000', '2830.00'),
(1683, '2019-05-17 14:03:21.858000', '2819.00'),
(1686, '2019-05-17 14:03:27.950000', '2815.00'),
(1689, '2019-05-17 14:03:36.102000', '2818.00'),
(1692, '2019-05-17 14:03:42.252000', '2795.00'),
(1695, '2019-05-17 14:03:48.345000', '2775.00'),
(1698, '2019-05-17 14:03:54.475000', '2792.00'),
(1701, '2019-05-17 14:04:00.615000', '2808.00'),
(1704, '2019-05-17 14:04:06.740000', '2772.00'),
(1707, '2019-05-17 14:04:14.834000', '2764.00'),
(1710, '2019-05-17 14:04:20.963000', '2763.00'),
(1713, '2019-05-17 14:04:27.138000', '2799.00'),
(1716, '2019-05-17 14:04:33.267000', '2816.00'),
(1719, '2019-05-17 14:04:39.441000', '2817.00'),
(1722, '2019-05-17 14:04:47.549000', '2818.00'),
(1725, '2019-05-17 14:04:53.722000', '2792.00'),
(1728, '2019-05-17 14:04:59.891000', '2815.00'),
(1731, '2019-05-17 14:05:08.168000', '2816.00'),
(1734, '2019-05-17 14:05:12.341000', '2790.00'),
(1737, '2019-05-17 14:05:18.579000', '2812.00'),
(1740, '2019-05-17 14:05:26.752000', '2767.00'),
(1743, '2019-05-17 14:05:33.002000', '2813.00'),
(1746, '2019-05-17 14:05:39.166000', '2791.00'),
(1749, '2019-05-17 14:05:45.303000', '2768.00'),
(1752, '2019-05-17 14:05:53.455000', '2747.00'),
(1755, '2019-05-17 14:05:59.653000', '2788.00'),
(1758, '2019-05-17 14:06:05.744000', '2765.00'),
(1761, '2019-05-17 14:06:11.842000', '2798.00'),
(1764, '2019-05-17 14:06:17.934000', '2820.00'),
(1767, '2019-05-17 14:06:28.082000', '2822.00'),
(1770, '2019-05-17 14:06:30.206000', '2789.00'),
(1773, '2019-05-17 14:06:38.337000', '2796.00'),
(1776, '2019-05-17 14:06:44.469000', '2780.00'),
(1779, '2019-05-17 14:06:50.633000', '2824.00'),
(1782, '2019-05-17 14:06:56.811000', '2803.00'),
(1785, '2019-05-17 14:07:03.105000', '2802.00'),
(1788, '2019-05-17 14:07:09.212000', '2810.00'),
(1791, '2019-05-17 14:07:17.376000', '2802.00'),
(1794, '2019-05-17 14:07:23.502000', '2821.00'),
(1797, '2019-05-17 14:07:29.695000', '2805.00'),
(1800, '2019-05-17 14:07:37.825000', '2808.00'),
(1803, '2019-05-17 14:07:44.021000', '2836.00'),
(1806, '2019-05-17 14:07:50.203000', '2832.00'),
(1809, '2019-05-17 14:07:56.502000', '2829.00'),
(1812, '2019-05-17 14:08:02.640000', '2792.00'),
(1815, '2019-05-17 14:08:10.806000', '2818.00'),
(1818, '2019-05-17 14:08:14.902000', '2844.00'),
(1821, '2019-05-17 14:08:21.071000', '2851.00'),
(1824, '2019-05-17 14:08:29.273000', '2830.00'),
(1827, '2019-05-17 14:08:35.598000', '2829.00'),
(1830, '2019-05-17 14:08:41.722000', '2812.00'),
(1833, '2019-05-17 14:08:47.856000', '2781.00'),
(1836, '2019-05-17 14:08:53.995000', '2779.00'),
(1839, '2019-05-17 14:09:02.164000', '2757.00'),
(1842, '2019-05-17 14:09:08.398000', '2744.00'),
(1845, '2019-05-17 14:09:14.515000', '2726.00'),
(1848, '2019-05-17 14:09:20.705000', '2748.00'),
(1851, '2019-05-17 14:09:26.843000', '2732.00'),
(1854, '2019-05-17 14:09:35.005000', '2710.00'),
(1857, '2019-05-17 14:09:41.221000', '2722.00'),
(1860, '2019-05-17 14:09:47.358000', '2725.00'),
(1863, '2019-05-17 14:09:53.537000', '2748.00'),
(1866, '2019-05-17 14:09:59.778000', '2799.00'),
(1869, '2019-05-17 14:10:09.944000', '2836.00'),
(1872, '2019-05-17 14:10:14.112000', '2809.00'),
(1875, '2019-05-17 14:10:20.251000', '2855.00'),
(1878, '2019-05-17 14:10:26.446000', '2824.00'),
(1881, '2019-05-17 14:10:32.590000', '2814.00'),
(1884, '2019-05-17 14:10:40.764000', '2829.00'),
(1887, '2019-05-17 14:10:44.951000', '2810.00'),
(1890, '2019-05-17 14:10:53.094000', '2842.00'),
(1893, '2019-05-17 14:10:59.309000', '2831.00'),
(1896, '2019-05-17 14:11:05.489000', '2816.00'),
(1899, '2019-05-17 14:11:11.682000', '2816.00'),
(1902, '2019-05-17 14:11:17.839000', '2839.00'),
(1905, '2019-05-17 14:11:25.985000', '2828.00'),
(1908, '2019-05-17 14:11:32.145000', '2828.00'),
(1911, '2019-05-17 14:11:38.257000', '2854.00'),
(1914, '2019-05-17 14:11:44.422000', '2846.00'),
(1917, '2019-05-17 14:11:52.577000', '2782.00'),
(1920, '2019-05-17 14:11:56.719000', '2738.00'),
(1923, '2019-05-17 14:12:05.016000', '2792.00'),
(1926, '2019-05-17 14:12:45.661000', '2795.00'),
(1929, '2019-05-17 14:12:53.808000', '2707.00'),
(1932, '2019-05-17 14:13:02.013000', '2704.00'),
(1935, '2019-05-17 14:13:04.142000', '2668.00'),
(1938, '2019-05-17 14:13:12.292000', '2654.00'),
(1941, '2019-05-17 14:13:18.622000', '2670.00'),
(1944, '2019-05-17 14:13:24.756000', '2669.00'),
(1947, '2019-05-17 14:13:30.945000', '2663.00'),
(1950, '2019-05-17 14:13:37.066000', '2627.00'),
(1953, '2019-05-17 14:13:43.176000', '2700.00'),
(1956, '2019-05-17 14:13:51.328000', '2693.00'),
(1959, '2019-05-17 14:13:57.468000', '2602.00'),
(1962, '2019-05-17 14:14:03.587000', '2523.00'),
(1965, '2019-05-17 14:14:09.704000', '2590.00'),
(1968, '2019-05-17 14:14:15.840000', '2621.00'),
(1971, '2019-05-17 14:14:23.967000', '2593.00'),
(1974, '2019-05-17 14:14:30.062000', '2569.00'),
(1977, '2019-05-17 14:14:36.151000', '2569.00'),
(1980, '2019-05-17 14:14:44.318000', '682.00'),
(1983, '2019-05-17 14:14:50.421000', '711.00'),
(1986, '2019-05-17 14:14:56.590000', '722.00'),
(1989, '2019-05-17 14:15:02.758000', '2576.00'),
(1992, '2019-05-17 14:15:08.967000', '2552.00'),
(1995, '2019-05-17 14:15:15.183000', '2553.00'),
(1998, '2019-05-17 14:15:23.364000', '2559.00'),
(2001, '2019-05-17 14:15:29.539000', '2639.00'),
(2004, '2019-05-17 14:15:35.665000', '2645.00'),
(2007, '2019-05-17 14:15:43.798000', '2632.00'),
(2010, '2019-05-17 14:15:48.061000', '2662.00'),
(2013, '2019-05-17 14:15:54.261000', '2637.00'),
(2016, '2019-05-17 14:16:00.417000', '1346.00'),
(2019, '2019-05-17 14:16:08.561000', '2630.00'),
(2022, '2019-05-17 14:16:14.702000', '2710.00'),
(2025, '2019-05-17 14:16:20.875000', '2729.00'),
(2028, '2019-05-17 14:16:27.012000', '2749.00'),
(2031, '2019-05-17 14:16:33.147000', '2711.00'),
(2034, '2019-05-17 14:16:41.275000', '2698.00'),
(2037, '2019-05-17 14:17:23.550000', '2706.00'),
(2040, '2019-05-17 14:17:29.668000', '2888.00'),
(2043, '2019-05-17 14:17:35.801000', '2919.00'),
(2046, '2019-05-17 14:17:43.945000', '2895.00'),
(2049, '2019-05-17 14:17:48.079000', '2913.00'),
(2052, '2019-05-17 14:17:56.260000', '2861.00'),
(2055, '2019-05-17 14:18:02.404000', '2860.00'),
(2058, '2019-05-17 14:18:08.540000', '2902.00'),
(2061, '2019-05-17 14:18:16.690000', '2897.00'),
(2064, '2019-05-17 14:18:20.813000', '2845.00'),
(2067, '2019-05-17 14:18:28.932000', '2814.00'),
(2070, '2019-05-17 14:18:35.063000', '2801.00'),
(2073, '2019-05-17 14:18:43.215000', '2870.00'),
(2076, '2019-05-17 14:18:49.431000', '2842.00'),
(2079, '2019-05-17 14:18:53.525000', '2830.00'),
(2082, '2019-05-17 14:19:01.628000', '2807.00'),
(2085, '2019-05-17 14:19:07.756000', '2807.00'),
(2088, '2019-05-17 14:19:13.889000', '2822.00'),
(2091, '2019-05-17 14:19:19.996000', '2861.00'),
(2094, '2019-05-17 14:19:26.078000', '2841.00'),
(2097, '2019-05-17 14:19:34.232000', '2824.00'),
(2100, '2019-05-17 14:19:40.392000', '2790.00'),
(2103, '2019-05-17 14:19:46.532000', '2797.00'),
(2106, '2019-05-17 14:19:52.625000', '2826.00'),
(2109, '2019-05-17 14:19:58.733000', '1141.00'),
(2112, '2019-05-17 14:20:06.839000', '1118.00'),
(2115, '2019-05-17 14:20:13.012000', '1111.00'),
(2118, '2019-05-17 14:20:19.303000', '2790.00'),
(2121, '2019-05-17 14:20:25.584000', '2790.00'),
(2124, '2019-05-17 14:20:31.728000', '2812.00'),
(2127, '2019-05-17 14:20:41.958000', '2824.00'),
(2130, '2019-05-17 14:20:46.098000', '2830.00'),
(2133, '2019-05-17 14:20:52.239000', '1931.00'),
(2136, '2019-05-17 14:20:58.346000', '2895.00'),
(2139, '2019-05-17 14:21:04.479000', '2904.00'),
(2142, '2019-05-17 14:21:10.585000', '1625.00'),
(2145, '2019-05-17 14:21:18.690000', '1114.00'),
(2148, '2019-05-17 14:21:24.829000', '1021.00'),
(2151, '2019-05-17 14:21:30.962000', '2046.00'),
(2154, '2019-05-17 14:21:37.102000', '2875.00'),
(2157, '2019-05-17 14:21:49.255000', '2864.00'),
(2160, '2019-05-17 14:21:51.389000', '2891.00'),
(2163, '2019-05-17 14:21:57.560000', '2896.00'),
(2166, '2019-05-17 14:22:03.699000', '2871.00'),
(2169, '2019-05-17 14:22:09.844000', '2921.00'),
(2172, '2019-05-17 14:22:16.021000', '2891.00'),
(2175, '2019-05-17 14:22:24.136000', '2889.00'),
(2178, '2019-05-17 14:22:30.278000', '2929.00'),
(2181, '2019-05-17 14:22:36.453000', '2865.00'),
(2184, '2019-05-17 14:22:42.598000', '2654.00'),
(2187, '2019-05-17 14:22:52.750000', '2892.00'),
(2190, '2019-05-17 14:22:56.847000', '2856.00'),
(2193, '2019-05-17 14:23:02.940000', '2838.00'),
(2196, '2019-05-17 14:23:09.066000', '2827.00'),
(2199, '2019-05-17 14:23:15.212000', '2854.00'),
(2202, '2019-05-17 14:23:21.355000', '638.00'),
(2205, '2019-05-17 14:23:29.462000', '2899.00'),
(2208, '2019-05-17 14:23:35.606000', '2915.00'),
(2211, '2019-05-17 14:23:41.694000', '2891.00'),
(2214, '2019-05-17 14:23:47.828000', '2896.00'),
(2217, '2019-05-17 14:23:56.073000', '2918.00'),
(2220, '2019-05-17 14:24:02.163000', '2928.00'),
(2223, '2019-05-17 14:24:08.265000', '2940.00'),
(2226, '2019-05-17 14:24:14.410000', '2941.00'),
(2229, '2019-05-17 14:24:20.547000', '2955.00'),
(2232, '2019-05-17 14:24:28.686000', '2964.00'),
(2235, '2019-05-17 14:24:34.814000', '2959.00'),
(2238, '2019-05-17 14:24:40.944000', '2935.00'),
(2241, '2019-05-17 14:24:47.040000', '2945.00'),
(2244, '2019-05-17 14:24:53.178000', '2961.00'),
(2247, '2019-05-17 14:24:59.318000', '2981.00'),
(2250, '2019-05-17 14:25:07.423000', '2950.00'),
(2253, '2019-05-17 14:25:13.568000', '2968.00'),
(2256, '2019-05-17 14:25:19.707000', '2973.00'),
(2259, '2019-05-17 14:25:25.924000', '2952.00'),
(2262, '2019-05-17 14:25:34.028000', '2979.00'),
(2265, '2019-05-17 14:25:40.151000', '2960.00'),
(2268, '2019-05-17 14:25:46.256000', '2972.00'),
(2271, '2019-05-17 14:25:52.356000', '2965.00'),
(2274, '2019-05-17 14:26:00.570000', '2968.00'),
(2277, '2019-05-17 14:26:04.657000', '2955.00'),
(2280, '2019-05-17 14:26:12.795000', '2969.00'),
(2283, '2019-05-17 14:26:18.923000', '2919.00'),
(2286, '2019-05-17 14:26:25.055000', '2912.00'),
(2289, '2019-05-17 14:26:31.199000', '2935.00'),
(2292, '2019-05-17 14:26:37.333000', '2971.00'),
(2295, '2019-05-17 14:26:45.474000', '2972.00'),
(2298, '2019-05-17 14:26:51.639000', '2927.00'),
(2301, '2019-05-17 14:26:57.770000', '2940.00'),
(2304, '2019-05-17 14:27:05.914000', '2945.00'),
(2307, '2019-05-17 14:27:12.063000', '2931.00'),
(2310, '2019-05-17 14:27:18.210000', '2952.00'),
(2313, '2019-05-17 14:27:24.305000', '2970.00'),
(2316, '2019-05-17 14:27:32.455000', '2977.00'),
(2319, '2019-05-17 14:27:36.596000', '2978.00'),
(2322, '2019-05-17 14:27:42.690000', '2944.00'),
(2325, '2019-05-17 14:27:48.827000', '2225.00'),
(2328, '2019-05-17 14:27:56.994000', '1180.00'),
(2331, '2019-05-17 14:28:03.090000', '1916.00'),
(2334, '2019-05-17 14:28:11.258000', '2971.00'),
(2337, '2019-05-17 14:28:15.429000', '2964.00'),
(2340, '2019-05-17 14:28:23.587000', '2981.00'),
(2343, '2019-05-17 14:28:29.833000', '2984.00'),
(2346, '2019-05-17 14:28:38.050000', '2937.00'),
(2349, '2019-05-17 14:28:44.163000', '2933.00'),
(2352, '2019-05-17 14:28:50.286000', '2904.00'),
(2355, '2019-05-17 14:28:54.476000', '2879.00'),
(2358, '2019-05-17 14:29:02.790000', '2889.00'),
(2361, '2019-05-17 14:29:08.921000', '2868.00'),
(2364, '2019-05-17 14:29:15.113000', '2810.00'),
(2367, '2019-05-17 14:29:59.417000', '2810.00'),
(2370, '2019-05-17 14:30:05.592000', '2814.00'),
(2373, '2019-05-17 14:30:11.729000', '2819.00'),
(2376, '2019-05-17 14:30:17.951000', '2814.00'),
(2379, '2019-05-17 14:30:26.096000', '2821.00'),
(2382, '2019-05-17 14:30:32.234000', '2822.00'),
(2385, '2019-05-17 14:30:38.382000', '2835.00'),
(2388, '2019-05-17 14:30:44.634000', '2863.00'),
(2391, '2019-05-17 14:30:50.787000', '2869.00'),
(2394, '2019-05-17 14:30:56.948000', '2859.00'),
(2397, '2019-05-17 14:31:03.097000', '2843.00'),
(2400, '2019-05-17 14:31:11.220000', '2838.00'),
(2403, '2019-05-17 14:31:17.358000', '2853.00'),
(2406, '2019-05-17 14:31:23.486000', '2867.00'),
(2409, '2019-05-17 14:31:49.705000', '2857.00'),
(2412, '2019-05-17 14:31:55.844000', '2736.00'),
(2415, '2019-05-17 14:32:02.003000', '2749.00'),
(2418, '2019-05-17 14:32:08.096000', '2707.00'),
(2421, '2019-05-17 14:32:14.191000', '2764.00'),
(2424, '2019-05-17 14:32:20.330000', '2785.00'),
(2427, '2019-05-17 14:32:28.500000', '2801.00'),
(2430, '2019-05-17 14:32:34.620000', '2802.00'),
(2433, '2019-05-17 14:32:40.757000', '2813.00'),
(2436, '2019-05-17 14:32:46.886000', '2830.00'),
(2439, '2019-05-17 14:32:52.990000', '2832.00'),
(2442, '2019-05-17 14:33:01.091000', '2829.00'),
(2445, '2019-05-17 14:33:09.245000', '2825.00'),
(2448, '2019-05-17 14:33:15.494000', '2832.00'),
(2451, '2019-05-17 14:33:21.621000', '2806.00'),
(2454, '2019-05-17 15:20:41.420000', '2801.00'),
(2457, '2019-05-17 15:20:47.726000', '2793.00'),
(2460, '2019-05-17 15:20:53.966000', '2816.00'),
(2463, '2019-05-17 15:21:00.164000', '2812.00'),
(2466, '2019-05-17 15:21:06.334000', '2817.00'),
(2469, '2019-05-17 15:21:12.565000', '2812.00'),
(2472, '2019-05-17 15:21:20.725000', '2805.00'),
(2475, '2019-05-17 15:21:26.878000', '2808.00'),
(2478, '2019-05-17 15:21:33.034000', '2816.00'),
(2481, '2019-05-17 15:21:39.448000', '2789.00'),
(2484, '2019-05-17 15:21:45.614000', '2794.00'),
(2487, '2019-05-17 15:21:51.795000', '2783.00'),
(2490, '2019-05-17 15:22:00.025000', '2762.00'),
(2493, '2019-05-17 15:22:06.168000', '2775.00'),
(2496, '2019-05-17 15:22:12.320000', '2777.00'),
(2499, '2019-05-17 15:22:18.471000', '2772.00'),
(2502, '2019-05-17 15:22:24.629000', '2781.00'),
(2505, '2019-05-17 15:22:30.810000', '2792.00'),
(2508, '2019-05-17 15:22:37.021000', '2799.00'),
(2511, '2019-05-17 15:22:45.183000', '2792.00'),
(2514, '2019-05-17 15:22:51.361000', '2803.00'),
(2517, '2019-05-17 15:22:57.570000', '2794.00'),
(2520, '2019-05-17 15:23:03.781000', '2789.00'),
(2523, '2019-05-17 15:23:10.001000', '2780.00'),
(2526, '2019-05-17 15:23:16.284000', '2755.00'),
(2529, '2019-05-17 15:23:24.423000', '2783.00'),
(2532, '2019-05-17 15:23:30.572000', '2807.00'),
(2535, '2019-05-17 15:23:36.710000', '2784.00'),
(2538, '2019-05-17 15:23:42.860000', '2753.00'),
(2541, '2019-05-17 15:29:42.845000', '2765.00'),
(2544, '2019-05-17 15:29:48.996000', '2923.00'),
(2547, '2019-05-17 15:29:55.111000', '2987.00'),
(2550, '2019-05-17 15:30:03.240000', '2986.00'),
(2553, '2019-05-17 15:30:09.383000', '2982.00'),
(2556, '2019-05-17 15:30:15.527000', '2991.00'),
(2559, '2019-05-17 15:30:21.670000', '2998.00'),
(2562, '2019-05-17 15:30:29.902000', '3007.00'),
(2565, '2019-05-17 15:30:36.042000', '2994.00'),
(2568, '2019-05-17 15:30:42.138000', '2971.00'),
(2571, '2019-05-17 15:30:48.241000', '3022.00'),
(2574, '2019-05-17 15:30:56.341000', '3023.00'),
(2577, '2019-05-17 15:31:02.484000', '3022.00'),
(2580, '2019-05-17 15:31:10.628000', '2999.00'),
(2583, '2019-05-17 15:31:14.750000', '2976.00'),
(2586, '2019-05-17 15:31:20.896000', '3001.00'),
(2589, '2019-05-17 15:31:27.046000', '3000.00'),
(2592, '2019-05-17 15:31:35.208000', '3000.00'),
(2595, '2019-05-17 15:31:39.394000', '2974.00'),
(2598, '2019-05-17 15:31:47.578000', '3024.00'),
(2601, '2019-05-17 16:01:49.332000', '3001.00'),
(2604, '2019-05-17 16:01:55.624000', '3075.00'),
(2607, '2019-05-17 16:02:01.788000', '3074.00'),
(2610, '2019-05-17 16:02:07.944000', '1513.00'),
(2613, '2019-05-17 16:02:16.083000', '3118.00'),
(2616, '2019-05-17 16:02:22.238000', '3069.00'),
(2619, '2019-05-17 16:02:28.604000', '3082.00'),
(2622, '2019-05-17 16:02:34.717000', '3040.00'),
(2625, '2019-05-17 16:02:40.862000', '3031.00'),
(2628, '2019-05-17 16:02:49.205000', '3032.00'),
(2631, '2019-05-17 16:02:55.400000', '3030.00'),
(2634, '2019-05-17 16:03:01.582000', '3030.00'),
(2637, '2019-05-17 16:03:07.747000', '3030.00'),
(2640, '2019-05-17 16:03:13.891000', '3011.00'),
(2643, '2019-05-17 16:03:20.039000', '3019.00'),
(2646, '2019-05-17 16:03:28.185000', '3024.00'),
(2649, '2019-05-17 16:03:34.287000', '2688.00'),
(2652, '2019-05-17 16:03:40.442000', '2352.00'),
(2655, '2019-05-17 16:03:46.597000', '3067.00'),
(2658, '2019-05-17 16:03:52.699000', '3094.00'),
(2661, '2019-05-17 16:03:58.856000', '3121.00'),
(2664, '2019-05-17 16:04:06.991000', '3109.00'),
(2667, '2019-05-17 16:04:13.152000', '1528.00'),
(2670, '2019-05-17 16:04:19.304000', '0.00'),
(2673, '2019-05-17 16:04:25.457000', '0.00'),
(2676, '2019-05-17 16:04:31.636000', '0.00'),
(2679, '2019-05-17 16:04:39.766000', '0.00'),
(2682, '2019-05-17 16:04:45.872000', '1573.00'),
(2685, '2019-05-17 16:04:52.027000', '3151.00'),
(2688, '2019-05-17 16:04:58.191000', '3153.00'),
(2691, '2019-05-17 16:05:04.356000', '3155.00'),
(2694, '2019-05-17 16:05:10.528000', '3158.00'),
(2697, '2019-05-17 16:05:18.750000', '3160.00'),
(2700, '2019-05-17 16:05:27.059000', '3160.00'),
(2703, '2019-05-17 16:05:31.171000', '1581.00'),
(2706, '2019-05-17 16:05:37.293000', '0.00'),
(2709, '2019-05-17 16:05:43.434000', '0.00'),
(2712, '2019-05-17 16:05:51.574000', '0.00'),
(2715, '2019-05-17 16:05:57.724000', '0.00'),
(2718, '2019-05-17 16:06:03.858000', '0.00'),
(2721, '2019-05-17 16:06:10.036000', '0.00'),
(2724, '2019-05-17 16:06:16.216000', '0.00'),
(2727, '2019-05-17 16:06:22.338000', '0.00'),
(2730, '2019-05-17 16:06:30.444000', '0.00'),
(2733, '2019-05-17 16:06:36.591000', '0.00'),
(2736, '2019-05-17 16:06:42.717000', '0.00'),
(2739, '2019-05-17 16:06:48.931000', '0.00'),
(2742, '2019-05-17 16:06:55.112000', '0.00'),
(2745, '2019-05-17 16:07:03.271000', '0.00'),
(2748, '2019-05-17 16:07:09.417000', '0.00'),
(2751, '2019-05-17 16:07:15.553000', '0.00'),
(2754, '2019-05-17 16:07:21.693000', '0.00'),
(2757, '2019-05-17 16:07:27.844000', '0.00'),
(2760, '2019-05-17 16:07:48.021000', '0.00'),
(2764, '2019-05-17 16:07:48.136000', '0.00'),
(2767, '2019-05-17 16:07:50.202000', '0.00'),
(2770, '2019-05-17 16:07:56.311000', '0.00'),
(2773, '2019-05-17 16:08:04.434000', '0.00'),
(2776, '2019-05-17 16:08:10.586000', '0.00'),
(2779, '2019-05-17 16:09:49.240000', '1544.00'),
(2782, '2019-05-17 16:09:55.437000', '3115.00'),
(2785, '2019-05-17 16:10:01.596000', '3092.00'),
(2788, '2019-05-17 16:10:07.704000', '3100.00'),
(2791, '2019-05-17 16:10:13.835000', '1535.00'),
(2794, '2019-05-17 16:10:21.968000', '0.00'),
(2797, '2019-05-17 16:10:28.135000', '0.00'),
(2800, '2019-05-17 16:10:34.300000', '0.00'),
(2803, '2019-05-17 16:10:40.440000', '0.00'),
(2806, '2019-05-17 16:10:46.724000', '0.00'),
(2809, '2019-05-17 16:10:54.880000', '0.00'),
(2812, '2019-05-17 16:11:01.074000', '0.00'),
(2815, '2019-05-17 16:11:07.239000', '0.00'),
(2818, '2019-05-17 16:11:13.391000', '0.00'),
(2821, '2019-05-17 16:11:19.541000', '0.00'),
(2824, '2019-05-17 16:11:25.672000', '3157.00'),
(2827, '2019-05-17 16:11:33.811000', '3135.00'),
(2830, '2019-05-17 16:11:39.962000', '3140.00'),
(2833, '2019-05-17 16:11:46.140000', '3169.00'),
(2836, '2019-05-17 16:11:54.334000', '3166.00'),
(2839, '2019-05-17 16:11:58.452000', '3136.00'),
(2842, '2019-05-17 16:12:06.615000', '3114.00'),
(2843, '2019-05-19 19:16:51.000000', '100.00'),
(2844, '2019-05-19 19:17:05.000000', '1100.00'),
(2845, '2019-05-19 19:17:05.000000', '1100.00'),
(2846, '2019-05-19 19:17:15.000000', '1100.00'),
(2847, '2019-05-19 19:17:05.000000', '1103.00'),
(2848, '2019-05-19 19:17:06.000000', '1098.00'),
(2849, '2019-05-19 19:17:06.000000', '1090.00'),
(2850, '2019-05-19 19:17:49.000000', '1100.00'),
(2851, '2019-05-19 19:17:49.000000', '1100.00'),
(2852, '2019-05-19 19:18:19.000000', '1100.00'),
(2853, '2019-05-19 19:17:49.000000', '1103.00'),
(2854, '2019-05-19 19:17:49.000000', '1098.00'),
(2855, '2019-05-19 19:17:49.000000', '1090.00'),
(2856, '2019-05-19 19:19:39.000000', '3600.00'),
(2857, '2019-05-19 19:19:39.000000', '3600.00'),
(2858, '2019-05-19 19:20:10.000000', '3600.00'),
(2859, '2019-05-19 19:19:40.000000', '3603.00'),
(2860, '2019-05-19 19:19:40.000000', '3598.00'),
(2861, '2019-05-19 19:19:40.000000', '3550.00'),
(2862, '2019-05-19 19:22:26.000000', '3600.00'),
(2863, '2019-05-19 19:22:27.000000', '3600.00'),
(2864, '2019-05-19 19:23:27.000000', '3600.00'),
(2865, '2019-05-19 19:22:27.000000', '3603.00'),
(2866, '2019-05-19 19:22:27.000000', '3598.00'),
(2867, '2019-05-19 19:22:27.000000', '3550.00'),
(2868, '2019-05-19 19:23:18.000000', '3600.00'),
(2869, '2019-05-19 19:23:18.000000', '3600.00'),
(2870, '2019-05-19 19:24:18.000000', '3600.00'),
(2871, '2019-05-19 19:23:18.000000', '3603.00'),
(2872, '2019-05-19 19:23:18.000000', '3598.00'),
(2873, '2019-05-19 19:23:18.000000', '3550.00'),
(2874, '2019-05-19 19:23:22.000000', '3600.00'),
(2875, '2019-05-19 19:23:22.000000', '3600.00'),
(2876, '2019-05-19 19:24:23.000000', '3600.00'),
(2877, '2019-05-19 19:23:23.000000', '3603.00'),
(2878, '2019-05-19 19:23:23.000000', '3598.00'),
(2879, '2019-05-19 19:23:23.000000', '3550.00'),
(2880, '2019-05-19 19:26:06.000000', '3625.00'),
(2881, '2019-05-19 19:26:07.000000', '3625.00'),
(2882, '2019-05-19 19:27:07.000000', '3625.00'),
(2883, '2019-05-19 19:26:07.000000', '3622.00'),
(2884, '2019-05-19 19:26:07.000000', '3627.00'),
(2885, '2019-05-19 19:26:07.000000', '3650.00'),
(2886, '2019-05-19 19:31:49.000000', '3625.00'),
(2887, '2019-05-19 19:31:49.000000', '3625.00'),
(2888, '2019-05-19 19:30:49.000000', '3625.00'),
(2889, '2019-05-19 19:31:49.000000', '3622.00'),
(2890, '2019-05-19 19:31:49.000000', '3627.00'),
(2891, '2019-05-19 19:31:49.000000', '3650.00'),
(2892, '2019-05-19 20:54:33.000000', '3600.00'),
(2893, '2019-05-19 20:54:33.000000', '3600.00'),
(2894, '2019-05-19 20:55:03.000000', '3600.00'),
(2895, '2019-05-19 20:54:33.000000', '3650.00'),
(2896, '2019-05-19 20:54:33.000000', '3604.00');

--
-- Triggers `medicoes_luminosidade`
--
DELIMITER $$
CREATE TRIGGER `verificar_luz` BEFORE INSERT ON `medicoes_luminosidade` FOR EACH ROW BEGIN

	SET @id = null;
	SET @min = (SELECT limiteInferiorLuz FROM sistema);
    SET @max = (SELECT limiteSuperiorLuz FROM sistema);
    SET @interval = (SELECT alertaintervalo FROM sistema);
    
    IF NOT EXISTS (SELECT * FROM alerta, sistema
    WHERE alerta.valor <= NEW.valormedicaoluminosidade + sistema.MargemAlertaLuz
    AND alerta.valor >= NEW.valormedicaoluminosidade - sistema.MargemAlertaLuz
    AND alerta.datahora BETWEEN NEW.datahoramedicao - INTERVAL @interval SECOND AND NEW.datahoramedicao + INTERVAL @interval SECOND) THEN
    IF NEW.valormedicaoluminosidade < @min THEN
        INSERT INTO alerta VALUES(@id, "luz", NEW.datahoramedicao, NEW.valormedicaoluminosidade, @min, @max,"valor abaixo do limite");
    ELSEIF NEW.valormedicaoluminosidade > @max THEN
       INSERT INTO alerta VALUES(@id, "luz", NEW.datahoramedicao, NEW.valormedicaoluminosidade, @min, @max,"valor acima do limite");
    END IF;
    END IF;
    
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `medicoes_temperatura`
--

CREATE TABLE `medicoes_temperatura` (
  `IDmedicao` int(11) NOT NULL,
  `DataHoraMedicao` timestamp(6) NULL DEFAULT NULL,
  `ValorMedicaoTemperatura` decimal(8,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `medicoes_temperatura`
--

INSERT INTO `medicoes_temperatura` (`IDmedicao`, `DataHoraMedicao`, `ValorMedicaoTemperatura`) VALUES
(9, '2019-05-17 12:46:53.303000', '13.75'),
(12, '2019-05-17 12:46:58.170000', '27.45'),
(15, '2019-05-17 12:47:04.718000', '27.50'),
(18, '2019-05-17 12:47:12.911000', '27.50'),
(21, '2019-05-17 12:47:19.213000', '27.50'),
(24, '2019-05-17 12:47:25.365000', '27.50'),
(27, '2019-05-17 12:47:31.631000', '27.50'),
(30, '2019-05-17 12:47:37.842000', '27.50'),
(33, '2019-05-17 12:47:44.170000', '27.50'),
(36, '2019-05-17 12:47:50.345000', '27.55'),
(39, '2019-05-17 12:47:58.510000', '27.50'),
(42, '2019-05-17 12:48:04.844000', '27.50'),
(45, '2019-05-17 12:48:11.046000', '27.55'),
(48, '2019-05-17 12:48:17.238000', '27.55'),
(51, '2019-05-17 12:48:23.458000', '27.60'),
(54, '2019-05-17 12:48:31.609000', '27.60'),
(57, '2019-05-17 12:48:35.999000', '27.55'),
(60, '2019-05-17 12:48:44.211000', '27.60'),
(63, '2019-05-17 12:48:50.373000', '27.60'),
(66, '2019-05-17 12:48:56.507000', '27.70'),
(69, '2019-05-17 12:49:02.705000', '27.60'),
(72, '2019-05-17 12:49:08.898000', '27.60'),
(75, '2019-05-17 12:49:15.082000', '27.60'),
(78, '2019-05-17 12:49:23.333000', '27.60'),
(81, '2019-05-17 12:49:29.534000', '27.60'),
(84, '2019-05-17 12:49:35.842000', '27.60'),
(87, '2019-05-17 12:49:42.008000', '27.60'),
(90, '2019-05-17 12:49:48.284000', '27.70'),
(93, '2019-05-17 12:49:54.402000', '27.65'),
(96, '2019-05-17 12:50:02.601000', '27.70'),
(99, '2019-05-17 12:50:08.939000', '28.40'),
(102, '2019-05-17 12:50:15.155000', '28.40'),
(105, '2019-05-17 12:50:21.335000', '28.00'),
(108, '2019-05-17 12:50:27.459000', '27.70'),
(111, '2019-05-17 12:50:33.729000', '27.70'),
(114, '2019-05-17 12:50:41.907000', '27.70'),
(117, '2019-05-17 12:50:48.173000', '27.70'),
(120, '2019-05-17 12:50:54.339000', '27.70'),
(123, '2019-05-17 12:51:00.538000', '27.70'),
(126, '2019-05-17 12:51:06.937000', '27.70'),
(129, '2019-05-17 12:51:13.117000', '27.70'),
(132, '2019-05-17 12:51:19.288000', '27.70'),
(135, '2019-05-17 12:51:27.393000', '27.70'),
(138, '2019-05-17 12:51:33.681000', '27.70'),
(141, '2019-05-17 12:51:39.867000', '27.65'),
(144, '2019-05-17 12:51:46.031000', '27.70'),
(147, '2019-05-17 12:51:52.164000', '27.70'),
(150, '2019-05-17 12:52:00.298000', '27.70'),
(153, '2019-05-17 12:52:06.460000', '27.70'),
(156, '2019-05-17 12:52:12.762000', '27.70'),
(159, '2019-05-17 12:52:18.887000', '27.70'),
(162, '2019-05-17 12:52:25.077000', '27.70'),
(165, '2019-05-17 12:52:31.233000', '27.70'),
(168, '2019-05-17 12:52:39.311000', '27.70'),
(171, '2019-05-17 12:52:45.480000', '27.70'),
(174, '2019-05-17 12:52:51.623000', '27.70'),
(177, '2019-05-17 12:52:57.756000', '27.70'),
(180, '2019-05-17 12:53:05.856000', '27.75'),
(183, '2019-05-17 12:53:12.059000', '27.80'),
(186, '2019-05-17 12:53:18.279000', '27.80'),
(189, '2019-05-17 12:53:24.558000', '27.80'),
(192, '2019-05-17 12:53:30.706000', '27.85'),
(195, '2019-05-17 12:53:36.868000', '27.90'),
(198, '2019-05-17 12:53:45.075000', '27.90'),
(201, '2019-05-17 12:53:51.258000', '27.90'),
(204, '2019-05-17 12:53:57.018000', '27.90'),
(207, '2019-05-17 12:54:03.628000', '27.95'),
(210, '2019-05-17 12:54:09.818000', '28.00'),
(213, '2019-05-17 12:54:15.963000', '28.00'),
(216, '2019-05-17 12:54:22.070000', '28.00'),
(219, '2019-05-17 12:54:30.350000', '28.00'),
(222, '2019-05-17 12:54:36.476000', '28.00'),
(225, '2019-05-17 12:54:42.621000', '28.00'),
(228, '2019-05-17 12:54:48.779000', '28.05'),
(231, '2019-05-17 12:54:56.980000', '28.05'),
(234, '2019-05-17 12:55:01.161000', '28.00'),
(237, '2019-05-17 12:55:09.374000', '28.05'),
(240, '2019-05-17 12:55:15.495000', '28.10'),
(243, '2019-05-17 12:55:21.678000', '28.10'),
(246, '2019-05-17 12:55:27.879000', '28.10'),
(249, '2019-05-17 12:55:34.067000', '28.10'),
(252, '2019-05-17 12:55:42.310000', '28.10'),
(255, '2019-05-17 12:55:48.595000', '28.20'),
(258, '2019-05-17 12:55:54.731000', '28.20'),
(261, '2019-05-17 12:56:00.909000', '28.20'),
(264, '2019-05-17 12:56:09.108000', '28.20'),
(267, '2019-05-17 12:56:13.295000', '28.20'),
(270, '2019-05-17 12:56:21.968000', '28.20'),
(273, '2019-05-17 12:56:28.126000', '28.20'),
(276, '2019-05-17 12:56:34.336000', '28.20'),
(279, '2019-05-17 12:56:40.515000', '28.20'),
(282, '2019-05-17 12:56:46.665000', '28.20'),
(285, '2019-05-17 12:56:52.842000', '28.20'),
(288, '2019-05-17 12:56:59.056000', '28.20'),
(291, '2019-05-17 12:57:07.206000', '28.20'),
(294, '2019-05-17 12:57:13.382000', '28.20'),
(297, '2019-05-17 12:57:19.554000', '28.20'),
(300, '2019-05-17 12:57:25.791000', '28.20'),
(303, '2019-05-17 12:57:33.955000', '28.20'),
(306, '2019-05-17 12:57:38.191000', '28.20'),
(309, '2019-05-17 12:57:46.431000', '28.20'),
(312, '2019-05-17 12:57:52.590000', '28.20'),
(315, '2019-05-17 12:57:58.832000', '28.20'),
(318, '2019-05-17 12:58:07.031000', '28.20'),
(321, '2019-05-17 12:58:11.215000', '28.20'),
(324, '2019-05-17 12:58:17.505000', '28.20'),
(327, '2019-05-17 12:58:23.647000', '28.20'),
(330, '2019-05-17 12:58:31.911000', '28.20'),
(333, '2019-05-17 12:58:38.104000', '28.20'),
(336, '2019-05-17 12:58:44.681000', '28.25'),
(339, '2019-05-17 12:58:51.027000', '28.25'),
(342, '2019-05-17 12:58:57.366000', '28.30'),
(345, '2019-05-17 12:59:05.510000', '28.30'),
(348, '2019-05-17 12:59:09.633000', '28.30'),
(351, '2019-05-17 12:59:17.798000', '28.35'),
(354, '2019-05-17 12:59:23.934000', '28.40'),
(357, '2019-05-17 12:59:30.156000', '28.45'),
(360, '2019-05-17 12:59:38.364000', '28.45'),
(363, '2019-05-17 12:59:42.482000', '28.50'),
(366, '2019-05-17 12:59:50.578000', '28.50'),
(369, '2019-05-17 12:59:56.699000', '28.70'),
(372, '2019-05-17 13:00:02.905000', '28.70'),
(375, '2019-05-17 13:00:08.997000', '28.70'),
(378, '2019-05-17 13:00:15.184000', '28.70'),
(381, '2019-05-17 13:00:21.459000', '28.70'),
(384, '2019-05-17 13:00:29.558000', '28.65'),
(387, '2019-05-17 13:00:35.739000', '28.60'),
(390, '2019-05-17 13:00:41.884000', '28.65'),
(393, '2019-05-17 13:00:47.986000', '28.60'),
(396, '2019-05-17 13:00:54.130000', '28.70'),
(399, '2019-05-17 13:01:02.289000', '28.80'),
(402, '2019-05-17 13:01:08.449000', '28.80'),
(405, '2019-05-17 13:01:14.555000', '28.80'),
(408, '2019-05-17 13:01:20.946000', '28.80'),
(411, '2019-05-17 13:01:27.071000', '28.80'),
(414, '2019-05-17 13:01:33.150000', '28.80'),
(417, '2019-05-17 13:01:41.589000', '28.90'),
(420, '2019-05-17 13:01:47.807000', '29.05'),
(423, '2019-05-17 13:01:55.900000', '29.10'),
(426, '2019-05-17 13:01:59.987000', '29.10'),
(429, '2019-05-17 13:02:08.150000', '29.05'),
(432, '2019-05-17 13:02:14.340000', '29.00'),
(435, '2019-05-17 13:02:20.429000', '28.95'),
(438, '2019-05-17 13:02:26.568000', '29.00'),
(441, '2019-05-17 13:02:32.692000', '28.90'),
(444, '2019-05-17 13:02:38.846000', '28.90'),
(447, '2019-05-17 13:02:46.928000', '28.90'),
(450, '2019-05-17 13:02:53.013000', '28.90'),
(453, '2019-05-17 13:02:59.131000', '28.90'),
(456, '2019-05-17 13:03:05.286000', '28.90'),
(459, '2019-05-17 13:03:11.377000', '28.90'),
(462, '2019-05-17 13:03:19.497000', '28.95'),
(465, '2019-05-17 13:03:25.563000', '28.85'),
(468, '2019-05-17 13:03:31.767000', '28.90'),
(471, '2019-05-17 13:03:37.848000', '28.90'),
(474, '2019-05-17 13:03:44.005000', '28.90'),
(477, '2019-05-17 13:03:52.337000', '28.90'),
(480, '2019-05-17 13:03:58.439000', '28.85'),
(483, '2019-05-17 13:04:04.515000', '28.80'),
(486, '2019-05-17 13:04:10.612000', '28.80'),
(489, '2019-05-17 13:04:16.739000', '28.80'),
(492, '2019-05-17 13:04:24.831000', '28.80'),
(495, '2019-05-17 13:04:30.948000', '28.75'),
(498, '2019-05-17 13:04:37.069000', '28.80'),
(501, '2019-05-17 13:04:43.139000', '28.80'),
(504, '2019-05-17 13:04:49.401000', '28.80'),
(507, '2019-05-17 13:04:57.533000', '28.75'),
(510, '2019-05-17 13:05:03.637000', '28.75'),
(513, '2019-05-17 13:05:09.736000', '28.70'),
(516, '2019-05-17 13:05:15.864000', '28.80'),
(519, '2019-05-17 13:05:23.996000', '28.75'),
(522, '2019-05-17 13:05:30.163000', '28.70'),
(525, '2019-05-17 13:05:36.469000', '28.80'),
(528, '2019-05-17 13:05:42.570000', '28.80'),
(531, '2019-05-17 13:05:48.765000', '28.90'),
(534, '2019-05-17 13:05:54.888000', '29.05'),
(537, '2019-05-17 13:06:01.094000', '29.20'),
(540, '2019-05-17 13:06:09.189000', '29.30'),
(543, '2019-05-17 13:06:15.302000', '29.45'),
(546, '2019-05-17 13:06:21.580000', '29.50'),
(549, '2019-05-17 13:06:27.809000', '29.60'),
(552, '2019-05-17 13:06:35.901000', '29.65'),
(555, '2019-05-17 13:06:41.990000', '29.70'),
(558, '2019-05-17 13:06:48.094000', '29.70'),
(561, '2019-05-17 13:06:54.351000', '29.70'),
(564, '2019-05-17 13:07:00.509000', '29.65'),
(567, '2019-05-17 13:07:06.599000', '29.60'),
(570, '2019-05-17 13:07:12.734000', '29.50'),
(573, '2019-05-17 13:07:20.878000', '29.45'),
(576, '2019-05-17 13:07:27.019000', '29.35'),
(579, '2019-05-17 13:07:33.192000', '29.30'),
(582, '2019-05-17 13:07:39.325000', '29.30'),
(585, '2019-05-17 13:07:45.429000', '29.25'),
(588, '2019-05-17 13:07:53.582000', '29.20'),
(591, '2019-05-17 13:07:59.727000', '29.20'),
(594, '2019-05-17 13:08:05.894000', '29.20'),
(597, '2019-05-17 13:08:12.026000', '29.20'),
(600, '2019-05-17 13:08:18.136000', '29.20'),
(603, '2019-05-17 13:08:26.250000', '29.20'),
(606, '2019-05-17 13:08:32.368000', '29.20'),
(609, '2019-05-17 13:08:38.464000', '29.20'),
(612, '2019-05-17 13:08:44.536000', '29.20'),
(615, '2019-05-17 13:08:50.623000', '29.20'),
(618, '2019-05-17 13:08:58.761000', '29.20'),
(621, '2019-05-17 13:09:04.909000', '29.20'),
(624, '2019-05-17 13:09:11.023000', '29.20'),
(627, '2019-05-17 13:09:17.211000', '29.20'),
(630, '2019-05-17 13:09:25.286000', '29.20'),
(633, '2019-05-17 13:09:31.403000', '29.20'),
(636, '2019-05-17 13:09:39.483000', '29.20'),
(639, '2019-05-17 13:09:45.561000', '29.20'),
(642, '2019-05-17 13:09:49.782000', '29.20'),
(645, '2019-05-17 13:09:57.850000', '29.10'),
(648, '2019-05-17 13:10:03.996000', '29.10'),
(651, '2019-05-17 13:10:10.229000', '29.10'),
(654, '2019-05-17 13:10:16.433000', '29.20'),
(657, '2019-05-17 13:10:22.557000', '29.10'),
(660, '2019-05-17 13:10:30.632000', '29.10'),
(663, '2019-05-17 13:10:36.792000', '29.10'),
(666, '2019-05-17 13:10:42.872000', '29.10'),
(669, '2019-05-17 13:10:48.967000', '29.10'),
(672, '2019-05-17 13:10:55.088000', '29.10'),
(675, '2019-05-17 13:11:03.184000', '29.10'),
(678, '2019-05-17 13:11:09.301000', '29.10'),
(681, '2019-05-17 13:11:15.435000', '29.10'),
(684, '2019-05-17 13:11:21.565000', '29.10'),
(687, '2019-05-17 13:11:29.747000', '29.10'),
(690, '2019-05-17 13:11:35.913000', '29.05'),
(693, '2019-05-17 13:11:41.999000', '29.05'),
(696, '2019-05-17 13:11:48.131000', '29.10'),
(699, '2019-05-17 13:11:54.254000', '29.05'),
(702, '2019-05-17 13:12:02.349000', '29.00'),
(705, '2019-05-17 13:12:08.452000', '29.10'),
(708, '2019-05-17 13:12:14.559000', '29.10'),
(711, '2019-05-17 13:12:22.631000', '29.00'),
(714, '2019-05-17 13:12:28.760000', '29.00'),
(717, '2019-05-17 13:12:33.046000', '29.00'),
(720, '2019-05-17 13:12:41.250000', '29.00'),
(723, '2019-05-17 13:12:47.434000', '29.00'),
(726, '2019-05-17 13:12:53.595000', '29.00'),
(729, '2019-05-17 13:13:01.728000', '28.95'),
(732, '2019-05-17 13:13:07.869000', '28.95'),
(735, '2019-05-17 13:13:14.045000', '28.95'),
(738, '2019-05-17 13:13:20.135000', '28.95'),
(741, '2019-05-17 13:13:26.367000', '29.00'),
(744, '2019-05-17 13:13:32.496000', '28.90'),
(747, '2019-05-17 13:13:38.644000', '28.90'),
(750, '2019-05-17 13:13:44.813000', '28.95'),
(753, '2019-05-17 13:13:52.927000', '29.00'),
(756, '2019-05-17 13:13:59.031000', '29.00'),
(759, '2019-05-17 13:14:05.165000', '28.95'),
(762, '2019-05-17 13:14:11.294000', '28.90'),
(765, '2019-05-17 13:14:19.379000', '28.90'),
(768, '2019-05-17 13:14:25.461000', '28.95'),
(771, '2019-05-17 13:14:31.545000', '28.90'),
(774, '2019-05-17 13:14:37.679000', '28.90'),
(777, '2019-05-17 13:14:43.812000', '28.90'),
(780, '2019-05-17 13:15:26.092000', '28.80'),
(783, '2019-05-17 13:15:32.210000', '28.70'),
(786, '2019-05-17 13:15:38.441000', '28.70'),
(789, '2019-05-17 13:15:44.600000', '28.80'),
(792, '2019-05-17 13:15:50.732000', '28.70'),
(795, '2019-05-17 13:15:58.828000', '28.70'),
(798, '2019-05-17 13:16:04.922000', '28.75'),
(801, '2019-05-17 13:16:11.077000', '28.80'),
(804, '2019-05-17 13:16:17.195000', '28.80'),
(807, '2019-05-17 13:16:23.351000', '28.75'),
(810, '2019-05-17 13:16:31.444000', '28.70'),
(813, '2019-05-17 13:16:37.562000', '28.70'),
(816, '2019-05-17 13:16:43.713000', '28.70'),
(819, '2019-05-17 13:16:51.883000', '28.70'),
(822, '2019-05-17 13:16:56.029000', '28.70'),
(825, '2019-05-17 13:17:04.128000', '28.70'),
(828, '2019-05-17 13:17:10.505000', '28.70'),
(831, '2019-05-17 13:17:16.730000', '28.70'),
(834, '2019-05-17 13:17:22.837000', '28.70'),
(837, '2019-05-17 13:17:28.930000', '28.70'),
(840, '2019-05-17 13:17:35.133000', '28.70'),
(843, '2019-05-17 13:17:43.225000', '28.75'),
(846, '2019-05-17 13:17:49.342000', '28.70'),
(849, '2019-05-17 13:17:55.507000', '28.70'),
(852, '2019-05-17 13:18:01.620000', '28.70'),
(855, '2019-05-17 13:18:09.744000', '28.70'),
(858, '2019-05-17 13:18:15.874000', '28.70'),
(861, '2019-05-17 13:18:22.043000', '28.70'),
(864, '2019-05-17 13:18:28.248000', '28.70'),
(867, '2019-05-17 13:18:34.454000', '28.70'),
(870, '2019-05-17 13:18:40.536000', '28.70'),
(873, '2019-05-17 13:18:48.703000', '28.70'),
(876, '2019-05-17 13:18:54.878000', '28.70'),
(879, '2019-05-17 13:19:00.951000', '28.70'),
(882, '2019-05-17 13:19:07.082000', '28.70'),
(885, '2019-05-17 13:19:13.197000', '28.65'),
(888, '2019-05-17 13:19:21.363000', '28.70'),
(891, '2019-05-17 13:19:27.509000', '28.70'),
(894, '2019-05-17 13:20:09.798000', '28.70'),
(897, '2019-05-17 13:20:15.951000', '28.60'),
(900, '2019-05-17 13:20:22.094000', '28.60'),
(903, '2019-05-17 13:20:28.367000', '28.60'),
(906, '2019-05-17 13:20:36.481000', '28.60'),
(909, '2019-05-17 13:20:42.638000', '28.60'),
(912, '2019-05-17 13:20:48.738000', '28.55'),
(915, '2019-05-17 13:20:54.925000', '28.50'),
(918, '2019-05-17 13:21:01.166000', '28.50'),
(921, '2019-05-17 13:21:07.302000', '28.50'),
(924, '2019-05-17 13:21:15.682000', '28.50'),
(927, '2019-05-17 13:21:21.841000', '28.50'),
(930, '2019-05-17 13:21:28.006000', '28.50'),
(933, '2019-05-17 13:21:36.137000', '28.50'),
(936, '2019-05-17 13:21:40.363000', '28.50'),
(939, '2019-05-17 13:21:46.540000', '28.50'),
(942, '2019-05-17 13:21:54.731000', '28.50'),
(945, '2019-05-17 13:22:00.893000', '28.50'),
(948, '2019-05-17 13:22:57.226000', '28.40'),
(951, '2019-05-17 13:23:05.504000', '28.35'),
(954, '2019-05-17 13:23:11.637000', '28.40'),
(957, '2019-05-17 13:23:17.822000', '28.35'),
(960, '2019-05-17 13:23:23.985000', '28.40'),
(963, '2019-05-17 13:23:30.230000', '28.30'),
(966, '2019-05-17 13:23:36.339000', '28.40'),
(969, '2019-05-17 13:23:42.428000', '28.30'),
(972, '2019-05-17 13:23:48.740000', '28.40'),
(975, '2019-05-17 13:23:56.893000', '28.50'),
(978, '2019-05-17 13:24:03.024000', '28.55'),
(981, '2019-05-17 13:24:09.306000', '28.65'),
(984, '2019-05-17 13:24:15.655000', '28.70'),
(987, '2019-05-17 13:24:21.808000', '28.75'),
(990, '2019-05-17 13:24:29.978000', '28.80'),
(993, '2019-05-17 13:24:36.122000', '28.80'),
(996, '2019-05-17 13:24:42.310000', '28.80'),
(999, '2019-05-17 13:24:48.479000', '28.80'),
(1002, '2019-05-17 13:24:54.605000', '28.80'),
(1005, '2019-05-17 13:25:00.777000', '28.70'),
(1008, '2019-05-17 13:25:08.908000', '28.70'),
(1011, '2019-05-17 13:25:15.074000', '28.70'),
(1014, '2019-05-17 13:25:21.290000', '28.70'),
(1017, '2019-05-17 13:25:27.378000', '28.70'),
(1020, '2019-05-17 13:25:33.820000', '28.65'),
(1023, '2019-05-17 13:25:39.952000', '28.60'),
(1026, '2019-05-17 13:25:48.086000', '28.60'),
(1029, '2019-05-17 13:25:54.390000', '28.55'),
(1032, '2019-05-17 13:26:00.570000', '28.50'),
(1035, '2019-05-17 13:26:08.701000', '28.50'),
(1038, '2019-05-17 13:26:14.830000', '28.50'),
(1041, '2019-05-17 13:26:20.927000', '28.50'),
(1044, '2019-05-17 13:26:27.064000', '28.50'),
(1047, '2019-05-17 13:26:33.175000', '28.50'),
(1050, '2019-05-17 13:26:39.303000', '28.50'),
(1053, '2019-05-17 13:26:45.421000', '28.50'),
(1056, '2019-05-17 13:26:53.520000', '28.50'),
(1059, '2019-05-17 13:26:59.689000', '28.50'),
(1062, '2019-05-17 13:27:05.816000', '28.50'),
(1065, '2019-05-17 13:27:11.961000', '28.50'),
(1068, '2019-05-17 13:27:18.105000', '28.50'),
(1071, '2019-05-17 13:27:26.240000', '28.45'),
(1074, '2019-05-17 13:27:32.323000', '28.45'),
(1077, '2019-05-17 13:27:38.423000', '28.40'),
(1080, '2019-05-17 13:27:44.563000', '28.40'),
(1083, '2019-05-17 13:28:28.765000', '28.40'),
(1086, '2019-05-17 13:28:33.903000', '28.70'),
(1089, '2019-05-17 13:28:41.269000', '28.70'),
(1092, '2019-05-17 13:28:47.705000', '28.70'),
(1095, '2019-05-17 13:28:53.974000', '28.80'),
(1098, '2019-05-17 13:29:01.542000', '28.80'),
(1101, '2019-05-17 13:29:07.764000', '28.80'),
(1104, '2019-05-17 13:29:14.558000', '28.75'),
(1107, '2019-05-17 13:29:20.017000', '28.70'),
(1110, '2019-05-17 13:29:26.902000', '28.70'),
(1113, '2019-05-17 13:29:34.397000', '28.70'),
(1116, '2019-05-17 13:29:40.967000', '28.70'),
(1119, '2019-05-17 13:29:47.212000', '28.70'),
(1122, '2019-05-17 13:29:53.466000', '28.70'),
(1125, '2019-05-17 13:30:01.665000', '28.80'),
(1128, '2019-05-17 13:30:05.886000', '28.90'),
(1131, '2019-05-17 13:30:14.041000', '28.95'),
(1134, '2019-05-17 13:30:20.145000', '29.00'),
(1137, '2019-05-17 13:30:26.432000', '29.10'),
(1140, '2019-05-17 13:30:34.554000', '29.10'),
(1143, '2019-05-17 13:30:41.018000', '29.10'),
(1146, '2019-05-17 13:30:47.984000', '29.10'),
(1149, '2019-05-17 13:30:54.062000', '29.00'),
(1152, '2019-05-17 13:31:00.373000', '29.00'),
(1155, '2019-05-17 13:44:12.116000', '28.55'),
(1158, '2019-05-17 13:44:18.406000', '27.70'),
(1161, '2019-05-17 13:44:24.558000', '27.70'),
(1164, '2019-05-17 13:44:30.705000', '27.70'),
(1167, '2019-05-17 13:44:38.853000', '27.70'),
(1170, '2019-05-17 13:44:45.075000', '27.70'),
(1173, '2019-05-17 13:44:51.201000', '27.70'),
(1176, '2019-05-17 13:44:57.303000', '27.70'),
(1179, '2019-05-17 13:45:03.456000', '27.70'),
(1182, '2019-05-17 13:45:09.567000', '27.75'),
(1185, '2019-05-17 13:45:17.685000', '27.70'),
(1188, '2019-05-17 13:45:23.941000', '27.75'),
(1191, '2019-05-17 13:45:30.172000', '27.80'),
(1194, '2019-05-17 13:45:38.344000', '27.80'),
(1197, '2019-05-17 13:45:42.625000', '27.85'),
(1200, '2019-05-17 13:45:50.803000', '29.00'),
(1203, '2019-05-17 13:45:55.170000', '29.65'),
(1206, '2019-05-17 13:46:01.892000', '29.30'),
(1209, '2019-05-17 13:46:10.704000', '28.95'),
(1212, '2019-05-17 13:46:14.894000', '28.65'),
(1215, '2019-05-17 13:46:23.096000', '28.45'),
(1218, '2019-05-17 13:46:29.348000', '28.20'),
(1221, '2019-05-17 13:46:35.620000', '28.10'),
(1224, '2019-05-17 13:46:41.908000', '28.00'),
(1227, '2019-05-17 13:46:48.063000', '28.00'),
(1230, '2019-05-17 13:46:54.242000', '27.90'),
(1233, '2019-05-17 13:47:02.345000', '27.90'),
(1236, '2019-05-17 13:47:08.496000', '27.85'),
(1239, '2019-05-17 13:47:14.649000', '27.80'),
(1242, '2019-05-17 13:47:20.776000', '27.85'),
(1245, '2019-05-17 13:47:28.940000', '27.90'),
(1248, '2019-05-17 13:47:35.079000', '28.00'),
(1251, '2019-05-17 13:47:41.217000', '27.90'),
(1254, '2019-05-17 13:47:47.455000', '27.90'),
(1257, '2019-05-17 13:47:55.566000', '27.90'),
(1260, '2019-05-17 13:47:59.708000', '27.90'),
(1263, '2019-05-17 13:48:05.842000', '27.85'),
(1266, '2019-05-17 13:48:14.015000', '27.90'),
(1269, '2019-05-17 13:48:20.140000', '27.85'),
(1272, '2019-05-17 13:48:26.267000', '27.80'),
(1275, '2019-05-17 13:48:32.401000', '27.80'),
(1278, '2019-05-17 13:48:40.584000', '27.85'),
(1281, '2019-05-17 13:48:46.717000', '27.85'),
(1284, '2019-05-17 13:48:52.892000', '27.85'),
(1287, '2019-05-17 13:49:00.993000', '27.90'),
(1290, '2019-05-17 13:49:05.090000', '27.85'),
(1293, '2019-05-17 13:49:11.246000', '27.85'),
(1296, '2019-05-17 13:49:19.401000', '27.90'),
(1299, '2019-05-17 13:49:25.500000', '27.90'),
(1302, '2019-05-17 13:49:31.598000', '27.85'),
(1305, '2019-05-17 13:49:37.761000', '27.90'),
(1308, '2019-05-17 13:49:43.860000', '27.90'),
(1311, '2019-05-17 13:49:51.987000', '27.90'),
(1314, '2019-05-17 13:49:58.131000', '27.90'),
(1317, '2019-05-17 13:50:04.285000', '27.90'),
(1320, '2019-05-17 13:50:10.460000', '27.90'),
(1323, '2019-05-17 13:50:18.664000', '27.90'),
(1326, '2019-05-17 13:50:24.787000', '27.95'),
(1329, '2019-05-17 13:50:30.931000', '28.00'),
(1332, '2019-05-17 13:50:37.012000', '28.10'),
(1335, '2019-05-17 13:50:45.416000', '28.20'),
(1338, '2019-05-17 13:50:49.571000', '28.10'),
(1341, '2019-05-17 13:50:57.742000', '28.15'),
(1344, '2019-05-17 13:51:03.914000', '28.20'),
(1347, '2019-05-17 13:51:10.022000', '28.20'),
(1350, '2019-05-17 13:51:16.100000', '28.20'),
(1353, '2019-05-17 13:51:22.232000', '28.15'),
(1356, '2019-05-17 13:51:28.345000', '28.10'),
(1359, '2019-05-17 13:51:36.949000', '28.10'),
(1362, '2019-05-17 13:51:43.026000', '28.10'),
(1365, '2019-05-17 13:51:49.194000', '28.10'),
(1368, '2019-05-17 13:51:55.367000', '28.00'),
(1371, '2019-05-17 13:52:01.483000', '28.10'),
(1374, '2019-05-17 13:52:09.580000', '28.00'),
(1377, '2019-05-17 13:52:15.683000', '28.00'),
(1380, '2019-05-17 13:52:23.818000', '28.05'),
(1383, '2019-05-17 13:52:27.927000', '28.00'),
(1386, '2019-05-17 13:52:34.075000', '28.10'),
(1389, '2019-05-17 13:52:40.186000', '28.30'),
(1392, '2019-05-17 13:52:48.398000', '30.40'),
(1395, '2019-05-17 13:52:54.491000', '31.10'),
(1398, '2019-05-17 13:53:00.579000', '30.35'),
(1401, '2019-05-17 13:53:08.731000', '29.75'),
(1404, '2019-05-17 13:53:14.861000', '29.40'),
(1407, '2019-05-17 13:53:20.951000', '29.05'),
(1410, '2019-05-17 13:53:27.099000', '28.75'),
(1413, '2019-05-17 13:53:33.334000', '28.55'),
(1416, '2019-05-17 13:53:39.473000', '28.30'),
(1419, '2019-05-17 13:53:45.578000', '28.20'),
(1422, '2019-05-17 13:53:53.747000', '28.10'),
(1425, '2019-05-17 13:53:59.876000', '28.10'),
(1428, '2019-05-17 13:54:08.011000', '28.10'),
(1431, '2019-05-17 13:54:12.108000', '28.10'),
(1434, '2019-05-17 13:54:18.264000', '28.10'),
(1437, '2019-05-17 13:54:26.387000', '28.10'),
(1440, '2019-05-17 13:54:32.533000', '28.10'),
(1443, '2019-05-17 13:54:38.690000', '28.10'),
(1446, '2019-05-17 13:54:44.795000', '28.10'),
(1449, '2019-05-17 13:54:52.941000', '28.10'),
(1452, '2019-05-17 13:54:59.040000', '28.10'),
(1455, '2019-05-17 13:55:05.272000', '28.20'),
(1458, '2019-05-17 13:55:11.592000', '28.10'),
(1461, '2019-05-17 13:55:17.823000', '28.10'),
(1464, '2019-05-17 13:55:24.107000', '28.20'),
(1467, '2019-05-17 13:55:30.183000', '28.20'),
(1470, '2019-05-17 13:55:38.307000', '28.20'),
(1473, '2019-05-17 13:55:44.508000', '28.20'),
(1476, '2019-05-17 13:55:50.626000', '28.20'),
(1479, '2019-05-17 13:55:58.846000', '28.20'),
(1482, '2019-05-17 13:56:06.969000', '28.35'),
(1485, '2019-05-17 13:56:11.125000', '28.20'),
(1488, '2019-05-17 13:56:17.232000', '28.20'),
(1491, '2019-05-17 13:56:25.377000', '28.20'),
(1494, '2019-05-17 13:56:31.490000', '28.20'),
(1497, '2019-05-17 13:56:35.699000', '28.20'),
(1500, '2019-05-17 13:56:43.908000', '28.20'),
(1503, '2019-05-17 13:56:49.996000', '28.20'),
(1506, '2019-05-17 13:56:56.218000', '28.20'),
(1509, '2019-05-17 13:57:02.307000', '28.20'),
(1512, '2019-05-17 13:57:08.454000', '28.20'),
(1515, '2019-05-17 13:57:14.587000', '28.20'),
(1518, '2019-05-17 13:57:22.750000', '28.20'),
(1521, '2019-05-17 13:57:28.880000', '28.20'),
(1524, '2019-05-17 13:57:37.020000', '28.20'),
(1527, '2019-05-17 13:57:43.098000', '28.20'),
(1530, '2019-05-17 13:57:49.249000', '28.20'),
(1533, '2019-05-17 13:57:55.371000', '28.20'),
(1536, '2019-05-17 13:58:01.476000', '28.20'),
(1539, '2019-05-17 13:58:07.618000', '28.20'),
(1542, '2019-05-17 13:58:15.721000', '28.20'),
(1545, '2019-05-17 13:58:19.807000', '28.20'),
(1548, '2019-05-17 13:58:28.004000', '28.20'),
(1551, '2019-05-17 13:58:34.150000', '28.20'),
(1554, '2019-05-17 13:58:40.257000', '28.10'),
(1557, '2019-05-17 13:58:46.387000', '28.20'),
(1560, '2019-05-17 13:58:52.488000', '28.20'),
(1563, '2019-05-17 13:59:00.680000', '28.20'),
(1566, '2019-05-17 13:59:06.803000', '28.15'),
(1569, '2019-05-17 13:59:13.008000', '28.15'),
(1572, '2019-05-17 13:59:19.100000', '28.20'),
(1575, '2019-05-17 13:59:27.333000', '28.20'),
(1578, '2019-05-17 13:59:33.457000', '28.10'),
(1581, '2019-05-17 13:59:39.551000', '28.10'),
(1584, '2019-05-17 13:59:45.726000', '28.10'),
(1587, '2019-05-17 13:59:51.861000', '28.10'),
(1590, '2019-05-17 13:59:58.177000', '28.10'),
(1593, '2019-05-17 14:00:06.345000', '28.10'),
(1596, '2019-05-17 14:00:12.509000', '28.10'),
(1599, '2019-05-17 14:00:18.600000', '28.10'),
(1602, '2019-05-17 14:00:24.748000', '28.10'),
(1605, '2019-05-17 14:00:30.895000', '28.10'),
(1608, '2019-05-17 14:00:37.089000', '28.15'),
(1611, '2019-05-17 14:00:45.273000', '28.10'),
(1614, '2019-05-17 14:00:51.609000', '28.10'),
(1617, '2019-05-17 14:00:57.695000', '28.15'),
(1620, '2019-05-17 14:01:05.869000', '28.20'),
(1623, '2019-05-17 14:01:09.995000', '28.20'),
(1626, '2019-05-17 14:01:20.154000', '28.20'),
(1629, '2019-05-17 14:01:24.264000', '28.20'),
(1632, '2019-05-17 14:01:30.510000', '28.20'),
(1635, '2019-05-17 14:01:36.687000', '28.20'),
(1638, '2019-05-17 14:01:42.881000', '28.20'),
(1641, '2019-05-17 14:01:49.048000', '28.20'),
(1644, '2019-05-17 14:01:57.213000', '28.20'),
(1647, '2019-05-17 14:02:03.369000', '28.20'),
(1650, '2019-05-17 14:02:09.558000', '28.10'),
(1653, '2019-05-17 14:02:15.770000', '28.20'),
(1656, '2019-05-17 14:02:22.385000', '28.20'),
(1659, '2019-05-17 14:02:34.683000', '28.20'),
(1662, '2019-05-17 14:02:36.814000', '28.20'),
(1665, '2019-05-17 14:02:42.978000', '28.20'),
(1668, '2019-05-17 14:02:49.138000', '28.20'),
(1671, '2019-05-17 14:02:55.272000', '28.20'),
(1674, '2019-05-17 14:03:01.360000', '28.20'),
(1677, '2019-05-17 14:03:11.489000', '28.25'),
(1680, '2019-05-17 14:03:15.672000', '28.30'),
(1683, '2019-05-17 14:03:21.858000', '28.30'),
(1686, '2019-05-17 14:03:27.950000', '28.30'),
(1689, '2019-05-17 14:03:36.102000', '28.25'),
(1692, '2019-05-17 14:03:42.252000', '28.30'),
(1695, '2019-05-17 14:03:48.345000', '28.25'),
(1698, '2019-05-17 14:03:54.475000', '28.20'),
(1701, '2019-05-17 14:04:00.615000', '28.20'),
(1704, '2019-05-17 14:04:06.740000', '28.20'),
(1707, '2019-05-17 14:04:14.834000', '28.20'),
(1710, '2019-05-17 14:04:20.963000', '28.20'),
(1713, '2019-05-17 14:04:27.138000', '28.20'),
(1716, '2019-05-17 14:04:33.267000', '28.20'),
(1719, '2019-05-17 14:04:39.441000', '28.20'),
(1722, '2019-05-17 14:04:47.549000', '28.20'),
(1725, '2019-05-17 14:04:53.722000', '28.20'),
(1728, '2019-05-17 14:04:59.891000', '28.30'),
(1731, '2019-05-17 14:05:08.168000', '28.20'),
(1734, '2019-05-17 14:05:12.341000', '28.20'),
(1737, '2019-05-17 14:05:18.579000', '28.20'),
(1740, '2019-05-17 14:05:26.752000', '28.20'),
(1743, '2019-05-17 14:05:33.002000', '28.20'),
(1746, '2019-05-17 14:05:39.166000', '28.20'),
(1749, '2019-05-17 14:05:45.303000', '28.20'),
(1752, '2019-05-17 14:05:53.455000', '28.20'),
(1755, '2019-05-17 14:05:59.653000', '28.20'),
(1758, '2019-05-17 14:06:05.744000', '28.20'),
(1761, '2019-05-17 14:06:11.842000', '28.20'),
(1764, '2019-05-17 14:06:17.934000', '28.20'),
(1767, '2019-05-17 14:06:28.082000', '28.20'),
(1770, '2019-05-17 14:06:30.206000', '28.20'),
(1773, '2019-05-17 14:06:38.337000', '28.25'),
(1776, '2019-05-17 14:06:44.469000', '28.30'),
(1779, '2019-05-17 14:06:50.633000', '28.30'),
(1782, '2019-05-17 14:06:56.811000', '28.30'),
(1785, '2019-05-17 14:07:03.105000', '28.20'),
(1788, '2019-05-17 14:07:09.212000', '28.30'),
(1791, '2019-05-17 14:07:17.376000', '28.30'),
(1794, '2019-05-17 14:07:23.502000', '28.30'),
(1797, '2019-05-17 14:07:29.695000', '28.30'),
(1800, '2019-05-17 14:07:37.825000', '28.35'),
(1803, '2019-05-17 14:07:44.021000', '28.30'),
(1806, '2019-05-17 14:07:50.203000', '28.30'),
(1809, '2019-05-17 14:07:56.502000', '28.30'),
(1812, '2019-05-17 14:08:02.640000', '28.30'),
(1815, '2019-05-17 14:08:10.806000', '28.30'),
(1818, '2019-05-17 14:08:14.902000', '28.30'),
(1821, '2019-05-17 14:08:21.071000', '28.40'),
(1824, '2019-05-17 14:08:29.273000', '28.35'),
(1827, '2019-05-17 14:08:35.598000', '28.30'),
(1830, '2019-05-17 14:08:41.722000', '28.30'),
(1833, '2019-05-17 14:08:47.856000', '28.35'),
(1836, '2019-05-17 14:08:53.995000', '28.40'),
(1839, '2019-05-17 14:09:02.164000', '28.30'),
(1842, '2019-05-17 14:09:08.398000', '28.35'),
(1845, '2019-05-17 14:09:14.515000', '28.40'),
(1848, '2019-05-17 14:09:20.705000', '28.40'),
(1851, '2019-05-17 14:09:26.843000', '28.40'),
(1854, '2019-05-17 14:09:35.005000', '28.40'),
(1857, '2019-05-17 14:09:41.221000', '28.35'),
(1860, '2019-05-17 14:09:47.358000', '28.30'),
(1863, '2019-05-17 14:09:53.537000', '28.35'),
(1866, '2019-05-17 14:09:59.778000', '28.40'),
(1869, '2019-05-17 14:10:09.944000', '28.40'),
(1872, '2019-05-17 14:10:14.112000', '28.40'),
(1875, '2019-05-17 14:10:20.251000', '28.40'),
(1878, '2019-05-17 14:10:26.446000', '28.30'),
(1881, '2019-05-17 14:10:32.590000', '28.45'),
(1884, '2019-05-17 14:10:40.764000', '28.40'),
(1887, '2019-05-17 14:10:44.951000', '28.45'),
(1890, '2019-05-17 14:10:53.094000', '28.50'),
(1893, '2019-05-17 14:10:59.309000', '28.45'),
(1896, '2019-05-17 14:11:05.489000', '28.40'),
(1899, '2019-05-17 14:11:11.682000', '28.50'),
(1902, '2019-05-17 14:11:17.839000', '28.50'),
(1905, '2019-05-17 14:11:25.985000', '28.50'),
(1908, '2019-05-17 14:11:32.145000', '28.50'),
(1911, '2019-05-17 14:11:38.257000', '28.50'),
(1914, '2019-05-17 14:11:44.422000', '28.45'),
(1917, '2019-05-17 14:11:52.577000', '28.40'),
(1920, '2019-05-17 14:11:56.719000', '28.45'),
(1923, '2019-05-17 14:12:05.016000', '28.45'),
(1926, '2019-05-17 14:12:45.661000', '28.45'),
(1929, '2019-05-17 14:12:53.808000', '28.35'),
(1932, '2019-05-17 14:13:02.013000', '28.35'),
(1935, '2019-05-17 14:13:04.142000', '28.30'),
(1938, '2019-05-17 14:13:12.292000', '28.20'),
(1941, '2019-05-17 14:13:18.622000', '28.20'),
(1944, '2019-05-17 14:13:24.756000', '28.30'),
(1947, '2019-05-17 14:13:30.945000', '28.25'),
(1950, '2019-05-17 14:13:37.066000', '28.20'),
(1953, '2019-05-17 14:13:43.176000', '28.30'),
(1956, '2019-05-17 14:13:51.328000', '28.30'),
(1959, '2019-05-17 14:13:57.468000', '28.30'),
(1962, '2019-05-17 14:14:03.587000', '28.30'),
(1965, '2019-05-17 14:14:09.704000', '28.30'),
(1968, '2019-05-17 14:14:15.840000', '28.30'),
(1971, '2019-05-17 14:14:23.967000', '28.40'),
(1974, '2019-05-17 14:14:30.062000', '28.50'),
(1977, '2019-05-17 14:14:36.151000', '28.45'),
(1980, '2019-05-17 14:14:44.318000', '28.45'),
(1983, '2019-05-17 14:14:50.421000', '28.50'),
(1986, '2019-05-17 14:14:56.590000', '28.50'),
(1989, '2019-05-17 14:15:02.758000', '28.60'),
(1992, '2019-05-17 14:15:08.967000', '28.60'),
(1995, '2019-05-17 14:15:15.183000', '28.60'),
(1998, '2019-05-17 14:15:23.364000', '28.60'),
(2001, '2019-05-17 14:15:29.539000', '28.50'),
(2004, '2019-05-17 14:15:35.665000', '28.60'),
(2007, '2019-05-17 14:15:43.798000', '28.60'),
(2010, '2019-05-17 14:15:48.061000', '28.60'),
(2013, '2019-05-17 14:15:54.261000', '28.60'),
(2016, '2019-05-17 14:16:00.417000', '29.10'),
(2019, '2019-05-17 14:16:08.561000', '30.25'),
(2022, '2019-05-17 14:16:14.702000', '29.95'),
(2025, '2019-05-17 14:16:20.875000', '29.65'),
(2028, '2019-05-17 14:16:27.012000', '29.35'),
(2031, '2019-05-17 14:16:33.147000', '29.15'),
(2034, '2019-05-17 14:16:41.275000', '28.95'),
(2037, '2019-05-17 14:17:23.550000', '28.80'),
(2040, '2019-05-17 14:17:29.668000', '28.65'),
(2043, '2019-05-17 14:17:35.801000', '28.60'),
(2046, '2019-05-17 14:17:43.945000', '28.60'),
(2049, '2019-05-17 14:17:48.079000', '28.60'),
(2052, '2019-05-17 14:17:56.260000', '28.55'),
(2055, '2019-05-17 14:18:02.404000', '28.60'),
(2058, '2019-05-17 14:18:08.540000', '28.60'),
(2061, '2019-05-17 14:18:16.690000', '28.60'),
(2064, '2019-05-17 14:18:20.813000', '28.60'),
(2067, '2019-05-17 14:18:28.932000', '28.60'),
(2070, '2019-05-17 14:18:35.063000', '28.60'),
(2073, '2019-05-17 14:18:43.215000', '28.60'),
(2076, '2019-05-17 14:18:49.431000', '28.60'),
(2079, '2019-05-17 14:18:53.525000', '28.55'),
(2082, '2019-05-17 14:19:01.628000', '28.60'),
(2085, '2019-05-17 14:19:07.756000', '28.55'),
(2088, '2019-05-17 14:19:13.889000', '28.50'),
(2091, '2019-05-17 14:19:19.996000', '28.50'),
(2094, '2019-05-17 14:19:26.078000', '28.50'),
(2097, '2019-05-17 14:19:34.232000', '28.50'),
(2100, '2019-05-17 14:19:40.392000', '28.50'),
(2103, '2019-05-17 14:19:46.532000', '28.50'),
(2106, '2019-05-17 14:19:52.625000', '28.50'),
(2109, '2019-05-17 14:19:58.733000', '28.50'),
(2112, '2019-05-17 14:20:06.839000', '28.50'),
(2115, '2019-05-17 14:20:13.012000', '28.50'),
(2118, '2019-05-17 14:20:19.303000', '28.50'),
(2121, '2019-05-17 14:20:25.584000', '28.50'),
(2124, '2019-05-17 14:20:31.728000', '28.50'),
(2127, '2019-05-17 14:20:41.958000', '28.50'),
(2130, '2019-05-17 14:20:46.098000', '28.55'),
(2133, '2019-05-17 14:20:52.239000', '28.70'),
(2136, '2019-05-17 14:20:58.346000', '28.70'),
(2139, '2019-05-17 14:21:04.479000', '28.70'),
(2142, '2019-05-17 14:21:10.585000', '28.70'),
(2145, '2019-05-17 14:21:18.690000', '28.80'),
(2148, '2019-05-17 14:21:24.829000', '28.90'),
(2151, '2019-05-17 14:21:30.962000', '28.90'),
(2154, '2019-05-17 14:21:37.102000', '28.90'),
(2157, '2019-05-17 14:21:49.255000', '28.90'),
(2160, '2019-05-17 14:21:51.389000', '28.85'),
(2163, '2019-05-17 14:21:57.560000', '28.90'),
(2166, '2019-05-17 14:22:03.699000', '28.90'),
(2169, '2019-05-17 14:22:09.844000', '28.85'),
(2172, '2019-05-17 14:22:16.021000', '28.80'),
(2175, '2019-05-17 14:22:24.136000', '28.80'),
(2178, '2019-05-17 14:22:30.278000', '28.80'),
(2181, '2019-05-17 14:22:36.453000', '28.80'),
(2184, '2019-05-17 14:22:42.598000', '29.40'),
(2187, '2019-05-17 14:22:52.750000', '30.00'),
(2190, '2019-05-17 14:22:56.847000', '29.70'),
(2193, '2019-05-17 14:23:02.940000', '29.45'),
(2196, '2019-05-17 14:23:09.066000', '29.25'),
(2199, '2019-05-17 14:23:15.212000', '29.15'),
(2202, '2019-05-17 14:23:21.355000', '29.10'),
(2205, '2019-05-17 14:23:29.462000', '29.20'),
(2208, '2019-05-17 14:23:35.606000', '29.20'),
(2211, '2019-05-17 14:23:41.694000', '29.10'),
(2214, '2019-05-17 14:23:47.828000', '29.10'),
(2217, '2019-05-17 14:23:56.073000', '29.00'),
(2220, '2019-05-17 14:24:02.163000', '29.00'),
(2223, '2019-05-17 14:24:08.265000', '29.00'),
(2226, '2019-05-17 14:24:14.410000', '29.00'),
(2229, '2019-05-17 14:24:20.547000', '29.00'),
(2232, '2019-05-17 14:24:28.686000', '29.00'),
(2235, '2019-05-17 14:24:34.814000', '29.00'),
(2238, '2019-05-17 14:24:40.944000', '29.00'),
(2241, '2019-05-17 14:24:47.040000', '29.00'),
(2244, '2019-05-17 14:24:53.178000', '29.00'),
(2247, '2019-05-17 14:24:59.318000', '29.00'),
(2250, '2019-05-17 14:25:07.423000', '29.00'),
(2253, '2019-05-17 14:25:13.568000', '29.00'),
(2256, '2019-05-17 14:25:19.707000', '29.00'),
(2259, '2019-05-17 14:25:25.924000', '29.00'),
(2262, '2019-05-17 14:25:34.028000', '29.00'),
(2265, '2019-05-17 14:25:40.151000', '29.00'),
(2268, '2019-05-17 14:25:46.256000', '29.00'),
(2271, '2019-05-17 14:25:52.356000', '29.00'),
(2274, '2019-05-17 14:26:00.570000', '29.00'),
(2277, '2019-05-17 14:26:04.657000', '28.90'),
(2280, '2019-05-17 14:26:12.795000', '29.00'),
(2283, '2019-05-17 14:26:18.923000', '29.00'),
(2286, '2019-05-17 14:26:25.055000', '29.00'),
(2289, '2019-05-17 14:26:31.199000', '29.00'),
(2292, '2019-05-17 14:26:37.333000', '29.00'),
(2295, '2019-05-17 14:26:45.474000', '29.00'),
(2298, '2019-05-17 14:26:51.639000', '29.00'),
(2301, '2019-05-17 14:26:57.770000', '29.00'),
(2304, '2019-05-17 14:27:05.914000', '29.00'),
(2307, '2019-05-17 14:27:12.063000', '29.00'),
(2310, '2019-05-17 14:27:18.210000', '29.00'),
(2313, '2019-05-17 14:27:24.305000', '29.00'),
(2316, '2019-05-17 14:27:32.455000', '29.00'),
(2319, '2019-05-17 14:27:36.596000', '29.05'),
(2322, '2019-05-17 14:27:42.690000', '29.05'),
(2325, '2019-05-17 14:27:48.827000', '29.05'),
(2328, '2019-05-17 14:27:56.994000', '29.10'),
(2331, '2019-05-17 14:28:03.090000', '29.20'),
(2334, '2019-05-17 14:28:11.258000', '29.20'),
(2337, '2019-05-17 14:28:15.429000', '29.20'),
(2340, '2019-05-17 14:28:23.587000', '29.20'),
(2343, '2019-05-17 14:28:29.833000', '29.20'),
(2346, '2019-05-17 14:28:38.050000', '29.20'),
(2349, '2019-05-17 14:28:44.163000', '29.20'),
(2352, '2019-05-17 14:28:50.286000', '29.20'),
(2355, '2019-05-17 14:28:54.476000', '29.25'),
(2358, '2019-05-17 14:29:02.790000', '29.20'),
(2361, '2019-05-17 14:29:08.921000', '29.20'),
(2364, '2019-05-17 14:29:15.113000', '29.25'),
(2367, '2019-05-17 14:29:59.417000', '29.15'),
(2370, '2019-05-17 14:30:05.592000', '29.00'),
(2373, '2019-05-17 14:30:11.729000', '29.00'),
(2376, '2019-05-17 14:30:17.951000', '29.00'),
(2379, '2019-05-17 14:30:26.096000', '29.00'),
(2382, '2019-05-17 14:30:32.234000', '29.00'),
(2385, '2019-05-17 14:30:38.382000', '29.00'),
(2388, '2019-05-17 14:30:44.634000', '29.00'),
(2391, '2019-05-17 14:30:50.787000', '29.00'),
(2394, '2019-05-17 14:30:56.948000', '29.00'),
(2397, '2019-05-17 14:31:03.097000', '29.00'),
(2400, '2019-05-17 14:31:11.220000', '29.00'),
(2403, '2019-05-17 14:31:17.358000', '29.00'),
(2406, '2019-05-17 14:31:23.486000', '29.00'),
(2409, '2019-05-17 14:31:49.705000', '29.00'),
(2412, '2019-05-17 14:31:55.844000', '29.00'),
(2415, '2019-05-17 14:32:02.003000', '28.90'),
(2418, '2019-05-17 14:32:08.096000', '29.00'),
(2421, '2019-05-17 14:32:14.191000', '29.00'),
(2424, '2019-05-17 14:32:20.330000', '29.00'),
(2427, '2019-05-17 14:32:28.500000', '29.00'),
(2430, '2019-05-17 14:32:34.620000', '29.00'),
(2433, '2019-05-17 14:32:40.757000', '29.00'),
(2436, '2019-05-17 14:32:46.886000', '29.00'),
(2439, '2019-05-17 14:32:52.990000', '29.00'),
(2442, '2019-05-17 14:33:01.091000', '28.90'),
(2445, '2019-05-17 14:33:09.245000', '28.90'),
(2448, '2019-05-17 14:33:15.494000', '28.90'),
(2451, '2019-05-17 14:33:21.621000', '28.90'),
(2454, '2019-05-17 15:20:41.420000', '26.95'),
(2457, '2019-05-17 15:20:47.726000', '25.00'),
(2460, '2019-05-17 15:20:53.966000', '25.00'),
(2463, '2019-05-17 15:21:00.164000', '25.00'),
(2466, '2019-05-17 15:21:06.334000', '25.00'),
(2469, '2019-05-17 15:21:12.565000', '25.00'),
(2472, '2019-05-17 15:21:20.725000', '25.00'),
(2475, '2019-05-17 15:21:26.878000', '25.00'),
(2478, '2019-05-17 15:21:33.034000', '25.00'),
(2481, '2019-05-17 15:21:39.448000', '25.00'),
(2484, '2019-05-17 15:21:45.614000', '25.00'),
(2487, '2019-05-17 15:21:51.795000', '25.00'),
(2490, '2019-05-17 15:22:00.025000', '25.00'),
(2493, '2019-05-17 15:22:06.168000', '25.00'),
(2496, '2019-05-17 15:22:12.320000', '25.00'),
(2499, '2019-05-17 15:22:18.471000', '25.00'),
(2502, '2019-05-17 15:22:24.629000', '25.00'),
(2505, '2019-05-17 15:22:30.810000', '25.00'),
(2508, '2019-05-17 15:22:37.021000', '25.00'),
(2511, '2019-05-17 15:22:45.183000', '25.00'),
(2514, '2019-05-17 15:22:51.361000', '25.00'),
(2517, '2019-05-17 15:22:57.570000', '25.00'),
(2520, '2019-05-17 15:23:03.781000', '25.00'),
(2523, '2019-05-17 15:23:10.001000', '25.00'),
(2526, '2019-05-17 15:23:16.284000', '25.00'),
(2529, '2019-05-17 15:23:24.423000', '25.00'),
(2532, '2019-05-17 15:23:30.572000', '25.00'),
(2535, '2019-05-17 15:23:36.710000', '25.00'),
(2538, '2019-05-17 15:23:42.860000', '24.95'),
(2541, '2019-05-17 15:29:42.845000', '25.00'),
(2544, '2019-05-17 15:29:48.996000', '25.25'),
(2547, '2019-05-17 15:29:55.111000', '25.30'),
(2550, '2019-05-17 15:30:03.240000', '25.30'),
(2553, '2019-05-17 15:30:09.383000', '25.30'),
(2556, '2019-05-17 15:30:15.527000', '25.35'),
(2559, '2019-05-17 15:30:21.670000', '25.30'),
(2562, '2019-05-17 15:30:29.902000', '25.30'),
(2565, '2019-05-17 15:30:36.042000', '25.30'),
(2568, '2019-05-17 15:30:42.138000', '25.35'),
(2571, '2019-05-17 15:30:48.241000', '25.30'),
(2574, '2019-05-17 15:30:56.341000', '25.30'),
(2577, '2019-05-17 15:31:02.484000', '25.35'),
(2580, '2019-05-17 15:31:10.628000', '25.35'),
(2583, '2019-05-17 15:31:14.750000', '25.40'),
(2586, '2019-05-17 15:31:20.896000', '25.40'),
(2589, '2019-05-17 15:31:27.046000', '25.40'),
(2592, '2019-05-17 15:31:35.208000', '25.40'),
(2595, '2019-05-17 15:31:39.394000', '25.40'),
(2598, '2019-05-17 15:31:47.578000', '25.45'),
(2601, '2019-05-17 16:01:49.332000', '25.50'),
(2604, '2019-05-17 16:01:55.624000', '26.95'),
(2607, '2019-05-17 16:02:01.788000', '27.00'),
(2610, '2019-05-17 16:02:07.944000', '27.00'),
(2613, '2019-05-17 16:02:16.083000', '27.00'),
(2616, '2019-05-17 16:02:22.238000', '27.00'),
(2619, '2019-05-17 16:02:28.604000', '27.00'),
(2622, '2019-05-17 16:02:34.717000', '27.00'),
(2625, '2019-05-17 16:02:40.862000', '26.95'),
(2628, '2019-05-17 16:02:49.205000', '27.00'),
(2631, '2019-05-17 16:02:55.400000', '27.00'),
(2634, '2019-05-17 16:03:01.582000', '27.00'),
(2637, '2019-05-17 16:03:07.747000', '27.00'),
(2640, '2019-05-17 16:03:13.891000', '27.00'),
(2643, '2019-05-17 16:03:20.039000', '27.00'),
(2646, '2019-05-17 16:03:28.185000', '27.00'),
(2649, '2019-05-17 16:03:34.287000', '27.00'),
(2652, '2019-05-17 16:03:40.442000', '27.95'),
(2655, '2019-05-17 16:03:46.597000', '28.25'),
(2658, '2019-05-17 16:03:52.699000', '28.05'),
(2661, '2019-05-17 16:03:58.856000', '27.75'),
(2664, '2019-05-17 16:04:06.991000', '27.50'),
(2667, '2019-05-17 16:04:13.152000', '27.35'),
(2670, '2019-05-17 16:04:19.304000', '27.25'),
(2673, '2019-05-17 16:04:25.457000', '27.20'),
(2676, '2019-05-17 16:04:31.636000', '27.20'),
(2679, '2019-05-17 16:04:39.766000', '27.20'),
(2682, '2019-05-17 16:04:45.872000', '27.20'),
(2685, '2019-05-17 16:04:52.027000', '27.20'),
(2688, '2019-05-17 16:04:58.191000', '27.20'),
(2691, '2019-05-17 16:05:04.356000', '27.20'),
(2694, '2019-05-17 16:05:10.528000', '27.20'),
(2697, '2019-05-17 16:05:18.750000', '27.20'),
(2700, '2019-05-17 16:05:27.059000', '27.20'),
(2703, '2019-05-17 16:05:31.171000', '27.20'),
(2706, '2019-05-17 16:05:37.293000', '27.20'),
(2709, '2019-05-17 16:05:43.434000', '27.20'),
(2712, '2019-05-17 16:05:51.574000', '27.20'),
(2715, '2019-05-17 16:05:57.724000', '27.20'),
(2718, '2019-05-17 16:06:03.858000', '27.10'),
(2721, '2019-05-17 16:06:10.036000', '27.10'),
(2724, '2019-05-17 16:06:16.216000', '27.20'),
(2727, '2019-05-17 16:06:22.338000', '27.15'),
(2730, '2019-05-17 16:06:30.444000', '27.20'),
(2733, '2019-05-17 16:06:36.591000', '27.20'),
(2736, '2019-05-17 16:06:42.717000', '27.20'),
(2739, '2019-05-17 16:06:48.931000', '27.20'),
(2742, '2019-05-17 16:06:55.112000', '27.20'),
(2745, '2019-05-17 16:07:03.271000', '27.20'),
(2748, '2019-05-17 16:07:09.417000', '27.20'),
(2751, '2019-05-17 16:07:15.553000', '27.20'),
(2754, '2019-05-17 16:07:21.693000', '27.20'),
(2757, '2019-05-17 16:07:27.844000', '27.20'),
(2760, '2019-05-17 16:07:48.021000', '27.20'),
(2764, '2019-05-17 16:07:48.136000', '27.20'),
(2767, '2019-05-17 16:07:50.202000', '27.20'),
(2770, '2019-05-17 16:07:56.311000', '27.20'),
(2773, '2019-05-17 16:08:04.434000', '27.20'),
(2776, '2019-05-17 16:08:10.586000', '27.30'),
(2779, '2019-05-17 16:09:49.240000', '27.20'),
(2782, '2019-05-17 16:09:55.437000', '27.10'),
(2785, '2019-05-17 16:10:01.596000', '27.00'),
(2788, '2019-05-17 16:10:07.704000', '27.00'),
(2791, '2019-05-17 16:10:13.835000', '27.00'),
(2794, '2019-05-17 16:10:21.968000', '27.00'),
(2797, '2019-05-17 16:10:28.135000', '27.00'),
(2800, '2019-05-17 16:10:34.300000', '27.05'),
(2803, '2019-05-17 16:10:40.440000', '27.10'),
(2806, '2019-05-17 16:10:46.724000', '27.15'),
(2809, '2019-05-17 16:10:54.880000', '27.20'),
(2812, '2019-05-17 16:11:01.074000', '27.20'),
(2815, '2019-05-17 16:11:07.239000', '27.20'),
(2818, '2019-05-17 16:11:13.391000', '27.15'),
(2821, '2019-05-17 16:11:19.541000', '27.20'),
(2824, '2019-05-17 16:11:25.672000', '27.20'),
(2827, '2019-05-17 16:11:33.811000', '27.20'),
(2830, '2019-05-17 16:11:39.962000', '27.20'),
(2833, '2019-05-17 16:11:46.140000', '27.15'),
(2836, '2019-05-17 16:11:54.334000', '27.15'),
(2839, '2019-05-17 16:11:58.452000', '27.15'),
(2842, '2019-05-17 16:12:06.615000', '27.20');

--
-- Triggers `medicoes_temperatura`
--
DELIMITER $$
CREATE TRIGGER `verificar_temp` BEFORE INSERT ON `medicoes_temperatura` FOR EACH ROW BEGIN

	SET @id = null;
	SET @min = (SELECT limiteInferiorTemperatura FROM sistema);
    SET @max = (SELECT limiteSuperiorTemperatura FROM sistema);
    SET @interval = (SELECT alertaintervalo FROM sistema);
    
    IF NOT EXISTS (SELECT * FROM alerta, sistema
    WHERE alerta.valor <= NEW.valormedicaotemperatura + sistema.MargemAlertaTemperatura
    AND alerta.valor >= NEW.valormedicaotemperatura - sistema.MargemAlertaTemperatura
    AND alerta.datahora BETWEEN NEW.datahoramedicao - INTERVAL @interval SECOND AND NEW.datahoramedicao + INTERVAL @interval SECOND) THEN
    IF NEW.valormedicaotemperatura < @min THEN
    	INSERT INTO alerta VALUES(@id, "temp", NEW.datahoramedicao, NEW.valormedicaotemperatura, @min, @max,"valor abaixo do limite");
    ELSEIF NEW.valormedicaotemperatura > @max THEN
        INSERT INTO alerta VALUES(@id, "temp", NEW.datahoramedicao, NEW.valormedicaotemperatura, @min, @max,"valor acima do limite");
    END IF;
    END IF;
    
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `sistema`
--

CREATE TABLE `sistema` (
  `LimiteInferiorTemperatura` decimal(8,2) DEFAULT NULL,
  `LimiteSuperiorTemperatura` decimal(8,2) DEFAULT NULL,
  `LimiteSuperiorLuz` decimal(8,2) DEFAULT NULL,
  `LimiteInferiorLuz` decimal(8,2) DEFAULT NULL,
  `MargemAlertaLuz` decimal(8,2) NOT NULL,
  `MargemAlertaTemperatura` decimal(8,2) NOT NULL,
  `AlertaIntervalo` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `sistema`
--

INSERT INTO `sistema` (`LimiteInferiorTemperatura`, `LimiteSuperiorTemperatura`, `LimiteSuperiorLuz`, `LimiteInferiorLuz`, `MargemAlertaLuz`, `MargemAlertaTemperatura`, `AlertaIntervalo`) VALUES
('15.00', '30.00', '3500.00', '1200.00', '5.00', '5.00', 20);

--
-- Triggers `sistema`
--
DELIMITER $$
CREATE TRIGGER `sistema_AFTER_DELETE` AFTER DELETE ON `sistema` FOR EACH ROW BEGIN

INSERT INTO sistema_log VALUES(NULL, 1, NOW(), 'D', current_user(), OLD.limiteinferiortemperatura, OLD.limitesuperiortemperatura, OLD.limiteinferiorluz, OLD.limitesuperiorluz);

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `sistema_AFTER_INSERT` AFTER INSERT ON `sistema` FOR EACH ROW BEGIN

INSERT INTO sistema_log VALUES(NULL, 1, NOW(), 'I', current_user(), NEW.limiteinferiortemperatura, NEW.limitesuperiortemperatura, NEW.limiteinferiorluz, NEW.limitesuperiorluz);

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `sistema_AFTER_UPDATE` AFTER UPDATE ON `sistema` FOR EACH ROW BEGIN

INSERT INTO sistema_log VALUES(NULL, 1, NOW(), 'U', current_user(), OLD.limiteinferiortemperatura, OLD.limitesuperiortemperatura, OLD.limiteinferiorluz, OLD.limitesuperiorluz);

INSERT INTO sistema_log VALUES(NULL, 2, NOW(), 'U', current_user(), NEW.limiteinferiortemperatura, NEW.limitesuperiortemperatura, NEW.limiteinferiorluz, NEW.limitesuperiorluz);

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `sistema_log`
--

CREATE TABLE `sistema_log` (
  `id` int(11) NOT NULL,
  `precedencia` int(11) NOT NULL,
  `datahora` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `operacao` varchar(45) NOT NULL,
  `utilizador` varchar(100) NOT NULL,
  `limiteInferiorTemperatura` decimal(8,2) NOT NULL,
  `limiteSuperiorTemperatura` decimal(8,2) NOT NULL,
  `limiteInferiorLuz` decimal(8,2) NOT NULL,
  `limiteSuperiorLuz` decimal(8,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `sistema_log`
--

INSERT INTO `sistema_log` (`id`, `precedencia`, `datahora`, `operacao`, `utilizador`, `limiteInferiorTemperatura`, `limiteSuperiorTemperatura`, `limiteInferiorLuz`, `limiteSuperiorLuz`) VALUES
(1, 1, '2019-05-17 16:05:11', 'I', 'root@localhost', '15.00', '30.00', '1200.00', '3500.00'),
(2, 1, '2019-05-19 18:50:18', 'U', 'root@localhost', '15.00', '30.00', '1200.00', '3500.00'),
(3, 2, '2019-05-19 18:50:18', 'U', 'root@localhost', '15.00', '30.00', '1200.00', '3500.00'),
(4, 1, '2019-05-19 18:55:23', 'U', 'root@localhost', '15.00', '30.00', '1200.00', '3500.00'),
(5, 2, '2019-05-19 18:55:23', 'U', 'root@localhost', '15.00', '30.00', '1200.00', '3500.00'),
(6, 1, '2019-05-19 19:12:41', 'U', 'root@localhost', '15.00', '30.00', '1200.00', '3500.00'),
(7, 2, '2019-05-19 19:12:41', 'U', 'root@localhost', '15.00', '30.00', '1200.00', '3500.00');

-- --------------------------------------------------------

--
-- Table structure for table `utilizador`
--

CREATE TABLE `utilizador` (
  `Email` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `NomeUtilizador` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `CategoriaProfissional` varchar(300) COLLATE utf8_bin DEFAULT NULL,
  `username` varchar(100) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `utilizador`
--

INSERT INTO `utilizador` (`Email`, `NomeUtilizador`, `CategoriaProfissional`, `username`) VALUES
('abc', 'abc', 'abc', 'abc@localhost'),
('abcd', 'acbd', 'abcd', 'abcd@localhost'),
('abcdef', 'abcdef', 'abcdef', 'abcdef@localhost'),
('def', 'def', 'def', 'def@localhost'),
('root', 'root', 'profissional', 'root@localhost'),
('sippinpurp@tm.com', 'sippin', 'purpp', 'sippin@localhost'),
('socio', 'socio', 'socio', 'socio@localhost'),
('toze', 'toze', 'toze', 'toze@localhost'),
('user', 'user', 'user', 'user@localhost'),
('e@mail.com', 'Utilizador A', 'Profisisonal', 'utilizador_a@localhost'),
('xyz', 'xyz', 'xyz', 'xyz@localhost');

--
-- Triggers `utilizador`
--
DELIMITER $$
CREATE TRIGGER `utilizador_AFTER_DELETE` AFTER DELETE ON `utilizador` FOR EACH ROW BEGIN

INSERT INTO utilizador_log VALUES(NULL, 1, NOW(), 'D', current_user(), OLD.email, OLD.nomeutilizador, OLD.categoriaprofissional, OLD.username);

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `utilizador_AFTER_INSERT` AFTER INSERT ON `utilizador` FOR EACH ROW BEGIN

INSERT INTO utilizador_log VALUES(NULL, 1, NOW(), 'I', current_user(), NEW.email, NEW.nomeutilizador, NEW.categoriaprofissional, NEW.username);

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `utilizador_log`
--

CREATE TABLE `utilizador_log` (
  `id` int(11) NOT NULL,
  `precedencia` int(11) NOT NULL,
  `datahora` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `operacao` varchar(45) NOT NULL,
  `utilizador` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `nomeUtilizador` varchar(100) NOT NULL,
  `categoriaProfissional` varchar(45) NOT NULL,
  `username` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `utilizador_log`
--

INSERT INTO `utilizador_log` (`id`, `precedencia`, `datahora`, `operacao`, `utilizador`, `email`, `nomeUtilizador`, `categoriaProfissional`, `username`) VALUES
(1, 1, '2019-05-12 13:14:26', 'I', 'root@localhost', 'asdASD', 'asdASD', 'asdASD', '\'asdASD\'@\'localhost\''),
(2, 1, '2019-05-12 19:27:35', 'I', 'root@localhost', 'email', 'nome', 'profissional', '\'user\'@\'localhost\''),
(3, 1, '2019-05-12 19:50:50', 'I', 'root@localhost', 'sadsadada', 'asdadasdasd', 'sadsad', '\'sadasdasdasd\'@\'localhost\''),
(4, 1, '2019-05-12 20:04:11', 'I', 'root@localhost', 'e@mail', 'McName', 'Prof', '\'useruser\'@\'localhost\''),
(5, 1, '2019-05-12 20:12:34', 'D', 'root@localhost', 'email', 'nome', 'profissional', '\'user\'@\'localhost\''),
(6, 1, '2019-05-12 20:12:52', 'D', 'root@localhost', 'asdASD', 'asdASD', 'asdASD', '\'asdASD\'@\'localhost\''),
(7, 1, '2019-05-13 10:56:59', 'I', 'root@localhost', 'abc', 'abc', 'abc', '\'abc\'@\'localhost\''),
(8, 1, '2019-05-13 11:03:28', 'I', 'root@localhost', 'cba', 'cba', 'cba', '\'cba\'@\'localhost\''),
(9, 1, '2019-05-13 11:11:06', 'I', 'root@localhost', 'email', 'root', 'root', '\'root\'@\'localhost\''),
(10, 1, '2019-05-13 11:11:37', 'I', 'root@localhost', 'de3d', '3ed3e', '3ed3', '\'d3ed3\'@\'rfcrfc\''),
(11, 1, '2019-05-13 11:24:06', 'I', 'root@localhost', 'def', 'def', 'def', 'def@localhost'),
(12, 1, '2019-05-13 11:24:59', 'D', 'root@localhost', 'abc', 'abc', 'abc', '\'abc\'@\'localhost\''),
(13, 1, '2019-05-13 11:24:59', 'D', 'root@localhost', 'cba', 'cba', 'cba', '\'cba\'@\'localhost\''),
(14, 1, '2019-05-13 11:24:59', 'D', 'root@localhost', 'de3d', '3ed3e', '3ed3', '\'d3ed3\'@\'rfcrfc\''),
(15, 1, '2019-05-13 11:24:59', 'D', 'root@localhost', 'email', 'root', 'root', '\'root\'@\'localhost\''),
(16, 1, '2019-05-13 11:24:59', 'D', 'root@localhost', 'sadsadada', 'asdadasdasd', 'sadsad', '\'sadasdasdasd\'@\'localhost\''),
(17, 1, '2019-05-13 11:24:59', 'D', 'root@localhost', 'e@mail', 'O\'Name', 'Prof', '\'useruser\'@\'localhost\''),
(18, 1, '2019-05-13 11:25:28', 'I', 'root@localhost', 'abcd', 'acbd', 'abcd', 'abcd@localhost'),
(19, 1, '2019-05-13 11:25:54', 'I', 'root@localhost', 'xyz', 'xyz', 'xyz', 'xyz@localhost'),
(20, 1, '2019-05-13 11:28:53', 'I', 'root@localhost', 'root', 'root', 'profissional', 'root@localhost'),
(21, 1, '2019-05-13 12:00:25', 'I', 'root@localhost', 'abc', 'abc', 'abc', 'abc@localhost'),
(22, 1, '2019-05-17 13:00:32', 'I', 'root@localhost', 'e@mail.com', 'Utilizador A', 'Profisisonal', 'utilizador_a@localhost'),
(23, 1, '2019-05-17 13:13:04', 'I', 'root@localhost', 'abcdef', 'abcdef', 'abcdef', 'abcdef@localhost'),
(24, 1, '2019-05-17 13:43:37', 'I', 'root@localhost', 'toze', 'toze', 'toze', 'toze@localhost'),
(25, 1, '2019-05-17 13:59:26', 'I', 'root@localhost', 'socio', 'socio', 'socio', 'socio@localhost'),
(26, 1, '2019-05-17 14:04:23', 'I', 'root@localhost', 'sippinpurp@tm.com', 'sippin', 'purpp', 'sippin@localhost'),
(27, 1, '2019-05-17 14:28:08', 'I', 'root@localhost', 'user', 'user', 'user', 'user@localhost');

-- --------------------------------------------------------

--
-- Table structure for table `variaveis_medidas`
--

CREATE TABLE `variaveis_medidas` (
  `LimiteInferior` decimal(8,2) DEFAULT NULL,
  `LimiteSuperior` decimal(8,2) DEFAULT NULL,
  `Variavel_IDVariavel` int(11) NOT NULL,
  `Cultura_IDCultura` int(11) NOT NULL,
  `Margem` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `variaveis_medidas`
--

INSERT INTO `variaveis_medidas` (`LimiteInferior`, `LimiteSuperior`, `Variavel_IDVariavel`, `Cultura_IDCultura`, `Margem`) VALUES
('333.00', '444.00', 7, 12, 5555),
('0.00', '100.00', 7, 16, 0),
('123.00', '333.00', 8, 12, 333),
('4.00', '7.00', 8, 21, 0),
('10.00', '20.00', 9, 20, 0),
('888.00', '999.00', 10, 12, 33),
('1.00', '2.00', 12, 22, 0),
('5.00', '10.00', 14, 23, 0),
('10.00', '15.00', 16, 24, 0);

--
-- Triggers `variaveis_medidas`
--
DELIMITER $$
CREATE TRIGGER `variaveis_medidas_AFTER_DELETE` AFTER DELETE ON `variaveis_medidas` FOR EACH ROW BEGIN

INSERT INTO variaveis_medidas_log VALUES(NULL, 1, NOW(), 'D', current_user(), OLD.limiteinferior, OLD.limitesuperior, OLD.variavel_idvariavel, OLD.cultura_idcultura,old.margem);

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `variaveis_medidas_AFTER_INSERT` AFTER INSERT ON `variaveis_medidas` FOR EACH ROW BEGIN

INSERT INTO variaveis_medidas_log VALUES(NULL, 1, NOW(), 'I', current_user(), NEW.limiteinferior, NEW.limitesuperior, NEW.variavel_idvariavel, NEW.cultura_idcultura,new.margem);

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `variaveis_medidas_AFTER_UPDATE` AFTER UPDATE ON `variaveis_medidas` FOR EACH ROW BEGIN

INSERT INTO variaveis_medidas_log VALUES(NULL, 1, NOW(), 'U', current_user(), OLD.limiteinferior, OLD.limitesuperior, OLD.variavel_idvariavel, OLD.cultura_idcultura,old.margem);

INSERT INTO variaveis_medidas_log VALUES(NULL, 2, NOW(), 'U', current_user(), NEW.limiteinferior, NEW.limitesuperior, NEW.variavel_idvariavel, NEW.cultura_idcultura,new.margem);

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `variaveis_medidas_log`
--

CREATE TABLE `variaveis_medidas_log` (
  `id` int(11) NOT NULL,
  `precedencia` int(11) NOT NULL,
  `datahora` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `operacao` varchar(45) NOT NULL,
  `utilizador` varchar(100) NOT NULL,
  `limiteInferior` decimal(8,2) NOT NULL,
  `limiteSuperior` decimal(8,2) NOT NULL,
  `Variavel_idVariavel` int(11) NOT NULL,
  `Cultura_IdCultura` int(11) NOT NULL,
  `Margem` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `variaveis_medidas_log`
--

INSERT INTO `variaveis_medidas_log` (`id`, `precedencia`, `datahora`, `operacao`, `utilizador`, `limiteInferior`, `limiteSuperior`, `Variavel_idVariavel`, `Cultura_IdCultura`, `Margem`) VALUES
(1, 1, '2019-05-13 14:32:32', 'I', 'root@localhost', '0.00', '100.00', 7, 13, 0),
(2, 1, '2019-05-13 14:32:33', 'I', 'root@localhost', '0.00', '100.00', 7, 16, 0),
(3, 1, '2019-05-13 15:00:16', 'I', 'root@localhost', '123.00', '123.00', 7, 12, 0),
(4, 1, '2019-05-13 16:29:39', 'I', 'root@localhost', '5.00', '220.00', 7, 19, 0),
(5, 1, '2019-05-13 16:45:50', 'U', 'root@localhost', '123.00', '123.00', 7, 12, 0),
(6, 2, '2019-05-13 16:45:50', 'U', 'root@localhost', '123.00', '1255.00', 7, 12, 0),
(7, 1, '2019-05-13 16:47:58', 'U', 'root@localhost', '123.00', '1255.00', 7, 12, 0),
(8, 2, '2019-05-13 16:47:58', 'U', 'root@localhost', '123.00', '1555.00', 7, 12, 0),
(9, 1, '2019-05-13 16:54:37', 'U', 'root@localhost', '123.00', '1555.00', 7, 12, 0),
(10, 2, '2019-05-13 16:54:37', 'U', 'root@localhost', '123.00', '2555.00', 7, 12, 0),
(11, 1, '2019-05-13 16:54:59', 'D', 'root@localhost', '0.00', '100.00', 7, 13, 0),
(12, 1, '2019-05-13 16:55:19', 'I', 'root@localhost', '20.00', '3050.00', 7, 13, 0),
(13, 1, '2019-05-13 16:55:38', 'D', 'root@localhost', '20.00', '3050.00', 7, 13, 0),
(14, 1, '2019-05-13 17:04:21', 'I', 'root@localhost', '22.00', '333.00', 7, 13, 0),
(15, 1, '2019-05-13 17:12:36', 'D', 'root@localhost', '22.00', '333.00', 7, 13, 0),
(16, 1, '2019-05-13 17:12:37', 'D', 'root@localhost', '123.00', '2555.00', 7, 12, 0),
(17, 1, '2019-05-13 17:12:46', 'I', 'root@localhost', '11.00', '92.00', 7, 12, 0),
(18, 1, '2019-05-13 17:12:58', 'U', 'root@localhost', '11.00', '92.00', 7, 12, 0),
(19, 2, '2019-05-13 17:12:58', 'U', 'root@localhost', '11.00', '95.00', 7, 12, 0),
(20, 1, '2019-05-13 17:13:07', 'D', 'root@localhost', '11.00', '95.00', 7, 12, 0),
(21, 1, '2019-05-13 17:14:27', 'I', 'root@localhost', '23.00', '333.00', 7, 12, 0),
(22, 1, '2019-05-13 17:14:34', 'U', 'root@localhost', '23.00', '333.00', 7, 12, 0),
(23, 2, '2019-05-13 17:14:34', 'U', 'root@localhost', '23.00', '43333.00', 7, 12, 0),
(24, 1, '2019-05-13 17:14:39', 'D', 'root@localhost', '23.00', '43333.00', 7, 12, 0),
(25, 1, '2019-05-13 17:29:55', 'I', 'root@localhost', '12.00', '2000.00', 7, 12, 0),
(26, 1, '2019-05-13 17:48:23', 'I', 'root@localhost', '10.00', '1222.00', 7, 13, 0),
(27, 1, '2019-05-13 17:49:44', 'D', 'root@localhost', '10.00', '1222.00', 7, 13, 0),
(28, 1, '2019-05-13 18:04:33', 'I', 'root@localhost', '44.00', '4444.00', 7, 13, 0),
(29, 1, '2019-05-13 18:05:47', 'D', 'root@localhost', '44.00', '4444.00', 7, 13, 0),
(30, 1, '2019-05-13 18:15:34', 'I', 'root@localhost', '32.00', '33333.00', 7, 13, 0),
(31, 1, '2019-05-13 18:17:18', 'D', 'root@localhost', '32.00', '33333.00', 7, 13, 0),
(32, 1, '2019-05-13 18:17:49', 'I', 'root@localhost', '345.00', '543.00', 7, 13, 0),
(33, 1, '2019-05-13 18:19:25', 'D', 'root@localhost', '345.00', '543.00', 7, 13, 0),
(34, 1, '2019-05-13 18:19:33', 'I', 'root@localhost', '345.00', '543.00', 7, 13, 0),
(35, 1, '2019-05-13 18:22:11', 'D', 'root@localhost', '345.00', '543.00', 7, 13, 0),
(36, 1, '2019-05-13 18:22:27', 'I', 'root@localhost', '11.00', '11111.00', 7, 13, 0),
(37, 1, '2019-05-15 15:25:59', 'U', 'root@localhost', '12.00', '2000.00', 7, 12, 0),
(38, 2, '2019-05-15 15:25:59', 'U', 'root@localhost', '12.00', '2000.00', 7, 12, 20),
(39, 1, '2019-05-16 21:32:36', 'U', 'root@localhost', '12.00', '2000.00', 7, 12, 20),
(40, 2, '2019-05-16 21:32:36', 'U', 'root@localhost', '12.00', '2000.00', 7, 12, 2222),
(41, 1, '2019-05-16 21:34:42', 'D', 'root@localhost', '11.00', '11111.00', 7, 13, 0),
(42, 1, '2019-05-16 21:34:44', 'D', 'root@localhost', '12.00', '2000.00', 7, 12, 2222),
(43, 1, '2019-05-16 21:34:53', 'I', 'root@localhost', '123.00', '123321.00', 7, 12, 222222),
(44, 1, '2019-05-16 21:40:00', 'U', 'root@localhost', '123.00', '123321.00', 7, 12, 222222),
(45, 2, '2019-05-16 21:40:00', 'U', 'root@localhost', '123.00', '123321.00', 7, 12, 2223333),
(46, 1, '2019-05-16 21:40:09', 'D', 'root@localhost', '123.00', '123321.00', 7, 12, 2223333),
(47, 1, '2019-05-16 21:41:57', 'I', 'root@localhost', '123.00', '123321.00', 7, 12, 222),
(48, 1, '2019-05-16 21:42:07', 'U', 'root@localhost', '123.00', '123321.00', 7, 12, 222),
(49, 2, '2019-05-16 21:42:07', 'U', 'root@localhost', '123.00', '123321.00', 7, 12, 333),
(50, 1, '2019-05-16 21:42:21', 'I', 'root@localhost', '123.00', '33333.00', 7, 13, 4444),
(51, 1, '2019-05-16 21:42:26', 'D', 'root@localhost', '123.00', '123321.00', 7, 12, 333),
(52, 1, '2019-05-16 22:10:51', 'D', 'root@localhost', '123.00', '33333.00', 7, 13, 4444),
(53, 1, '2019-05-16 22:22:56', 'I', 'root@localhost', '123.00', '123321.00', 7, 12, 333),
(54, 1, '2019-05-16 22:54:10', 'I', 'root@localhost', '123.00', '333.00', 8, 12, 3333),
(55, 1, '2019-05-16 22:54:49', 'I', 'root@localhost', '3232.00', '3232.00', 7, 13, 323),
(56, 1, '2019-05-16 22:57:48', 'D', 'root@localhost', '123.00', '123321.00', 7, 12, 333),
(57, 1, '2019-05-16 22:58:02', 'D', 'root@localhost', '3232.00', '3232.00', 7, 13, 323),
(58, 1, '2019-05-16 22:58:07', 'D', 'root@localhost', '123.00', '333.00', 8, 12, 3333),
(59, 1, '2019-05-16 22:58:21', 'I', 'root@localhost', '123.00', '321.00', 7, 12, 123),
(60, 1, '2019-05-16 23:00:07', 'I', 'root@localhost', '333.00', '444.00', 7, 13, 555),
(61, 1, '2019-05-16 23:01:20', 'I', 'root@localhost', '133.00', '33.00', 8, 12, 3333),
(62, 1, '2019-05-16 23:01:29', 'I', 'root@localhost', '323.00', '3232.00', 8, 13, 33),
(63, 1, '2019-05-16 23:03:45', 'D', 'root@localhost', '323.00', '3232.00', 8, 13, 33),
(64, 1, '2019-05-16 23:03:45', 'D', 'root@localhost', '123.00', '321.00', 7, 12, 123),
(65, 1, '2019-05-16 23:03:45', 'D', 'root@localhost', '333.00', '444.00', 7, 13, 555),
(66, 1, '2019-05-16 23:03:45', 'D', 'root@localhost', '133.00', '33.00', 8, 12, 3333),
(67, 1, '2019-05-16 23:04:08', 'I', 'root@localhost', '123.00', '321.00', 8, 12, 333),
(68, 1, '2019-05-16 23:04:17', 'I', 'root@localhost', '333.00', '444.00', 7, 12, 5555),
(69, 1, '2019-05-16 23:04:29', 'U', 'root@localhost', '123.00', '321.00', 8, 12, 333),
(70, 2, '2019-05-16 23:04:29', 'U', 'root@localhost', '123.00', '333.00', 8, 12, 333),
(71, 1, '2019-05-17 13:04:36', 'I', 'root@localhost', '888.00', '999.00', 10, 12, 33),
(72, 1, '2019-05-17 13:17:51', 'I', 'root@localhost', '10.00', '20.00', 9, 20, 0),
(73, 1, '2019-05-17 13:54:24', 'I', 'root@localhost', '4.00', '7.00', 8, 21, 0),
(74, 1, '2019-05-17 14:01:52', 'I', 'root@localhost', '1.00', '2.00', 12, 22, 0),
(75, 1, '2019-05-17 14:07:52', 'I', 'root@localhost', '5.00', '10.00', 14, 23, 0),
(76, 1, '2019-05-17 14:08:27', 'I', 'root@localhost', '0.00', '0.00', 15, 23, 10),
(77, 1, '2019-05-17 14:30:00', 'I', 'root@localhost', '15.00', '10.00', 16, 24, 0),
(78, 1, '2019-05-17 14:30:38', 'U', 'root@localhost', '15.00', '10.00', 16, 24, 0),
(79, 2, '2019-05-17 14:30:38', 'U', 'root@localhost', '10.00', '15.00', 16, 24, 0);

-- --------------------------------------------------------

--
-- Table structure for table `variavel`
--

CREATE TABLE `variavel` (
  `IDvariavel` int(11) NOT NULL,
  `NomeVariavel` varchar(100) COLLATE utf8_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `variavel`
--

INSERT INTO `variavel` (`IDvariavel`, `NomeVariavel`) VALUES
(7, 'asdaddd'),
(8, 'variavel x'),
(9, 'Chumbo'),
(10, 'Sódio'),
(11, 'Ouro no pescoco'),
(12, 'condeina'),
(13, 'lean'),
(14, 'sabor'),
(16, 'Calcio');

--
-- Triggers `variavel`
--
DELIMITER $$
CREATE TRIGGER `variavel_AFTER_DELETE` AFTER DELETE ON `variavel` FOR EACH ROW BEGIN

INSERT INTO variavel_log VALUES(NULL, 1, NOW(), 'D', current_user(), OLD.idvariavel, OLD.nomevariavel);

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `variavel_AFTER_INSERT` AFTER INSERT ON `variavel` FOR EACH ROW BEGIN

INSERT INTO variavel_log VALUES(NULL, 1, NOW(), 'I', current_user(), NEW.idvariavel, NEW.nomevariavel);

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `variavel_AFTER_UPDATE` AFTER UPDATE ON `variavel` FOR EACH ROW BEGIN

INSERT INTO variavel_log VALUES(NULL, 1, NOW(), 'U', current_user(), OLD.idvariavel, OLD.nomevariavel);

INSERT INTO variavel_log VALUES(NULL, 2, NOW(), 'U', current_user(), NEW.idvariavel, NEW.nomevariavel);

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `variavel_log`
--

CREATE TABLE `variavel_log` (
  `id` int(11) NOT NULL,
  `precedencia` int(11) NOT NULL,
  `datahora` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `operacao` varchar(45) NOT NULL,
  `utilizador` varchar(100) NOT NULL,
  `IDVariavel` int(11) NOT NULL,
  `NomeVariavel` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `variavel_log`
--

INSERT INTO `variavel_log` (`id`, `precedencia`, `datahora`, `operacao`, `utilizador`, `IDVariavel`, `NomeVariavel`) VALUES
(1, 1, '2019-05-13 09:38:54', 'I', 'root@localhost', 7, 'asda'),
(2, 1, '2019-05-13 09:40:15', 'I', 'root@localhost', 8, 'variavel b'),
(3, 1, '2019-05-13 09:40:56', 'I', 'root@localhost', 9, 'variavel aaaaa'),
(4, 1, '2019-05-13 09:41:26', 'D', 'root@localhost', 8, 'variavel b'),
(5, 1, '2019-05-13 10:28:29', 'U', 'root@localhost', 9, 'variavel aaaaa'),
(6, 2, '2019-05-13 10:28:29', 'U', 'root@localhost', 9, 'variavel abcdef'),
(7, 1, '2019-05-13 10:30:43', 'U', 'root@localhost', 7, 'asda'),
(8, 2, '2019-05-13 10:30:43', 'U', 'root@localhost', 7, 'asdaddd'),
(9, 1, '2019-05-13 10:30:53', 'D', 'root@localhost', 9, 'variavel abcdef'),
(10, 1, '2019-05-16 22:12:42', 'I', 'root@localhost', 8, 'variavel x'),
(11, 1, '2019-05-17 12:59:29', 'I', 'root@localhost', 9, 'Chumbo'),
(12, 1, '2019-05-17 12:59:36', 'I', 'root@localhost', 10, 'Sódio'),
(13, 1, '2019-05-17 13:59:41', 'I', 'root@localhost', 11, 'Ouro no pescoco'),
(14, 1, '2019-05-17 13:59:48', 'I', 'root@localhost', 12, 'condeina'),
(15, 1, '2019-05-17 14:00:10', 'I', 'root@localhost', 13, 'lean'),
(16, 1, '2019-05-17 14:06:33', 'I', 'root@localhost', 14, 'sabor'),
(17, 1, '2019-05-17 14:06:40', 'I', 'root@localhost', 15, 'xanax'),
(18, 1, '2019-05-17 14:27:11', 'I', 'root@localhost', 16, 'Calcio'),
(19, 1, '2019-05-17 14:27:17', 'D', 'root@localhost', 15, 'xanax');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `alerta`
--
ALTER TABLE `alerta`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `alertavariavel`
--
ALTER TABLE `alertavariavel`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cultura`
--
ALTER TABLE `cultura`
  ADD PRIMARY KEY (`IDcultura`),
  ADD KEY `username_idx` (`username`);

--
-- Indexes for table `cultura_log`
--
ALTER TABLE `cultura_log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `medicao`
--
ALTER TABLE `medicao`
  ADD PRIMARY KEY (`NumeroMedicao`),
  ADD KEY `id_cultura_idx` (`VariaveisMedidas_IDCultura`),
  ADD KEY `id_variavel_idx` (`VariaveisMedidas_IDVariavel`);

--
-- Indexes for table `medicao_log`
--
ALTER TABLE `medicao_log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `medicoes_luminosidade`
--
ALTER TABLE `medicoes_luminosidade`
  ADD PRIMARY KEY (`IDMedicao`);

--
-- Indexes for table `medicoes_temperatura`
--
ALTER TABLE `medicoes_temperatura`
  ADD PRIMARY KEY (`IDmedicao`);

--
-- Indexes for table `sistema_log`
--
ALTER TABLE `sistema_log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `utilizador`
--
ALTER TABLE `utilizador`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `utilizador_log`
--
ALTER TABLE `utilizador_log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `variaveis_medidas`
--
ALTER TABLE `variaveis_medidas`
  ADD PRIMARY KEY (`Variavel_IDVariavel`,`Cultura_IDCultura`),
  ADD KEY `cultura_idcultura_idx` (`Cultura_IDCultura`),
  ADD KEY `variaveis_idvariavel_idx` (`Variavel_IDVariavel`);

--
-- Indexes for table `variaveis_medidas_log`
--
ALTER TABLE `variaveis_medidas_log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `variavel`
--
ALTER TABLE `variavel`
  ADD PRIMARY KEY (`IDvariavel`);

--
-- Indexes for table `variavel_log`
--
ALTER TABLE `variavel_log`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `alerta`
--
ALTER TABLE `alerta`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- AUTO_INCREMENT for table `alertavariavel`
--
ALTER TABLE `alertavariavel`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `cultura`
--
ALTER TABLE `cultura`
  MODIFY `IDcultura` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `cultura_log`
--
ALTER TABLE `cultura_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `medicao`
--
ALTER TABLE `medicao`
  MODIFY `NumeroMedicao` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `medicao_log`
--
ALTER TABLE `medicao_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT for table `medicoes_luminosidade`
--
ALTER TABLE `medicoes_luminosidade`
  MODIFY `IDMedicao` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2897;

--
-- AUTO_INCREMENT for table `medicoes_temperatura`
--
ALTER TABLE `medicoes_temperatura`
  MODIFY `IDmedicao` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2843;

--
-- AUTO_INCREMENT for table `sistema_log`
--
ALTER TABLE `sistema_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `utilizador_log`
--
ALTER TABLE `utilizador_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `variaveis_medidas_log`
--
ALTER TABLE `variaveis_medidas_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=80;

--
-- AUTO_INCREMENT for table `variavel`
--
ALTER TABLE `variavel`
  MODIFY `IDvariavel` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `variavel_log`
--
ALTER TABLE `variavel_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cultura`
--
ALTER TABLE `cultura`
  ADD CONSTRAINT `username` FOREIGN KEY (`username`) REFERENCES `utilizador` (`username`) ON DELETE CASCADE;

--
-- Constraints for table `medicao`
--
ALTER TABLE `medicao`
  ADD CONSTRAINT `id_cultura` FOREIGN KEY (`VariaveisMedidas_IDCultura`) REFERENCES `variaveis_medidas` (`Cultura_IDCultura`) ON DELETE CASCADE,
  ADD CONSTRAINT `id_variavel` FOREIGN KEY (`VariaveisMedidas_IDVariavel`) REFERENCES `variaveis_medidas` (`Variavel_IDVariavel`) ON DELETE CASCADE;

--
-- Constraints for table `variaveis_medidas`
--
ALTER TABLE `variaveis_medidas`
  ADD CONSTRAINT `cultura_idcultura` FOREIGN KEY (`Cultura_IDCultura`) REFERENCES `cultura` (`IDcultura`) ON DELETE CASCADE,
  ADD CONSTRAINT `variaveis_idvariavel` FOREIGN KEY (`Variavel_IDVariavel`) REFERENCES `variavel` (`IDvariavel`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
