USE [stock_exchange];

CREATE TABLE dbo.tbl_companies (
	company_id int IDENTITY (1,1) NOT NULL,
	company_name nvarchar(100) UNIQUE NOT NULL,
	PRIMARY KEY (company_id)
);

CREATE TABLE dbo.tbl_exchanges (
	exchange_id int IDENTITY (1,1) NOT NULL,
	exchange_name varchar(50) NOT NULL UNIQUE,
	PRIMARY KEY (exchange_id)
);

CREATE TABLE dbo.tbl_coexchanges (
	coexchange_id int IDENTITY (1,1) NOT NULL,
	company_id int NOT NULL,
	exchange_id int NOT NULL,
	PRIMARY KEY (coexchange_id),
	CONSTRAINT fk_coexchange_company FOREIGN KEY (company_id)
	REFERENCES tbl_companies(company_id),
	CONSTRAINT fk_coexchange_exchange FOREIGN KEY (exchange_id)
	REFERENCES tbl_exchanges(exchange_id)
);

CREATE TABLE dbo.tbl_stock_symbols (
	stock_symbol_id int IDENTITY(1,1) NOT NULL,
	stock_symbol varchar(15) NOT NULL,
	coexchange_id int NOT NULL,
	PRIMARY KEY (stock_symbol_id),
	CONSTRAINT fk_symbol_coexchange FOREIGN KEY (coexchange_id)
	REFERENCES dbo.tbl_coexchanges(coexchange_id)
);

CREATE TABLE dbo.tbl_stock_prices (
	stock_symbol_id int NOT NULL,
	market_date date NOT NULL,
	stock_price_open float NOT NULL,
	stock_price_high float NOT NULL,
	stock_price_low float NOT NULL,
	stock_price_close float NOT NULL,
	stock_volume int NOT NULL,
	stock_price_adj_closed float NOT NULL,
	PRIMARY KEY (stock_symbol_id, market_date),
);