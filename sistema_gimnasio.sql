-- phpMyAdmin SQL Dump
-- version 5.0.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 15-12-2023 a las 19:12:30
-- Versión del servidor: 10.4.11-MariaDB
-- Versión de PHP: 7.4.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `sistema_gimnasio`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ajustes`
--

CREATE TABLE `ajustes` (
  `nombre` varchar(255) DEFAULT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `telefono` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `ajustes`
--

INSERT INTO `ajustes` (`nombre`, `logo`, `direccion`, `telefono`) VALUES
('GYM', './imagenes/657b061726bf5.png', 'BARINAS', '02736634569');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `membresias`
--

CREATE TABLE `membresias` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `duracion` int(6) NOT NULL,
  `precio` decimal(6,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `membresias`
--

INSERT INTO `membresias` (`id`, `nombre`, `duracion`, `precio`) VALUES
(1, 'BASICA', 31, '50.00'),
(2, 'REGULAR', 31, '100.00'),
(3, 'AVANZADO', 31, '150.00'),
(4, 'TEST', 3, '10.00'),
(5, 'SPEED', 1, '5.00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `miembros`
--

CREATE TABLE `miembros` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `matricula` varchar(50) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `telefono` varchar(20) NOT NULL,
  `direccion` varchar(255) NOT NULL,
  `edad` tinyint(4) NOT NULL,
  `sufreEnfermedad` tinyint(1) DEFAULT NULL,
  `tieneSeguro` tinyint(1) DEFAULT NULL,
  `enfermedad` varchar(255) DEFAULT NULL,
  `institucion` varchar(255) DEFAULT NULL,
  `nombreContacto` varchar(255) NOT NULL,
  `telefonoContacto` varchar(255) NOT NULL,
  `imagen` varchar(255) DEFAULT NULL,
  `estado` enum('ACTIVO','VENCIDO') DEFAULT NULL,
  `fechaRegistro` datetime NOT NULL,
  `fechaInicio` datetime DEFAULT NULL,
  `fechaFin` datetime DEFAULT NULL,
  `idMembresia` bigint(20) DEFAULT NULL,
  `cedula` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `miembros`
--

INSERT INTO `miembros` (`id`, `matricula`, `nombre`, `telefono`, `direccion`, `edad`, `sufreEnfermedad`, `tieneSeguro`, `enfermedad`, `institucion`, `nombreContacto`, `telefonoContacto`, `imagen`, `estado`, `fechaRegistro`, `fechaInicio`, `fechaFin`, `idMembresia`, `cedula`) VALUES
(9, '2023-1', 'JOSE PEREZ', '04124536589', 'BARINAS', 25, 0, 0, '', '', 'JOSE PEREZ', '04123659856', './imagenes/657b3609c5bc8.png', 'ACTIVO', '2023-12-14 18:06:17', '2023-12-15 17:42:43', '2023-12-16 17:42:43', 5, '12345678'),
(10, '2023-10', 'DEBORA NUÑEZ', '04125638968', 'BARINAS', 25, 0, 0, '', '', 'DEBORA', '0412785963', './imagenes/657b364f98f9a.png', 'ACTIVO', '2023-12-14 18:07:27', '2023-12-15 17:40:03', '2023-12-16 17:40:03', 5, '27510231'),
(11, '2023-11', 'YORMAN PEREZ', '04147857859', 'PERU', 22, 0, 0, '', '', 'YORMAN', '02145564', './imagenes/657b367e97576.png', 'ACTIVO', '2023-12-14 18:08:14', '2023-12-15 17:34:35', '2024-01-15 17:34:35', 2, '30269369'),
(12, '2023-12', 'THOR YAKITORY', '25252525', 'BARINAS', 100, 0, 0, '', '', 'THOR YAKITORY', '0414141414', './imagenes/657c82d6dbc8c.png', 'ACTIVO', '2023-12-15 17:46:14', '2023-12-15 17:46:46', '2024-01-15 17:46:46', 2, '25252525'),
(13, '2023-13', 'pepito', '56565656', 'barinas', 30, 0, 0, '', '', 'pepi', '656565', './imagenes/657c83f5e5091.png', 'ACTIVO', '2023-12-15 17:51:01', '2023-12-15 17:53:47', '2023-12-16 17:53:47', 5, '6666666'),
(14, '2023-14', 'hilber garcias', '041254546', 'barinas', 41, 0, 0, '', '', 'hil gar', '21321321', './imagenes/usuario.png', 'ACTIVO', '2023-12-15 17:51:34', '2023-12-15 17:51:56', '2023-12-16 17:51:56', 5, '12121212');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pagos`
--

CREATE TABLE `pagos` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `matricula` varchar(50) NOT NULL,
  `idMembresia` bigint(20) NOT NULL,
  `idUsuario` bigint(20) NOT NULL,
  `fecha` datetime NOT NULL,
  `monto` decimal(5,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `pagos`
--

INSERT INTO `pagos` (`id`, `matricula`, `idMembresia`, `idUsuario`, `fecha`, `monto`) VALUES
(1, '2023-1', 0, 1, '2023-12-14 00:00:00', '0.00'),
(2, '2023-1', 0, 1, '2023-12-14 00:00:00', '0.00'),
(3, '2023-2', 1, 1, '2023-12-14 00:00:00', '50.00'),
(4, '2023-1', 2, 1, '2023-12-14 00:00:00', '100.00'),
(5, '0', 0, 1, '2023-12-14 14:42:10', '0.00'),
(6, '0', 0, 1, '2023-12-14 14:44:14', '120.00'),
(7, '2023-1', 2, 1, '2023-12-14 00:00:00', '100.00'),
(8, '2023-4', 1, 1, '2023-12-14 00:00:00', '50.00'),
(9, '2023-5', 3, 1, '2023-12-14 00:00:00', '150.00'),
(10, '2023-6', 4, 1, '2023-12-14 00:00:00', '10.00'),
(11, '2023-7', 4, 2, '2023-12-14 00:00:00', '10.00'),
(12, '2023-8', 4, 2, '2023-12-15 00:00:00', '10.00'),
(13, '2023-10', 5, 1, '2023-12-14 00:00:00', '5.00'),
(14, '2023-11', 5, 1, '2023-12-14 00:00:00', '5.00'),
(15, '2023-11', 2, 1, '2023-12-15 00:00:00', '100.00'),
(16, '2023-10', 5, 1, '2023-12-15 00:00:00', '5.00'),
(17, '2023-1', 5, 1, '2023-12-15 00:00:00', '5.00'),
(18, '2023-12', 2, 1, '2023-12-15 00:00:00', '100.00'),
(19, '2023-14', 5, 1, '2023-12-15 00:00:00', '5.00'),
(20, '2023-13', 5, 1, '2023-12-15 00:00:00', '5.00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `usuario` varchar(255) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `telefono` varchar(20) NOT NULL,
  `password` varchar(255) NOT NULL,
  `rol` varchar(55) NOT NULL DEFAULT 'ADMINISTRADOR'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `usuario`, `nombre`, `telefono`, `password`, `rol`) VALUES
(1, 'admin', 'ADMIN', '000211313', '$2y$10$JUt5GRbnwf1vTH5dy23Y5Ob1/74Poey/emkzDJUUmNnV8uWE24p/C', 'ADMINISTRADOR'),
(6, 'recepcionista', 'recepcionista', '1321365', '$2y$10$COzq3ZjfYRJWL4SVIWbS4.e7F0k/dERPQCfXnnUHZ3oA4Y9gXhlxa', 'RECEPCIONISTA');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `visitas`
--

CREATE TABLE `visitas` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `idMiembro` bigint(20) DEFAULT NULL,
  `idUsuario` bigint(20) NOT NULL,
  `idMembresia` bigint(20) DEFAULT NULL,
  `fecha` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `visitas`
--

INSERT INTO `visitas` (`id`, `idMiembro`, `idUsuario`, `idMembresia`, `fecha`) VALUES
(1, NULL, 1, NULL, '2023-12-14 14:42:10'),
(2, 1, 1, 2, '2023-12-14 14:42:34'),
(3, 2, 1, 1, '2023-12-14 14:43:56'),
(4, NULL, 1, NULL, '2023-12-14 14:44:14');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `membresias`
--
ALTER TABLE `membresias`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `miembros`
--
ALTER TABLE `miembros`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `pagos`
--
ALTER TABLE `pagos`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `visitas`
--
ALTER TABLE `visitas`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `membresias`
--
ALTER TABLE `membresias`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `miembros`
--
ALTER TABLE `miembros`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de la tabla `pagos`
--
ALTER TABLE `pagos`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `visitas`
--
ALTER TABLE `visitas`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
