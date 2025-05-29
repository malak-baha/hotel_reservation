CREATE  DATABASE projet_hotel;
USE projet_hotel;
CREATE TABLE hotel (
  id INT PRIMARY KEY,
  ville VARCHAR(50),
  pays VARCHAR(50),
  code_postal INT
);
CREATE TABLE client (
  id INT PRIMARY KEY,
  adresse TEXT,
  ville VARCHAR(50),
  code_postal INT,
  email VARCHAR(100),
  telephone VARCHAR(20),
  nom VARCHAR(100)
);
CREATE TABLE Prestation (
  id INT PRIMARY KEY,
  prix DECIMAL(10,2),
  description VARCHAR(100)
);
CREATE TABLE TypeChambre (
  id INT PRIMARY KEY,
  nom VARCHAR(50),
  prix DECIMAL(10,2)
);
CREATE TABLE Chambre (
  id INT PRIMARY KEY,
  numero INT,
  etage INT,
  balcon BOOLEAN,
  type_id INT,
  hotel_id INT,
  FOREIGN KEY (type_id) REFERENCES TypeChambre(id),
  FOREIGN KEY (hotel_id) REFERENCES Hotel(id)
);

CREATE TABLE Reservation (
  id INT PRIMARY KEY,
  date_debut DATE,
  date_fin DATE,
  client_id INT,
  chambre_id INT,
  FOREIGN KEY (client_id) REFERENCES Client(id),
  FOREIGN KEY (chambre_id) REFERENCES Chambre(id)
);
CREATE TABLE Evaluation (
  id INT PRIMARY KEY,
  date DATE,
  note INT,
  commentaire TEXT,
  reservation_id INT,
  FOREIGN KEY (reservation_id) REFERENCES Reservation(id)
);

INSERT INTO Hotel VALUES
(1, 'Paris', 'France', 75001),
(2, 'Lyon', 'France', 69002);

INSERT INTO Client VALUES
(1, '12 Rue de Paris', 'Paris', 75001, 'jean.dupont@email.fr', '0612345678', 'Jean Dupont'),
(2, '5 Avenue Victor Hugo', 'Lyon', 69002, 'marie.leroy@email.fr', '0623456789', 'Marie Leroy'),
(3, '8 Boulevard Saint-Michel', 'Marseille', 13005, 'paul.moreau@email.fr', '0634567890', 'Paul Moreau'),
(4, '27 Rue Nationale', 'Lille', 59800, 'lucie.martin@email.fr', '0645678901', 'Lucie Martin'),
(5, '3 Rue des Fleurs', 'Nice', 06000, 'emma.giraud@email.fr', '0656789012', 'Emma Giraud');

INSERT INTO Prestation VALUES
(1, 15, 'Petit-déjeuner'),
(2, 30, 'Navette aéroport'),
(3, 0, 'Wi-Fi gratuit'),
(4, 50, 'Spa et bien-être'),
(5, 20, 'Parking sécurisé');

INSERT INTO TypeChambre VALUES
(1, 'Simple', 80),
(2, 'Double', 120);

INSERT INTO Chambre VALUES
(1, 201, 2, 0, 1, 1),
(2, 502, 5, 1, 1, 2),
(3, 305, 3, 0, 2, 1),
(4, 410, 4, 0, 2, 2),
(5, 104, 1, 1, 2, 2),
(6, 202, 2, 0, 1, 1),
(7, 307, 3, 1, 1, 2),
(8, 101, 1, 0, 1, 1);

INSERT INTO Reservation VALUES
(1, '2025-06-15', '2025-06-18', 1, 1),
(2, '2025-07-01', '2025-07-05', 2, 2),
(3, '2025-08-10', '2025-08-14', 3, 3),
(4, '2025-09-05', '2025-09-07', 4, 4),
(5, '2025-09-20', '2025-09-25', 5, 5),
(7, '2025-11-12', '2025-11-14', 2, 6),
(9, '2026-01-15', '2026-01-18', 4, 7),
(10, '2026-02-01', '2026-02-05', 2, 8);

INSERT INTO Evaluation VALUES
(1, '2025-06-15', 5, 'Excellent séjour, personnel très accueillant.', 1),
(2, '2025-07-01', 4, 'Chambre propre, bon rapport qualité/prix.', 2),
(3, '2025-08-10', 3, 'Séjour correct mais bruyant la nuit.', 3),
(4, '2025-09-05', 5, 'Service impeccable, je recommande.', 4),
(5, '2025-09-20', 4, 'Très bon petit-déjeuner, hôtel bien situé.', 5);




SELECT r.id, c.nom, h.ville
FROM Reservation r
JOIN Client c ON r.client_id = c.id
JOIN Chambre ch ON r.chambre_id = ch.id
JOIN Hotel h ON ch.hotel_id = h.id;


SELECT * FROM Client WHERE ville = 'Paris';

SELECT client_id, COUNT(*) AS nb_reservations
FROM Reservation
GROUP BY client_id;


SELECT type_id, COUNT(*) AS nb_chambres
FROM Chambre
GROUP BY type_id;


SELECT * FROM Chambre
WHERE id NOT IN (
    SELECT chambre_id FROM Reservation
    WHERE date_debut <= '2025-07-15' AND date_fin >= '2025-07-10'
);
