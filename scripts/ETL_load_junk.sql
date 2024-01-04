Use CarRepairShopDW;
INSERT INTO Junk SELECT uct, ic FROM (VALUES ('Nie u¿yto lawety'), ('U¿yto lawety')) AS UCT(uct), (VALUES(N'Zwyk³a naprawa'), (N'Naprawa reklamacyjna')) AS IC(ic);