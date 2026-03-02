
SELECT DISTINCT linjaID
FROM pysäkki NATURAL JOIN pysähtyy
WHERE vyöhyke = 'A';




SELECT kuljettajaID, Count(lippuID)
FROM Nousu NATURAL JOIN Ajokerta
GROUP BY kuljettajaID
ORDER BY Count(lippuID) DESC;



SELECT DISTINCT A.linjaID
FROM Ajokerta A
WHERE A.harjoittelijankuljettajaID IS NOT NULL;


SELECT E.erityisryhmäID
FROM Erityisryhmä E
JOIN Kuuluu K ON E.erityisryhmäID = K.erityisryhmäID
WHERE K.asiakasID = 4;



SELECT P.pysäkkiID, P.vyöhyke
FROM Pysähtyy PS
JOIN Pysäkki P ON PS.pysäkkiID = P.pysäkkiID
WHERE PS.linjaID = 10
ORDER BY PS.järjestysnumero;



SELECT K.nimi
FROM SaaAjaa SA
JOIN Kuljettaja K ON SA.henkilötunnus = K.henkilötunnus
WHERE SA.mallinumero = 1;



SELECT K.nimi
FROM Ajokerta A
JOIN Kuljettaja K ON A.kuljettajaID = K.henkilötunnus
WHERE A.linjaID = 510 AND A.päivämäärä = 20240504;



SELECT henkilötunnus
FROM (SELECT K1.henkilötunnus,
COUNT(DISTINCT T.työvuoroID) AS työvuorot,
COUNT(DISTINCT P.poissaoloID) AS poissaolot
FROM Kuljettaja AS K1
LEFT JOIN Työvuoro AS T ON K1.henkilötunnus = T.henkilötunnus
LEFT JOIN Poissaolo AS P ON K1.henkilötunnus = P.henkilötunnus
GROUP BY K1.henkilötunnus)
WHERE työvuorot < poissaolot;




SELECT *
FROM Lippu
WHERE ostohetki = 20240609;




SELECT Linja.linjaID, arkilähtöaika, lauantailähtöaika, sunnuntailähtöaika
FROM Linja
LEFT JOIN Pysähtyy P1 ON Linja.linjaID = P1.linjaID
LEFT JOIN Pysähtyy P2 ON Linja.linjaID = P2.linjaID
WHERE P1.pysäkkiID = 1924 AND P2.pysäkkiID = 2353
AND P1.järjestysnumero < P2.järjestysnumero;





SELECT a.nimi, a.osoite, a.puhelinnumero
FROM Asiakas a
JOIN Kuuluu k ON a.asiakasID = k.asiakasID
WHERE k.erityisryhmäID = 4;




SELECT nimi
FROM Kuljettaja
WHERE henkilötunnus NOT IN (
SELECT henkilötunnus FROM Työvuoro WHERE päivämäärä = 20250504
);




SELECT ostohetki, kesto
FROM lippu
WHERE lippuID = 3;





SELECT p.pysäkkiID, COUNT(n.NousuID) AS nousuja
FROM Pysäkki p
LEFT JOIN Nousu n ON p.pysäkkiID = n.PysäkkiID
GROUP BY p.pysäkkiID
ORDER BY nousuja DESC;



DELETE FROM AlennettuHinta
WHERE lippuID IN (SELECT lippuID
			FROM lippu
			WHERE ostohetki < 20240605);

DELETE FROM lippu
WHERE ostohetki < 20240605;
