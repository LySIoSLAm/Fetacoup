--
-- FeTaCoup database
--

-- Create database
CREATE DATABASE IF NOT EXISTS fetacoup_database;

-- Use database
USE fetacoup_database;

-- Create tables

-- Table: utilisateur
CREATE TABLE IF NOT EXISTS utilisateur (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(55) NOT NULL,
    prenom VARCHAR(55) NOT NULL,
    email VARCHAR(255) NOT NULL,
    mot_de_passe VARCHAR(255) NOT NULL,
    role ENUM('admin', 'coiffeur', 'client') NOT NULL,
    date_inscription TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Insert data into table utilisateur
INSERT INTO utilisateur (nom, prenom, email, mot_de_passe) VALUES
('admin', 'admin', 'admin@gmail.com', 'admin'),
('coiffeur', 'coiffeur', 'coiffeur@gmail.com', 'coiffeur'),
('client', 'client', 'client@gmail.com', 'client');

-- Table: administateur
CREATE TABLE IF NOT EXISTS administrateur (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_utilisateur INT NOT NULL,
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table: coiffeur
CREATE TABLE IF NOT EXISTS coiffeur (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_utilisateur INT NOT NULL,
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- Table: galerie
CREATE TABLE IF NOT EXISTS galerie (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(55) NOT NULL,
    photo VARCHAR(255) NOT NULL,
    date_ajout TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Insert data into table galerie
INSERT INTO galerie (nom ,photo) VALUES
('photo1', 'photo1.jpg'),
('photo2', 'photo2.jpg'),
('photo3', 'photo3.jpg'),
('photo4', 'photo4.jpg'),
('photo5', 'photo5.jpg');

-- Table: horaire
CREATE TABLE IF NOT EXISTS horaire (
    id INT AUTO_INCREMENT PRIMARY KEY,
    jour ENUM('lundi', 'mardi', 'mercredi', 'jeudi', 'vendredi', 'samedi', 'dimanche') NOT NULL,
    heure_ouverture TIME NOT NULL DEFAULT '09:00:00',
    heure_fermeture TIME NOT NULL DEFAULT '20:00:00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Insert data into table horaire
INSERT INTO horaire (jour) VALUES
('lundi'),
('mardi'),
('mercredi'),
('jeudi'),
('vendredi'),
('samedi'),
('dimanche');

-- Table: produit
CREATE TABLE IF NOT EXISTS produit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(55) NOT NULL,
    description TEXT NOT NULL,
    prix DECIMAL(10, 2) NOT NULL,
    disponible BOOLEAN NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Insert data into table produit
INSERT INTO produit (nom, description, prix) VALUES
('produit1', 'description produit1', 10.00),
('produit2', 'description produit2', 20.00),
('produit3', 'description produit3', 30.00),
('produit4', 'description produit4', 40.00),
('produit5', 'description produit5', 50.00);


-- Table: galerie_produit
CREATE TABLE IF NOT EXISTS galerie_produit (
    id_galerie INT NOT NULL,
    id_produit INT NOT NULL,
    PRIMARY KEY (id_galerie, id_produit),
    FOREIGN KEY (id_galerie) REFERENCES galerie(id),
    FOREIGN KEY (id_produit) REFERENCES produit(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Insert data into table galerie_produit
INSERT INTO galerie_produit (id_galerie, id_produit) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 2),
(5, 2);

-- Table: reservation_produit
CREATE TABLE IF NOT EXISTS reservation_produit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_utilisateur INT NOT NULL,
    id_produit INT NOT NULL,
    date_reservation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id),
    FOREIGN KEY (id_produit) REFERENCES produit(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Insert data into table reservation_produit
INSERT INTO reservation_produit (id_utilisateur, id_produit) VALUES
(9, 1),
(9, 2);

-- Table: service
CREATE TABLE IF NOT EXISTS service (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(55) NOT NULL,
    duree TIME NOT NULL,
    prix DECIMAL(10, 2) NOT NULL,
    description TEXT NOT NULL,
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Insert data into table service
--hairdresser services
INSERT INTO service (nom, duree, prix, description) VALUES
('coupe homme', '00:30:00', 10.00, 'description coupe homme'),
('coupe enfant', '00:30:00', 10.00, 'description coupe enfant'),
('coupe brushing', '01:00:00', 20.00, 'description coupe brushing'),
('coupe couleur', '01:30:00', 30.00, 'description coupe couleur'),
('coupe meches', '01:30:00', 30.00, 'description coupe meches'),
('coupe permanente', '02:00:00', 40.00, 'description coupe permanente'),
('coupe mariage', '02:00:00', 40.00, 'description coupe mariage'),
('coupe soin', '01:30:00', 30.00, 'description coupe soin');

-- Table: galerie_service
CREATE TABLE IF NOT EXISTS galerie_service (
    id_galerie INT NOT NULL,
    id_service INT NOT NULL,
    PRIMARY KEY (id_galerie, id_service),
    FOREIGN KEY (id_galerie) REFERENCES galerie(id),
    FOREIGN KEY (id_service) REFERENCES service(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Insert data into table galerie_service
INSERT INTO galerie_service (id_galerie, id_service) VALUES
(1, 1),
(2, 1);


-- Table: rendez_vous
DROP TABLE IF EXISTS rendez_vous;
CREATE TABLE IF NOT EXISTS rendez_vous (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_coiffeur INT NOT NULL,
    id_utilisateur INT NOT NULL,
    date_rendez_vous DATE NOT NULL,
    heure_rendez_vous TIME NOT NULL,
    id_produit  NOT NULL BOOLEAN DEFAULT 0,
    FOREIGN KEY (id_coiffeur) REFERENCES coiffeur(id),
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id),
    FOREIGN KEY (id_produit) REFERENCES produit(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Insert data into table rendez_vous
INSERT INTO rendez_vous (id_coiffeur, id_utilisateur, date_rendez_vous, heure_rendez_vous, id_produit) VALUES
(1, 9, '2021-06-01', '10:00:00', 1),
(1, 9, '2021-06-01', '11:00:00', 2);


-- Table: rendez_vous_service
CREATE TABLE IF NOT EXISTS rendez_vous_service (
    id_rendez_vous INT NOT NULL,
    id_service INT NOT NULL,
    PRIMARY KEY (id_rendez_vous, id_service),
    FOREIGN KEY (id_rendez_vous) REFERENCES rendez_vous(id),
    FOREIGN KEY (id_service) REFERENCES service(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Insert data into table rendez_vous_service
INSERT INTO rendez_vous_service (id_rendez_vous, id_service) VALUES
(1, 1),
(2, 1);


-- Table: avis
CREATE TABLE IF NOT EXISTS avis (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_utilisateur INT NOT NULL,
    id_rendez_vous INT NOT NULL,
    note INT NOT NULL,
    commentaire TEXT NOT NULL,
    date_avis TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id),
    FOREIGN KEY (id_rendez_vous) REFERENCES rendez_vous(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Insert data into table avis
INSERT INTO avis (id_utilisateur, id_rendez_vous, note, commentaire) VALUES
(9, 1, 5, 'avis 1'),
(9, 2, 4, 'avis 2');

-- Table: rappel_rendez_vous
CREATE TABLE IF NOT EXISTS rappel_rendez_vous (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_rendez_vous INT NOT NULL,
    id_utilisateur INT NOT NULL,
    envoyer BOOLEAN NOT NULL DEFAULT 0,
    FOREIGN KEY (id_utilisateur) REFERENCES rendez_vous(id_utilisateur),
    FOREIGN KEY (id_rendez_vous) REFERENCES rendez_vous(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- Creates triggers

-- Trigger: after_insert_utilisateur_coiffeur

DROP TRIGGER IF EXISTS after_insert_utilisateur_coiffeur;
DELIMITER $$

CREATE TRIGGER after_insert_utilisateur_coiffeur
AFTER INSERT ON utilisateur FOR EACH ROW
BEGIN
    IF NEW.role = 'coiffeur' THEN
        INSERT INTO coiffeur (id_utilisateur) VALUES (NEW.id);
    END IF;
END;
$$
DELIMITER ;

-- Trigger: after_insert_utilisateur_administrateur

DROP TRIGGER IF EXISTS after_insert_utilisateur_administrateur;
DELIMITER $$
CREATE TRIGGER after_insert_utilisateur_administrateur
AFTER INSERT ON utilisateur FOR EACH ROW
BEGIN
    IF NEW.role = 'admin' THEN
        INSERT INTO administrateur (id_utilisateur) VALUES (NEW.id);
    END IF;
END;
$$
DELIMITER ;

-- Trigger: insert_default_role_client

DROP TRIGGER IF EXISTS insert_default_role_client;
DELIMITER $$
CREATE TRIGGER insert_default_role_client
BEFORE INSERT ON utilisateur FOR EACH ROW
BEGIN
    IF NEW.role IS NULL THEN
        SET NEW.role = 'client';
    END IF;
END;
$$
DELIMITER ;



