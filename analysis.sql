-- Calculate daily returns
WITH daily_returns AS (
    SELECT
        symbol,
        date,
        (close_price - LAG(close_price) OVER (PARTITION BY symbol ORDER BY date)) / LAG(close_price) OVER (PARTITION BY symbol ORDER BY date) AS daily_return
    FROM
        stocks
)
SELECT * FROM daily_returns WHERE daily_return IS NOT NULL;

-- Calculate volatility (standard deviation of returns)
WITH daily_returns AS (
    SELECT
        symbol,
        date,
        (close_price - LAG(close_price) OVER (PARTITION BY symbol ORDER BY date)) / LAG(close_price) OVER (PARTITION BY symbol ORDER BY date) AS daily_return
    FROM
        stocks
)
SELECT
    symbol,
    SQRT(AVG(POWER(daily_return - AVG(daily_return) OVER (PARTITION BY symbol), 2))) OVER (PARTITION BY symbol) AS volatility
FROM
    daily_returns
WHERE
    daily_return IS NOT NULL
GROUP BY
    symbol, date, daily_return;

-- Simple moving average (5-day)
SELECT
    symbol,
    date,
    close_price,
    AVG(close_price) OVER (PARTITION BY symbol ORDER BY date ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) AS sma_5
FROM
    stocks;

-- Relative Strength Index (RSI) - 14-day period
WITH price_diff AS (
    SELECT
        symbol,
        date,
        close_price - LAG(close_price) OVER (PARTITION BY symbol ORDER BY date) AS diff
    FROM
        stocks
),
avg_gain_loss AS (
    SELECT
        symbol,
        date,
        AVG(CASE WHEN diff > 0 THEN diff ELSE 0 END) OVER (PARTITION BY symbol ORDER BY date ROWS BETWEEN 13 PRECEDING AND CURRENT ROW) AS avg_gain,
        AVG(CASE WHEN diff < 0 THEN ABS(diff) ELSE 0 END) OVER (PARTITION BY symbol ORDER BY date ROWS BETWEEN 13 PRECEDING AND CURRENT ROW) AS avg_loss
    FROM
        price_diff
)
SELECT
    symbol,
    date,
    100 - (100 / (1 + (avg_gain / NULLIF(avg_loss, 0)))) AS rsi
FROM
    avg_gain_loss
WHERE
    avg_gain IS NOT NULL AND avg_loss IS NOT NULL;