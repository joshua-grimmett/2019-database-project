USE [stock_exchange];

CREATE TABLE tbl_stock_names_temp (
	stock_symbol varchar(5) NOT NULL,
	stock_name varchar(100) NOT NULL,
	stock_exchange varchar(15) NOT NULL,
	PRIMARY KEY (stock_symbol)
);

CREATE TABLE tbl_daily_prices_temp (
	stock_exchange char(4) NOT NULL,
	stock_symbol char(3) NOT NULL,
	market_date varchar(10) NOT NULL,
	stock_price_open float NOT NULL,
	stock_price_high float NOT NULL,
	stock_price_low float NOT NULL,
	stock_price_close float NOT NULL,
	stock_volume int NOT NULL,
	stock_price_adj_close float NOT NULL,
);

BULK INSERT tbl_stock_names_temp
FROM 'D:\temp\NYSE_stock_names.tsv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = '\t',
	ROWTERMINATOR = '\n',
	TABLOCK
);

BULK INSERT tbl_daily_prices_temp
FROM 'D:\temp\NYSE_daily_prices_A.tsv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = '\t',
	ROWTERMINATOR = '\n',
	TABLOCK
);

INSERT INTO tbl_exchanges (exchange_name)
SELECT DISTINCT stock_exchange as exchange_name from tbl_stock_names_temp;

INSERT INTO tbl_companies (company_name)
SELECT 	stock_name AS [company_name] FROM tbl_stock_names_temp;

INSERT INTO	tbl_coexchanges (company_id, exchange_id)
SELECT	tbl_companies.company_id, tbl_exchanges.exchange_id
FROM	tbl_companies, tbl_exchanges, tbl_stock_names_temp
WHERE	tbl_companies.company_name = tbl_stock_names_temp.stock_name AND
		tbl_exchanges.exchange_name = tbl_stock_names_temp.stock_exchange;

INSERT 	INTO tbl_stock_symbols (stock_symbol, coexchange_id)
SELECT 	tbl_stock_names_temp.stock_symbol, tbl_coexchanges.coexchange_id
FROM 	tbl_stock_names_temp, tbl_coexchanges
WHERE	tbl_stock_names_temp.stock_name = (
			SELECT tbl_companies.company_name
			FROM tbl_companies
			WHERE tbl_companies.company_id = tbl_coexchanges.company_id
		);

SET DATEFORMAT dmy;

INSERT INTO tbl_stock_prices (
	stock_symbol_id,
	market_date,
	stock_price_open,
	stock_price_high,
	stock_price_low,
	stock_price_close,
	stock_price_adj_closed,
	stock_volume
)
SELECT	stock_symbol_id,
		CONVERT(date, market_date) AS market_date,
		stock_price_open,
		stock_price_low,
		stock_price_high,
		stock_price_close,
		stock_price_adj_close,
		stock_volume
FROM 	tbl_daily_prices_temp as dp, tbl_stock_symbols as sy
WHERE 	dp.stock_symbol = sy.stock_symbol;

DROP TABLE tbl_stock_names_temp;

DROP TABLE tbl_daily_prices_temp;