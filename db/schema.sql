CREATE TABLE Users (
	userID INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
	firstName VARCHAR(32) NOT NULL,
	lastName VARCHAR(32) NOT NULL,
	email NVARCHAR(320) NOT NULL UNIQUE,
	password NVARCHAR(128) NOT NULL,
	salt NVARCHAR(36) NOT NULL
);
CREATE TABLE Passwords (
	passwordID INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
	userID INT NOT NULL FOREIGN KEY REFERENCES Users(userID) ON DELETE CASCADE,
	oldPassword NVARCHAR(128) NOT NULL,
	salt NVARCHAR(36) NOT NULL,
	changeDate DATETIME NOT NULL
);
CREATE TABLE Sessions (
	sessionID INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
	userID INT NOT NULL FOREIGN KEY REFERENCES Users(userID) ON DELETE CASCADE,
	issueDate DATETIME NOT NULL
);

CREATE TRIGGER ChangedPassword ON Users AFTER UPDATE AS
	IF UPDATE(password)
		BEGIN
			INSERT INTO Passwords (userID, oldPassword, salt, changeDate)
			SELECT userID, password, salt, GETDATE()
			FROM deleted
		END
GO

CREATE VIEW LoginCount AS
SELECT userID, COUNT(userID) AS "Total Logins" FROM Sessions GROUP BY userID

CREATE PROCEDURE Register(@FirstName AS VARCHAR(32), @LastName AS VARCHAR(32), @Email AS NVARCHAR(320), @Password AS NVARCHAR(128), @ResponseMessage NVARCHAR(MAX) OUTPUT) AS
BEGIN
	BEGIN TRANSACTION 
		DECLARE @Error NVARCHAR(MAX);
		DECLARE @UserID INT;
		DECLARE @Max INT;

		BEGIN TRY 
			SET @Error = 'Max: ' + CAST(@UserID AS NVARCHAR);
			/* Check to make sure a UserID with that email doesn't already exist. */
			SELECT @UserID = userID FROM Users WHERE email = @Email;

			/* If the UserID is NULL, then that email doesn't exist. */
			IF @UserID IS NULL
				BEGIN
					SELECT @Max = MAX(userID) FROM Users;
					IF @Max IS NULL
						BEGIN
							SET @Max = 1;
						END
						
					DBCC CHECKIDENT(Users, reseed, @Max);

					DECLARE @Salt UNIQUEIDENTIFIER = NEWID()

					INSERT INTO Users (firstName, lastName, email, password, salt)
					VALUES (@FirstName, @LastName, @Email, CONVERT(VARCHAR(128), HASHBYTES('SHA2_512', @Password + CAST(@Salt AS NVARCHAR(36))), 2), @Salt);

					IF @@TRANCOUNT > 0
						/* The user's newly generated ID can now be fetched from the table. */
						SELECT @UserID = userID FROM Users WHERE email = @Email;
						SET @ResponseMessage = '{ "code":"200", "UserID":"' + CAST(@UserID AS NVARCHAR) + '" }';
						COMMIT;
				END
			ELSE
				BEGIN
					SET @ResponseMessage = '{ "code":"208", "message":"A user with that email already exists." }';
					ROLLBACK TRANSACTION;
				END
		END TRY
		BEGIN CATCH
			SET @Error = @Error + ': An error occurred, and the user could not be registered.';
			SET @ResponseMessage = '{ "message":"' + @Error + '" }';
			IF @@TRANCOUNT > 0
				ROLLBACK TRANSACTION;
			RAISERROR(@Error, 1, 0);
		END CATCH;

		SELECT @ResponseMessage AS "Response";
END;
GO

CREATE PROCEDURE ValidateUser(@Email AS VARCHAR(320), @Password AS NVARCHAR(128)) AS
BEGIN
	DECLARE @UserID INT;
	DECLARE @ReturnValue INT;
	DECLARE @ValidEmail VARCHAR(320);
	DECLARE @ValidPassword VARCHAR(128);
	DECLARE @Salt NVARCHAR(36);
	DECLARE @Hashed NVARCHAR(128);

	SELECT @ValidEmail = email FROM Users WHERE email = @Email;
	SELECT @ValidPassword = password FROM Users WHERE email = @Email;
	SELECT @Salt = salt FROM Users WHERE email = @Email;

	SET @Hashed = CONVERT(VARCHAR(128), HASHBYTES('SHA2_512', @Password + CAST(@Salt AS NVARCHAR(36))), 2);

	IF @ValidEmail = @Email AND @ValidPassword = @Hashed
		BEGIN
			SELECT @UserID = userID FROM Users WHERE email = @Email;
			INSERT INTO Sessions (userID, issueDate)
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

CREATE PROCEDURE UpdateUser(@UserID AS INT, @FirstName AS VARCHAR(32), @LastName AS VARCHAR(32), @Email AS NVARCHAR(320), @Password AS NVARCHAR(128)) AS
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
					IF EXISTS(SELECT * FROM Users WHERE userID = @UserID)
						BEGIN
							DECLARE @Salt UNIQUEIDENTIFIER = NEWID()

							UPDATE Users
							SET firstName = @FirstName,
								lastName = @LastName,
								email = @Email,
								password = CONVERT(VARCHAR(128), HASHBYTES('SHA2_512', @Password + CAST(@Salt AS NVARCHAR(36))), 2),
								salt = @Salt
							WHERE userID = @UserID;

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
					IF EXISTS(SELECT * FROM Users WHERE userID = @UserID)
						BEGIN
							DELETE FROM Users WHERE userID = @UserID;

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

/* Register(@FirstName AS VARCHAR(32), @LastName AS VARCHAR(32), @Email AS NVARCHAR(320), @Password AS NVARCHAR(128), @ResponseMessage NVARCHAR(MAX) */
/* ValidateUser(@Email AS VARCHAR(320), @Password AS NVARCHAR(128) */
/* UpdateUser(@UserID AS INT, @FirstName AS VARCHAR(32), @LastName AS VARCHAR(32), @Email AS NVARCHAR(320), @Password AS NVARCHAR(128) */
/* DeleteUser(@UserID AS INT) */