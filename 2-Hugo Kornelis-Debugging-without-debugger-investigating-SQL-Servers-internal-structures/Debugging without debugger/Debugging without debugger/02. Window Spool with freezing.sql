USE AdventureWorks2012;
GO

-- Same query as demo 1.
-- Step 1: Run it to get results
--		   (already done in demo 1)
/*
SELECT sod.SalesOrderID,
       sod.SalesOrderDetailID,
       sod.UnitPrice,
       MAX(sod.UnitPrice) OVER (ORDER BY sod.SalesOrderID,
                                         sod.SalesOrderDetailID
                                ROWS BETWEEN 10000 PRECEDING AND 3 FOLLOWING)
FROM   Sales.SalesOrderDetail AS sod;
*/

-- Step 2: Copy the below to a new window.
--         Execute, then return here.
/*
USE AdventureWorks2012;
GO

DROP TABLE IF EXISTS dbo.BlockWindowSpool;
CREATE TABLE dbo.BlockWindowSpool
    (SalesOrderID             int          NOT NULL,
     SalesOrderDetailID       int          NOT NULL,
     CarrierTrackingNumber    nvarchar(25) NULL,
     MaxCarrierTrackingNumber nvarchar(25) NULL,
     CONSTRAINT PK_Test1 PRIMARY KEY (SalesOrderID, SalesOrderDetailID));
GO

BEGIN TRAN;
INSERT INTO dbo.BlockWindowSpool (SalesOrderID,
                                  SalesOrderDetailID,
                                  CarrierTrackingNumber,
                                  MaxCarrierTrackingNumber)
-- Key values below are from a row in output; other values are irrelevant.
-- In this case I use row number 10100, so I know the spool is "full"
VALUES (46359, 10100, NULL, NULL);
--ROLLBACK TRAN;
*/

-- Step 3: Get execution plan only for query below, to verify the INSERT doesn't affect the shape.
--         After that, execute with live execution plan enabled, and wait until it is blocked.
-- (This is fairly quick; it blocks after ~20 seconds)
INSERT dbo.BlockWindowSpool (SalesOrderID,
                             SalesOrderDetailID,
                             CarrierTrackingNumber,
                             MaxCarrierTrackingNumber)
SELECT sod.SalesOrderID,
       sod.SalesOrderDetailID,
       sod.CarrierTrackingNumber,
       MAX(sod.CarrierTrackingNumber) OVER (ORDER BY sod.SalesOrderID,
                                                     sod.SalesOrderDetailID
                                            ROWS BETWEEN 10000 PRECEDING AND 3 FOLLOWING)
FROM   Sales.SalesOrderDetail AS sod;
GO
