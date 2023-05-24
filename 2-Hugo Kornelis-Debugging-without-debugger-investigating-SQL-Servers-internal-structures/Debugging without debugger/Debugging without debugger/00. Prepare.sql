/*
Preparation steps:

1: Create separate instance for testing purposes.
2: Ensure tempdb has just a single file. Large enough to prevent autogrow. Small enough to prevent IAM chains
    (I used 10 MB for the demos in this session)
3: Prevent parallelism in plans by setting system wide MAXDOP to 1
	

All of these make some things just a bit easier.
*/

EXEC sys.sp_configure N'max degree of parallelism', N'1';
RECONFIGURE WITH OVERRIDE;
GO
