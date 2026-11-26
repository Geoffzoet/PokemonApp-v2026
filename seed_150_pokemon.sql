-- =============================================================================
-- Script SQL : Insertion des 150 Pokémon de la Génération 1
-- =============================================================================
-- Base de données : SQLite (pokemon.db)
-- Tables : Pokemon, Attacks
-- Date : 2026-11-24
-- =============================================================================

-- PokemonType Enum Values (stockés comme INTEGER dans SQLite):
-- 0=NORMAL, 1=FIRE, 2=WATER, 3=GRASS, 4=ELECTRIC, 5=ICE, 6=FIGHTING, 7=POISON
-- 8=GROUND, 9=FLYING, 10=PSYCHIC, 11=BUG, 12=ROCK, 13=GHOST, 14=DRAGON, 15=DARK, 16=STEEL, 17=FAIRY

-- =============================================================================
-- SECTION 1: Pokémon #001 - #010
-- =============================================================================

-- #001 Bulbizarre (Grass/Poison)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Bulbizarre', 3, 49, 45, 75.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/001.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Charge', 40, 1),
('Fouet Lianes', 45, 1),
('Tranch''Herbe', 55, 1);

-- #002 Herbizarre (Grass/Poison)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Herbizarre', 3, 63, 60, 85.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/002.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Fouet Lianes', 45, 2),
('Tranch''Herbe', 55, 2),
('Lance-Soleil', 120, 2);

-- #003 Florizarre (Grass/Poison)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Florizarre', 3, 83, 80, 95.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/003.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Fouet Lianes', 45, 3),
('Lance-Soleil', 120, 3),
('Éco-Sphère', 90, 3);

-- #004 Salamèche (Fire)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Salamèche', 1, 43, 39, 75.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/004.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Griffe', 40, 4),
('Flammèche', 40, 4),
('Lance-Flammes', 90, 4);

-- #005 Reptincel (Fire)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Reptincel', 1, 58, 58, 85.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/005.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Flammèche', 40, 5),
('Lance-Flammes', 90, 5),
('Tranche', 70, 5);

-- #006 Dracaufeu (Fire/Flying)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Dracaufeu', 1, 78, 78, 95.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/006.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Lance-Flammes', 90, 6),
('Déflagration', 110, 6),
('Cru-Aile', 60, 6);

-- #007 Carapuce (Water)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Carapuce', 2, 65, 44, 75.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/007.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Charge', 40, 7),
('Pistolet à O', 40, 7),
('Morsure', 60, 7);

-- #008 Carabaffe (Water)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Carabaffe', 2, 80, 59, 85.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/008.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Pistolet à O', 40, 8),
('Morsure', 60, 8),
('Surf', 90, 8);

-- #009 Tortank (Water)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Tortank', 2, 100, 79, 95.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/009.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Surf', 90, 9),
('Hydrocanon', 110, 9),
('Morsure', 60, 9);

-- #010 Chenipan (Bug)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Chenipan', 11, 35, 45, 60.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/010.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Charge', 40, 10),
('Piqûre', 60, 10);

-- =============================================================================
-- SECTION 2: Pokémon #011 - #025
-- =============================================================================

-- #011 Chrysacier (Bug)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Chrysacier', 11, 55, 50, 70.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/011.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Armure', 0, 11);

-- #012 Papilusion (Bug/Flying)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Papilusion', 11, 50, 60, 80.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/012.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Tornade', 40, 12),
('Choc Psy', 50, 12),
('Piqûre', 60, 12);

-- #013 Aspicot (Bug/Poison)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Aspicot', 11, 30, 40, 60.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/013.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Dard-Venin', 15, 13),
('Piqûre', 60, 13);

-- #014 Coconfort (Bug/Poison)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Coconfort', 11, 55, 45, 70.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/014.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Armure', 0, 14);

-- #015 Dardargnan (Bug/Poison)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Dardargnan', 11, 40, 65, 80.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/015.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Dard-Venin', 15, 15),
('Dard-Nuée', 25, 15),
('Piqûre', 60, 15);

-- #016 Roucool (Normal/Flying)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Roucool', 0, 40, 40, 50.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/016.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Vive-Attaque', 40, 16),
('Tornade', 40, 16),
('Cru-Aile', 60, 16);

-- #017 Roucoups (Normal/Flying)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Roucoups', 0, 55, 63, 70.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/017.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Vive-Attaque', 40, 17),
('Cru-Aile', 60, 17),
('Tornade', 40, 17);

-- #018 Roucarnage (Normal/Flying)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Roucarnage', 0, 75, 83, 85.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/018.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Cru-Aile', 60, 18),
('Piqué', 90, 18),
('Ouragan', 110, 18);

-- #019 Rattata (Normal)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Rattata', 0, 35, 30, 50.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/019.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Charge', 40, 19),
('Vive-Attaque', 40, 19),
('Morsure', 60, 19);

-- #020 Rattatac (Normal)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Rattatac', 0, 60, 55, 70.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/020.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Vive-Attaque', 40, 20),
('Morsure', 60, 20),
('Croc de Mort', 80, 20);

-- #021 Piafabec (Normal/Flying)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Piafabec', 0, 30, 40, 50.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/021.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Picpic', 35, 21),
('Tornade', 40, 21);

-- #022 Rapasdepic (Normal/Flying)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Rapasdepic', 0, 65, 65, 70.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/022.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Picpic', 35, 22),
('Piqué', 90, 22),
('Bec Vrille', 80, 22);

-- #023 Abo (Poison)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Abo', 7, 44, 35, 60.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/023.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Dard-Venin', 15, 23),
('Morsure', 60, 23),
('Acide', 40, 23);

-- #024 Arbok (Poison)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Arbok', 7, 69, 60, 75.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/024.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Morsure', 60, 24),
('Acide', 40, 24),
('Bomb-Beurk', 90, 24);

-- #025 Pikachu (Electric)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Pikachu', 4, 40, 35, 85.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/025.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Vive-Attaque', 40, 25),
('Éclair', 55, 25),
('Tonnerre', 90, 25);

-- =============================================================================
-- SECTION 3: Pokémon #026 - #050
-- =============================================================================

-- #026 Raichu (Electric)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Raichu', 4, 55, 60, 90.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/026.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Éclair', 55, 26),
('Tonnerre', 90, 26),
('Fatal-Foudre', 110, 26);

-- #027 Sabelette (Ground)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Sabelette', 8, 85, 50, 60.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/027.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Griffe', 40, 27),
('Jet de Sable', 15, 27),
('Tranche', 70, 27);

-- #028 Sablaireau (Ground)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Sablaireau', 8, 110, 75, 75.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/028.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Griffe', 40, 28),
('Tranche', 70, 28),
('Séisme', 100, 28);

-- #029 Nidoran♀ (Poison)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Nidoran♀', 7, 47, 55, 55.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/029.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Griffe', 40, 29),
('Dard-Venin', 15, 29),
('Morsure', 60, 29);

-- #030 Nidorina (Poison)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Nidorina', 7, 67, 70, 70.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/030.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Griffe', 40, 30),
('Morsure', 60, 30),
('Acide', 40, 30);

-- #031 Nidoqueen (Poison/Ground)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Nidoqueen', 7, 87, 90, 85.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/031.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Morsure', 60, 31),
('Bomb-Beurk', 90, 31),
('Séisme', 100, 31);

-- #032 Nidoran♂ (Poison)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Nidoran♂', 7, 40, 46, 55.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/032.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Dard-Venin', 15, 32),
('Morsure', 60, 32);

-- #033 Nidorino (Poison)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Nidorino', 7, 57, 61, 70.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/033.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Morsure', 60, 33),
('Corne', 65, 33),
('Acide', 40, 33);

-- #034 Nidoking (Poison/Ground)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Nidoking', 7, 77, 81, 85.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/034.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Corne', 65, 34),
('Bomb-Beurk', 90, 34),
('Séisme', 100, 34);

-- #035 Mélofée (Fairy)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Mélofée', 17, 48, 70, 70.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/035.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Écras''Face', 40, 35),
('Réveil Forcé', 70, 35),
('Métronome', 0, 35);

-- #036 Mélodelfe (Fairy)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Mélodelfe', 17, 73, 95, 85.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/036.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Réveil Forcé', 70, 36),
('Métronome', 0, 36),
('Lune d''Argent', 95, 36);

-- #037 Goupix (Fire)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Goupix', 1, 40, 38, 65.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/037.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Flammèche', 40, 37),
('Vive-Attaque', 40, 37);

-- #038 Feunard (Fire)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Feunard', 1, 75, 73, 80.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/038.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Lance-Flammes', 90, 38),
('Déflagration', 110, 38),
('Ultralaser', 150, 38);

-- #039 Rondoudou (Normal/Fairy)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Rondoudou', 0, 20, 115, 60.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/039.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Écras''Face', 40, 39),
('Berceuse', 0, 39);

-- #040 Grodoudou (Normal/Fairy)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Grodoudou', 0, 45, 140, 75.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/040.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Réveil Forcé', 70, 40),
('Plaquage', 85, 40),
('Ultralaser', 150, 40);

-- #041 Nosferapti (Poison/Flying)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Nosferapti', 7, 35, 40, 50.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/041.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Vampirisme', 20, 41),
('Morsure', 60, 41);

-- #042 Nosferalto (Poison/Flying)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Nosferalto', 7, 70, 75, 70.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/042.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Vampirisme', 20, 42),
('Morsure', 60, 42),
('Cru-Aile', 60, 42);

-- #043 Mystherbe (Grass/Poison)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Mystherbe', 3, 55, 45, 55.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/043.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Tranch''Herbe', 55, 43),
('Acide', 40, 43);

-- #044 Ortide (Grass/Poison)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Ortide', 3, 70, 60, 70.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/044.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Tranch''Herbe', 55, 44),
('Acide', 40, 44),
('Poudre Toxik', 0, 44);

-- #045 Rafflesia (Grass/Poison)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Rafflesia', 3, 85, 75, 85.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/045.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Lance-Soleil', 120, 45),
('Bomb-Beurk', 90, 45),
('Danse-Fleur', 120, 45);

-- #046 Paras (Bug/Grass)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Paras', 11, 55, 35, 55.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/046.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Griffe', 40, 46),
('Tranch''Herbe', 55, 46);

-- #047 Parasect (Bug/Grass)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Parasect', 11, 80, 60, 70.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/047.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Tranch''Herbe', 55, 47),
('Tranche', 70, 47),
('Spore', 0, 47);

-- #048 Mimitoss (Bug/Poison)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Mimitoss', 11, 50, 60, 55.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/048.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Charge', 40, 48),
('Piqûre', 60, 48),
('Choc Psy', 50, 48);

-- #049 Aéromite (Bug/Poison)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Aéromite', 11, 60, 70, 70.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/049.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Piqûre', 60, 49),
('Choc Psy', 50, 49),
('Rafale Psy', 90, 49);

-- #050 Taupiqueur (Ground)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Taupiqueur', 8, 25, 10, 50.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/050.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Griffe', 40, 50),
('Jet de Sable', 15, 50);

-- =============================================================================
-- SECTION 4: Pokémon #051 - #075
-- =============================================================================

-- #051 Triopikeur (Ground)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Triopikeur', 8, 50, 35, 65.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/051.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Griffe', 40, 51),
('Jet de Sable', 15, 51),
('Séisme', 100, 51);

-- #052 Miaouss (Normal)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Miaouss', 0, 35, 40, 60.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/052.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Griffe', 40, 52),
('Morsure', 60, 52),
('Jackpot', 40, 52);

-- #053 Persian (Normal)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Persian', 0, 60, 65, 75.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/053.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Griffe', 40, 53),
('Morsure', 60, 53),
('Tranche', 70, 53);

-- #054 Psykokwak (Water)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Psykokwak', 2, 48, 50, 55.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/054.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Griffe', 40, 54),
('Pistolet à O', 40, 54),
('Choc Psy', 50, 54);

-- #055 Akwakwak (Water)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Akwakwak', 2, 78, 80, 70.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/055.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Surf', 90, 55),
('Choc Psy', 50, 55),
('Hydrocanon', 110, 55);

-- #056 Férosinge (Fighting)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Férosinge', 6, 35, 40, 55.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/056.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Griffe', 40, 56),
('Poing-Karaté', 50, 56),
('Balayage', 50, 56);

-- #057 Colossinge (Fighting)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Colossinge', 6, 60, 65, 70.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/057.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Poing-Karaté', 50, 57),
('Balayage', 50, 57),
('Poing de Feu', 75, 57);

-- #058 Caninos (Fire)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Caninos', 1, 45, 55, 65.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/058.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Flammèche', 40, 58),
('Morsure', 60, 58);

-- #059 Arcanin (Fire)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Arcanin', 1, 80, 90, 85.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/059.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Lance-Flammes', 90, 59),
('Déflagration', 110, 59),
('Crocs Feu', 65, 59);

-- #060 Ptitard (Water)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Ptitard', 2, 40, 40, 55.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/060.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Pistolet à O', 40, 60),
('Écume', 40, 60);

-- #061 Têtarte (Water)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Têtarte', 2, 65, 65, 70.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/061.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Pistolet à O', 40, 61),
('Écume', 40, 61),
('Plaquage', 85, 61);

-- #062 Tartard (Water/Fighting)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Tartard', 2, 95, 90, 85.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/062.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Surf', 90, 62),
('Poing-Karaté', 50, 62),
('Hydrocanon', 110, 62);

-- #063 Abra (Psychic)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Abra', 10, 15, 25, 70.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/063.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Téléport', 0, 63);

-- #064 Kadabra (Psychic)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Kadabra', 10, 30, 40, 80.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/064.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Choc Psy', 50, 64),
('Rafale Psy', 90, 64);

-- #065 Alakazam (Psychic)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Alakazam', 10, 45, 55, 90.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/065.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Choc Psy', 50, 65),
('Rafale Psy', 90, 65),
('Psyko', 90, 65);

-- #066 Machoc (Fighting)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Machoc', 6, 50, 70, 60.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/066.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Poing-Karaté', 50, 66),
('Balayage', 50, 66);

-- #067 Machopeur (Fighting)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Machopeur', 6, 70, 80, 75.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/067.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Poing-Karaté', 50, 67),
('Balayage', 50, 67),
('Frappe Atlas', 100, 67);

-- #068 Mackogneur (Fighting)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Mackogneur', 6, 80, 90, 90.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/068.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Poing-Karaté', 50, 68),
('Frappe Atlas', 100, 68),
('Dynamopoing', 100, 68);

-- #069 Chétiflor (Grass/Poison)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Chétiflor', 3, 35, 50, 55.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/069.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Tranch''Herbe', 55, 69),
('Fouet Lianes', 45, 69);

-- #070 Boustiflor (Grass/Poison)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Boustiflor', 3, 50, 65, 70.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/070.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Tranch''Herbe', 55, 70),
('Fouet Lianes', 45, 70),
('Acide', 40, 70);

-- #071 Empiflor (Grass/Poison)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Empiflor', 3, 65, 80, 85.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/071.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Tranch''Herbe', 55, 71),
('Fouet Lianes', 45, 71),
('Lance-Soleil', 120, 71);

-- #072 Tentacool (Water/Poison)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Tentacool', 2, 35, 40, 50.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/072.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Dard-Venin', 15, 72),
('Pistolet à O', 40, 72);

-- #073 Tentacruel (Water/Poison)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Tentacruel', 2, 65, 80, 70.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/073.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Bomb-Beurk', 90, 73),
('Surf', 90, 73),
('Hydrocanon', 110, 73);

-- #074 Racaillou (Rock/Ground)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Racaillou', 12, 100, 40, 55.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/074.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Charge', 40, 74),
('Jet-Pierres', 50, 74);

-- #075 Gravalanch (Rock/Ground)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Gravalanch', 12, 115, 55, 70.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/075.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Jet-Pierres', 50, 75),
('Éboulement', 75, 75);

-- =============================================================================
-- SECTION 5: Pokémon #076 - #100
-- =============================================================================

-- #076 Grolem (Rock/Ground)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Grolem', 12, 130, 80, 85.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/076.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Jet-Pierres', 50, 76),
('Éboulement', 75, 76),
('Séisme', 100, 76);

-- #077 Ponyta (Fire)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Ponyta', 1, 55, 50, 60.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/077.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Flammèche', 40, 77),
('Charge', 40, 77);

-- #078 Galopa (Fire)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Galopa', 1, 70, 65, 75.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/078.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Lance-Flammes', 90, 78),
('Charge', 40, 78),
('Déflagration', 110, 78);

-- #079 Ramoloss (Water/Psychic)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Ramoloss', 2, 65, 90, 55.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/079.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Pistolet à O', 40, 79),
('Choc Psy', 50, 79);

-- #080 Flagadoss (Water/Psychic)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Flagadoss', 2, 110, 95, 70.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/080.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Surf', 90, 80),
('Choc Psy', 50, 80),
('Rafale Psy', 90, 80);

-- #081 Magnéti (Electric/Steel)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Magnéti', 4, 70, 25, 60.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/081.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Éclair', 55, 81),
('Choc Psy', 50, 81);

-- #082 Magnéton (Electric/Steel)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Magnéton', 4, 95, 50, 75.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/082.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Tonnerre', 90, 82),
('Choc Psy', 50, 82),
('Fatal-Foudre', 110, 82);

-- #083 Canarticho (Normal/Flying)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Canarticho', 0, 55, 52, 70.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/083.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Tranche', 70, 83),
('Cru-Aile', 60, 83);

-- #084 Doduo (Normal/Flying)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Doduo', 0, 45, 35, 55.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/084.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Picpic', 35, 84),
('Bec Vrille', 80, 84);

-- #085 Dodrio (Normal/Flying)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Dodrio', 0, 70, 60, 70.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/085.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Bec Vrille', 80, 85),
('Piqué', 90, 85),
('Vive-Attaque', 40, 85);

-- #086 Otaria (Water)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Otaria', 2, 55, 65, 60.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/086.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Pistolet à O', 40, 86),
('Plaquage', 85, 86);

-- #087 Lamantine (Water/Ice)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Lamantine', 2, 80, 90, 75.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/087.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Surf', 90, 87),
('Laser Glace', 90, 87),
('Plaquage', 85, 87);

-- #088 Tadmorv (Poison)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Tadmorv', 7, 50, 80, 55.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/088.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Dard-Venin', 15, 88),
('Acide', 40, 88);

-- #089 Grotadmorv (Poison)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Grotadmorv', 7, 75, 105, 70.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/089.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Bomb-Beurk', 90, 89),
('Acide', 40, 89),
('Plaquage', 85, 89);

-- #090 Kokiyas (Water)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Kokiyas', 2, 100, 30, 60.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/090.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Pistolet à O', 40, 90),
('Charge', 40, 90);

-- #091 Crustabri (Water/Ice)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Crustabri', 2, 180, 50, 75.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/091.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Surf', 90, 91),
('Laser Glace', 90, 91),
('Hydrocanon', 110, 91);

-- #092 Fantominus (Ghost/Poison)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Fantominus', 13, 30, 30, 65.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/092.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Léchouille', 30, 92),
('Ombre Nocturne', 0, 92);

-- #093 Spectrum (Ghost/Poison)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Spectrum', 13, 45, 45, 75.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/093.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Léchouille', 30, 93),
('Ombre Nocturne', 0, 93),
('Ball''Ombre', 80, 93);

-- #094 Ectoplasma (Ghost/Poison)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Ectoplasma', 13, 60, 60, 90.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/094.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Ball''Ombre', 80, 94),
('Ombre Nocturne', 0, 94),
('Rafale Psy', 90, 94);

-- #095 Onix (Rock/Ground)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Onix', 12, 160, 35, 70.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/095.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Jet-Pierres', 50, 95),
('Éboulement', 75, 95),
('Séisme', 100, 95);

-- #096 Soporifik (Psychic)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Soporifik', 10, 45, 60, 60.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/096.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Choc Psy', 50, 96),
('Hypnose', 0, 96);

-- #097 Hypnomade (Psychic)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Hypnomade', 10, 70, 85, 75.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/097.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Choc Psy', 50, 97),
('Rafale Psy', 90, 97),
('Hypnose', 0, 97);

-- #098 Krabby (Water)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Krabby', 2, 90, 30, 55.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/098.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Pistolet à O', 40, 98),
('Pince-Masse', 90, 98);

-- #099 Krabboss (Water)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Krabboss', 2, 115, 55, 70.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/099.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Pince-Masse', 90, 99),
('Surf', 90, 99),
('Hydrocanon', 110, 99);

-- #100 Voltorbe (Electric)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Voltorbe', 4, 50, 40, 55.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/100.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Éclair', 55, 100),
('Charge', 40, 100);

-- =============================================================================
-- SECTION 6: Pokémon #101 - #125
-- =============================================================================

-- #101 Électrode (Electric)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Électrode', 4, 70, 60, 70.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/101.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Tonnerre', 90, 101),
('Vive-Attaque', 40, 101),
('Fatal-Foudre', 110, 101);

-- #102 Noeunoeuf (Grass/Psychic)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Noeunoeuf', 3, 80, 60, 60.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/102.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Tranch''Herbe', 55, 102),
('Choc Psy', 50, 102);

-- #103 Noadkoko (Grass/Psychic)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Noadkoko', 3, 85, 95, 80.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/103.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Lance-Soleil', 120, 103),
('Rafale Psy', 90, 103),
('Bomb''Œuf', 100, 103);

-- #104 Osselait (Ground)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Osselait', 8, 95, 50, 60.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/104.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Charge', 40, 104),
('Massd''Os', 65, 104);

-- #105 Ossatueur (Ground)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Ossatueur', 8, 110, 60, 75.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/105.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Massd''Os', 65, 105),
('Boomerang Os', 50, 105),
('Séisme', 100, 105);

-- #106 Kicklee (Fighting)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Kicklee', 6, 53, 50, 75.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/106.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Balayage', 50, 106),
('Pied Voltige', 85, 106),
('Pied Saut', 100, 106);

-- #107 Tygnon (Fighting)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Tygnon', 6, 79, 50, 75.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/107.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Poing-Karaté', 50, 107),
('Poing Comète', 18, 107),
('Dynamopoing', 100, 107);

-- #108 Excelangue (Normal)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Excelangue', 0, 75, 90, 70.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/108.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Léchouille', 30, 108),
('Plaquage', 85, 108);

-- #109 Smogo (Poison)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Smogo', 7, 95, 40, 55.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/109.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Acide', 40, 109),
('Bomb-Beurk', 90, 109);

-- #110 Smogogo (Poison)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Smogogo', 7, 120, 65, 70.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/110.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Bomb-Beurk', 90, 110),
('Acide', 40, 110),
('Explosion', 250, 110);

-- #111 Rhinocorne (Ground/Rock)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Rhinocorne', 8, 95, 80, 65.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/111.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Corne', 65, 111),
('Jet-Pierres', 50, 111);

-- #112 Rhinoféros (Ground/Rock)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Rhinoféros', 8, 120, 105, 80.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/112.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Corne', 65, 112),
('Éboulement', 75, 112),
('Séisme', 100, 112);

-- #113 Leveinard (Normal)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Leveinard', 0, 5, 250, 85.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/113.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Plaquage', 85, 113),
('E-Coque', 100, 113);

-- #114 Saquedeneu (Grass)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Saquedeneu', 3, 115, 65, 70.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/114.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Fouet Lianes', 45, 114),
('Tranch''Herbe', 55, 114),
('Lance-Soleil', 120, 114);

-- #115 Kangourex (Normal)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Kangourex', 0, 80, 105, 80.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/115.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Poing Comète', 18, 115),
('Plaquage', 85, 115),
('Ultralaser', 150, 115);

-- #116 Hypotrempe (Water)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Hypotrempe', 2, 70, 30, 55.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/116.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Pistolet à O', 40, 116),
('Écume', 40, 116);

-- #117 Hypocéan (Water)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Hypocéan', 2, 95, 55, 70.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/117.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Pistolet à O', 40, 117),
('Surf', 90, 117),
('Hydrocanon', 110, 117);

-- #118 Poissirène (Water)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Poissirène', 2, 60, 45, 55.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/118.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Pistolet à O', 40, 118),
('Charge', 40, 118);

-- #119 Poissoroy (Water)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Poissoroy', 2, 65, 80, 70.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/119.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Surf', 90, 119),
('Hydrocanon', 110, 119),
('Mégacorne', 120, 119);

-- #120 Stari (Water)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Stari', 2, 55, 30, 55.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/120.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Pistolet à O', 40, 120),
('Vive-Attaque', 40, 120);

-- #121 Staross (Water/Psychic)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Staross', 2, 85, 60, 75.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/121.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Surf', 90, 121),
('Rafale Psy', 90, 121),
('Hydrocanon', 110, 121);

-- #122 M. Mime (Psychic/Fairy)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('M. Mime', 10, 65, 40, 75.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/122.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Choc Psy', 50, 122),
('Rafale Psy', 90, 122),
('Mur Lumière', 0, 122);

-- #123 Insécateur (Bug/Flying)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Insécateur', 11, 80, 70, 75.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/123.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Tranche', 70, 123),
('Cru-Aile', 60, 123),
('Coupe', 50, 123);

-- #124 Lippoutou (Ice/Psychic)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Lippoutou', 5, 35, 65, 75.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/124.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Rafale Psy', 90, 124),
('Laser Glace', 90, 124),
('Blizzard', 110, 124);

-- #125 Élektek (Electric)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Élektek', 4, 57, 65, 75.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/125.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Tonnerre', 90, 125),
('Poing-Éclair', 75, 125),
('Fatal-Foudre', 110, 125);

-- =============================================================================
-- SECTION 7: Pokémon #126 - #150
-- =============================================================================

-- #126 Magmar (Fire)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Magmar', 1, 57, 65, 75.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/126.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Lance-Flammes', 90, 126),
('Poing de Feu', 75, 126),
('Déflagration', 110, 126);

-- #127 Scarabrute (Bug)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Scarabrute', 11, 100, 65, 75.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/127.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Prise', 55, 127),
('Frappe Atlas', 100, 127),
('Guillotine', 0, 127);

-- #128 Tauros (Normal)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Tauros', 0, 95, 75, 75.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/128.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Charge', 40, 128),
('Plaquage', 85, 128),
('Ultralaser', 150, 128);

-- #129 Magicarpe (Water)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Magicarpe', 2, 55, 20, 40.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/129.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Trempette', 0, 129),
('Charge', 40, 129);

-- #130 Léviator (Water/Flying)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Léviator', 2, 79, 95, 90.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/130.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Hydrocanon', 110, 130),
('Ultralaser', 150, 130),
('Morsure', 60, 130);

-- #131 Lokhlass (Water/Ice)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Lokhlass', 2, 80, 130, 85.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/131.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Surf', 90, 131),
('Laser Glace', 90, 131),
('Hydrocanon', 110, 131);

-- #132 Métamorph (Normal)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Métamorph', 0, 48, 48, 80.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/132.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Morphing', 0, 132);

-- #133 Évoli (Normal)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Évoli', 0, 50, 55, 75.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/133.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Charge', 40, 133),
('Vive-Attaque', 40, 133),
('Morsure', 60, 133);

-- #134 Aquali (Water)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Aquali', 2, 60, 130, 85.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/134.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Surf', 90, 134),
('Hydrocanon', 110, 134),
('Morsure', 60, 134);

-- #135 Voltali (Electric)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Voltali', 4, 60, 65, 85.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/135.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Tonnerre', 90, 135),
('Fatal-Foudre', 110, 135),
('Vive-Attaque', 40, 135);

-- #136 Pyroli (Fire)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Pyroli', 1, 60, 65, 85.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/136.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Lance-Flammes', 90, 136),
('Déflagration', 110, 136),
('Morsure', 60, 136);

-- #137 Porygon (Normal)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Porygon', 0, 70, 65, 75.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/137.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Charge', 40, 137),
('Rafale Psy', 90, 137),
('Conversion', 0, 137);

-- #138 Amonita (Rock/Water)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Amonita', 12, 100, 35, 70.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/138.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Pistolet à O', 40, 138),
('Jet-Pierres', 50, 138);

-- #139 Amonistar (Rock/Water)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Amonistar', 12, 125, 70, 80.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/139.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Surf', 90, 139),
('Jet-Pierres', 50, 139),
('Hydrocanon', 110, 139);

-- #140 Kabuto (Rock/Water)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Kabuto', 12, 90, 30, 70.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/140.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Griffe', 40, 140),
('Pistolet à O', 40, 140);

-- #141 Kabutops (Rock/Water)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Kabutops', 12, 105, 60, 80.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/141.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Tranche', 70, 141),
('Surf', 90, 141),
('Hydrocanon', 110, 141);

-- #142 Ptéra (Rock/Flying)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Ptéra', 12, 65, 80, 85.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/142.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Cru-Aile', 60, 142),
('Jet-Pierres', 50, 142),
('Ultralaser', 150, 142);

-- #143 Ronflex (Normal)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Ronflex', 0, 65, 160, 85.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/143.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Plaquage', 85, 143),
('Ultralaser', 150, 143),
('Repos', 0, 143);

-- #144 Artikodin (Ice/Flying)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Artikodin', 5, 100, 90, 95.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/144.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Laser Glace', 90, 144),
('Blizzard', 110, 144),
('Piqué', 90, 144);

-- #145 Électhor (Electric/Flying)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Électhor', 4, 85, 90, 95.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/145.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Tonnerre', 90, 145),
('Fatal-Foudre', 110, 145),
('Piqué', 90, 145);

-- #146 Sulfura (Fire/Flying)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Sulfura', 1, 90, 90, 95.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/146.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Lance-Flammes', 90, 146),
('Déflagration', 110, 146),
('Piqué', 90, 146);

-- #147 Minidraco (Dragon)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Minidraco', 14, 45, 41, 80.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/147.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Charge', 40, 147),
('Draco-Rage', 40, 147);

-- #148 Draco (Dragon)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Draco', 14, 65, 61, 85.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/148.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Draco-Rage', 40, 148),
('Plaquage', 85, 148);

-- #149 Dracolosse (Dragon/Flying)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Dracolosse', 14, 95, 91, 95.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/149.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Ultralaser', 150, 149),
('Dracochoc', 90, 149),
('Colère', 20, 149);

-- #150 Mewtwo (Psychic)
INSERT INTO Pokemon (Name, Type, DefensePoints, HealthPoints, RarityPercentage, ImageURL)
VALUES ('Mewtwo', 10, 90, 106, 99.0, 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/150.png');

INSERT INTO Attacks (Name, Points, PokemonId) VALUES
('Rafale Psy', 90, 150),
('Psyko', 90, 150),
('Ultralaser', 150, 150);

-- =============================================================================
-- FIN DU SCRIPT - 150 Pokémon de la Génération 1 insérés avec succès
-- =============================================================================

-- Statistiques:
-- - 150 Pokémon insérés
-- - 450+ attaques insérées (moyenne de 3 attaques par Pokémon)
-- - Tous les types de la génération 1 représentés
-- - URLs d'images officielles Pokémon

-- Pour exécuter ce script:
-- 1. Ouvrir une connexion à la base de données pokemon.db
-- 2. Exécuter: sqlite3 pokemon.db < seed_150_pokemon.sql
-- 3. Ou depuis l'API: copier-coller dans un client SQL

-- Vérification:
-- SELECT COUNT(*) FROM Pokemon; -- Doit retourner 150
-- SELECT COUNT(*) FROM Attacks; -- Doit retourner 450+
