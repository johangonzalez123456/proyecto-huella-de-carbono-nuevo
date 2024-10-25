-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 25-10-2024 a las 14:30:56
-- Versión del servidor: 10.4.28-MariaDB
-- Versión de PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `carbonocero1`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActualizarTransporte` (IN `p_trans_id` INT, IN `p_tipo` VARCHAR(100), IN `p_distancia` DECIMAL(10,2))   BEGIN
    UPDATE tbl_transporte
    SET trans_tipo = p_tipo, trans_distancia_km = p_distancia
    WHERE trans_id = p_trans_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `CalculoHuellaEmpleado` (IN `p_emp_id` INT)   BEGIN
    SELECT c.cons_fecha, c.cons_tipo, c.cons_gasto, e.emp_nombre, e.emp_apellido
    FROM tbl_consumo_personal c
    INNER JOIN tbl_empleado e ON c.emp_id = e.emp_id
    WHERE e.emp_id = p_emp_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `EliminarConsumoPersonal` (IN `p_cons_id` INT)   BEGIN
    

    -- Eliminar el registro principal
    DELETE FROM tbl_consumo_personal
    WHERE cons_id = p_cons_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertarActividadDiaria` (IN `p_fecha` DATE, IN `p_descripcion` VARCHAR(255), IN `p_empleado_id` INT, IN `p_periodo` VARCHAR(10))   BEGIN
    INSERT INTO tbl_actividades_diarias (act_fecha, act_descripcion, act_periodo, emp_id)
    VALUES (p_fecha, p_descripcion, p_periodo, p_empleado_id);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtenerActividadesDiarias` (IN `p_emp_id` INT)   BEGIN
    SELECT a.act_fecha, a.act_descripcion, e.emp_nombre, e.emp_apellido
    FROM tbl_actividades_diarias a
    INNER JOIN tbl_empleado e ON a.emp_id = e.emp_id
    WHERE e.emp_id = p_emp_id;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_actividades_diarias`
--

CREATE TABLE `tbl_actividades_diarias` (
  `act_id` int(11) NOT NULL,
  `act_fecha` date NOT NULL,
  `act_cantidad` int(11) NOT NULL,
  `act_periodo` varchar(10) NOT NULL,
  `emp_id` int(11) NOT NULL,
  `tipo_act_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_actividades_diarias`
--

INSERT INTO `tbl_actividades_diarias` (`act_id`, `act_fecha`, `act_cantidad`, `act_periodo`, `emp_id`, `tipo_act_id`) VALUES
(1, '2024-09-01', 8, 'Diario', 2, 1),
(2, '2024-09-01', 2, 'Mensual', 2, 2),
(3, '2024-09-01', 1, 'Anual', 3, 3),
(4, '2024-09-01', 8, 'Diario', 4, 1),
(5, '2024-09-01', 2, 'Mensual', 5, 2),
(6, '2024-09-01', 1, 'Anual', 6, 3),
(7, '2024-09-01', 1, 'Anual', 7, 3);

--
-- Disparadores `tbl_actividades_diarias`
--
DELIMITER $$
CREATE TRIGGER `trg_audit_insert_actividades` AFTER INSERT ON `tbl_actividades_diarias` FOR EACH ROW BEGIN
    INSERT INTO tbl_auditoria_actividades (aud_fecha, aud_descripcion, aud_empleado_id, aud_accion)
    VALUES (NEW.act_fecha, NEW.act_cantidad, NEW.emp_id, 'INSERT');
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_administrador`
--

CREATE TABLE `tbl_administrador` (
  `admin_id` int(11) NOT NULL,
  `admin_usuario_id` int(11) DEFAULT NULL,
  `admin_nombre` varchar(100) NOT NULL,
  `admin_apellido` varchar(100) NOT NULL,
  `admin_correo` varchar(100) NOT NULL,
  `admin_password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_administrador`
--

INSERT INTO `tbl_administrador` (`admin_id`, `admin_usuario_id`, `admin_nombre`, `admin_apellido`, `admin_correo`, `admin_password`) VALUES
(24, 1, 'Administrador1', 'Apellido1', 'admin1@empresa.com', 'adminpassword1'),
(65, 1, 'Administrador2', 'Apellido2', 'admin2@empresa.com', 'adminpassword2');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_alimentacion`
--

CREATE TABLE `tbl_alimentacion` (
  `alim_id` int(11) NOT NULL,
  `alim_fecha` date NOT NULL,
  `alim_cantidad` int(11) NOT NULL,
  `alim_periodo` varchar(10) NOT NULL,
  `emp_id` int(11) NOT NULL,
  `tipo_alim_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_alimentacion`
--

INSERT INTO `tbl_alimentacion` (`alim_id`, `alim_fecha`, `alim_cantidad`, `alim_periodo`, `emp_id`, `tipo_alim_id`) VALUES
(1, '2024-09-01', 3, 'Diario', 2, 1),
(2, '2024-09-01', 2, 'Mensual', 3, 2),
(3, '2024-09-01', 3, 'Diario', 4, 3),
(4, '2024-09-01', 2, 'Mensual', 5, 2),
(5, '2024-09-01', 3, 'Diario', 6, 1),
(6, '2024-09-01', 2, 'Mensual', 7, 3),
(7, '2024-09-01', 3, 'Diario', 8, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_auditoria_actividades`
--

CREATE TABLE `tbl_auditoria_actividades` (
  `aud_id` int(11) NOT NULL,
  `aud_fecha` date NOT NULL,
  `aud_descripcion` text NOT NULL,
  `aud_empleado_id` int(11) DEFAULT NULL,
  `aud_accion` varchar(50) NOT NULL,
  `aud_fecha_accion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_auditoria_transporte`
--

CREATE TABLE `tbl_auditoria_transporte` (
  `aud_id` int(11) NOT NULL,
  `aud_fecha` date NOT NULL,
  `aud_tipo_anterior` varchar(100) NOT NULL,
  `aud_distancia_anterior` decimal(10,2) NOT NULL,
  `aud_tipo_nuevo` varchar(100) NOT NULL,
  `aud_distancia_nueva` decimal(10,2) NOT NULL,
  `aud_empleado_id` int(11) DEFAULT NULL,
  `aud_accion` varchar(50) NOT NULL,
  `aud_fecha_accion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_calculo`
--

CREATE TABLE `tbl_calculo` (
  `calc_id` int(11) NOT NULL,
  `calc_fecha` date NOT NULL,
  `emp_id` int(11) NOT NULL,
  `periodo` varchar(10) NOT NULL,
  `huella_actividades` decimal(10,2) DEFAULT 0.00,
  `huella_transporte` decimal(10,2) DEFAULT 0.00,
  `huella_alimentacion` decimal(10,2) DEFAULT 0.00,
  `huella_consumo` decimal(10,2) DEFAULT 0.00,
  `huella_total` decimal(10,2) GENERATED ALWAYS AS (`huella_actividades` + `huella_transporte` + `huella_alimentacion` + `huella_consumo`) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_calculo`
--

INSERT INTO `tbl_calculo` (`calc_id`, `calc_fecha`, `emp_id`, `periodo`, `huella_actividades`, `huella_transporte`, `huella_alimentacion`, `huella_consumo`) VALUES
(1, '2024-09-01', 2, 'Diario', 12.50, 5.00, 10.00, 8.00),
(2, '2024-09-01', 2, 'Mensual', 250.00, 150.00, 200.00, 100.00),
(3, '2024-09-01', 2, 'Anual', 3000.00, 1800.00, 2400.00, 1200.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_consumo_personal`
--

CREATE TABLE `tbl_consumo_personal` (
  `cons_id` int(11) NOT NULL,
  `cons_fecha` date NOT NULL,
  `cons_cantidad` int(11) NOT NULL,
  `cons_periodo` varchar(10) NOT NULL,
  `emp_id` int(11) NOT NULL,
  `tipo_cons_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_consumo_personal`
--

INSERT INTO `tbl_consumo_personal` (`cons_id`, `cons_fecha`, `cons_cantidad`, `cons_periodo`, `emp_id`, `tipo_cons_id`) VALUES
(1, '2024-09-01', 10, 'Diario', 2, 1),
(2, '2024-09-01', 15, 'Mensual', 3, 2),
(3, '2024-09-01', 10, 'Diario', 4, 1),
(4, '2024-09-01', 15, 'Mensual', 5, 2),
(5, '2024-09-01', 10, 'Diario', 6, 1),
(6, '2024-09-01', 15, 'Mensual', 7, 2),
(7, '2024-09-01', 10, 'Diario', 8, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_conversion_actividades`
--

CREATE TABLE `tbl_conversion_actividades` (
  `conversion_act_id` int(11) NOT NULL,
  `act_id` int(11) NOT NULL,
  `periodo` varchar(10) NOT NULL,
  `huella_carbono` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_conversion_actividades`
--

INSERT INTO `tbl_conversion_actividades` (`conversion_act_id`, `act_id`, `periodo`, `huella_carbono`) VALUES
(1, 1, 'Diario', 12.50),
(2, 2, 'Mensual', 250.00),
(3, 3, 'Anual', 3001.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_conversion_alimentacion`
--

CREATE TABLE `tbl_conversion_alimentacion` (
  `conversion_alim_id` int(11) NOT NULL,
  `alim_id` int(11) NOT NULL,
  `periodo` varchar(10) NOT NULL,
  `huella_carbono` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_conversion_consumo`
--

CREATE TABLE `tbl_conversion_consumo` (
  `conversion_cons_id` int(11) NOT NULL,
  `cons_id` int(11) NOT NULL,
  `periodo` varchar(10) NOT NULL,
  `huella_carbono` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_conversion_transporte`
--

CREATE TABLE `tbl_conversion_transporte` (
  `conversion_trans_id` int(11) NOT NULL,
  `trans_id` int(11) NOT NULL,
  `periodo` varchar(10) NOT NULL,
  `huella_carbono` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_conversion_transporte`
--

INSERT INTO `tbl_conversion_transporte` (`conversion_trans_id`, `trans_id`, `periodo`, `huella_carbono`) VALUES
(1, 1, 'Diario', 5.00),
(2, 2, 'Mensual', 150.00),
(3, 3, 'Anual', 1802.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_empleado`
--

CREATE TABLE `tbl_empleado` (
  `emp_id` int(11) NOT NULL,
  `emp_usuario_id` int(11) DEFAULT NULL,
  `emp_nombre` varchar(100) NOT NULL,
  `emp_apellido` varchar(100) NOT NULL,
  `emp_correo` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_empleado`
--

INSERT INTO `tbl_empleado` (`emp_id`, `emp_usuario_id`, `emp_nombre`, `emp_apellido`, `emp_correo`) VALUES
(2, 2, 'Juan', 'Perez', 'juan.perez@empresa.com'),
(3, 2, 'Ana', 'Lopez', 'ana.lopez@empresa.com'),
(4, 2, 'Carlos', 'Sanchez', 'carlos.sanchez@empresa.com'),
(5, 2, 'Maria', 'Garcia', 'maria.garcia@empresa.com'),
(6, 2, 'Pedro', 'Fernandez', 'pedro.fernandez@empresa.com'),
(7, 2, 'Luisa', 'Martinez', 'luisa.martinez@empresa.com'),
(8, 2, 'Jorge', 'Rodriguez', 'jorge.rodriguez@empresa.com');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_gestion_usuarios`
--

CREATE TABLE `tbl_gestion_usuarios` (
  `gestion_id` int(11) NOT NULL,
  `gestion_fecha` date NOT NULL,
  `gestion_accion` varchar(255) NOT NULL,
  `admin_id` int(11) DEFAULT NULL,
  `emp_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_gestion_usuarios`
--

INSERT INTO `tbl_gestion_usuarios` (`gestion_id`, `gestion_fecha`, `gestion_accion`, `admin_id`, `emp_id`) VALUES
(1, '2024-08-19', 'Creación de usuario', 24, 2),
(2, '2024-08-18', 'Actualización de usuario', 65, 3),
(3, '2024-08-17', 'Eliminación de usuario', 24, 4),
(4, '2024-08-16', 'Creación de usuario', 65, 5),
(5, '2024-08-15', 'Actualización de usuario', 24, 6),
(6, '2024-08-14', 'Eliminación de usuario', 65, 7),
(7, '2024-08-13', 'Creación de usuario', 24, 8);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_huella_total`
--

CREATE TABLE `tbl_huella_total` (
  `huella_total_id` int(11) NOT NULL,
  `emp_id` int(11) NOT NULL,
  `periodo` varchar(10) NOT NULL,
  `huella_actividades` decimal(10,2) DEFAULT 0.00,
  `huella_transporte` decimal(10,2) DEFAULT 0.00,
  `huella_alimentacion` decimal(10,2) DEFAULT 0.00,
  `huella_consumo` decimal(10,2) DEFAULT 0.00,
  `huella_total` decimal(10,2) GENERATED ALWAYS AS (`huella_actividades` + `huella_transporte` + `huella_alimentacion` + `huella_consumo`) STORED,
  `act_id` int(11) DEFAULT NULL,
  `trans_id` int(11) DEFAULT NULL,
  `alim_id` int(11) DEFAULT NULL,
  `cons_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_huella_total`
--

INSERT INTO `tbl_huella_total` (`huella_total_id`, `emp_id`, `periodo`, `huella_actividades`, `huella_transporte`, `huella_alimentacion`, `huella_consumo`, `act_id`, `trans_id`, `alim_id`, `cons_id`) VALUES
(1, 2, 'Diario', 12.50, 5.00, 10.00, 8.00, NULL, NULL, NULL, NULL),
(2, 2, 'Mensual', 250.00, 150.00, 200.00, 100.00, NULL, NULL, NULL, NULL),
(3, 2, 'Anual', 3000.00, 1800.00, 2400.00, 1200.00, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_reportes`
--

CREATE TABLE `tbl_reportes` (
  `reporte_id` int(11) NOT NULL,
  `reporte_tipo` varchar(255) NOT NULL,
  `reporte_fecha` date NOT NULL,
  `reporte_total_cal` int(11) DEFAULT NULL,
  `admin_id` int(11) DEFAULT NULL,
  `emp_id` int(11) DEFAULT NULL,
  `reporte_nombre_pdf` varchar(255) NOT NULL,
  `reporte_ruta_pdf` varchar(255) NOT NULL,
  `reporte_descripcion` text DEFAULT NULL,
  `reporte_estado` enum('Pendiente','Aprobado','Rechazado') DEFAULT 'Pendiente'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_reportes`
--

INSERT INTO `tbl_reportes` (`reporte_id`, `reporte_tipo`, `reporte_fecha`, `reporte_total_cal`, `admin_id`, `emp_id`, `reporte_nombre_pdf`, `reporte_ruta_pdf`, `reporte_descripcion`, `reporte_estado`) VALUES
(1, 'Reporte de Actividades', '2024-08-19', NULL, 24, 2, 'reporte_actividades_20240819.pdf', '/pdfs/reporte_actividades_20240819.pdf', 'Este reporte detalla las actividades realizadas por el empleado durante el día 19 de agosto de 2024.', 'Pendiente'),
(2, 'Reporte de Transporte', '2024-08-18', NULL, 65, 3, 'reporte_transporte_20240818.pdf', '/pdfs/reporte_transporte_20240818.pdf', 'Este reporte contiene el detalle de los medios de transporte utilizados y su impacto en la huella de carbono del empleado.', 'Aprobado'),
(3, 'Reporte de Alimentación', '2024-08-17', NULL, 24, 4, 'reporte_alimentacion_20240817.pdf', '/pdfs/reporte_alimentacion_20240817.pdf', 'Reporte sobre el consumo alimenticio del empleado y su impacto ambiental.', 'Rechazado'),
(4, 'Reporte de Consumo Personal', '2024-08-16', NULL, 65, 5, 'reporte_consumo_personal_20240816.pdf', '/pdfs/reporte_consumo_personal_20240816.pdf', 'Informe sobre los hábitos de consumo personal y su influencia en la huella de carbono.', 'Pendiente'),
(5, 'Reporte de Cálculo de Huella', '2024-08-15', NULL, 24, 6, 'reporte_calculo_huella_20240815.pdf', '/pdfs/reporte_calculo_huella_20240815.pdf', 'Cálculo detallado de la huella de carbono del empleado para el día 15 de agosto de 2024.', 'Aprobado'),
(6, 'Reporte de Actividades', '2024-08-14', NULL, 65, 7, 'reporte_actividades_20240814.pdf', '/pdfs/reporte_actividades_20240814.pdf', 'Este reporte detalla las actividades realizadas por el empleado durante el día 14 de agosto de 2024.', 'Pendiente'),
(7, 'Reporte de Transporte', '2024-08-13', NULL, 24, 8, 'reporte_transporte_20240813.pdf', '/pdfs/reporte_transporte_20240813.pdf', 'Este reporte contiene el detalle de los medios de transporte utilizados y su impacto en la huella de carbono del empleado.', 'Rechazado');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_rol`
--

CREATE TABLE `tbl_rol` (
  `rol_id` int(11) NOT NULL,
  `rol_nombre` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_rol`
--

INSERT INTO `tbl_rol` (`rol_id`, `rol_nombre`) VALUES
(1, 'Administrador'),
(2, 'Empleado');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_tipo_actividades`
--

CREATE TABLE `tbl_tipo_actividades` (
  `tipo_act_id` int(11) NOT NULL,
  `tipo_act_nombre` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_tipo_actividades`
--

INSERT INTO `tbl_tipo_actividades` (`tipo_act_id`, `tipo_act_nombre`) VALUES
(1, 'Trabajo remoto'),
(2, 'Caminata'),
(3, 'Ejercicio'),
(4, 'Trabajo de oficina'),
(5, 'Reunión'),
(6, 'Trabajo en campo'),
(7, 'Visita a cliente');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_tipo_alimentacion`
--

CREATE TABLE `tbl_tipo_alimentacion` (
  `tipo_alim_id` int(11) NOT NULL,
  `tipo_alim_nombre` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_tipo_alimentacion`
--

INSERT INTO `tbl_tipo_alimentacion` (`tipo_alim_id`, `tipo_alim_nombre`) VALUES
(1, 'Vegetariana'),
(2, 'Carnes'),
(3, 'Vegana');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_tipo_consumo`
--

CREATE TABLE `tbl_tipo_consumo` (
  `tipo_cons_id` int(11) NOT NULL,
  `tipo_cons_nombre` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_tipo_consumo`
--

INSERT INTO `tbl_tipo_consumo` (`tipo_cons_id`, `tipo_cons_nombre`) VALUES
(1, 'Electrodomésticos'),
(2, 'Ropa'),
(3, 'Electrónica'),
(4, 'Muebles');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_tipo_transporte`
--

CREATE TABLE `tbl_tipo_transporte` (
  `tipo_trans_id` int(11) NOT NULL,
  `tipo_trans_nombre` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_tipo_transporte`
--

INSERT INTO `tbl_tipo_transporte` (`tipo_trans_id`, `tipo_trans_nombre`) VALUES
(1, 'Bicicleta'),
(2, 'Coche'),
(3, 'Transporte público'),
(4, 'Caminata');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_transporte`
--

CREATE TABLE `tbl_transporte` (
  `trans_id` int(11) NOT NULL,
  `trans_fecha` date NOT NULL,
  `trans_distancia_km` decimal(10,2) NOT NULL,
  `trans_periodo` varchar(10) NOT NULL,
  `emp_id` int(11) NOT NULL,
  `tipo_trans_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_transporte`
--

INSERT INTO `tbl_transporte` (`trans_id`, `trans_fecha`, `trans_distancia_km`, `trans_periodo`, `emp_id`, `tipo_trans_id`) VALUES
(1, '2024-09-01', 15.50, 'Diario', 2, 1),
(2, '2023-03-01', 5.00, 'Mensual', 3, 4),
(3, '2024-02-01', 15.50, 'Diario', 4, 2),
(4, '2023-03-01', 5.00, 'Mensual', 5, 4),
(5, '2023-07-01', 15.50, 'Diario', 6, 3),
(6, '2023-06-01', 5.00, 'Mensual', 7, 4),
(7, '2024-08-01', 15.50, 'Diario', 8, 1);

--
-- Disparadores `tbl_transporte`
--
DELIMITER $$
CREATE TRIGGER `trg_audit_update_transporte` AFTER UPDATE ON `tbl_transporte` FOR EACH ROW BEGIN
    INSERT INTO tbl_auditoria_transporte (
        aud_fecha, aud_tipo_anterior, aud_distancia_anterior,
        aud_tipo_nuevo, aud_distancia_nueva, aud_empleado_id, aud_accion
    )
    VALUES (
        OLD.trans_fecha,
        (SELECT tipo_trans_nombre FROM tbl_tipo_transporte WHERE tipo_trans_id = OLD.tipo_trans_id),
        OLD.trans_distancia_km,
        (SELECT tipo_trans_nombre FROM tbl_tipo_transporte WHERE tipo_trans_id = NEW.tipo_trans_id),
        NEW.trans_distancia_km,
        NEW.emp_id, 'UPDATE'
    );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_usuario`
--

CREATE TABLE `tbl_usuario` (
  `usuario_id` int(11) NOT NULL,
  `usuario_nombre` varchar(100) NOT NULL,
  `usuario_apellido` varchar(100) NOT NULL,
  `usuario_correo` varchar(100) NOT NULL,
  `usuario_password` varchar(255) NOT NULL,
  `usuario_rol_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_usuario`
--

INSERT INTO `tbl_usuario` (`usuario_id`, `usuario_nombre`, `usuario_apellido`, `usuario_correo`, `usuario_password`, `usuario_rol_id`) VALUES
(1, 'Admin1', 'Apellido1', 'admin1@empresa.com', 'password1', 1),
(2, 'Empleado1', 'Apellido2', 'empleado1@empresa.com', 'password2', 2),
(3, 'Empleado2', 'Apellido3', 'empleado2@empresa.com', 'password3', 2),
(4, 'Empleado3', 'Apellido4', 'empleado3@empresa.com', 'password4', 2),
(5, 'Empleado4', 'Apellido5', 'empleado4@empresa.com', 'password5', 2),
(6, 'Empleado5', 'Apellido6', 'empleado5@empresa.com', 'password6', 2),
(7, 'Empleado6', 'Apellido7', 'empleado6@empresa.com', 'password7', 2);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vistahuellacarbono`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vistahuellacarbono` (
`emp_nombre` varchar(100)
,`emp_apellido` varchar(100)
,`calc_fecha` date
,`calc_valor` decimal(10,2)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vistatransporteempleado`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vistatransporteempleado` (
`emp_nombre` varchar(100)
,`emp_apellido` varchar(100)
,`trans_fecha` date
,`trans_tipo` varchar(100)
,`trans_distancia_km` decimal(10,2)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vistahuellacarbono`
--
DROP TABLE IF EXISTS `vistahuellacarbono`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vistahuellacarbono`  AS SELECT `e`.`emp_nombre` AS `emp_nombre`, `e`.`emp_apellido` AS `emp_apellido`, `c`.`calc_fecha` AS `calc_fecha`, `c`.`huella_total` AS `calc_valor` FROM (`tbl_empleado` `e` join `tbl_calculo` `c` on(`e`.`emp_id` = `c`.`emp_id`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vistatransporteempleado`
--
DROP TABLE IF EXISTS `vistatransporteempleado`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vistatransporteempleado`  AS SELECT `e`.`emp_nombre` AS `emp_nombre`, `e`.`emp_apellido` AS `emp_apellido`, `t`.`trans_fecha` AS `trans_fecha`, `tt`.`tipo_trans_nombre` AS `trans_tipo`, `t`.`trans_distancia_km` AS `trans_distancia_km` FROM ((`tbl_empleado` `e` join `tbl_transporte` `t` on(`e`.`emp_id` = `t`.`emp_id`)) join `tbl_tipo_transporte` `tt` on(`t`.`tipo_trans_id` = `tt`.`tipo_trans_id`)) ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `tbl_actividades_diarias`
--
ALTER TABLE `tbl_actividades_diarias`
  ADD PRIMARY KEY (`act_id`),
  ADD KEY `emp_id` (`emp_id`),
  ADD KEY `tipo_act_id` (`tipo_act_id`),
  ADD KEY `idx_act_fecha` (`act_fecha`);

--
-- Indices de la tabla `tbl_administrador`
--
ALTER TABLE `tbl_administrador`
  ADD PRIMARY KEY (`admin_id`),
  ADD UNIQUE KEY `admin_correo` (`admin_correo`),
  ADD KEY `admin_usuario_id` (`admin_usuario_id`);

--
-- Indices de la tabla `tbl_alimentacion`
--
ALTER TABLE `tbl_alimentacion`
  ADD PRIMARY KEY (`alim_id`),
  ADD KEY `emp_id` (`emp_id`),
  ADD KEY `tipo_alim_id` (`tipo_alim_id`);

--
-- Indices de la tabla `tbl_auditoria_actividades`
--
ALTER TABLE `tbl_auditoria_actividades`
  ADD PRIMARY KEY (`aud_id`);

--
-- Indices de la tabla `tbl_auditoria_transporte`
--
ALTER TABLE `tbl_auditoria_transporte`
  ADD PRIMARY KEY (`aud_id`);

--
-- Indices de la tabla `tbl_calculo`
--
ALTER TABLE `tbl_calculo`
  ADD PRIMARY KEY (`calc_id`),
  ADD KEY `emp_id` (`emp_id`);

--
-- Indices de la tabla `tbl_consumo_personal`
--
ALTER TABLE `tbl_consumo_personal`
  ADD PRIMARY KEY (`cons_id`),
  ADD KEY `emp_id` (`emp_id`),
  ADD KEY `tipo_cons_id` (`tipo_cons_id`);

--
-- Indices de la tabla `tbl_conversion_actividades`
--
ALTER TABLE `tbl_conversion_actividades`
  ADD PRIMARY KEY (`conversion_act_id`),
  ADD KEY `act_id` (`act_id`);

--
-- Indices de la tabla `tbl_conversion_alimentacion`
--
ALTER TABLE `tbl_conversion_alimentacion`
  ADD PRIMARY KEY (`conversion_alim_id`),
  ADD KEY `alim_id` (`alim_id`);

--
-- Indices de la tabla `tbl_conversion_consumo`
--
ALTER TABLE `tbl_conversion_consumo`
  ADD PRIMARY KEY (`conversion_cons_id`),
  ADD KEY `cons_id` (`cons_id`);

--
-- Indices de la tabla `tbl_conversion_transporte`
--
ALTER TABLE `tbl_conversion_transporte`
  ADD PRIMARY KEY (`conversion_trans_id`),
  ADD KEY `trans_id` (`trans_id`);

--
-- Indices de la tabla `tbl_empleado`
--
ALTER TABLE `tbl_empleado`
  ADD PRIMARY KEY (`emp_id`),
  ADD UNIQUE KEY `emp_correo` (`emp_correo`),
  ADD KEY `emp_usuario_id` (`emp_usuario_id`),
  ADD KEY `idx_emp_apellido` (`emp_apellido`);

--
-- Indices de la tabla `tbl_gestion_usuarios`
--
ALTER TABLE `tbl_gestion_usuarios`
  ADD PRIMARY KEY (`gestion_id`),
  ADD KEY `admin_id` (`admin_id`),
  ADD KEY `emp_id` (`emp_id`);

--
-- Indices de la tabla `tbl_huella_total`
--
ALTER TABLE `tbl_huella_total`
  ADD PRIMARY KEY (`huella_total_id`),
  ADD KEY `emp_id` (`emp_id`),
  ADD KEY `act_id` (`act_id`),
  ADD KEY `trans_id` (`trans_id`),
  ADD KEY `alim_id` (`alim_id`),
  ADD KEY `cons_id` (`cons_id`);

--
-- Indices de la tabla `tbl_reportes`
--
ALTER TABLE `tbl_reportes`
  ADD PRIMARY KEY (`reporte_id`),
  ADD KEY `admin_id` (`admin_id`),
  ADD KEY `emp_id` (`emp_id`);

--
-- Indices de la tabla `tbl_rol`
--
ALTER TABLE `tbl_rol`
  ADD PRIMARY KEY (`rol_id`);

--
-- Indices de la tabla `tbl_tipo_actividades`
--
ALTER TABLE `tbl_tipo_actividades`
  ADD PRIMARY KEY (`tipo_act_id`);

--
-- Indices de la tabla `tbl_tipo_alimentacion`
--
ALTER TABLE `tbl_tipo_alimentacion`
  ADD PRIMARY KEY (`tipo_alim_id`);

--
-- Indices de la tabla `tbl_tipo_consumo`
--
ALTER TABLE `tbl_tipo_consumo`
  ADD PRIMARY KEY (`tipo_cons_id`);

--
-- Indices de la tabla `tbl_tipo_transporte`
--
ALTER TABLE `tbl_tipo_transporte`
  ADD PRIMARY KEY (`tipo_trans_id`);

--
-- Indices de la tabla `tbl_transporte`
--
ALTER TABLE `tbl_transporte`
  ADD PRIMARY KEY (`trans_id`),
  ADD KEY `emp_id` (`emp_id`),
  ADD KEY `tipo_trans_id` (`tipo_trans_id`);

--
-- Indices de la tabla `tbl_usuario`
--
ALTER TABLE `tbl_usuario`
  ADD PRIMARY KEY (`usuario_id`),
  ADD UNIQUE KEY `usuario_correo` (`usuario_correo`),
  ADD KEY `usuario_rol_id` (`usuario_rol_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `tbl_actividades_diarias`
--
ALTER TABLE `tbl_actividades_diarias`
  MODIFY `act_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `tbl_administrador`
--
ALTER TABLE `tbl_administrador`
  MODIFY `admin_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=66;

--
-- AUTO_INCREMENT de la tabla `tbl_alimentacion`
--
ALTER TABLE `tbl_alimentacion`
  MODIFY `alim_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `tbl_auditoria_actividades`
--
ALTER TABLE `tbl_auditoria_actividades`
  MODIFY `aud_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_auditoria_transporte`
--
ALTER TABLE `tbl_auditoria_transporte`
  MODIFY `aud_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_calculo`
--
ALTER TABLE `tbl_calculo`
  MODIFY `calc_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `tbl_consumo_personal`
--
ALTER TABLE `tbl_consumo_personal`
  MODIFY `cons_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `tbl_conversion_actividades`
--
ALTER TABLE `tbl_conversion_actividades`
  MODIFY `conversion_act_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `tbl_conversion_alimentacion`
--
ALTER TABLE `tbl_conversion_alimentacion`
  MODIFY `conversion_alim_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_conversion_consumo`
--
ALTER TABLE `tbl_conversion_consumo`
  MODIFY `conversion_cons_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_conversion_transporte`
--
ALTER TABLE `tbl_conversion_transporte`
  MODIFY `conversion_trans_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `tbl_empleado`
--
ALTER TABLE `tbl_empleado`
  MODIFY `emp_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `tbl_gestion_usuarios`
--
ALTER TABLE `tbl_gestion_usuarios`
  MODIFY `gestion_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `tbl_huella_total`
--
ALTER TABLE `tbl_huella_total`
  MODIFY `huella_total_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `tbl_reportes`
--
ALTER TABLE `tbl_reportes`
  MODIFY `reporte_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `tbl_rol`
--
ALTER TABLE `tbl_rol`
  MODIFY `rol_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `tbl_tipo_actividades`
--
ALTER TABLE `tbl_tipo_actividades`
  MODIFY `tipo_act_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `tbl_tipo_alimentacion`
--
ALTER TABLE `tbl_tipo_alimentacion`
  MODIFY `tipo_alim_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `tbl_tipo_consumo`
--
ALTER TABLE `tbl_tipo_consumo`
  MODIFY `tipo_cons_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `tbl_tipo_transporte`
--
ALTER TABLE `tbl_tipo_transporte`
  MODIFY `tipo_trans_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `tbl_transporte`
--
ALTER TABLE `tbl_transporte`
  MODIFY `trans_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `tbl_usuario`
--
ALTER TABLE `tbl_usuario`
  MODIFY `usuario_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `tbl_actividades_diarias`
--
ALTER TABLE `tbl_actividades_diarias`
  ADD CONSTRAINT `tbl_actividades_diarias_ibfk_1` FOREIGN KEY (`emp_id`) REFERENCES `tbl_empleado` (`emp_id`),
  ADD CONSTRAINT `tbl_actividades_diarias_ibfk_2` FOREIGN KEY (`tipo_act_id`) REFERENCES `tbl_tipo_actividades` (`tipo_act_id`);

--
-- Filtros para la tabla `tbl_administrador`
--
ALTER TABLE `tbl_administrador`
  ADD CONSTRAINT `tbl_administrador_ibfk_1` FOREIGN KEY (`admin_usuario_id`) REFERENCES `tbl_usuario` (`usuario_id`);

--
-- Filtros para la tabla `tbl_alimentacion`
--
ALTER TABLE `tbl_alimentacion`
  ADD CONSTRAINT `tbl_alimentacion_ibfk_1` FOREIGN KEY (`emp_id`) REFERENCES `tbl_empleado` (`emp_id`),
  ADD CONSTRAINT `tbl_alimentacion_ibfk_2` FOREIGN KEY (`tipo_alim_id`) REFERENCES `tbl_tipo_alimentacion` (`tipo_alim_id`);

--
-- Filtros para la tabla `tbl_calculo`
--
ALTER TABLE `tbl_calculo`
  ADD CONSTRAINT `tbl_calculo_ibfk_1` FOREIGN KEY (`emp_id`) REFERENCES `tbl_empleado` (`emp_id`);

--
-- Filtros para la tabla `tbl_consumo_personal`
--
ALTER TABLE `tbl_consumo_personal`
  ADD CONSTRAINT `tbl_consumo_personal_ibfk_1` FOREIGN KEY (`emp_id`) REFERENCES `tbl_empleado` (`emp_id`),
  ADD CONSTRAINT `tbl_consumo_personal_ibfk_2` FOREIGN KEY (`tipo_cons_id`) REFERENCES `tbl_tipo_consumo` (`tipo_cons_id`);

--
-- Filtros para la tabla `tbl_conversion_actividades`
--
ALTER TABLE `tbl_conversion_actividades`
  ADD CONSTRAINT `tbl_conversion_actividades_ibfk_1` FOREIGN KEY (`act_id`) REFERENCES `tbl_actividades_diarias` (`act_id`);

--
-- Filtros para la tabla `tbl_conversion_alimentacion`
--
ALTER TABLE `tbl_conversion_alimentacion`
  ADD CONSTRAINT `tbl_conversion_alimentacion_ibfk_1` FOREIGN KEY (`alim_id`) REFERENCES `tbl_alimentacion` (`alim_id`);

--
-- Filtros para la tabla `tbl_conversion_consumo`
--
ALTER TABLE `tbl_conversion_consumo`
  ADD CONSTRAINT `tbl_conversion_consumo_ibfk_1` FOREIGN KEY (`cons_id`) REFERENCES `tbl_consumo_personal` (`cons_id`);

--
-- Filtros para la tabla `tbl_conversion_transporte`
--
ALTER TABLE `tbl_conversion_transporte`
  ADD CONSTRAINT `tbl_conversion_transporte_ibfk_1` FOREIGN KEY (`trans_id`) REFERENCES `tbl_transporte` (`trans_id`);

--
-- Filtros para la tabla `tbl_empleado`
--
ALTER TABLE `tbl_empleado`
  ADD CONSTRAINT `tbl_empleado_ibfk_1` FOREIGN KEY (`emp_usuario_id`) REFERENCES `tbl_usuario` (`usuario_id`);

--
-- Filtros para la tabla `tbl_gestion_usuarios`
--
ALTER TABLE `tbl_gestion_usuarios`
  ADD CONSTRAINT `tbl_gestion_usuarios_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `tbl_administrador` (`admin_id`),
  ADD CONSTRAINT `tbl_gestion_usuarios_ibfk_2` FOREIGN KEY (`emp_id`) REFERENCES `tbl_empleado` (`emp_id`);

--
-- Filtros para la tabla `tbl_huella_total`
--
ALTER TABLE `tbl_huella_total`
  ADD CONSTRAINT `tbl_huella_total_ibfk_1` FOREIGN KEY (`emp_id`) REFERENCES `tbl_empleado` (`emp_id`),
  ADD CONSTRAINT `tbl_huella_total_ibfk_2` FOREIGN KEY (`act_id`) REFERENCES `tbl_conversion_actividades` (`act_id`),
  ADD CONSTRAINT `tbl_huella_total_ibfk_3` FOREIGN KEY (`trans_id`) REFERENCES `tbl_conversion_transporte` (`trans_id`),
  ADD CONSTRAINT `tbl_huella_total_ibfk_4` FOREIGN KEY (`alim_id`) REFERENCES `tbl_conversion_alimentacion` (`alim_id`),
  ADD CONSTRAINT `tbl_huella_total_ibfk_5` FOREIGN KEY (`cons_id`) REFERENCES `tbl_conversion_consumo` (`cons_id`);

--
-- Filtros para la tabla `tbl_reportes`
--
ALTER TABLE `tbl_reportes`
  ADD CONSTRAINT `tbl_reportes_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `tbl_administrador` (`admin_id`),
  ADD CONSTRAINT `tbl_reportes_ibfk_2` FOREIGN KEY (`emp_id`) REFERENCES `tbl_empleado` (`emp_id`);

--
-- Filtros para la tabla `tbl_transporte`
--
ALTER TABLE `tbl_transporte`
  ADD CONSTRAINT `tbl_transporte_ibfk_1` FOREIGN KEY (`emp_id`) REFERENCES `tbl_empleado` (`emp_id`),
  ADD CONSTRAINT `tbl_transporte_ibfk_2` FOREIGN KEY (`tipo_trans_id`) REFERENCES `tbl_tipo_transporte` (`tipo_trans_id`);

--
-- Filtros para la tabla `tbl_usuario`
--
ALTER TABLE `tbl_usuario`
  ADD CONSTRAINT `tbl_usuario_ibfk_1` FOREIGN KEY (`usuario_rol_id`) REFERENCES `tbl_rol` (`rol_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
