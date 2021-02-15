REM **********************************************************************
REM Script ORACLE de création de la base du projet LOT1
REM Auteur : TAN Lucie, TENDON KENNY
REM Date de création : 14/05/2020
REM **********************************************************************  

alter session set nls_date_format = 'DD/MM/RRRR';

REM SUPPRESSION des tables
 
DROP TABLE Promotion CASCADE CONSTRAINT PURGE;
DROP TABLE Secteur CASCADE CONSTRAINT PURGE;
DROP TABLE Commercial CASCADE CONSTRAINT PURGE;
DROP TABLE Offre CASCADE CONSTRAINT PURGE;
DROP TABLE Sponsoriser CASCADE CONSTRAINT PURGE;
DROP TABLE Annoncer CASCADE CONSTRAINT PURGE;

-- -----------------------------------------------------------------------------
--       SUPPRESSION ET CREATION des Sequences
-- -----------------------------------------------------------------------------

DROP SEQUENCE SeqPromotion;
DROP SEQUENCE SeqSecteur;
DROP SEQUENCE SeqOffre;
DROP SEQUENCE SeqCommercial;

CREATE SEQUENCE SeqPromotion start with 7 increment by 1;
CREATE SEQUENCE SeqSecteur start with 20 increment by 1;
CREATE SEQUENCE SeqCommercial;
CREATE SEQUENCE SeqOffre;

-- -----------------------------------------------------------------------------
--       CREATION TABLES
-- -----------------------------------------------------------------------------

REM CREATION TABLE Promotion

CREATE TABLE Promotion(
Id_Prom INTEGER,
Intitule_Prom VARCHAR(50) NOT NULL UNIQUE,
NbreAnnonceur INTEGER NOT NULL,
MontantTotal INTEGER
);


REM CREATION TABLE Secteur
CREATE TABLE Secteur(
Id_Secteur INTEGER,
Nom_Secteur VARCHAR(50),
NBRepresentant INTEGER 
);

REM CREATION TABLE Offre

CREATE TABLE Offre(
Id_Prom INTEGER,
Id_Offre INTEGER,
Nom_Offre VARCHAR(50)

);

REM CREATION TABLE Commercial

CREATE TABLE Commercial (
Id_Secteur INTEGER,
Id_Com INTEGER,
Nom_Com VARCHAR(50) NOT NULL,
Prenom_Com VARCHAR(50) NOT NULL,
Localisation_Com VARCHAR(50) NOT NULL,
Email_Com VARCHAR(40),
Tel_Com VARCHAR(50)
);

-- -----------------------------------------------------------------------------
--       CREATION TABLE D'ASSOCIATION
-- -----------------------------------------------------------------------------

REM CREATION TABLE Annoncer

CREATE TABLE Annoncer (
Id_Prom INTEGER,
Id_Com INTEGER, 
DateAnnonce DATE
);

REM CREATION TABLE Sponsoriser

CREATE TABLE Sponsoriser(
Id_Offre INTEGER, 
Id_Com INTEGER, 
Accord CHAR(1) NOT NULL

);

REM CONTRAINTE PK de la table Promotion

ALTER TABLE Promotion ADD (
    CONSTRAINT PK_TT_Promotion PRIMARY KEY(Id_Prom),
    CONSTRAINT CK_TT_NbreAnnonceur CHECK (LENGTH(NbreAnnonceur) >= 0)
);
 
REM CONTRAINTE PK de la table Secteur

ALTER TABLE Secteur
ADD CONSTRAINT PK_TT_Secteur PRIMARY KEY(Id_Secteur);

REM CONTRAINTE PK & FK de la table Commercial

ALTER TABLE Commercial ADD (
    CONSTRAINT PK_TT_Commercial PRIMARY KEY(Id_Com),
    CONSTRAINT FK_TT_Secteur_Commercial 
        FOREIGN KEY(Id_Secteur) REFERENCES Secteur(Id_Secteur),
    CONSTRAINT CK_TT_Tel_Com CHECK (LENGTH(Tel_Com) = 10)
);

REM CONTRAINTE PK & FK de la table Offre

ALTER TABLE Offre ADD (
    CONSTRAINT PK_TT_Offre PRIMARY KEY(Id_Offre),
    CONSTRAINT FK_TT_Promotion_Offre
        FOREIGN KEY(Id_Prom) REFERENCES Promotion(Id_Prom)
);



REM CONTRAINTE PK & FK de la table Annoncer

ALTER TABLE Annoncer ADD (
    CONSTRAINT PK_TT_Annoncer PRIMARY KEY(Id_Prom,Id_Com),
    CONSTRAINT FK_TT_Promotion_Annoncer
        FOREIGN KEY(Id_Prom) REFERENCES Promotion(Id_Prom),
    CONSTRAINT FK_TT_Commercial_Annoncer 
        FOREIGN KEY(Id_Com) REFERENCES Commercial(Id_Com)
);

REM CONTRAINTE PK & FK de la table Sponsoriser

ALTER TABLE Sponsoriser ADD (
    CONSTRAINT PK_TT_Sponsoriser PRIMARY KEY(Id_Offre,Id_Com),
    CONSTRAINT FK_TT_Offre_Sponsoriser
        FOREIGN KEY(Id_Offre) REFERENCES Offre(Id_Offre),
    CONSTRAINT FK_TT_Commercial_Sponsoriser
        FOREIGN KEY(Id_Com) REFERENCES Commercial(Id_Com),
    CONSTRAINT CK_TT_Accord CHECK (Accord in ('O','N'))
);

-- -----------------------------------------------------------------------------
--       INSERTION DES DONNEES dans les TABLES 
-- -----------------------------------------------------------------------------


REM INSERTION dans la table Promotion

insert into Promotion (Id_Prom, Intitule_Prom, NbreAnnonceur, MontantTotal) values
(SeqPromotion.nextval, 'Eclair au chocolat délicieux',7,2);
insert into Promotion (Id_Prom, Intitule_Prom, NbreAnnonceur, MontantTotal) values
(SeqPromotion.nextval, 'Céréales extra croustillantes',5, 5);
insert into Promotion (Id_Prom, Intitule_Prom, NbreAnnonceur, MontantTotal) values
(SeqPromotion.nextval, 'Ipoire 12',20,1500);
insert into Promotion (Id_Prom, Intitule_Prom, NbreAnnonceur, MontantTotal) values
(SeqPromotion.nextval, 'Veste légère',3, 45);
insert into Promotion (Id_Prom, Intitule_Prom, NbreAnnonceur, MontantTotal) values
(SeqPromotion.nextval, 'Rayban',3, 45);

REM INSERTION dans la table Secteur

insert into Secteur (Id_Secteur, Nom_Secteur, NBRepresentant) values (SeqSecteur.nextval, 'Alimentaire', 1);
insert into Secteur (Id_Secteur, Nom_Secteur, NBRepresentant) values (SeqSecteur.nextval, 'Alimentaire', 3);
insert into Secteur (Id_Secteur, Nom_Secteur, NBRepresentant) values (SeqSecteur.nextval, 'Loisirs', 10);
insert into Secteur (Id_Secteur, Nom_Secteur, NBRepresentant) values (SeqSecteur.nextval, 'Numérique', 10);
insert into Secteur (Id_Secteur, Nom_Secteur, NBRepresentant) values (SeqSecteur.nextval, 'Mode', 10);
insert into Secteur (Id_Secteur, Nom_Secteur, NBRepresentant) values (SeqSecteur.nextval, 'Santé', 10);
insert into Secteur (Id_Secteur, Nom_Secteur, NBRepresentant) values (SeqSecteur.nextval, 'Loisirs', 3);
insert into Secteur (Id_Secteur, Nom_Secteur, NBRepresentant) values (SeqSecteur.nextval, 'Loisirs', 45);

REM  INSERTION dans la table Offre

insert into Offre (Id_Prom, Id_Offre,Nom_Offre) values (7, SeqOffre.nextval,'Patisserie');
insert into Offre (Id_Prom, Id_Offre,Nom_Offre) values (8, SeqOffre.nextval,'Céréales');
insert into Offre (Id_Prom, Id_Offre,Nom_Offre) values (9, SeqOffre.nextval,'Smartphone');
insert into Offre (Id_Prom, Id_Offre,Nom_Offre) values (10, SeqOffre.nextval,'Vêtement');
insert into Offre (Id_Prom, Id_Offre,Nom_Offre) values (11, SeqOffre.nextval,'Lunettes');
insert into Offre (Id_Prom, Id_Offre,Nom_Offre) values (7, SeqOffre.nextval,'Patisserie');

REM  INSERTION dans la table Commercial

insert into Commercial (Id_Secteur, Id_Com,Nom_Com,Prenom_Com, Localisation_Com, Email_Com, Tel_Com) values
(20, SeqCommercial.nextval, 'LIGNAC','Cyril','60 rue du patissier','Lignac.Cyril@gmail.com','0987654321');
insert into Commercial (Id_Secteur, Id_Com,Nom_Com,Prenom_Com, Localisation_Com, Email_Com, Tel_Com) values
(21, SeqCommercial.nextval, 'DUPONT','Pierre','4 rue les roses','Dupont.Pierre@gmail.fr','0123456789');
insert into Commercial (Id_Secteur, Id_Com,Nom_Com,Prenom_Com, Localisation_Com, Email_Com, Tel_Com) values
(22, SeqCommercial.nextval, 'DUVAL','Christelle','3 rue de la gentilesse','christelle.duval@gmail.com','0164763098');
insert into Commercial (Id_Secteur, Id_Com,Nom_Com,Prenom_Com, Localisation_Com, Email_Com, Tel_Com) values
(23, SeqCommercial.nextval, 'CHEVAL','Francis','5 rue du fou','cheval.Francis@gmail.com','0154496534');
insert into Commercial (Id_Secteur, Id_Com,Nom_Com,Prenom_Com, Localisation_Com, Email_Com, Tel_Com) values
(24, SeqCommercial.nextval, 'AFFLELOU','Alain','5 rue de la vision','Alain.Afflelou@gmail.com','0154496534');
insert into Commercial (Id_Secteur, Id_Com,Nom_Com,Prenom_Com, Localisation_Com, Email_Com, Tel_Com) values
(20, SeqCommercial.nextval, 'SMITH','Will','60 rue du rôle','Will.Smith@gmail.com','0546814321');
insert into Commercial (Id_Secteur, Id_Com,Nom_Com,Prenom_Com, Localisation_Com, Email_Com, Tel_Com) values
(20, SeqCommercial.nextval, 'ETCHEBEST','Philippe','60 rue du cuisinière','E.Philippe@gmail.com','0987345565');




REM INSERTION dans la table Sponsoriser

insert into Sponsoriser (Id_Com, Id_Offre, Accord) values ( 1, 1, 'O');
insert into Sponsoriser (Id_Com, Id_Offre, Accord) values ( 2, 2, 'O');
insert into Sponsoriser (Id_Com, Id_Offre, Accord) values ( 3, 3, 'N');
insert into Sponsoriser (Id_Com, Id_Offre, Accord) values ( 4, 4, 'N');
insert into Sponsoriser (Id_Com, Id_Offre, Accord) values ( 5, 5, 'O');
insert into Sponsoriser (Id_Com, Id_Offre, Accord) values ( 2, 6, 'O');

REM INSERTION dans la table Annoncer

insert into Annoncer (id_Prom, Id_Com, DateAnnonce) values ( 7, 1, '12/03/2020');
insert into Annoncer (id_Prom, Id_Com, DateAnnonce) values ( 7, 6, '03/03/2020');
insert into Annoncer (id_Prom, Id_Com, DateAnnonce) values ( 7, 7, '04/01/2020');
insert into Annoncer (id_Prom, Id_Com, DateAnnonce) values ( 8, 2, '05/11/2019');
insert into Annoncer (id_Prom, Id_Com, DateAnnonce) values ( 9, 3, '17/01/2020');
insert into Annoncer (id_Prom, Id_Com, DateAnnonce) values ( 10, 4, '01/02/2020');
insert into Annoncer (id_Prom, Id_Com, DateAnnonce) values ( 11, 5, '14/04/2020');



