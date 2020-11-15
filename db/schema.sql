CREATE TABLE Users (
	UserID INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
	FirstName VARCHAR(64) NOT NULL,
	LastName VARCHAR(64) NOT NULL,
	Email NVARCHAR(320) NOT NULL UNIQUE,
	UserPassword NVARCHAR(255) NOT NULL
);
CREATE TABLE Passwords (
	UserID INT NOT NULL FOREIGN KEY REFERENCES Users(UserID),
	OldPassword NVARCHAR(255) NOT NULL,
	ChangeDate DATETIME NOT NULL
);
CREATE TABLE Sessions (
	UserID INT NOT NULL FOREIGN KEY REFERENCES Users(UserID),
	SessionToken NVARCHAR(255),
	IssueDate DATETIME
);

CREATE PROCEDURE Register(@FirstName AS VARCHAR(64), @LastName AS VARCHAR(64), @Email AS NVARCHAR(320), @Password AS NVARCHAR(255), @ResponseMessage NVARCHAR(MAX) OUTPUT) AS
BEGIN
	BEGIN TRANSACTION 
		DECLARE @Error NVARCHAR(MAX);
		DECLARE @UserID INT;

		BEGIN TRY 
			SET @Error = 'Max: ' + CAST(@UserID AS NVARCHAR);
			/* Check to make sure a UserID with that email doesn't already exist. */
			SELECT @UserID = UserID FROM Users WHERE Email = @Email;

			/* If the UserID is NULL, then that email doesn't exist. */
			IF @UserID IS NULL
				BEGIN
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
	DECLARE @ReturnValue INT;
	DECLARE @ValidEmail VARCHAR(320);
	DECLARE @ValidPassword VARCHAR(255);

	SELECT @ValidEmail = Email FROM Users WHERE Email = @Email;
	SELECT @ValidPassword = UserPassword FROM Users WHERE Email = @Email;

	IF @ValidEmail = @Email AND @ValidPassword = @Password
		BEGIN
			SET @ReturnValue = 1;
		END
	ELSE 
		BEGIN
			SET @ReturnValue = 0;
		END

	RETURN @ReturnValue;
END;
GO