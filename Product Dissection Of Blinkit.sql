IF NOT EXISTS (
    SELECT name 
    FROM sys.databases 
    WHERE name = N'blinkit_db'
)
BEGIN
    CREATE DATABASE blinkit_db;
END
GO

CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    FullName VARCHAR(100),
    Email VARCHAR(100) UNIQUE,
    PhoneNumber VARCHAR(15),
    PasswordHash VARCHAR(MAX),
    DefaultAddressID INT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    LastLogin DATETIME,
    IsActive BIT DEFAULT 1
);
CREATE TABLE Address (
    AddressID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT,
    StreetAddress VARCHAR(MAX),
    Landmark VARCHAR(100),
    City VARCHAR(50),
    State VARCHAR(50),
    Pincode VARCHAR(10),
    Latitude DECIMAL(9,6),
    Longitude DECIMAL(9,6),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
CREATE TABLE Category (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(100),
    Description VARCHAR(MAX)
);
CREATE TABLE Product (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(100),
    Description VARCHAR(MAX),
    CategoryID INT,
    Brand VARCHAR(100),
    Unit VARCHAR(20),
    Price DECIMAL(10,2),
    Discount DECIMAL(5,2),
    StockQuantity INT,
    ImageURL VARCHAR(MAX),
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
);
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT,
    AddressID INT,
    TotalAmount DECIMAL(10,2),
    DeliveryCharge DECIMAL(10,2),
    PaymentID INT NULL,
    Status VARCHAR(20),
    CreatedAt DATETIME DEFAULT GETDATE(),
    EstimatedDelivery DATETIME,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (AddressID) REFERENCES Address(AddressID)
);
CREATE TABLE OrderItem (
    OrderItemID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT,
    ProductID INT,
    Quantity INT,
    PriceAtPurchase DECIMAL(10,2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);
CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT,
    OrderID INT,
    PaymentMethod VARCHAR(20),
    PaymentStatus VARCHAR(20),
    TransactionRef VARCHAR(100),
    Amount DECIMAL(10,2),
    PaidAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);
CREATE TABLE DeliveryAgent (
    AgentID INT PRIMARY KEY IDENTITY(1,1),
    FullName VARCHAR(100),
    PhoneNumber VARCHAR(15),
    VehicleNumber VARCHAR(20),
    AssignedArea VARCHAR(100),
    Status VARCHAR(20) DEFAULT 'Active'
);
CREATE TABLE Delivery (
    DeliveryID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT,
    AgentID INT,
    PickupTime DATETIME,
    DeliveryTime DATETIME,
    DeliveryStatus VARCHAR(20),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (AgentID) REFERENCES DeliveryAgent(AgentID)
);
