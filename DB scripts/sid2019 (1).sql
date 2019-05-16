-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: 14-Maio-2019 às 17:40
-- Versão do servidor: 10.1.39-MariaDB
-- versão do PHP: 7.3.5

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `sid2019`
--
create database sid2019;
use sid2019;

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

CREATE DEFINER=`root`@`localhost` PROCEDURE `cria_variaveis_medidas` (IN `culturaid` INT, IN `variavelid` INT, IN `limiteS` DECIMAL(8,2), IN `limiteI` DECIMAL(8,2))  NO SQL
    SQL SECURITY INVOKER
begin
	if culturaid in (SELECT idcultura from cultura where current_user()=username) THEN
    INSERT into variaveis_medidas values (limiteI,limiteS,variavelid,culturaid);
    end if;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getAlertasCultura` (IN `id` INT, IN `tim` TIMESTAMP)  NO SQL
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `select_limites` ()  NO SQL
    SQL SECURITY INVOKER
BEGIN

	SELECT limiteinferior, limitesuperior, variavel_idvariavel, cultura_idcultura, nomevariavel, nomecultura FROM variaveis_medidas, cultura, variavel
    WHERE cultura_idcultura = IDcultura AND
    username = CURRENT_USER();

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `select_medicoes` ()  NO SQL
    SQL SECURITY INVOKER
BEGIN

SELECT NumeroMedicao, datahoramedicao, valormedicao, VariaveisMedidas_IDCultura,VariaveisMedidas_IDVariavel, nomevariavel, nomecultura 
FROM medicao, cultura, variavel
WHERE VariaveisMedidas_IDCultura = IDcultura AND
username = CURRENT_USER();

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `alerta`
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
-- Extraindo dados da tabela `alerta`
--

INSERT INTO `alerta` (`id`, `tipo`, `datahora`, `valor`, `limiteInferior`, `limiteSuperior`, `Descricao`) VALUES
(1, 'luz', '2019-05-14 15:01:31', '23.00', '1.00', '10.00', 'maior');

-- --------------------------------------------------------

--
-- Estrutura da tabela `alertavariavel`
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
-- Extraindo dados da tabela `alertavariavel`
--

INSERT INTO `alertavariavel` (`id`, `datahora`, `variavel`, `cultura`, `valor`, `limiteInferior`, `limiteSuperior`, `Descricao`) VALUES
(0, '2019-05-14 15:22:12', 7, 12, '23.00', '123.00', '123.00', 'descricao');

-- --------------------------------------------------------

--
-- Estrutura da tabela `cultura`
--

CREATE TABLE `cultura` (
  `IDcultura` int(11) NOT NULL,
  `NomeCultura` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `DescricaoCultura` text COLLATE utf8_bin,
  `username` varchar(100) COLLATE utf8_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Extraindo dados da tabela `cultura`
--

INSERT INTO `cultura` (`IDcultura`, `NomeCultura`, `DescricaoCultura`, `username`) VALUES
(12, 'cultura1', 'descricao1', 'root@localhost'),
(13, 'cultura2', 'descricao2', 'root@localhost'),
(14, 'cultura3', 'descricao3', 'abcd@localhost'),
(15, 'cultura4', 'descricao4', 'xyz@localhost'),
(16, 'cultura5', 'descricao5', 'abcd@localhost'),
(17, 'cultura6', 'descricao6', 'xyz@localhost');

--
-- Acionadores `cultura`
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
-- Estrutura da tabela `cultura_log`
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
-- Extraindo dados da tabela `cultura_log`
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
(29, 1, '2019-05-13 17:14:14', 'D', 'root@localhost', 21, 'rrrreeeeeee', 'rrrrr', 'root@localhost');

-- --------------------------------------------------------

--
-- Estrutura da tabela `medicao`
--

CREATE TABLE `medicao` (
  `NumeroMedicao` int(11) NOT NULL,
  `DataHoraMedicao` timestamp(6) NULL DEFAULT NULL,
  `ValorMedicao` decimal(8,2) DEFAULT NULL,
  `VariaveisMedidas_IDCultura` int(11) DEFAULT NULL,
  `VariaveisMedidas_IDVariavel` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Extraindo dados da tabela `medicao`
--

INSERT INTO `medicao` (`NumeroMedicao`, `DataHoraMedicao`, `ValorMedicao`, `VariaveisMedidas_IDCultura`, `VariaveisMedidas_IDVariavel`) VALUES
(16, '2019-05-13 18:22:16.000000', '4444.00', 12, 7);

--
-- Acionadores `medicao`
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

	SET @id = 0;
	SET @min = (SELECT limiteInferior FROM variaveis_medidas WHERE variavel_idvariavel = NEW.variaveismedidas_idvariavel AND cultura_idcultura = NEW.variaveismedidas_idcultura);
    SET @max = (SELECT limiteSuperior FROM variaveis_medidas WHERE variavel_idvariavel = NEW.variaveismedidas_idvariavel AND cultura_idcultura = NEW.variaveismedidas_idcultura);
    
	IF NEW.valormedicao < @min OR NEW.valormedicao > @max THEN
    	INSERT INTO alertavariavel VALUES(@id, NEW.datahoramedicao, NEW.variaveismedidas_idvariavel, NEW.variaveismedidas_idcultura, NEW.valormedicao, @min, @max,"descricao");
    END IF;
    
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `medicao_log`
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
-- Extraindo dados da tabela `medicao_log`
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
(15, 2, '2019-05-13 18:49:14', 'U', 'root@localhost', 16, '2019-05-13 18:22:16', '4444.00', 12, 7);

-- --------------------------------------------------------

--
-- Estrutura da tabela `medicoes_luminosidade`
--

CREATE TABLE `medicoes_luminosidade` (
  `IDMedicao` int(11) NOT NULL,
  `DataHoraMedicao` timestamp(6) NULL DEFAULT NULL,
  `ValorMedicaoLuminosidade` decimal(8,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Extraindo dados da tabela `medicoes_luminosidade`
--

INSERT INTO `medicoes_luminosidade` (`IDMedicao`, `DataHoraMedicao`, `ValorMedicaoLuminosidade`) VALUES
(1, '2019-05-14 14:04:56.000000', '2000.00'),
(10, '2019-05-14 12:44:18.000000', '2807.00'),
(20, '2019-05-14 12:44:40.000000', '2812.00'),
(30, '2019-05-14 12:45:02.000000', '2803.00'),
(40, '2019-05-14 12:45:24.000000', '2811.00'),
(50, '2019-05-14 12:45:46.000000', '2807.00'),
(60, '2019-05-14 12:46:08.000000', '2810.00'),
(70, '2019-05-14 12:46:29.000000', '2808.00'),
(80, '2019-05-14 12:46:51.000000', '2808.00'),
(90, '2019-05-14 12:47:13.000000', '2813.00'),
(100, '2019-05-14 12:47:35.000000', '2808.00'),
(120, '2019-05-14 12:48:18.000000', '607.00'),
(130, '2019-05-14 12:48:40.000000', '2728.00'),
(150, '2019-05-14 12:49:24.000000', '2739.00'),
(160, '2019-05-14 12:49:45.000000', '2725.00'),
(170, '2019-05-14 12:50:07.000000', '2735.00'),
(180, '2019-05-14 12:50:29.000000', '2733.00'),
(190, '2019-05-14 12:50:50.000000', '2738.00'),
(200, '2019-05-14 12:51:12.000000', '2738.00'),
(210, '2019-05-14 12:51:34.000000', '2746.00'),
(220, '2019-05-14 12:51:56.000000', '2742.00'),
(230, '2019-05-14 12:52:17.000000', '2733.00'),
(240, '2019-05-14 12:52:39.000000', '2743.00'),
(250, '2019-05-14 12:53:01.000000', '2741.00'),
(260, '2019-05-14 12:53:23.000000', '2732.00'),
(270, '2019-05-14 12:53:44.000000', '2740.00'),
(290, '2019-05-14 12:54:28.000000', '2722.00'),
(300, '2019-05-14 12:54:50.000000', '2738.00'),
(310, '2019-05-14 12:55:12.000000', '2729.00'),
(320, '2019-05-14 12:55:34.000000', '2739.00'),
(330, '2019-05-14 12:55:56.000000', '2803.00'),
(340, '2019-05-14 12:56:17.000000', '2797.00'),
(350, '2019-05-14 12:56:39.000000', '2805.00'),
(360, '2019-05-14 12:57:01.000000', '2805.00'),
(370, '2019-05-14 12:57:23.000000', '2819.00'),
(380, '2019-05-14 12:57:44.000000', '2818.00'),
(390, '2019-05-14 12:58:06.000000', '2817.00'),
(400, '2019-05-14 12:58:28.000000', '2819.00'),
(410, '2019-05-14 12:58:50.000000', '2816.00'),
(420, '2019-05-14 13:24:29.000000', '2808.00'),
(430, '2019-05-14 13:24:51.000000', '2803.00'),
(440, '2019-05-14 13:25:12.000000', '2799.00'),
(450, '2019-05-14 13:25:34.000000', '2802.00'),
(460, '2019-05-14 13:25:55.000000', '2806.00'),
(470, '2019-05-14 13:26:17.000000', '2801.00'),
(480, '2019-05-14 13:26:39.000000', '2801.00'),
(490, '2019-05-14 14:36:12.000000', '2811.00'),
(500, '2019-05-14 14:36:34.000000', '2828.00'),
(510, '2019-05-14 14:36:56.000000', '2832.00'),
(520, '2019-05-14 14:37:18.000000', '2831.00'),
(530, '2019-05-14 14:37:39.000000', '2826.00'),
(540, '2019-05-14 14:38:01.000000', '2834.00'),
(550, '2019-05-14 14:38:23.000000', '2827.00'),
(560, '2019-05-14 14:38:45.000000', '2832.00'),
(570, '2019-05-14 14:39:06.000000', '2832.00'),
(580, '2019-05-14 14:39:28.000000', '2829.00'),
(590, '2019-05-14 14:39:50.000000', '2833.00'),
(600, '2019-05-14 14:40:12.000000', '2835.00'),
(610, '2019-05-14 14:40:34.000000', '2826.00');

--
-- Acionadores `medicoes_luminosidade`
--
DELIMITER $$
CREATE TRIGGER `verificar_luz` BEFORE INSERT ON `medicoes_luminosidade` FOR EACH ROW BEGIN

	SET @id = 0;
	SET @min = (SELECT limiteInferiorLuz FROM sistema);
    SET @max = (SELECT limiteSuperiorLuz FROM sistema);
    
    IF NEW.valormedicaoluminosidade < @min OR NEW.valormedicaoluminosidade > @max THEN
    	INSERT INTO alerta VALUES(@id, "luz", NEW.datahoramedicao, NEW.valormedicaoluminosidade, @min, @max,"descricao");
    END IF;
    
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `medicoes_temperatura`
--

CREATE TABLE `medicoes_temperatura` (
  `IDmedicao` int(11) NOT NULL,
  `DataHoraMedicao` timestamp(6) NULL DEFAULT NULL,
  `ValorMedicaoTemperatura` decimal(8,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Extraindo dados da tabela `medicoes_temperatura`
--

INSERT INTO `medicoes_temperatura` (`IDmedicao`, `DataHoraMedicao`, `ValorMedicaoTemperatura`) VALUES
(10, '2019-05-14 12:44:18.000000', '24.62'),
(20, '2019-05-14 12:44:40.000000', '24.57'),
(30, '2019-05-14 12:45:02.000000', '24.53'),
(40, '2019-05-14 12:45:24.000000', '24.50'),
(50, '2019-05-14 12:45:46.000000', '24.51'),
(60, '2019-05-14 12:46:08.000000', '24.45'),
(70, '2019-05-14 12:46:29.000000', '24.45'),
(80, '2019-05-14 12:46:51.000000', '24.42'),
(90, '2019-05-14 12:47:13.000000', '24.38'),
(100, '2019-05-14 12:47:35.000000', '24.33'),
(120, '2019-05-14 12:48:18.000000', '24.80'),
(130, '2019-05-14 12:48:40.000000', '25.16'),
(150, '2019-05-14 12:49:24.000000', '27.93'),
(160, '2019-05-14 12:49:45.000000', '26.28'),
(170, '2019-05-14 12:50:07.000000', '25.60'),
(180, '2019-05-14 12:50:29.000000', '25.46'),
(190, '2019-05-14 12:50:50.000000', '25.40'),
(200, '2019-05-14 12:51:12.000000', '25.42'),
(210, '2019-05-14 12:51:34.000000', '25.40'),
(220, '2019-05-14 12:51:56.000000', '25.40'),
(230, '2019-05-14 12:52:17.000000', '25.38'),
(240, '2019-05-14 12:52:39.000000', '25.40'),
(250, '2019-05-14 12:53:01.000000', '25.40'),
(260, '2019-05-14 12:53:23.000000', '25.39'),
(270, '2019-05-14 12:53:44.000000', '25.43'),
(290, '2019-05-14 12:54:28.000000', '26.24'),
(300, '2019-05-14 12:54:50.000000', '26.02'),
(310, '2019-05-14 12:55:12.000000', '25.84'),
(320, '2019-05-14 12:55:34.000000', '25.71'),
(330, '2019-05-14 12:55:56.000000', '25.59'),
(340, '2019-05-14 12:56:17.000000', '25.39'),
(350, '2019-05-14 12:56:39.000000', '25.21'),
(360, '2019-05-14 12:57:01.000000', '25.12'),
(370, '2019-05-14 12:57:23.000000', '25.00'),
(380, '2019-05-14 12:57:44.000000', '24.93'),
(390, '2019-05-14 12:58:06.000000', '24.86'),
(400, '2019-05-14 12:58:28.000000', '24.81'),
(410, '2019-05-14 12:58:50.000000', '24.77'),
(420, '2019-05-14 13:24:29.000000', '24.33'),
(430, '2019-05-14 13:24:51.000000', '23.38'),
(440, '2019-05-14 13:25:12.000000', '23.34'),
(450, '2019-05-14 13:25:34.000000', '23.38'),
(460, '2019-05-14 13:25:55.000000', '23.38'),
(470, '2019-05-14 13:26:17.000000', '23.31'),
(480, '2019-05-14 13:26:39.000000', '23.39'),
(490, '2019-05-14 14:36:12.000000', '23.33'),
(500, '2019-05-14 14:36:34.000000', '23.26'),
(510, '2019-05-14 14:36:56.000000', '23.28'),
(520, '2019-05-14 14:37:18.000000', '23.28'),
(530, '2019-05-14 14:37:39.000000', '23.30'),
(540, '2019-05-14 14:38:01.000000', '23.28'),
(550, '2019-05-14 14:38:23.000000', '23.29'),
(560, '2019-05-14 14:38:45.000000', '23.26'),
(570, '2019-05-14 14:39:06.000000', '23.27'),
(580, '2019-05-14 14:39:28.000000', '23.29'),
(590, '2019-05-14 14:39:50.000000', '23.29'),
(600, '2019-05-14 14:40:12.000000', '23.25'),
(610, '2019-05-14 14:40:34.000000', '23.27');

--
-- Acionadores `medicoes_temperatura`
--
DELIMITER $$
CREATE TRIGGER `verificar_temp` BEFORE INSERT ON `medicoes_temperatura` FOR EACH ROW BEGIN

	SET @id = 0;
	SET @min = (SELECT limiteInferiorTemperatura FROM sistema);
    SET @max = (SELECT limiteSuperiorTemperatura FROM sistema);
    
	IF NEW.valormedicaotemperatura < @min OR NEW.valormedicaotemperatura > @max THEN
    	INSERT INTO alerta VALUES(@id, "temp", NEW.datahoramedicao, NEW.valormedicaotemperatura, @min, @max,"descricao");
    END IF;
    
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `sistema`
--

CREATE TABLE `sistema` (
  `LimiteInferiorTemperatura` decimal(8,2) DEFAULT NULL,
  `LimiteSuperiorTemperatura` decimal(8,2) DEFAULT NULL,
  `LimiteSuperiorLuz` decimal(8,2) DEFAULT NULL,
  `LimiteInferiorLuz` decimal(8,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Acionadores `sistema`
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
-- Estrutura da tabela `sistema_log`
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

-- --------------------------------------------------------

--
-- Estrutura da tabela `utilizador`
--

CREATE TABLE `utilizador` (
  `Email` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `NomeUtilizador` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `CategoriaProfissional` varchar(300) COLLATE utf8_bin DEFAULT NULL,
  `username` varchar(100) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Extraindo dados da tabela `utilizador`
--

INSERT INTO `utilizador` (`Email`, `NomeUtilizador`, `CategoriaProfissional`, `username`) VALUES
('abc', 'abc', 'abc', 'abc@localhost'),
('abcd', 'acbd', 'abcd', 'abcd@localhost'),
('def', 'def', 'def', 'def@localhost'),
('root', 'root', 'profissional', 'root@localhost'),
('xyz', 'xyz', 'xyz', 'xyz@localhost');

--
-- Acionadores `utilizador`
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
-- Estrutura da tabela `utilizador_log`
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
-- Extraindo dados da tabela `utilizador_log`
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
(21, 1, '2019-05-13 12:00:25', 'I', 'root@localhost', 'abc', 'abc', 'abc', 'abc@localhost');

-- --------------------------------------------------------

--
-- Estrutura da tabela `variaveis_medidas`
--

CREATE TABLE `variaveis_medidas` (
  `LimiteInferior` decimal(8,2) DEFAULT NULL,
  `LimiteSuperior` decimal(8,2) DEFAULT NULL,
  `Variavel_IDVariavel` int(11) NOT NULL,
  `Cultura_IDCultura` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Extraindo dados da tabela `variaveis_medidas`
--

INSERT INTO `variaveis_medidas` (`LimiteInferior`, `LimiteSuperior`, `Variavel_IDVariavel`, `Cultura_IDCultura`) VALUES
('12.00', '2000.00', 7, 12),
('11.00', '11111.00', 7, 13),
('0.00', '100.00', 7, 16);

--
-- Acionadores `variaveis_medidas`
--
DELIMITER $$
CREATE TRIGGER `variaveis_medidas_AFTER_DELETE` AFTER DELETE ON `variaveis_medidas` FOR EACH ROW BEGIN

INSERT INTO variaveis_medidas_log VALUES(NULL, 1, NOW(), 'D', current_user(), OLD.limiteinferior, OLD.limitesuperior, OLD.variavel_idvariavel, OLD.cultura_idcultura);

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `variaveis_medidas_AFTER_INSERT` AFTER INSERT ON `variaveis_medidas` FOR EACH ROW BEGIN

INSERT INTO variaveis_medidas_log VALUES(NULL, 1, NOW(), 'I', current_user(), NEW.limiteinferior, NEW.limitesuperior, NEW.variavel_idvariavel, NEW.cultura_idcultura);

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `variaveis_medidas_AFTER_UPDATE` AFTER UPDATE ON `variaveis_medidas` FOR EACH ROW BEGIN

INSERT INTO variaveis_medidas_log VALUES(NULL, 1, NOW(), 'U', current_user(), OLD.limiteinferior, OLD.limitesuperior, OLD.variavel_idvariavel, OLD.cultura_idcultura);

INSERT INTO variaveis_medidas_log VALUES(NULL, 2, NOW(), 'U', current_user(), NEW.limiteinferior, NEW.limitesuperior, NEW.variavel_idvariavel, NEW.cultura_idcultura);

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `variaveis_medidas_log`
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
  `Cultura_IdCultura` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `variaveis_medidas_log`
--

INSERT INTO `variaveis_medidas_log` (`id`, `precedencia`, `datahora`, `operacao`, `utilizador`, `limiteInferior`, `limiteSuperior`, `Variavel_idVariavel`, `Cultura_IdCultura`) VALUES
(1, 1, '2019-05-13 14:32:32', 'I', 'root@localhost', '0.00', '100.00', 7, 13),
(2, 1, '2019-05-13 14:32:33', 'I', 'root@localhost', '0.00', '100.00', 7, 16),
(3, 1, '2019-05-13 15:00:16', 'I', 'root@localhost', '123.00', '123.00', 7, 12),
(4, 1, '2019-05-13 16:29:39', 'I', 'root@localhost', '5.00', '220.00', 7, 19),
(5, 1, '2019-05-13 16:45:50', 'U', 'root@localhost', '123.00', '123.00', 7, 12),
(6, 2, '2019-05-13 16:45:50', 'U', 'root@localhost', '123.00', '1255.00', 7, 12),
(7, 1, '2019-05-13 16:47:58', 'U', 'root@localhost', '123.00', '1255.00', 7, 12),
(8, 2, '2019-05-13 16:47:58', 'U', 'root@localhost', '123.00', '1555.00', 7, 12),
(9, 1, '2019-05-13 16:54:37', 'U', 'root@localhost', '123.00', '1555.00', 7, 12),
(10, 2, '2019-05-13 16:54:37', 'U', 'root@localhost', '123.00', '2555.00', 7, 12),
(11, 1, '2019-05-13 16:54:59', 'D', 'root@localhost', '0.00', '100.00', 7, 13),
(12, 1, '2019-05-13 16:55:19', 'I', 'root@localhost', '20.00', '3050.00', 7, 13),
(13, 1, '2019-05-13 16:55:38', 'D', 'root@localhost', '20.00', '3050.00', 7, 13),
(14, 1, '2019-05-13 17:04:21', 'I', 'root@localhost', '22.00', '333.00', 7, 13),
(15, 1, '2019-05-13 17:12:36', 'D', 'root@localhost', '22.00', '333.00', 7, 13),
(16, 1, '2019-05-13 17:12:37', 'D', 'root@localhost', '123.00', '2555.00', 7, 12),
(17, 1, '2019-05-13 17:12:46', 'I', 'root@localhost', '11.00', '92.00', 7, 12),
(18, 1, '2019-05-13 17:12:58', 'U', 'root@localhost', '11.00', '92.00', 7, 12),
(19, 2, '2019-05-13 17:12:58', 'U', 'root@localhost', '11.00', '95.00', 7, 12),
(20, 1, '2019-05-13 17:13:07', 'D', 'root@localhost', '11.00', '95.00', 7, 12),
(21, 1, '2019-05-13 17:14:27', 'I', 'root@localhost', '23.00', '333.00', 7, 12),
(22, 1, '2019-05-13 17:14:34', 'U', 'root@localhost', '23.00', '333.00', 7, 12),
(23, 2, '2019-05-13 17:14:34', 'U', 'root@localhost', '23.00', '43333.00', 7, 12),
(24, 1, '2019-05-13 17:14:39', 'D', 'root@localhost', '23.00', '43333.00', 7, 12),
(25, 1, '2019-05-13 17:29:55', 'I', 'root@localhost', '12.00', '2000.00', 7, 12),
(26, 1, '2019-05-13 17:48:23', 'I', 'root@localhost', '10.00', '1222.00', 7, 13),
(27, 1, '2019-05-13 17:49:44', 'D', 'root@localhost', '10.00', '1222.00', 7, 13),
(28, 1, '2019-05-13 18:04:33', 'I', 'root@localhost', '44.00', '4444.00', 7, 13),
(29, 1, '2019-05-13 18:05:47', 'D', 'root@localhost', '44.00', '4444.00', 7, 13),
(30, 1, '2019-05-13 18:15:34', 'I', 'root@localhost', '32.00', '33333.00', 7, 13),
(31, 1, '2019-05-13 18:17:18', 'D', 'root@localhost', '32.00', '33333.00', 7, 13),
(32, 1, '2019-05-13 18:17:49', 'I', 'root@localhost', '345.00', '543.00', 7, 13),
(33, 1, '2019-05-13 18:19:25', 'D', 'root@localhost', '345.00', '543.00', 7, 13),
(34, 1, '2019-05-13 18:19:33', 'I', 'root@localhost', '345.00', '543.00', 7, 13),
(35, 1, '2019-05-13 18:22:11', 'D', 'root@localhost', '345.00', '543.00', 7, 13),
(36, 1, '2019-05-13 18:22:27', 'I', 'root@localhost', '11.00', '11111.00', 7, 13);

-- --------------------------------------------------------

--
-- Estrutura da tabela `variavel`
--

CREATE TABLE `variavel` (
  `IDvariavel` int(11) NOT NULL,
  `NomeVariavel` varchar(100) COLLATE utf8_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Extraindo dados da tabela `variavel`
--

INSERT INTO `variavel` (`IDvariavel`, `NomeVariavel`) VALUES
(7, 'asdaddd');

--
-- Acionadores `variavel`
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
-- Estrutura da tabela `variavel_log`
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
-- Extraindo dados da tabela `variavel_log`
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
(9, 1, '2019-05-13 10:30:53', 'D', 'root@localhost', 9, 'variavel abcdef');

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `alertavariavel`
--
ALTER TABLE `alertavariavel`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cultura`
--
ALTER TABLE `cultura`
  MODIFY `IDcultura` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `cultura_log`
--
ALTER TABLE `cultura_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `medicao`
--
ALTER TABLE `medicao`
  MODIFY `NumeroMedicao` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `medicao_log`
--
ALTER TABLE `medicao_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `medicoes_luminosidade`
--
ALTER TABLE `medicoes_luminosidade`
  MODIFY `IDMedicao` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=611;

--
-- AUTO_INCREMENT for table `medicoes_temperatura`
--
ALTER TABLE `medicoes_temperatura`
  MODIFY `IDmedicao` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=611;

--
-- AUTO_INCREMENT for table `sistema_log`
--
ALTER TABLE `sistema_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `utilizador_log`
--
ALTER TABLE `utilizador_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `variaveis_medidas_log`
--
ALTER TABLE `variaveis_medidas_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `variavel`
--
ALTER TABLE `variavel`
  MODIFY `IDvariavel` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `variavel_log`
--
ALTER TABLE `variavel_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Constraints for dumped tables
--

--
-- Limitadores para a tabela `cultura`
--
ALTER TABLE `cultura`
  ADD CONSTRAINT `username` FOREIGN KEY (`username`) REFERENCES `utilizador` (`username`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `medicao`
--
ALTER TABLE `medicao`
  ADD CONSTRAINT `id_cultura` FOREIGN KEY (`VariaveisMedidas_IDCultura`) REFERENCES `variaveis_medidas` (`Cultura_IDCultura`) ON DELETE CASCADE,
  ADD CONSTRAINT `id_variavel` FOREIGN KEY (`VariaveisMedidas_IDVariavel`) REFERENCES `variaveis_medidas` (`Variavel_IDVariavel`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `variaveis_medidas`
--
ALTER TABLE `variaveis_medidas`
  ADD CONSTRAINT `cultura_idcultura` FOREIGN KEY (`Cultura_IDCultura`) REFERENCES `cultura` (`IDcultura`) ON DELETE CASCADE,
  ADD CONSTRAINT `variaveis_idvariavel` FOREIGN KEY (`Variavel_IDVariavel`) REFERENCES `variavel` (`IDvariavel`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
