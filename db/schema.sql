CREATE TABLE Users (
	UserID INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
	FirstName VARCHAR(64) NOT NULL,
	LastName VARCHAR(64) NOT NULL,
	Email NVARCHAR(320) NOT NULL UNIQUE,
	UserPassword NVARCHAR(255) NOT NULL
);
CREATE TABLE Passwords (
	UserID INT NOT NULL FOREIGN KEY REFERENCES Users(UserID) ON DELETE CASCADE,
	OldPassword NVARCHAR(255) NOT NULL,
	ChangeDate DATETIME NOT NULL
);
CREATE TABLE Sessions (
	UserID INT NOT NULL FOREIGN KEY REFERENCES Users(UserID) ON DELETE CASCADE,
	IssueDate DATETIME NOT NULL
);

CREATE PROCEDURE Register(@FirstName AS VARCHAR(64), @LastName AS VARCHAR(64), @Email AS NVARCHAR(320), @Password AS NVARCHAR(255), @ResponseMessage NVARCHAR(MAX) OUTPUT) AS
BEGIN
	BEGIN TRANSACTION 
		DECLARE @Error NVARCHAR(MAX);
		DECLARE @UserID INT;
		DECLARE @Max INT;  

		BEGIN TRY 
			SET @Error = 'Max: ' + CAST(@UserID AS NVARCHAR);
			/* Check to make sure a UserID with that email doesn't already exist. */
			SELECT @UserID = UserID FROM Users WHERE Email = @Email;

			/* If the UserID is NULL, then that email doesn't exist. */
			IF @UserID IS NULL
				BEGIN
					select @Max = MAX(UserID) FROM Users;  
					DBCC CHECKIDENT(Users, reseed, @max);

					INSERT INTO Users (FirstName, LastName, Email, UserPassword)
					VALUES (@FirstName, @LastName, @Email, @Password);

					IF @@TRANCOUNT > 0
						/* The user's newly generated ID can now be fetched from the table. */
						SELECT @UserID = UserID FROM Users WHERE Email = @Email;
						SET @ResponseMessage = '{status:200, id:' + CAST(@UserID AS NVARCHAR) + '}';
						COMMIT;
				END
			ELSE
				BEGIN
					SET @ResponseMessage = '{status:400, error:A user with that email already exists.}';
					ROLLBACK TRANSACTION;
				END
		END TRY
		BEGIN CATCH
			SET @Error = @Error + ': An error occurred, and the user could not be registered.';
			SET @ResponseMessage = '{status:400, error:' + @Error + '}';
			IF @@TRANCOUNT > 0
				ROLLBACK TRANSACTION;
			RAISERROR(@Error, 1, 0);
		END CATCH;

		SELECT @ResponseMessage AS "Response";
END;
GO

CREATE PROCEDURE ValidateUser(@Email AS VARCHAR(320), @Password AS NVARCHAR(255)) AS
BEGIN
	DECLARE @UserID INT;
	DECLARE @ReturnValue INT;
	DECLARE @ValidEmail VARCHAR(320);
	DECLARE @ValidPassword VARCHAR(255);

	SELECT @ValidEmail = Email FROM Users WHERE Email = @Email;
	SELECT @ValidPassword = UserPassword FROM Users WHERE Email = @Email;

	IF @ValidEmail = @Email AND @ValidPassword = @Password
		BEGIN
			SELECT @UserID = UserID FROM Users WHERE Email = @Email;
			INSERT INTO Sessions (UserID, IssueDate)
			VALUES (@UserID, GETDATE());
			SET @ReturnValue = 1;
		END
	ELSE 
		BEGIN
			SET @ReturnValue = 0;
		END

	RETURN @ReturnValue;
END;
GO

CREATE PROCEDURE UpdateUser(@UserID AS INT, @FirstName AS VARCHAR(64), @LastName AS VARCHAR(64), @Email AS NVARCHAR(320), @Password AS NVARCHAR(255)) AS
BEGIN
	BEGIN TRANSACTION 
		DECLARE @Error NVARCHAR(MAX);

		BEGIN TRY 
			IF @UserID IS NULL
				BEGIN
					SET @Error = 'UserID cannot be null.';
					ROLLBACK TRANSACTION;
					RAISERROR(@Error, 1, 0);
				END
			ELSE
				BEGIN
					IF EXISTS(SELECT * FROM Users WHERE UserID = @UserID)
						BEGIN
							UPDATE Users
							SET FirstName = @FirstName,
								LastName = @LastName,
								Email = @Email,
								UserPassword = @Password
							WHERE UserID = @UserID;

							IF @@TRANCOUNT > 0
								COMMIT;
						END
					ELSE
						BEGIN
							SET @Error = 'No users found with that UserID.';
							ROLLBACK TRANSACTION;
							RAISERROR(@Error, 1, 0);
						END
				END
		END TRY
		BEGIN CATCH
			SET @Error = @Error + ': An error occurred, and the user details could not be updated.';
			IF @@TRANCOUNT > 0
				ROLLBACK TRANSACTION;
			RAISERROR(@Error, 1, 0);
		END CATCH;
		/* Since the assessment didn't ask for an output parameter or any return values, there's no response message or output (except if there's an error of course). */
END;
GO

CREATE PROCEDURE DeleteUser(@UserID AS INT) AS
BEGIN
	BEGIN TRANSACTION 
		DECLARE @Error NVARCHAR(MAX);

		BEGIN TRY 
			IF @UserID IS NULL
				BEGIN
					SET @Error = 'UserID cannot be null.';
					ROLLBACK TRANSACTION;
					RAISERROR(@Error, 1, 0);
				END
			ELSE
				BEGIN
					IF EXISTS(SELECT * FROM Users WHERE UserID = @UserID)
						BEGIN
							DELETE FROM Users WHERE UserID = @UserID;

							IF @@TRANCOUNT > 0
								COMMIT;
						END
					ELSE
						BEGIN
							SET @Error = 'No users found with that UserID.';
							ROLLBACK TRANSACTION;
							RAISERROR(@Error, 1, 0);
						END
				END
		END TRY
		BEGIN CATCH
			SET @Error = @Error + ': An error occurred, and the user could not be deleted.';
			IF @@TRANCOUNT > 0
				ROLLBACK TRANSACTION;
			RAISERROR(@Error, 1, 0);
		END CATCH;
		/* Since the assessment didn't ask for an output parameter or any return values, there's no response message or output (except if there's an error of course). */
END;
GO

CREATE TRIGGER ChangedPassword ON Users AFTER UPDATE AS
	IF UPDATE(UserPassword)
		BEGIN
			INSERT INTO Passwords (UserID, OldPassword, ChangeDate)
			SELECT UserID, UserPassword, GETDATE()
			FROM deleted
		END
GO

CREATE VIEW LoginCount AS
SELECT UserID, COUNT(UserID) AS "Total Logins" FROM Sessions GROUP BY UserID

/* To generate mock data, and test all the code above. */

EXEC Register "John", "Smith", "john.smith@domain.com", "passw0rd", "Response";
EXEC Register "James", "Jackson", "j.jackson@domain.com", "secr3t", "Response";
EXEC Register "Rachel", "Woods", "rachelw@domain.com", "qu13t", "Response";
EXEC Register "Evan", "Adamson", "e.adamson@domain.com", "4d4m50n", "Response";
EXEC Register "Barnaby", "Deleted", "born2bedeleted@domain.com", "d3l3t3", "Response";

EXEC ValidateUser "john.smith@domain.com", "passw0rd";
EXEC ValidateUser "john.smith@domain.com", "passw0rd";
EXEC ValidateUser "john.smith@domain.com", "passw0rd";
EXEC ValidateUser "j.jackson@domain.com", "secr3t";
EXEC ValidateUser "j.jackson@domain.com", "WrongPassword";
EXEC ValidateUser "rachelw@domain.com", "qu13t";
EXEC ValidateUser "rachelw@domain.com", "qu13t";
EXEC ValidateUser "rachelw@domain.com", "qu13t";
EXEC ValidateUser "rachelw@domain.com", "qu13t";
EXEC ValidateUser "rachelw@domain.com", "qu13t";
EXEC ValidateUser "rachelw@domain.com", "qu13t";
EXEC ValidateUser "rachelw@domain.com", "Wrong";
EXEC ValidateUser "e.adamson@domain.com", "Wrong";

EXEC UpdateUser 2, "Crumb", "Colgate", "crumb.colgate@domain.com", "newp4ss";
EXEC UpdateUser 2, "Crumb", "Colgate", "crumb.colgate@domain.com", "newerp4ss";

EXEC DeleteUser 5;

/* 
	The expected result is that the Users table will have the following users by the end of the procedures above:
	John Smith
	Crumb Colgate
	Rachel Woods
	Evan Adamson

	Barnaby Deleted would be deleted, as he was born to be deleted unfortunately. James Jackson would've become Crumb Colgate, which is a much better name anyway. John Smith would have 3 entries in the Sessions table, Crumb Colgate (James Jackson) would have 1 since the other login attempt is incorrect on purpose, Rachel would have 6 since the 7th is incorrect, and Evan would have 0 since his one and only attempt was incorrect.

	So overall, 4 records in the Users table, 2 in the Passwords table, and 10 in the Sessions table.
*/

/* Register(@FirstName AS VARCHAR(64), @LastName AS VARCHAR(64), @Email AS NVARCHAR(320), @Password AS NVARCHAR(255), @ResponseMessage NVARCHAR(MAX) */
/* ValidateUser(@Email AS VARCHAR(320), @Password AS NVARCHAR(255) */
/* UpdateUser(@UserID AS INT, @FirstName AS VARCHAR(64), @LastName AS VARCHAR(64), @Email AS NVARCHAR(320), @Password AS NVARCHAR(255) */
/* DeleteUser(@UserID AS INT) */