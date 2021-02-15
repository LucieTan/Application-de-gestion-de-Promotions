REM **********************************************************************
REM Mise en place des procédures et fonctions stockées LOT2
REM Auteur : TAN Lucie, TENDON Kenny
REM Date de création : 16/05/2020
REM **********************************************************************  


CREATE OR REPLACE PACKAGE PACK_LOT2 IS
FUNCTION EffectifCommercial(Idpromotion INTEGER) RETURN number;
PROCEDURE MAJNBANNONCEUR(IdPromotion NUMBER, NbC NUMBER);
PROCEDURE PromotionAnnonce;
PROCEDURE CreationAnnonce(IdPromotion INT, NbC INT);
PROCEDURE ListeCom(IdOf INTEGER);
PROCEDURE ListeComPromo(IdPromotion INTEGER);
END PACK_LOT2;
/


CREATE OR REPLACE PACKAGE BODY PACK_LOT2 AS 

FUNCTION EffectifCommercial(Idpromotion INTEGER) RETURN number
IS
NBCom INTEGER;
BEGIN
Select COUNT(Id_Com) Into NBCom From Annoncer
WHERE Id_Prom = Idpromotion;
RETURN NBCom;
END EffectifCommercial;


PROCEDURE MAJNBANNONCEUR(IdPromotion NUMBER, NbC NUMBER) IS TMP_NB INTEGER;

BEGIN
SELECT NbreAnnonceur INTO TMP_NB FROM Promotion Where (Id_Prom = IdPromotion);

If ((TMP_NB + NbC) < EffectifCommercial(IdPromotion)) THEN
    DBMS_OUTPUT.PUT_LINE ('Vous avez retirer beaucoup trop de commerciaux! :))');
ELSE UPDATE Promotion SET NbreAnnonceur = (NbreAnnonceur+NbC) WHERE Id_Prom = IdPromotion;

END IF;
END MAJNBANNONCEUR;


PROCEDURE PromotionAnnonce IS
CURSOR C_ANNONCEPROM IS SELECT p.intitule_prom,  p.Id_Prom FROM Promotion p;
BEGIN
FOR tuple_ANNONCEPROM IN C_ANNONCEPROM LOOP
    DBMS_OUTPUT.PUT_LINE (EffectifCommercial(tuple_ANNONCEPROM.Id_Prom) || ' Commerciaux annoncent la promotion ' || tuple_ANNONCEPROM.intitule_prom);
END LOOP;
END PromotionAnnonce; 


PROCEDURE CreationAnnonce(IdPromotion INT, NbC INT) IS TMP_NB INTEGER;
CURSOR C_ANNONCE IS SELECT p.Id_Prom, a.Id_Com, p.NbreAnnonceur FROM Promotion p  INNER JOIN Annoncer a ON p.Id_Prom= a.Id_Prom;
BEGIN
SELECT NbreAnnonceur INTO TMP_NB FROM Promotion Where (Id_Prom = IdPromotion);

If ((EffectifCommercial(IdPromotion)) > TMP_NB-1) THEN
    DBMS_OUTPUT.PUT_LINE ('Le nombre max dannonceur est atteint ! Impossible d ajouter un nouveau commercial sur cette promo');
ELSE INSERT INTO Annoncer (Id_Prom, Id_Com, DateAnnonce) Values (IdPromotion, NbC, SYSDATE);

END IF;
END CreationAnnonce;


PROCEDURE ListeCom(IdOf INTEGER) IS
CURSOR C_LISTCOM IS select c.prenom_Com, c.nom_Com, s.accord, s.id_Offre, c.id_Com From Sponsoriser s INNER JOIN Commercial c
ON s.Id_Com = c.Id_Com 
ORDER BY 1 ,2;
BEGIN
FOR tuple_LISTCOM IN C_LISTCOM LOOP
    IF (tuple_LISTCOM.accord ='O' AND tuple_LISTCOM.id_Offre = IdOf) THEN
        DBMS_OUTPUT.PUT_LINE (tuple_LISTCOM.Prenom_Com || ' ' || tuple_LISTCOM.Nom_Com || ' sponsorise loffre n° ' || tuple_LISTCOM.Id_Offre );

END IF;
END LOOP;
END ListeCom;


PROCEDURE ListeComPromo(IdPromotion INTEGER) IS 
BEGIN 
FOR tuple_COMPOM IN (SELECT c.prenom_Com, c.nom_Com, s.accord, o.Id_Prom, o.Nom_Offre From Commercial c INNER JOIN Sponsoriser s ON c.Id_Com = s.Id_Com INNER JOIN Offre o ON s.Id_Offre = o.Id_Offre ORDER BY 1,2) LOOP
    IF (tuple_COMPOM.accord ='O' AND tuple_COMPOM.id_Prom = IdPromotion) THEN
        DBMS_OUTPUT.PUT_LINE (tuple_COMPOM.Prenom_Com || ' ' || tuple_COMPOM.Nom_Com || ' sponsorise la promotion  ' || tuple_COMPOM.Nom_Offre );
        
END IF;
END LOOP;
END ListeComPromo;

END PACK_LOT2;
/

SELECT PACK_LOT2.EffectifCommercial(7) FROM DUAL;
EXEC  PACK_LOT2.MAJNBANNONCEUR(7, 2) ; 
EXEC  PACK_LOT2.CreationAnnonce(11,7);
EXEC  PACK_LOT2.ListeCom(2);
EXEC  PACK_LOT2.ListeComPromo(10);