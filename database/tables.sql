-- Создание таблицы ProductCategory
CREATE TABLE IF NOT EXISTS ProductCategory (
    id_product_category INT NOT NULL PRIMARY KEY,
    name_category VARCHAR(50) NOT NULL UNIQUE
);

-- Создание таблицы Customer
CREATE TABLE IF NOT EXISTS Customer (
    id_customer INT NOT NULL PRIMARY KEY,
    phone_number VARCHAR(16) NOT NULL UNIQUE,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    email VARCHAR(245) NULL
);

-- Создание таблицы Product
CREATE TABLE IF NOT EXISTS Product (
    id_product INT NOT NULL PRIMARY KEY,
    id_product_category INT NOT NULL,
    barcode CHAR(13) NOT NULL UNIQUE,
    name_product VARCHAR(100) NOT NULL UNIQUE,
    CONSTRAINT fk_product_category FOREIGN KEY (id_product_category)
        REFERENCES ProductCategory(id_product_category)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
);

-- Создание таблицы CurrentPrice
CREATE TABLE IF NOT EXISTS CurrentPrice (
    id_product INT NOT NULL PRIMARY KEY,
    base_price_value DECIMAL(10, 2) NOT NULL CHECK (base_price_value >= 0),
    base_discount_percent INT NULL CHECK (base_discount_percent IS NULL OR (base_discount_percent BETWEEN 0 AND 100)),
    time_updated TIMESTAMP NOT NULL,
    -- Вычисляемый столбец - цена с учётом скидки
    price_value DECIMAL(10, 2) GENERATED ALWAYS AS (
        ROUND(
            base_price_value * (1 - COALESCE(base_discount_percent, 0) / 100.0),
            2
        )
    ) STORED,
    CONSTRAINT fk_currentprice_product FOREIGN KEY (id_product)
        REFERENCES Product(id_product)
        ON DELETE CASCADE
        ON UPDATE RESTRICT
);

-- Создание таблицы LoyaltyCard
CREATE TABLE IF NOT EXISTS LoyaltyCard (
    id_loyalty_card INT NOT NULL PRIMARY KEY,
    id_customer INT NOT NULL UNIQUE,
    qr_code UUID NOT NULL UNIQUE,
    balance_points INT NOT NULL CHECK (balance_points >= 0),
    time_created TIMESTAMP NOT NULL,
    CONSTRAINT fk_loyaltycard_customer FOREIGN KEY (id_customer)
        REFERENCES Customer(id_customer)
        ON DELETE CASCADE
        ON UPDATE RESTRICT
);

-- Создание таблицы PersonalDiscount
CREATE TABLE IF NOT EXISTS PersonalDiscount (
    id_personal_discount INT NOT NULL PRIMARY KEY,
    id_customer INT NOT NULL,
    id_product_category INT NOT NULL,
    discount_percent INT NOT NULL CHECK (discount_percent BETWEEN 0 AND 100),
    valid_from DATE NOT NULL,
    valid_to DATE NOT NULL,
    CONSTRAINT uk_personaldiscount_customer_category UNIQUE (id_customer, id_product_category),
    CONSTRAINT fk_personaldiscount_customer FOREIGN KEY (id_customer)
        REFERENCES Customer(id_customer)
        ON DELETE CASCADE
        ON UPDATE RESTRICT,
    CONSTRAINT fk_personaldiscount_category FOREIGN KEY (id_product_category)
        REFERENCES ProductCategory(id_product_category)
        ON DELETE CASCADE
        ON UPDATE RESTRICT,
    CONSTRAINT chk_valid_dates CHECK (valid_to >= valid_from)
);

-- Создание таблицы OperationLog
CREATE TABLE IF NOT EXISTS OperationLog (
    id_operation_log INT NOT NULL PRIMARY KEY,
    id_customer INT NOT NULL,
    operation_type VARCHAR(30) NOT NULL,
    description VARCHAR(200) NOT NULL,
    time_performed TIMESTAMP NOT NULL,
    CONSTRAINT fk_operationlog_customer FOREIGN KEY (id_customer)
        REFERENCES Customer(id_customer)
        ON DELETE CASCADE
        ON UPDATE RESTRICT
);

-- Расширение для генерации UUID
CREATE EXTENSION IF NOT EXISTS pgcrypto;