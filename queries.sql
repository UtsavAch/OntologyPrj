-- SOME EXAMPLE QUERIES FOR THE ONLINE ART STORE DATABASE --
------------------------------------------------------------

-- 1 Get all people and their roles
SET search_path TO OnlineArtStore;
SELECT p.personId, p.name, p.email,
       CASE
           WHEN o.personId IS NOT NULL THEN 'Owner'
           WHEN a.personId IS NOT NULL THEN 'Artist'
           WHEN rc.personId IS NOT NULL THEN 'Registered Customer'
           WHEN c.personId IS NOT NULL THEN 'Customer'
           ELSE 'Person'
       END AS role
FROM Person p
LEFT JOIN Owner o ON p.personId = o.personId
LEFT JOIN Artist a ON p.personId = a.personId
LEFT JOIN RegisteredCustomer rc ON p.personId = rc.personId
LEFT JOIN Customer c ON p.personId = c.personId;

-- 2 List all artworks with their type
SELECT aw.artworkId, aw.title, aw.price, aw.creationDate, p.name AS artist,
       CASE
           WHEN pa.artworkId IS NOT NULL THEN 'Paint'
           WHEN s.artworkId IS NOT NULL THEN 'Sketch'
           WHEN d.artworkId IS NOT NULL THEN 'Digital'
           ELSE 'Unknown'
       END AS type
FROM Artwork aw
JOIN Artist ar ON aw.artistId = ar.personId
JOIN Person p ON ar.personId = p.personId
LEFT JOIN Paint pa ON aw.artworkId = pa.artworkId
LEFT JOIN Sketch s ON aw.artworkId = s.artworkId
LEFT JOIN Digital d ON aw.artworkId = d.artworkId;


-- 3 Get all orders with their customers and total amounts
SELECT o.orderId, o.orderDate, p.name AS customerName, o.totalAmount, o.status
FROM "Order" o
JOIN Customer c ON o.customerId = c.personId
JOIN Person p ON c.personId = p.personId;

-- 4 List orders with shipping information
SELECT o.orderId, o.status, dl.address, dl.city, dl.country,
       CASE
           WHEN n.deliveryLocationId IS NOT NULL THEN 'National'
           WHEN i.deliveryLocationId IS NOT NULL THEN 'International'
       END AS deliveryType
FROM "Order" o
JOIN DeliveryLocation dl ON o.orderId = dl.orderId
LEFT JOIN National n ON dl.deliveryLocationId = n.deliveryLocationId
LEFT JOIN International i ON dl.deliveryLocationId = i.deliveryLocationId;

-- 5. Customers and the artworks they ordered
SELECT p.name AS customer, aw.title AS artwork, o.orderDate, o.status
FROM "Order" o
JOIN Customer c ON o.customerId = c.personId
JOIN Person p ON c.personId = p.personId
JOIN Payment pay ON o.orderId = pay.orderId
JOIN Artwork aw ON aw.artworkId IN (1, 2, 3);
