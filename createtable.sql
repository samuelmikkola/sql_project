
CREATE TABLE Nousu (
	nousuID INTEGER NOT NULL PRIMARY KEY,
	lippuID INTEGER,
	pysäkkiID INTEGER,
	ajokertaID INTEGER
);
CREATE TABLE Pysäkki (
	pysäkkiID INTEGER NOT NULL PRIMARY KEY,
	vyöhyke TEXT
);

CREATE TABLE Linja (
linjaID INTEGER NOT NULL PRIMARY KEY,
tyyppi TEXT NOT NULL,
arkilähtöaika INTEGER,
lauantailähtöaika INTEGER,
sunnuntailähtöaika INTEGER,
ajoaika INTEGER NOT NULL
);

CREATE TABLE Pysähtyy (
pysäkkiID INTEGER NOT NULL REFERENCES Pysäkki(pysäkkiID),
linjaID INTEGER NOT NULL REFERENCES Linja(linjaID),
järjestysnumero INTEGER,
PRIMARY KEY(pysäkkiID, linjaID)
);

CREATE TABLE Kuljettaja (
	henkilötunnus TEXT NOT NULL PRIMARY KEY,
	nimi TEXT,
	osoite TEXT,
	puhelinnumero INTEGER
);

CREATE TABLE PäteväAjamaan (
linjaID INTEGER NOT NULL REFERENCES Linja(linjaID),
kuljettajaID TEXT NOT NULL REFERENCES Kuljettaja(henkilötunnus),
PRIMARY KEY(linjaID, kuljettajaID)
);

CREATE TABLE Ajokerta (
ajokertaID INTEGER NOT NULL PRIMARY KEY,
päivämäärä INTEGER NOT NULL,
linjaID INTEGER NOT NULL REFERENCES Linja(linjaID),
ajoneuvoID TEXT NOT NULL REFERENCES Ajoneuvo(rekisteriNumero),
kuljettajaID TEXT REFERENCES Kuljettaja(henkilötunnus),
harjoittelijankuljettajaID TEXT REFERENCES Kuljettaja(henkilötunnus)
);

CREATE TABLE Lippu (
lippuID INTEGER NOT NULL PRIMARY KEY,
hinta INTEGER NOT NULL,
tyyppi TEXT NOT NULL,
ostohetki INTEGER NOT NULL,
kesto INTEGER NOT NULL
);

CREATE TABLE Asiakas (
asiakasID INTEGER NOT NULL PRIMARY KEY,
nimi TEXT,
osoite TEXT,
puhelinnumero INTEGER
);

CREATE TABLE Erityisryhmä (
erityisryhmäID INTEGER NOT NULL PRIMARY KEY
);

CREATE TABLE Kuuluu (
asiakasID INTEGER NOT NULL REFERENCES Asiakas(asiakasID),
erityisryhmäID INTEGER NOT NULL REFERENCES Erityisryhmä(erityisryhmäID),
PRIMARY KEY (asiakasID, erityisryhmäID)
);

CREATE TABLE Ajoneuvotyyppi (
	malliNumero INTEGER NOT NULL PRIMARY KEY,
	energianLähde TEXT CHECK (energianLähde IN ('sähkö', 'diesel', 'bensiini')),
	istumapaikat INTEGER,
	seisomapaikat INTEGER,
	tyyppi TEXT CHECK (tyyppi IN ('bussi', 'juna', 'raitiovaunu'))
);
CREATE TABLE Ajoneuvo (
	rekisterinumero TEXT NOT NULL PRIMARY KEY,
	malliNumero INTEGER REFERENCES Ajoneuvotyyppi(mallinumero)
);
CREATE TABLE Työvuoro (
	työvuoroID INTEGER NOT NULL PRIMARY KEY,
	päivämäärä INTEGER,
	alkuKlo INTEGER,
	loppuKlo INTEGER,
	henkilötunnus TEXT REFERENCES Kuljettaja(henkilötunnus)
);

CREATE TABLE Poissaolo(
	poissaoloID INTEGER NOT NULL PRIMARY KEY,
	alkupvm INTEGER,
loppupvm INTEGER,
tyyppi TEXT CHECK (tyyppi IN ('sairaus', 'loma')),
	henkilötunnus TEXT REFERENCES Kuljettaja(henkilötunnus)
);

CREATE TABLE SaaAjaa (
	henkilötunnus TEXT NOT NULL REFERENCES Kuljettaja(henkilötunnus),
	mallinumero INTEGER NOT NULL REFERENCES Ajoneuvotyyppi(mallinumero),
	PRIMARY KEY (henkilötunnus, mallinumero)
);


CREATE TABLE AlennettuHinta (
	lippuID INTEGER NOT NULL REFERENCES Lippu(lippuID),
	erityisryhmäID INTEGER NOT NULL REFERENCES Erityisryhmä(erityisryhmäID),
	alennusprosentti INTEGER,
	PRIMARY KEY (lippuID, erityisRyhmäID)
);

CREATE INDEX idx_kuljettajan_tyovuorot ON Työvuoro(henkilötunnus);
CREATE INDEX idx_kuljettajan_poissaolot ON Poissaolo(henkilötunnus);
CREATE INDEX idx_linjan_lahto_ajat ON Linja(LinjaID);
CREATE INDEX idx_erityisryhman_alennettu_hinta ON AlennettuHinta(erityisRyhmäID);
CREATE INDEX idx_ajokerrat_päivämäärä_Linja ON Ajokerta(päivämäärä, linjaID);
CREATE INDEX idx_kuljettajan_tyovuorot ON Työvuoro(henkilötunnus);
CREATE INDEX idx_kuljettajan_poissaolot ON Poissaolo(henkilötunnus);
CREATE INDEX idx_linjan_lahto_ajat ON Linja(LinjaID);
CREATE INDEX idx_erityisryhman_alennettu_hinta ON AlennettuHinta(erityisRyhmäID);
CREATE INDEX idx_ajokerrat_päivämäärä_Linja ON Ajokerta(päivämäärä, linjaID);

INSERT INTO Linja(linjaID, tyyppi, arkilähtöaika, lauantailähtöaika, sunnuntailähtöaika, ajoaika) VALUES
(510, 'bussi', 081200, 081200, 081200, 012800),
(520, 'bussi', 120900, 132500, 132500, 005700),
(240, 'bussi', 180300, 201300, 211300, 004400),
(10, 'juna', 072300, 072300, 072300, 023200),
(8, 'juna', 172300, 192100, 192300, 021200),
(14, 'raitiovaunu', 110600, 112700, 112700, 003700),
(15, 'raitiovaunu', 151400, 151400, 151400, 005000);


INSERT INTO Lippu(lippuID, hinta, tyyppi, ostohetki, kesto) VALUES
(1, 3, 'kertalippu', 20240603, 1),
(2, 2, 'erikoiskertalippu', 20240603, 1),
(3, 40, 'kausilippu', 20240604, 30),
(4, 3, 'kertalippu', 20240607, 1),
(5, 2.5, 'mobiilisovelluslippu', 20240608, 1),
(6, 300, 'vuosilippu', 20240609, 360),
(7, 1.3, 'erikoiskertalippu', 20240609, 1),
(8, 20, 'kertalippu', 20230601, 1);


INSERT INTO Pysäkki(pysäkkiID, vyöhyke) VALUES
(1924, 'A'),
(1953, 'A'),
(1927, 'A'),
(1911, 'A'),
(1932, 'A'),
(2353, 'B'),
(2276, 'B'),
(2251, 'B'),
(3205, 'C'),
(3123, 'C'),
(0032, 'A'),
(0027, 'A'),
(0017, 'B'),
(0079, 'C');


INSERT INTO Pysähtyy(pysäkkiID, LinjaID, järjestysnumero) VALUES
(1924, 510, 1),
(1953, 510, 2),
(1932, 510, 3),
(2353, 510, 4),
(1911, 520, 1),
(1932, 520, 2),
(2251, 520, 3),
(2276, 520, 4),
(2251, 240, 1),
(3205, 240, 2),
(3123, 240, 3),
(0032, 10, 1),
(0027, 10, 2),
(0017, 10, 3),
(0079, 10, 4),
(0017, 8, 1),
(0027, 8, 2),
(0032, 8, 3),
(1911, 14, 1),
(1932, 14, 2),
(1953, 14, 3),
(1924, 15, 1),
(1927, 15, 2),
(1932, 15, 3),
(1953, 15, 4);


INSERT INTO Kuljettaja(henkilötunnus, nimi, osoite, puhelinnumero) VALUES
('231287E283J', 'Hessu Hakkarainen', 'Puutie 2, Helsinki', 0502739955),
('180298F594X', 'Jaana Hemppainen', 'Sähkökatu 14, Helsinki', 0402993712),
('180138Q634D', 'Pekko Kemppainen', 'Katu 1, Espoo', 0402322888),
('232122A987D', 'Meri Mehkala', 'Kivimiehen tie 5, Vantaa', 0402322888),
('251224Y654E', 'Tervo Kankaanpää', 'Vanha katu 8, Espoo', 0402322888);


INSERT INTO Nousu(nousuID, lippuID, pysäkkiID, ajokertaID) VALUES
(1, 1, 1924, 1),
(2, 2, 1932, 2),
(3, 2, 2251, 3),
(4, 3, 1924, 4),
(5, 4, 1924, 5);


INSERT INTO Asiakas (asiakasID, nimi, osoite, puhelinnumero) VALUES
(1, 'Matti Meikäläinen', 'katu 1, Helsinki', 040125215),
(2, 'Majia Juu', 'katu 2, Helsinki', 040457457),
(3, 'Meikä Mattilainen', 'katu 3, Espoo', 040745745),
(4, 'Bussi Kuski', 'katu 4, Helsinki', 040125218),
(5, 'Cole slaw', 'katu 5, Vantaa', 040457485),
(6, 'Jalo v iina', 'katu 6, Helsinki', 04012547),
(7, 'Alvar Aalto', 'katu 7, Espoo', 040121548),
(8, 'Kalle Ruttik', 'katu 8, Helsinki', 040125437);


INSERT INTO Erityisryhmä(erityisryhmäID) Values
(1),
(2),
(3),
(4);

INSERT INTO Kuuluu(asiakasID, erityisryhmäID) Values
(1, 1),
(4, 2),
(8, 3),
(5, 1),
(6, 4);


INSERT INTO Ajoneuvotyyppi (malliNumero, energianLähde, istumapaikat, seisomapaikat, tyyppi) VALUES
(1, 'diesel', 40, 20, 'bussi'),
(2, 'sähkö', 40, 20, 'bussi'),
(3, 'sähkö', 100, 40, 'juna'),
(4, 'bensiini', 40, 20, 'bussi'),
(5, 'sähkö', 60, 15, 'raitiovaunu'),
(6, 'diesel', 200, 50, 'juna');


INSERT INTO Ajoneuvo(rekisterinumero, malliNumero) VALUES
('ABC-123', 1),
('ABC-124', 2),
('CBA-123', 3),
('CBA-124', 4),
('BCA-123', 5),
('BCA-124', 6);


INSERT INTO Ajokerta (ajokertaID, päivämäärä, linjaID, ajoneuvoID, kuljettajaID, harjoittelijankuljettajaID) VALUES
(1, 20240504, 510, 'ABC-123', '231287E283J', NULL),
(2, 20240504, 240, 'ABC-124', '231287E283J', NULL),
(3, 20240504, 10, 'CBA-123', '180298F594X', NULL),
(4, 20240504, 8, 'CBA-124', '180138Q634D', '232122A987D'),
(5, 20240504, 14, 'BCA-123', '180138Q634D', '251224Y654E');


INSERT INTO Työvuoro (työvuoroID, päivämäärä, alkuKlo, loppuKlo, henkilötunnus) VALUES
(1, 20250504, 700, 1500, '231287E283J' ),
(2, 20250504, 800, 1600, '180298F594X' ),
(3, 20250504, 1000, 1900, '180138Q634D'),
(4, 20250505, 700, 1500, '232122A987D' ),
(5, 20250504, 800, 1600, '251224Y654E' ),
(6, 20250504, 1200, 2200, '251224Y654E' );


INSERT INTO Poissaolo (poissaoloID, alkupvm, loppupvm, tyyppi, henkilötunnus) VALUES
(1, 20250107, 20250109, 'sairaus', '180138Q634D'),
(2, 20250210, 20250215, 'sairaus', '232122A987D'),
(3, 20250601, 20250701, 'loma', '231287E283J'),
(4, 20250106, 20250108, 'loma', '251224Y654E'),
(5, 20250315, 20250319, 'sairaus', '232122A987D');

INSERT INTO SaaAjaa (henkilötunnus, mallinumero) VALUES
('231287E283J', 1),
('231287E283J', 2),
('231287E283J', 4),
('180298F594X', 3),
('180298F594X', 6),
('180138Q634D', 5),
('232122A987D', 1),
('232122A987D', 2),
('232122A987D', 3),
('251224Y654E', 1);

INSERT INTO PäteväAjamaan (linjaID, kuljettajaID) VALUES
(510 ,'231287E283J'),
(240 ,'231287E283J'),
(10, '180298F594X'),
(8, '180138Q634D'),
(14, '180138Q634D');

INSERT INTO AlennettuHinta (lippuID, erityisryhmäID, alennusprosentti ) VALUES
(2, 1, 33),
(7, 4, 66);


CREATE VIEW AjokertaInfo AS
SELECT
A.ajokertaID,
A.päivämäärä,
L.linjaID,
K.nimi AS kuljettaja,
AJ.rekisterinumero,
AT.tyyppi AS ajoneuvotyyppi
FROM Ajokerta A
JOIN Linja L ON A.linjaID = L.linjaID
JOIN Kuljettaja K ON A.kuljettajankuljettajaID = K.henkilötunnus
JOIN Ajoneuvo AJ ON A.ajoneuvoID = AJ.rekisterinumero
JOIN Ajoneuvotyyppi AT ON AJ.malliNumero = AT.malliNumero

