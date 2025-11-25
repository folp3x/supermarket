-- Очистка таблиц
TRUNCATE TABLE OperationLog,
PersonalDiscount,
LoyaltyCard,
CurrentPrice,
Product,
Customer,
ProductCategory RESTART IDENTITY CASCADE;

-- Категории
INSERT INTO ProductCategory (id_product_category, name_category) VALUES
(1, 'Напитки'),
(2, 'Снеки'),
(3, 'Молочные продукты'),
(4, 'Выпечка'),
(5, 'Бытовая химия');

-- Клиенты
INSERT INTO Customer (id_customer, phone_number, first_name, last_name, email) VALUES
(1, '+79990000001', 'Иван', 'Иванов', 'ivan@example.com'),
(2, '+79990000002', 'Пётр', 'Петров', 'petr@example.com'),
(3, '+79990000003', 'Анна', 'Сидорова', 'anna@example.com'),
(4, '+79990000004', 'Мария', 'Кузнецова', NULL),
(5, '+79990000005', 'Сергей', 'Васильев', 'sergey@example.com');

-- Товары
INSERT INTO Product (id_product, id_product_category, barcode, name_product) VALUES
(1, 1, '4601234567001', 'Лимонад 1 л'),
(2, 1, '4601234567002', 'Сок апельсиновый 1 л'),
(3, 2, '4601234567003', 'Чипсы картофельные 150 г'),
(4, 3, '4601234567004', 'Молоко 1 л'),
(5, 4, '4601234567005', 'Хлеб пшеничный'),
(6, 5, '4601234567006', 'Стиральный порошок 1 кг');

-- Текущие цены
INSERT INTO CurrentPrice (id_product, base_price_value, base_discount_percent, time_updated) VALUES
(1, 89.90, NULL, NOW()),
(2, 139.90, 14, NOW()),
(3, 79.90, NULL, NOW()),
(4, 89.90, 22, NOW()),
(5, 39.90, NULL, NOW()),
(6, 499.00, 20, NOW());

-- Карты лояльности
INSERT INTO LoyaltyCard (id_loyalty_card, id_customer, qr_code, balance_points, time_created) VALUES
(1, 1, gen_random_uuid(), 120, NOW() - INTERVAL '30 days'),
(2, 2, gen_random_uuid(), 300, NOW() - INTERVAL '10 days'),
(3, 3, gen_random_uuid(), 50,  NOW() - INTERVAL '5 days'),
(4, 4, gen_random_uuid(), 0,   NOW() - INTERVAL '40 days'),
(5, 5, gen_random_uuid(), 500, NOW() - INTERVAL '1 day');

-- Персональные скидки
INSERT INTO PersonalDiscount (id_personal_discount, id_customer, id_product_category, discount_percent, valid_from, valid_to) VALUES
(1, 1, 1, 2,  CURRENT_DATE, (DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month - 1 day')::DATE),
(2, 1, 3, 5,  CURRENT_DATE, (DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month - 1 day')::DATE),
(3, 2, 2, 5,  CURRENT_DATE, (DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month - 1 day')::DATE),
(4, 3, 5, 2,  CURRENT_DATE, (DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month - 1 day')::DATE),
(5, 5, 4, 7,  CURRENT_DATE, (DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month - 1 day')::DATE);

-- Журнал операций
INSERT INTO OperationLog (id_operation_log, id_customer, operation_type, description, time_performed) VALUES
(1, 1, 'Покупка', 'Покупка: Лимонад 1 л', NOW() - INTERVAL '5 days'),
(2, 1, 'Проверка цены', 'Проверка цены: Молоко 1 л', NOW() - INTERVAL '4 days'),
(3, 3, 'Начисление баллов', 'Начислено 20 баллов', NOW() - INTERVAL '2 days'),
(4, 1, 'Списание баллов', 'Списано 50 баллов при покупке сока', NOW() - INTERVAL '1 day 2 hours'),
(5, 4, 'Активация карты', 'Карта лояльности активирована через приложение', NOW() - INTERVAL '10 days');