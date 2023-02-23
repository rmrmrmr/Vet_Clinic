/* Populate database with sample data. */

INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight) VALUES ('Agumon', '2020-02-03', 0, true, 10.23);
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight) VALUES ('Gabumon', '2018-11-15', 2, true, 8.0);
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight) VALUES ('Pikachu', '2021-01-07', 1, false, 15.04);
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight) VALUES ('Devimon', '2017-05-12', 5, true, 11.0);
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight) VALUES ('Charmander', '2020-02-08', 0, false, -11.0);
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight) VALUES ('Plantmon', '2021-11-15', 2, true, -5.7);
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight) VALUES ('Squirtle', '1993-04-02', 3, false, -12.13);
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight) VALUES ('Angemon', '2005-06-12', 0, true, -45.0);
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight) VALUES ('Boarmon', '2005-06-07', 7, true, 20.4);
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight) VALUES ('Ditto', '2022-05-14', 4, true, 22.0);

INSERT INTO owners (full_name, age) VALUES ('Sam Smith', 34);
INSERT INTO owners (full_name, age) VALUES ('Jennifer Orwell', 19);
INSERT INTO owners (full_name, age) VALUES ('Bob', 45);
INSERT INTO owners (full_name, age) VALUES ('Melody Pond', 77);
INSERT INTO owners (full_name, age) VALUES ('Dean Winchester', 14);
INSERT INTO owners (full_name, age) VALUES ('Jodie Whittaker', 38);

INSERT INTO species (name) VALUES ('Pokemon');
INSERT INTO species (name) VALUES ('Digimon');

UPDATE animals
  SET	species_id = 
  CASE
    WHEN name like '%mon' THEN (SELECT id FROM species WHERE name = 'Digimon')
    else (SELECT id FROM species WHERE name = 'Pokemon')
  END;

UPDATE animals
  SET owner_id =
  CASE
    WHEN name = 'Agumon' THEN (SELECT id FROM owners WHERE full_name = 'Sam Smith')
    WHEN name = 'Pikachu' OR name = 'Gabumon' THEN (SELECT id FROM owners WHERE full_name = 'Jennifer Orwell')
    WHEN name = 'Devimon' OR name = 'Plantmon' THEN (SELECT id FROM owners WHERE full_name = 'Bob')
    WHEN name = 'Charmander' OR name = 'Squirtle' OR name = 'Blossom' THEN (SELECT id FROM owners WHERE full_name = 'Melody Pond')
    WHEN name = 'Angemon' OR name = 'Boarmon'THEN (SELECT id FROM owners WHERE full_name = 'Dean Winchester')
  END;