
-- --------------------------------------------------------------------------
-- Create database
CREATE DATABASE IF NOT EXISTS fetacoup_database_v2;
-- --------------------------------------------------------------------------
-- Use database
USE fetacoup_database_v2;
-- --------------------------------------------------------------------------

-- Create triggers

-- Trigger: give_default_role_client
DELIMITER $$
CREATE TRIGGER give_default_role_client
BEFORE INSERT ON utilisateur
FOR EACH ROW
BEGIN
    IF NEW.role IS NULL THEN
        SET NEW.role = 'client';
    END IF;
END;
$$
DELIMITER ;

-- Trigger: after_insert_give_role_admin
DELIMITER $$
CREATE TRIGGER after_insert_give_role_admin
AFTER INSERT ON utilisateur
FOR EACH ROW
BEGIN
    IF NEW.role = 'admin' THEN
        INSERT INTO administrateur (id_utilisateur) VALUES (NEW.id);
    END IF;
END;
$$
DELIMITER ;

-- Trigger: after_insert_give_role_coiffeur
DELIMITER $$
CREATE TRIGGER after_insert_give_role_coiffeur
AFTER INSERT ON utilisateur
FOR EACH ROW
BEGIN
    IF NEW.role = 'coiffeur' THEN
        INSERT INTO coiffeur (id_utilisateur) VALUES (NEW.id);
    END IF;
END;
$$
DELIMITER ;


-- ------------------------------------------------------------------------

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
('test', 'test', 'test@gmail.com', 'test');


-- Table: administrateur
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

INSERT INTO galerie (nom ,photo) VALUES
('produits de cheveux', 'produits_de_cheveux.jpg'),
('soins de la peau', 'soins_de_la_peau.jpg'),
('maquillage', 'maquillage.jpg'),
('accessoires', 'accessoires.jpg'),
('coiffure', 'coiffure.jpg'),
('esthétique', 'esthétique.jpg'),
('maquillage', 'maquillage.jpg'),
('onglerie', 'onglerie.jpg'),
('image1', 'image1.jpg'),
('image2', 'image2.jpg'),
('image3', 'image3.jpg'),
('image4', 'image4.jpg'),
('image5', 'image5.jpg');

-- Table: horaire
CREATE TABLE IF NOT EXISTS horaire (
    id INT AUTO_INCREMENT PRIMARY KEY,
    jour ENUM('lundi', 'mardi', 'mercredi', 'jeudi', 'vendredi', 'samedi', 'dimanche') NOT NULL,
    heure_ouverture TIME NOT NULL DEFAULT '09:00:00',
    heure_fermeture TIME NOT NULL DEFAULT '20:00:00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
    prix DECIMAL(10, 2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO produit (nom, description, prix) VALUES
('produit1', 'description1', 10.00),
('produit2', 'description2', 20.00),
('produit3', 'description3', 30.00),
('produit4', 'description4', 40.00),
('produit5', 'description5', 50.00);

-- Table: galerie_produit
CREATE TABLE IF NOT EXISTS galerie_produit (
    id_galerie INT NOT NULL,
    id_produit INT NOT NULL,
    PRIMARY KEY (id_galerie, id_produit),
    FOREIGN KEY (id_galerie) REFERENCES galerie(id),
    FOREIGN KEY (id_produit) REFERENCES produit(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO galerie_produit (id_galerie, id_produit) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 1),
(5, 1),
(6, 1),
(7, 1),
(8, 1),
(9, 1),
(10, 1),
(11, 1),
(12, 1),
(13, 1);

-- Table: service
CREATE TABLE IF NOT EXISTS service (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(55) NOT NULL,
    description TEXT NOT NULL,
    prix DECIMAL(10, 2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO service (nom, description, prix) VALUES
('service1', 'description1', 10.00),
('service2', 'description2', 20.00),
('service3', 'description3', 30.00),
('service4', 'description4', 40.00),
('service5', 'description5', 50.00);

-- Table: galerie_service
CREATE TABLE IF NOT EXISTS galerie_service (
    id_galerie INT NOT NULL,
    id_service INT NOT NULL,
    PRIMARY KEY (id_galerie, id_service),
    FOREIGN KEY (id_galerie) REFERENCES galerie(id),
    FOREIGN KEY (id_service) REFERENCES service(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO galerie_service (id_galerie, id_service) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 1),
(5, 1),
(6, 1),
(7, 1),
(8, 1),
(9, 1),
(10, 1),
(11, 1),
(12, 1),
(13, 1);


-- Table: rendez_vous
CREATE TABLE IF NOT EXISTS rendez_vous (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_coiffeur INT NOT NULL,
    id_utilisateur INT NOT NULL,
    date_rendez_vous DATE NOT NULL,
    heure_rendez_vous TIME NOT NULL,
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id),
    FOREIGN KEY (id_coiffeur) REFERENCES coiffeur(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Insert data into table rendez_vous
INSERT INTO rendez_vous (id_coiffeur, id_utilisateur, date_rendez_vous, heure_rendez_vous) VALUES
(1, 1, '2021-01-01', '10:00:00'),
(1, 1, '2021-01-02', '11:00:00');


-- Table: reservation_produit
CREATE TABLE IF NOT EXISTS reservation_produit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_utilisateur INT NOT NULL,
    id_produit INT NOT NULL,
    date_reservation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_utilisateur) REFERENCES rendez_vous(id_utilisateur),
    FOREIGN KEY (id_produit) REFERENCES produit(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Insert data into table reservation_produit
INSERT INTO reservation_produit (id_utilisateur, id_produit) VALUES
(1, 1),
(1, 2);

-- Table: rendez_vous_service
CREATE TABLE IF NOT EXISTS rendez_vous_service (
    id_utilisateur INT NOT NULL,
    id_service INT NOT NULL,
    PRIMARY KEY (id_utilisateur, id_service),
    FOREIGN KEY (id_utilisateur) REFERENCES rendez_vous(id_utilisateur),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Insert data into table rendez_vous_service
INSERT INTO rendez_vous_service (id_utilisateur, id_service) VALUES
(1, 1),
(1, 2);

-- Table: avis
CREATE TABLE IF NOT EXISTS avis (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_utilisateur INT NOT NULL,
    id_rendez_vous INT NOT NULL,
    note INT NOT NULL,
    commentaire TEXT NOT NULL,
    date_avis TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id),
    FOREIGN KEY (id_rendez_vous) REFERENCES rendez_vous(id),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Insert data into table avis
INSERT INTO avis (id_utilisateur, id_rendez_vous, note, commentaire) VALUES
(1, 1, 5, 'avis 1'),
(1, 2, 4, 'avis 2');

-- Table: rappel_rendez_vous
CREATE TABLE IF NOT EXISTS rappel_rendez_vous (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_rendez_vous INT NOT NULL,
    id_utilisateur INT NOT NULL,
    envoyer BOOLEAN NOT NULL DEFAULT 0,
    FOREIGN KEY (id_rendez_vous) REFERENCES rendez_vous(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Insert data into table rappel_rendez_vous
INSERT INTO rappel_rendez_vous (id_rendez_vous, id_utilisateur) VALUES
(1, 1),
(2, 1);

-- ------------------------------------------------------------------------
-- End of file database_v2.sql
-- ------------------------------------------------------------------------


