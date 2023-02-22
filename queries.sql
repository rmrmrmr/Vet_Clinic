/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name like '%mon';

SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';

SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;

SELECT date_of_birth FROM animals WHERE name = 'Agumon' OR name = 'Pikachu';

SELECT name, escape_attempts FROM animals WHERE neutered = true AND weight > 10.4;

SELECT name FROM animals WHERE neutered = true;

SELECT name FROM animals WHERE name != 'Gabumon';

SELECT name FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

BEGIN;
  UPDATE animals SET species = 'unspecified';
  SELECT species FROM animals;
  ROLLBACK;
  SELECT species FROM animals;
COMMIT;

BEGIN;
  UPDATE animals
  SET species = 'Digimon'
  WHERE name like '%mon';
  UPDATE animals
  SET species = 'Pokemon'
  WHERE species ISNULL;
COMMIT;
SELECT name, species FROM animals;

BEGIN;
  DELETE FROM animals;
  ROLLBACK;
COMMIT;
SELECT * FROM animals;

BEGIN;
  DELETE FROM animals 
  WHERE date_of_birth >= '2022-01-01';
  SAVEPOINT no_twentytwentytwo;
  UPDATE animals
  SET weight = weight * -1;
  ROLLBACK TO SAVEPOINT no_twentytwentytwo;
  UPDATE animals
  SET weight = weight * -1
  WHERE weight < 0;
COMMIT;
SELECT * FROM animals;

/* How many animals are there? */
SELECT COUNT(*) FROM animals;

/* How many animals have never tried to escape? */
SELECT COUNT(escape_attempts) FROM animals WHERE escape_attempts = 0;

/* What is the average weight of animals? */
SELECT AVG(weight) FROM animals;

/* Who escapes the most, neutered or not neutered animals? */
SELECT neutered, MAX(escape_attempts) FROM animals GROUP BY neutered;

/* What is the minimum and maximum weight of each type of animal? */
SELECT species, MIN(weight), MAX(weight) FROM animals GROUP BY (species);

/* What is the average number of escape attempts per animal type of those born between 1990 and 2000? */
SELECT species, AVG(escape_attempts) FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY species;
