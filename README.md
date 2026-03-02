#  HSL Public Transit Database

A relational database system modelling the operations of a public transport operator (inspired by HSL), built as a university project for the course **CS-A1150 – Tietokannat** at Aalto University.

---

##  Overview

This project designs and implements a full relational database for managing public transit operations — covering routes, stops, vehicles, drivers, tickets, and passengers. The schema is normalized to **Boyce-Codd Normal Form (BCNF)** and includes realistic sample data, indexes, views, and a variety of SQL queries demonstrating real-world use cases.

---

##  Project Structure

```
├── createtable.sql       # Schema creation, indexes, view, and sample data inserts
├── selectkäskyt.sql      # Use case queries (SELECT, DELETE)
└── README.md
```

---

##  Database Schema

The database consists of **17 tables** covering the following domains:

| Domain | Tables |
|---|---|
| Transit network | `Linja`, `Pysäkki`, `Pysähtyy` |
| Operations | `Ajokerta`, `Nousu` |
| Vehicles | `Ajoneuvo`, `Ajoneuvotyyppi`, `SaaAjaa` |
| Drivers | `Kuljettaja`, `PäteväAjamaan`, `Työvuoro`, `Poissaolo` |
| Tickets & customers | `Lippu`, `Asiakas`, `Erityisryhmä`, `Kuuluu`, `AlennettuHinta` |

### Key design decisions

- **Integer timestamps** (e.g. `20250101`, `0830`) are used for dates and times to enable simple range comparisons with standard operators.
- **BCNF normalization** — all functional dependencies have superkeys on the left-hand side, eliminating redundancy and update anomalies throughout.
- The `Ajokerta` (ride) table supports `NULL` for driver and vehicle, allowing future rides to be scheduled before those details are confirmed.
- A driver must complete supervised rides (`harjoittelijankuljettajaID`) before being certified to drive a route alone, captured directly in the schema.

---

##  Sample Queries

A selection of the use cases implemented in `selectkäskyt.sql`:

**All lines that stop in zone A**
```sql
SELECT DISTINCT linjaID
FROM Pysäkki NATURAL JOIN Pysähtyy
WHERE vyöhyke = 'A';
```

**Drivers with more absences than scheduled shifts**
```sql
SELECT henkilötunnus
FROM (
  SELECT K.henkilötunnus,
    COUNT(DISTINCT T.työvuoroID) AS työvuorot,
    COUNT(DISTINCT P.poissaoloID) AS poissaolot
  FROM Kuljettaja K
  LEFT JOIN Työvuoro T ON K.henkilötunnus = T.henkilötunnus
  LEFT JOIN Poissaolo P ON K.henkilötunnus = P.henkilötunnus
  GROUP BY K.henkilötunnus
)
WHERE työvuorot < poissaolot;
```

**Direct routes between two stops with departure times**
```sql
SELECT Linja.linjaID, arkilähtöaika, lauantailähtöaika, sunnuntailähtöaika
FROM Linja
LEFT JOIN Pysähtyy P1 ON Linja.linjaID = P1.linjaID
LEFT JOIN Pysähtyy P2 ON Linja.linjaID = P2.linjaID
WHERE P1.pysäkkiID = 1924 AND P2.pysäkkiID = 2353
  AND P1.järjestysnumero < P2.järjestysnumero;
```

---

##  Indexes

Five indexes are defined to optimize common access patterns:

| Index | Purpose |
|---|---|
| `idx_kuljettajan_tyovuorot` | Look up a driver's shifts |
| `idx_kuljettajan_poissaolot` | Look up a driver's absences |
| `idx_linjan_lahto_ajat` | Fetch departure times for a line |
| `idx_erityisryhman_alennettu_hinta` | Discounted prices by special group |
| `idx_ajokerrat_päivämäärä_Linja` | All rides on a given day for a line |

---

##  View

```sql
CREATE VIEW AjokertaInfo AS
SELECT ajokertaID, päivämäärä, linjaID, kuljettaja, rekisterinumero, ajoneuvotyyppi
...
```

Provides a convenient joined summary of each ride with driver name and vehicle type.

---

##  Setup

The project uses standard SQL and was developed with **SQLite**. To set up:

```bash
# Run schema + data in one step
sqlite3 hsl.db < createtable.sql

# Run queries
sqlite3 hsl.db < selectkäskyt.sql
```

---

##  Normalization

All relations were analyzed for functional dependencies and verified to be in **BCNF** — every non-trivial functional dependency has a superkey on its left-hand side. No decomposition was needed, meaning the schema has no redundancy-driven anomalies.

---

##  Authors

- Samuel Mikkola
- Vesa Holopainen  
- Hashim Sher Agha

*Aalto University – CS-A1150 Tietokannat, 2025*
