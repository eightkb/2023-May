USE tempdb;
GO

-- Inspect the PFS page (page 1 in the data file).
-- (Can also use the GAM page, which is page 2; but then you get allocations at the extent level and may miss some)
--   ====>>>>  Restart the service!!!!!!
-- This is necessary because old structures sometimes remain allocated for re-use,
-- and we can only find the allocated structures by searching for new allocations.
-- Copy query below to new window, then run it.
-- Start & freeze the query, then run same query here and compare results.
DBCC TRACEON(3604); -- Force DBCC PAGE output to screen instead of to errorlog
DBCC PAGE(tempdb, 1, 1, 3);
GO

-- Find a newly allocated page and drop its page number in the query below
DBCC PAGE(tempdb, 1, 93, 1);

-- For these hidden worktables, "m_objId (AllocUnitId.idObj)" should be a negative number.
-- But "Metadata: AllocUnitId" should be positive, and can be used in the next query.
GO

-- This query finds the IAM page, index page, and data pages allocated to the object.
-- For this demo, there should be 85 rows (so 83 data pages).
SELECT   *
FROM     sys.dm_os_buffer_descriptors
WHERE    database_id   = DB_ID('tempdb')
AND      allocation_unit_id = 422212465328128 -- Metadata: AllocUnitId from DBCC PAGE
ORDER BY page_type DESC,
         page_id;
GO

-- Let's examine the root (index) page first
-- Copy page_id of INDEX_PAGE entry in the query below
DBCC PAGE(tempdb, 1, 281, 1); -- Unfortunately, dump style 3 is not supported for worktable objects :(
GO

-- Look at slot 0, last 6 byte pairs. These are page number + file number of "first" page
-- Decode page number and put into next query to inspect this first page
DBCC PAGE(tempdb, 1, 280, 1); -- Unfortunately, dump style 3 is not supported for worktable objects :(
GO

