USE AdventureWorks2012;
GO

SET STATISTICS IO ON;
GO

-- Run with Live Query Statistics; explain while running. Do not clear results after.
-- (Warning: Takes approximately 6 minutes on my laptop)
SELECT sod.SalesOrderID,
       sod.SalesOrderDetailID,
       sod.CarrierTrackingNumber,
       MAX(sod.CarrierTrackingNumber) OVER (ORDER BY sod.SalesOrderID,
                                                     sod.SalesOrderDetailID
                                            ROWS BETWEEN 10000 PRECEDING AND 3 FOLLOWING)
FROM   Sales.SalesOrderDetail AS sod;
GO
