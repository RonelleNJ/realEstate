-- AGENT TABLE
CREATE TABLE Agent (
    AgentID SERIAL PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    CompanyName VARCHAR(50),
    Picture BYTEA,
    PhoneNumber VARCHAR(20),
    EmailAddress VARCHAR(100)
);

-- CLIENT TABLE
CREATE TABLE Client (
    ClientID SERIAL PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    PhoneNumber VARCHAR(20),
    EmailAddress VARCHAR(100)
);
CREATE TABLE Property (
    PropertyID SERIAL PRIMARY KEY,
    Price DECIMAL(12,2) CHECK (Price > 0),
    Size FLOAT CHECK (Size > 0),
    AgentID INT NOT NULL,
    PropertyType VARCHAR(50),
    Picture BYTEA,
    Rooms INT CHECK (Rooms > 0),
    FOREIGN KEY (AgentID) REFERENCES Agent(AgentID)
);

CREATE TABLE Transaction (
    TransactionID SERIAL PRIMARY KEY,
    ClientID INT,
    AgentID INT,
    PropertyID INT,
    TransactionType VARCHAR(20) CHECK (TransactionType IN ('Buy', 'Rent')),
    FOREIGN KEY (ClientID) REFERENCES Client(ClientID),
    FOREIGN KEY (AgentID) REFERENCES Agent(AgentID),
    FOREIGN KEY (PropertyID) REFERENCES Property(PropertyID)
);

CREATE TABLE Date (
    TransactionID INT PRIMARY KEY,
    TransYear INT,
    TransMonth INT CHECK (TransMonth BETWEEN 1 AND 12),
    TransDay INT CHECK (TransDay BETWEEN 1 AND 31),
    FOREIGN KEY (TransactionID) REFERENCES Transaction(TransactionID)
);

CREATE TABLE PropertyFeature (
    FeatureID SERIAL PRIMARY KEY,
    PropertyID INT,
    FeatureName VARCHAR(100),
    FOREIGN KEY (PropertyID) REFERENCES Property(PropertyID)
);

CREATE TABLE PropertyLocation (
    PropertyID INT PRIMARY KEY,
    Country VARCHAR(50),
    City VARCHAR(50),
    StreetName VARCHAR(100),
    PostalCode VARCHAR(10),
    FOREIGN KEY (PropertyID) REFERENCES Property(PropertyID)
);

CREATE TABLE AgentContact (
    AgentID INT PRIMARY KEY,
    PhoneNumber VARCHAR(20),
    EmailAddress VARCHAR(100),
    FOREIGN KEY (AgentID) REFERENCES Agent(AgentID) ON DELETE CASCADE
);

CREATE TABLE ClientContact (
    ClientID INT PRIMARY KEY,
    PhoneNumber VARCHAR(20),
    EmailAddress VARCHAR(100),
    FOREIGN KEY (ClientID) REFERENCES Client(ClientID) ON DELETE CASCADE
);

INSERT INTO Agent (FirstName, LastName, CompanyName, PhoneNumber, EmailAddress)
VALUES 
('Lebogang', 'Smith', 'Elite Estates', '0752525656', 'lebogang23@elite.com'),
('Anna', 'Grey', 'Prime Properties', '0728986569', 'anna988@prime.com'),
('Thulani', 'Brown', 'Zonke Properties', '0875659845', 'thulanibrown45@zonke.com'),
('Moloko', 'Oceans', 'Babize Agents', '0726548956', 'moolokooceans@babize.com');

INSERT INTO Client (FirstName, LastName, PhoneNumber, EmailAddress)
VALUES 
('Sarah', 'Mkhize', '0646562354', 'sarahmk54@gmail.com'),
('John', 'Taylor', '4567890123', 'johntaylor62@gmail.com');

INSERT INTO Property (Price, Size, AgentID, PropertyType, Rooms)
VALUES
(450000.00, 120.5, 1, 'Apartment', 3),
(2450000.00, 200.0, 2, 'House', 5);

INSERT INTO PropertyLocation (PropertyID, Country, City, StreetName, PostalCode)
VALUES
(1, 'South Africa', 'Cape Town', 'Main Street', '1004'),
(2, 'South Africa', 'Johannesburg', 'Oak Avenue', '2007');

INSERT INTO PropertyFeature (PropertyID, FeatureName)
VALUES
(1, 'Swimming Pool'),
(1, 'Garage'),
(1, 'Patio'),
(1, 'Garden');

INSERT INTO Transaction (ClientID, AgentID, PropertyID, TransactionType)
VALUES
(1, 2, 1, 'Buy'),
(2, 1, 2, 'Rent');

INSERT INTO Date (TransactionID, TransYear, TransMonth, TransDay)
VALUES
(1, 2025, 7, 1),
(2, 2025, 5, 2);

CREATE INDEX idx_agent_email ON Agent(EmailAddress);
CREATE INDEX idx_client_email ON Client(EmailAddress);
CREATE INDEX idx_property_price ON Property(Price);
CREATE INDEX idx_transaction_type ON Transaction(TransactionType);

CREATE VIEW View_Properties_With_Agents AS
SELECT p.PropertyID, p.Price, p.PropertyType, a.FirstName || ' ' || a.LastName AS AgentName
FROM Property p
JOIN Agent a ON p.AgentID = a.AgentID;

CREATE VIEW View_Transactions_Detail AS
SELECT t.TransactionID, c.FirstName || ' ' || c.LastName AS ClientName, t.TransactionType, d.TransYear, d.TransMonth, d.TransDay
FROM Transaction t
JOIN Client c ON t.ClientID = c.ClientID
JOIN Date d ON t.TransactionID = d.TransactionID;
