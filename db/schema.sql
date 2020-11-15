CREATE TABLE Users (
	UserID INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
	FirstName VARCHAR(64) NOT NULL,
	LastName VARCHAR(64) NOT NULL,
	Email NVARCHAR(320) NOT NULL,
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