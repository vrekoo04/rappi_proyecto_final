/* Proyecto académico Rappi | SQL Server 2019/2022
   Datos de ejemplo (10 registros por tabla).
   Ejecutar DESPUÉS de crear las tablas, en una base vacía (los IDs IDENTITY empiezan en 1). */

SET XACT_ABORT ON;
GO

-- 1) Clientes
INSERT INTO dbo.Clientes (Nombre, Email, Telefono, Ciudad) VALUES
(N'Ana Torres',        'ana.torres@correo.com',     '4771234501', N'León'),
(N'Luis Hernández',    'luis.hernandez@correo.com', '4771234502', N'León'),
(N'María González',    'maria.gonzalez@correo.com', '5551234503', N'Ciudad de México'),
(N'Carlos Ramírez',    'carlos.ramirez@correo.com', '3331234504', N'Guadalajara'),
(N'Sofía Martínez',    'sofia.martinez@correo.com', '8181234505', N'Monterrey'),
(N'Jorge López',       'jorge.lopez@correo.com',    '4621234506', N'Irapuato'),
(N'Valeria Cruz',      'valeria.cruz@correo.com',   '4731234507', N'Guanajuato'),
(N'Diego Flores',      'diego.flores@correo.com',   '2221234508', N'Puebla'),
(N'Fernanda Ruiz',     'fernanda.ruiz@correo.com',  NULL,         N'Querétaro'),
(N'Miguel Sánchez',    'miguel.sanchez@correo.com', '9981234510', N'Mérida');
GO

-- 2) Comercios
INSERT INTO dbo.Comercios (Nombre, Categoria, Ciudad) VALUES
(N'Tacos El Güero',        N'Restaurante',  N'León'),
(N'Pizzería Napoli',       N'Restaurante',  N'León'),
(N'Súper Fresco',          N'Supermercado', N'Ciudad de México'),
(N'Farmacia Salud Plus',   N'Farmacia',     N'Guadalajara'),
(N'Sushi Kento',           N'Restaurante',  N'Monterrey'),
(N'Café Aroma',            N'Cafetería',    N'Irapuato'),
(N'Panadería La Espiga',   N'Panadería',    N'Guanajuato'),
(N'Burger House',          N'Restaurante',  N'Puebla'),
(N'Licorería El Barril',   N'Licorería',    N'Querétaro'),
(N'Heladería Polar',       N'Postres',      N'Mérida');
GO

-- 3) Repartidores
INSERT INTO dbo.Repartidores (Nombre, Telefono) VALUES
(N'Pedro Castillo',   '4779000001'),
(N'Raúl Mendoza',     '4779000002'),
(N'Laura Vega',       '5559000003'),
(N'Andrés Navarro',   '3339000004'),
(N'Daniela Ortiz',    '8189000005'),
(N'Héctor Salinas',   '4629000006'),
(N'Patricia Rojas',   '4739000007'),
(N'Iván Morales',     '2229000008'),
(N'Gabriela Silva',   '4429000009'),
(N'Omar Delgado',     '9989000010');
GO

-- 4) Productos (el producto i pertenece al comercio i)
INSERT INTO dbo.Productos (ComercioID, Nombre, Precio, Activo) VALUES
(1,  N'Orden de tacos al pastor', 85.00,  1),
(2,  N'Pizza pepperoni grande',   189.00, 1),
(3,  N'Despensa básica',          350.50, 1),
(4,  N'Paracetamol 500 mg',       45.90,  1),
(5,  N'Rollo California',         159.00, 1),
(6,  N'Café americano grande',    42.00,  1),
(7,  N'Pan de elote',             28.00,  1),
(8,  N'Hamburguesa doble',        139.00, 1),
(9,  N'Six de cerveza',           130.00, 0),
(10, N'Helado de vainilla 1 L',   95.00,  1);
GO

-- 5) Pedidos (el pedido i es del cliente i y del comercio i)
--    Respeta los CHECK: ENTREGADO requiere FechaEntrega y RepartidorID.
INSERT INTO dbo.Pedidos (PedidoOrigen, ClienteID, ComercioID, RepartidorID, FechaPedido, FechaEntrega, Estado, CostoEnvio) VALUES
('RAP-2026-0001', 1,  1,  1,    '2026-11-20 13:05:00', '2026-11-20 13:40:00', 'ENTREGADO', 25.00),
('RAP-2026-0002', 2,  2,  2,    '2026-11-20 20:10:00', '2026-11-20 20:55:00', 'ENTREGADO', 30.00),
('RAP-2026-0003', 3,  3,  3,    '2026-11-21 10:30:00', '2026-11-21 11:20:00', 'ENTREGADO', 35.00),
('RAP-2026-0004', 4,  4,  4,    '2026-11-21 18:45:00', '2026-11-21 19:15:00', 'ENTREGADO', 20.00),
('RAP-2026-0005', 5,  5,  5,    '2026-11-22 14:00:00', '2026-11-22 14:50:00', 'ENTREGADO', 40.00),
('RAP-2026-0006', 6,  6,  6,    '2026-11-22 09:15:00', NULL,                  'EN_CAMINO', 22.00),
('RAP-2026-0007', 7,  7,  NULL, '2026-11-23 08:40:00', NULL,                  'PENDIENTE', 18.00),
('RAP-2026-0008', 8,  8,  8,    '2026-11-22 21:00:00', NULL,                  'EN_CAMINO', 28.00),
('RAP-2026-0009', 9,  9,  NULL, '2026-11-22 22:30:00', NULL,                  'CANCELADO', 32.00),
('RAP-2026-0010', 10, 10, 10,   '2026-11-23 12:20:00', '2026-11-23 12:58:00', 'ENTREGADO', 26.00);
GO

-- 6) DetallePedido (pedido i, producto i, comercio i; mismo comercio en ambas FK compuestas)
INSERT INTO dbo.DetallePedido (PedidoID, ProductoID, ComercioID, Cantidad, PrecioUnitario) VALUES
(1,  1,  1,  3, 85.00),
(2,  2,  2,  1, 189.00),
(3,  3,  3,  2, 350.50),
(4,  4,  4,  2, 45.90),
(5,  5,  5,  4, 159.00),
(6,  6,  6,  2, 42.00),
(7,  7,  7,  6, 28.00),
(8,  8,  8,  2, 139.00),
(9,  9,  9,  1, 130.00),
(10, 10, 10, 1, 95.00);
GO

-- 7) StgPedidos (staging: todo en texto, con algunos datos "sucios" a propósito)
INSERT INTO dbo.StgPedidos (PedidoOrigen, ClienteIDTexto, ComercioIDTexto, RepartidorIDTexto, FechaPedidoTexto, FechaEntregaTexto, EstadoTexto, CostoEnvioTexto) VALUES
('RAP-2026-0011', '1',  '2',  '3',  '2026-11-23 09:00:00', '2026-11-23 09:45:00', 'ENTREGADO', '25.00'),
('RAP-2026-0012', '2',  '1',  '1',  '2026-11-23 10:10:00', '2026-11-23 10:50:00', 'entregado', '30.00'),
('RAP-2026-0013', '3',  '5',  NULL, '2026-11-23 11:30:00', NULL,                  'PENDIENTE', '35'),
('RAP-2026-0014', '4',  '8',  '8',  '23/11/2026 12:15',    NULL,                  'EN_CAMINO', '$28.00'),
('RAP-2026-0015', '5',  '3',  '5',  '2026-11-23 13:00:00', '2026-11-23 13:40:00', 'ENTREGADO', '20.50'),
('RAP-2026-0016', 'abc','4',  '4',  '2026-11-23 14:05:00', NULL,                  'EN_CAMINO', '22.00'),
('RAP-2026-0017', '7',  '7',  NULL, 'fecha inválida',      NULL,                  'PENDIENTE', '18.00'),
('RAP-2026-0018', '8',  '10', '10', '2026-11-23 15:20:00', '2026-11-23 15:55:00', 'ENTREGADO', 'gratis'),
('RAP-2026-0019', '9',  '9',  NULL, '2026-11-23 16:00:00', NULL,                  'CANCELADO', '32.00'),
('RAP-2026-0020', '10', '6',  '6',  '2026-11-23 17:45:00', NULL,                  'EN_CAMINO', '24.00');
GO
