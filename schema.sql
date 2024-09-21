-- Create the stocks table
CREATE TABLE stocks (
    id INTEGER PRIMARY KEY,
    symbol VARCHAR(10) NOT NULL,
    date DATE NOT NULL,
    open_price DECIMAL(10, 2) NOT NULL,
    close_price DECIMAL(10, 2) NOT NULL,
    high_price DECIMAL(10, 2) NOT NULL,
    low_price DECIMAL(10, 2) NOT NULL,
    volume INTEGER NOT NULL
);

-- Insert sample data (representative of real stocks)
INSERT INTO stocks (symbol, date, open_price, close_price, high_price, low_price, volume)
VALUES
    ('AAPL', '2023-01-01', 130.28, 131.86, 132.42, 129.64, 85000000),
    ('AAPL', '2023-01-02', 131.74, 130.73, 132.78, 130.05, 79500000),
    ('AAPL', '2023-01-03', 130.28, 125.07, 130.90, 124.17, 112600000),
    ('GOOGL', '2023-01-01', 88.73, 89.12, 89.93, 87.90, 22000000),
    ('GOOGL', '2023-01-02', 89.24, 88.80, 89.58, 88.10, 20500000),
    ('GOOGL', '2023-01-03', 88.45, 85.78, 88.70, 85.16, 28700000);

