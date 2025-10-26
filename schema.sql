CREATE SCHEMA IF NOT EXISTS OnlineArtStore;
SET search_path TO OnlineArtStore;
-----------------------------------------------------------

-- Drop existing tables if needed
DROP TABLE IF EXISTS RegisteredCustomer;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Artist;
DROP TABLE IF EXISTS Owner;
DROP TABLE IF EXISTS Person;
DROP TABLE IF EXISTS Paint;
DROP TABLE IF EXISTS Sketch;
DROP TABLE IF EXISTS Artwork;
DROP TABLE IF EXISTS Payment;
DROP TABLE IF EXISTS DeliveryMethod;
DROP TABLE IF EXISTS ShippingStatus;
DROP TABLE IF EXISTS International;
DROP TABLE IF EXISTS National;
DROP TABLE IF EXISTS DeliveryLocation;
DROP TABLE IF EXISTS "Order";
DROP TABLE IF EXISTS OnlineAccount;
DROP TABLE IF EXISTS Review;
DROP TABLE IF EXISTS Promotion;
DROP TABLE IF EXISTS Newsletter;
DROP TABLE IF EXISTS SubscribesTo;
DROP TABLE IF EXISTS Digital;

-----------------------------------------------------------
-- PERSON HIERARCHY
-----------------------------------------------------------
CREATE TABLE Person (
    personId INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE Owner (
    personId INT PRIMARY KEY,
    storeName VARCHAR(100),
    FOREIGN KEY (personId) REFERENCES Person(personId)
);

CREATE TABLE Artist (
    personId INT PRIMARY KEY,
    biography VARCHAR(255),
    country VARCHAR(100),
    FOREIGN KEY (personId) REFERENCES Person(personId)
);

CREATE TABLE Customer (
    personId INT PRIMARY KEY,
    customerId VARCHAR(50),
    FOREIGN KEY (personId) REFERENCES Person(personId)
);

CREATE TABLE RegisteredCustomer (
    personId INT PRIMARY KEY,
    subscriptionDate DATE,
    FOREIGN KEY (personId) REFERENCES Customer(personId)
);

-----------------------------------------------------------
-- ARTWORK HIERARCHY
-----------------------------------------------------------
CREATE TABLE Artwork (
    artworkId INT PRIMARY KEY,
    title VARCHAR(100),
    price DECIMAL(10,2),
    creationDate DATE,
    artistId INT,
    stockQuantity INT,
    FOREIGN KEY (artistId) REFERENCES Artist(personId)
);

CREATE TABLE Paint (
    artworkId INT PRIMARY KEY,
    FOREIGN KEY (artworkId) REFERENCES Artwork(artworkId)
);

CREATE TABLE Sketch (
    artworkId INT PRIMARY KEY,
    FOREIGN KEY (artworkId) REFERENCES Artwork(artworkId)
);

CREATE TABLE Digital (
    artworkId INT PRIMARY KEY,
    FOREIGN KEY (artworkId) REFERENCES Artwork(artworkId)
);

-----------------------------------------------------------
-- ORDER INFORMATION
-----------------------------------------------------------
CREATE TABLE "Order" (
    orderId INT PRIMARY KEY,
    orderDate DATE,
    customerId INT,
    totalAmount DECIMAL(10,2),
    status VARCHAR(50),
    FOREIGN KEY (customerId) REFERENCES Customer(personId)
);

CREATE TABLE Payment (
    paymentId INT PRIMARY KEY,
    method VARCHAR(50),
    amount DECIMAL(10,2),
    orderId INT,
    FOREIGN KEY (orderId) REFERENCES "Order"(orderId)
);

CREATE TABLE DeliveryMethod (
    methodId INT PRIMARY KEY,
    methodName VARCHAR(50),
    orderId INT,
    FOREIGN KEY (orderId) REFERENCES "Order"(orderId)
);

CREATE TABLE ShippingStatus (
    statusId INT PRIMARY KEY,
    currentStatus VARCHAR(50),
    orderId INT,
    FOREIGN KEY (orderId) REFERENCES "Order"(orderId)
);

CREATE TABLE DeliveryLocation (
    deliveryLocationId INT PRIMARY KEY,
    address VARCHAR(255),
    city VARCHAR(50),
    postalCode VARCHAR(20),
    country VARCHAR(50),
    orderId INT,
    FOREIGN KEY (orderId) REFERENCES "Order"(orderId)
);

CREATE TABLE National (
    deliveryLocationId INT PRIMARY KEY,
    FOREIGN KEY (deliveryLocationId) REFERENCES DeliveryLocation(deliveryLocationId)
);

CREATE TABLE International (
    deliveryLocationId INT PRIMARY KEY,
    FOREIGN KEY (deliveryLocationId) REFERENCES DeliveryLocation(deliveryLocationId)
);

-----------------------------------------------------------
-- OTHER CLASSES
-----------------------------------------------------------
CREATE TABLE OnlineAccount (
    accountId INT PRIMARY KEY,
    username VARCHAR(50),
    password VARCHAR(50),
    creationDate DATE,
    ownerId INT,
    FOREIGN KEY (ownerId) REFERENCES Owner(personId)
);

CREATE TABLE Review (
    reviewId INT PRIMARY KEY,
    rating INT,
    comment VARCHAR(255),
    reviewDate DATE,
    artworkId INT,
    customerId INT,
    FOREIGN KEY (artworkId) REFERENCES Artwork(artworkId),
    FOREIGN KEY (customerId) REFERENCES Customer(personId)
);

CREATE TABLE Promotion (
    promotionId INT PRIMARY KEY,
    discountPercentage DECIMAL(5,2),
    startDate DATE,
    endDate DATE,
    artworkId INT,
    FOREIGN KEY (artworkId) REFERENCES Artwork(artworkId)
);

CREATE TABLE NewsLetter (
    newsletterId INT PRIMARY KEY,
    newsletterName VARCHAR(100),
    newsletterBody VARCHAR(255),
    frequency VARCHAR(50)
);

CREATE TABLE SubscribesTo (
    personId INT,
    newsletterId INT,
    PRIMARY KEY (personId, newsletterId),
    FOREIGN KEY (personId) REFERENCES RegisteredCustomer(personId),
    FOREIGN KEY (newsletterId) REFERENCES NewsLetter(newsletterId)
);




-----------------------------------------------------------
-- Sample Data Insertion

-----------------------------------------------------------
-- PERSON HIERARCHY
-----------------------------------------------------------

INSERT INTO Person VALUES (1, 'Alice Martins', 'alice@artstore.com');
INSERT INTO Person VALUES (2, 'Vincent Van Gogh', 'vangogh@artstore.com');
INSERT INTO Person VALUES (3, 'Leonardo Da Vinci', 'leo@artstore.com');
INSERT INTO Person VALUES (4, 'Luis Costa', 'luis@artstore.com');
INSERT INTO Person VALUES (5, 'Utsav Acharya', 'utsav@artstore.com');
INSERT INTO Person VALUES (6, 'Maria Lopes', 'maria@artstore.com');

-- Owner
INSERT INTO Owner VALUES (1, 'Alice Art Gallery');

-- Artists
INSERT INTO Artist VALUES (2, 'Dutch post-impressionist painter known for Starry Night', 'Netherlands');
INSERT INTO Artist VALUES (3, 'Italian Renaissance polymath known for the Mona Lisa and Vitruvian Man', 'Italy');

-- Customers
INSERT INTO Customer VALUES (4, 'CUST001');
INSERT INTO Customer VALUES (5, 'CUST002');
INSERT INTO Customer VALUES (6, 'CUST003');

-- Registered Customers
INSERT INTO RegisteredCustomer VALUES (5, DATE '2023-07-10');
INSERT INTO RegisteredCustomer VALUES (6, DATE '2023-09-02');

-----------------------------------------------------------
-- ARTWORK HIERARCHY
-----------------------------------------------------------

INSERT INTO Artwork VALUES (1, 'Starry Night', 1500.00, DATE '1889-06-01', 2, 2);
INSERT INTO Artwork VALUES (2, 'Vitruvian Man', 2500.00, DATE '1490-01-01', 3, 1);
INSERT INTO Artwork VALUES (3, 'Digital Sunrise', 500.00, DATE '2024-04-15', 2, 10);

-- Subclasses
INSERT INTO Paint VALUES (1);
INSERT INTO Sketch VALUES (2);
INSERT INTO Digital VALUES (3);

-----------------------------------------------------------
-- ORDER INFORMATION
-----------------------------------------------------------

INSERT INTO "Order" VALUES (101, DATE '2024-09-20', 4, 1500.00, 'Completed');
INSERT INTO "Order" VALUES (102, DATE '2024-09-25', 5, 2500.00, 'Processing');
INSERT INTO "Order" VALUES (103, DATE '2024-10-02', 6, 500.00, 'Delivered');

-- Payments
INSERT INTO Payment VALUES (201, 'Credit Card', 1500.00, 101);
INSERT INTO Payment VALUES (202, 'PayPal', 2500.00, 102);
INSERT INTO Payment VALUES (203, 'Bank Transfer', 500.00, 103);

-- Delivery Methods
INSERT INTO DeliveryMethod VALUES (301, 'Standard Shipping', 101);
INSERT INTO DeliveryMethod VALUES (302, 'Express Delivery', 102);
INSERT INTO DeliveryMethod VALUES (303, 'Email Delivery', 103);

-- Shipping Status
INSERT INTO ShippingStatus VALUES (401, 'Delivered', 101);
INSERT INTO ShippingStatus VALUES (402, 'Preparing', 102);
INSERT INTO ShippingStatus VALUES (403, 'Delivered', 103);

-- Delivery Locations
INSERT INTO DeliveryLocation VALUES (501, '123 Art St', 'Lisbon', '1000-001', 'Portugal', 101);
INSERT INTO DeliveryLocation VALUES (502, '45 King Rd', 'London', 'SW1A 1AA', 'UK', 102);
INSERT INTO DeliveryLocation VALUES (503, '5 Avenida Sol', 'Madrid', '28013', 'Spain', 103);

-- Subclasses of DeliveryLocation
INSERT INTO National VALUES (501);
INSERT INTO International VALUES (502);
INSERT INTO International VALUES (503);

-----------------------------------------------------------
-- OTHER CLASSES
-----------------------------------------------------------

-- OnlineAccount
INSERT INTO OnlineAccount VALUES (601, 'alice_admin', 'pass123', DATE '2023-05-01', 1);

-- Reviews
INSERT INTO Review VALUES (701, 5, 'Absolutely stunning piece of art!', DATE '2024-09-30', 1, 4);
INSERT INTO Review VALUES (702, 4, 'Beautiful sketch, great details.', DATE '2024-10-05', 2, 5);

-- Promotions
INSERT INTO Promotion VALUES (801, 10.00, DATE '2024-09-01', DATE '2024-09-15', 1);
INSERT INTO Promotion VALUES (802, 15.00, DATE '2024-10-01', DATE '2024-10-10', 3);

-- Newsletters
INSERT INTO NewsLetter VALUES (901, 'Monthly Art Digest', 'Get the latest updates on artwork and promotions.', 'Monthly');
INSERT INTO NewsLetter VALUES (902, 'Exclusive Offers', 'Special discounts for registered customers.', 'Weekly');

-- Subscriptions (Registered Customers → NewsLetters)
INSERT INTO SubscribesTo VALUES (5, 901);
INSERT INTO SubscribesTo VALUES (6, 901);
INSERT INTO SubscribesTo VALUES (6, 902);
