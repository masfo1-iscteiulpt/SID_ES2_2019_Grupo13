-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: 12-Maio-2019 às 18:07
-- Versão do servidor: 10.1.38-MariaDB
-- versão do PHP: 7.3.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `teste2`
--
create database teste3;
use teste3;

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `altera_cultura` (IN `id` INT, IN `des` TEXT)  NO SQL
BEGIN
if id in(select idcultura from cultura
 where current_user()=cultura.username) then
update cultura
set cultura.descricaocultura=des
 where cultura.idcultura=id;
end if;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `apaga_cultura` (IN `id` INT)  NO SQL
BEGIN
if id in(select idcultura from cultura
 where current_user()=cultura.username) then
delete from cultura
where cultura.idcultura=id;
end if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `apaga_medicao` (IN `idcultura` INT, IN `id` INT)  NO SQL
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `cria_cultura` (IN `nome` VARCHAR(100), IN `descricao` TEXT)  NO SQL
BEGIN
insert into cultura
values(null,nome,descricao,currentuser());
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cria_utilizador` (IN `Email` VARCHAR(50), IN `Nome` VARCHAR(100), IN `CProf` VARCHAR(300), IN `p_Name` VARCHAR(100), IN `p_Passw` VARCHAR(100))  NO SQL
BEGIN
    SET @_HOST = "@'localhost'";
    SET @name = CONCAT('''', REPLACE(TRIM(p_Name), CHAR(39), CONCAT(CHAR(92), CHAR(39))), '''');
    SET @pass = CONCAT('''', REPLACE(TRIM(p_Passw), CHAR(39), CONCAT(CHAR(92), CHAR(39))), '''');
    SET @sql = CONCAT('CREATE USER ', @name, @_HOST, ' IDENTIFIED BY ', @pass);
    
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
 
    DEALLOCATE PREPARE stmt;
    FLUSH PRIVILEGES;

    INSERT INTO utilizador VALUES(Email, Nome, CProf, CONCAT(@name, @_HOST));
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getAlertasCultura` (IN `id` INT, IN `tim` TIMESTAMP)  NO SQL
begin
	if id in (SELECT idCultura from cultura WHERE CURRENT_USER()=username) THEN 
	select * from alertavariavel
    WHERE cultura=id and tim=datahora;
    end if;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getAlertasGlobais` (IN `tim` TIMESTAMP)  NO SQL
begin
	select * from alerta
    where datahora=tim;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getInformacaoCultura` (IN `id` INT)  NO SQL
BEGIN
	select * from cultura 
    WHERE idCultura=id and username=CURRENT_USER();
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getMedicoesLuminosidade` ()  NO SQL
begin
select * from medicoes_luminosidade where datahoramedicao > date_sub(now(), interval 5 minute);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getMedicoesTemperatura` ()  NO SQL
begin
	select * from medicoes_temperatura where datahoramedicao > date_sub(now(), interval 5 minute);
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insere_medicao` (IN `valor` DECIMAL(8,2), IN `idCultura` INT, IN `idVariavel` INT)  NO SQL
BEGIN
if idcultura in(select idcultura from cultura
 where current_user()=cultura.username) then
insert into medicao
values(null,now(),valor,idCultura,idVariavel);
end if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `select_culturas` ()  NO SQL
BEGIN
select * from cultura
 where current_user()=cultura.username;
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
  `limiteSuperior` decimal(8,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
  `limiteSuperior` decimal(8,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
    	INSERT INTO alertavariavel VALUES(@id, NEW.datahoramedicao, NEW.variaveismedidas_idvariavel, NEW.variaveismedidas_idcultura, NEW.valormedicao, @min, @max);
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
-- Acionadores `medicoes_luminosidade`
--
DELIMITER $$
CREATE TRIGGER `verificar_luz` BEFORE INSERT ON `medicoes_luminosidade` FOR EACH ROW BEGIN

	SET @id = 0;
	SET @min = (SELECT limiteInferiorLuz FROM sistema);
    SET @max = (SELECT limiteSuperiorLuz FROM sistema);
    
    IF NEW.valormedicaoluminosidade < @min OR NEW.valormedicaoluminosidade > @max THEN
    	INSERT INTO alerta VALUES(@id, "luz", NEW.datahoramedicao, NEW.valormedicaoluminosidade, @min, @max);
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
-- Acionadores `medicoes_temperatura`
--
DELIMITER $$
CREATE TRIGGER `verificar_temp` BEFORE INSERT ON `medicoes_temperatura` FOR EACH ROW BEGIN

	SET @id = 0;
	SET @min = (SELECT limiteInferiorTemp FROM sistema);
    SET @max = (SELECT limiteSuperiorTemp FROM sistema);
    
	IF NEW.valormedicaotemperatura < @min OR NEW.valormedicaotemperatura > @max THEN
    	INSERT INTO alerta VALUES(@id, "temp", NEW.datahoramedicao, NEW.valormedicaotemperatura, @min, @max);
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
('asdASD', 'asdASD', 'asdASD', '\'asdASD\'@\'localhost\'');

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
(1, 1, '2019-05-12 13:14:26', 'I', 'root@localhost', 'asdASD', 'asdASD', 'asdASD', '\'asdASD\'@\'localhost\'');

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

-- --------------------------------------------------------

--
-- Estrutura da tabela `variavel`
--

CREATE TABLE `variavel` (
  `IDvariavel` int(11) NOT NULL,
  `NomeVariavel` varchar(100) COLLATE utf8_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `alertavariavel`
--
ALTER TABLE `alertavariavel`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cultura`
--
ALTER TABLE `cultura`
  MODIFY `IDcultura` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cultura_log`
--
ALTER TABLE `cultura_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `medicao`
--
ALTER TABLE `medicao`
  MODIFY `NumeroMedicao` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `medicao_log`
--
ALTER TABLE `medicao_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `medicoes_luminosidade`
--
ALTER TABLE `medicoes_luminosidade`
  MODIFY `IDMedicao` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `medicoes_temperatura`
--
ALTER TABLE `medicoes_temperatura`
  MODIFY `IDmedicao` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sistema_log`
--
ALTER TABLE `sistema_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `utilizador_log`
--
ALTER TABLE `utilizador_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `variaveis_medidas_log`
--
ALTER TABLE `variaveis_medidas_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `variavel`
--
ALTER TABLE `variavel`
  MODIFY `IDvariavel` int(11) NOT NULL AUTO_INCREMENT;

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
