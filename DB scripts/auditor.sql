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

CREATE Database auditor;
USE auditor;

--
-- Database: `sid`
--

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
-- Indexes for dumped tables
--

--
-- Indexes for table `cultura_log`
--
ALTER TABLE `cultura_log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `medicao_log`
--
ALTER TABLE `medicao_log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `sistema_log`
--
ALTER TABLE `sistema_log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `utilizador_log`
--
ALTER TABLE `utilizador_log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `variaveis_medidas_log`
--
ALTER TABLE `variaveis_medidas_log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `variavel_log`
--
ALTER TABLE `variavel_log`
  ADD PRIMARY KEY (`id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
