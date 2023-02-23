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

/* What animals belong to Melody Pond? */
SELECT a.name, b.full_name
  FROM animals a
  JOIN owners b
	  ON a.owner_id = b.id
  WHERE b.full_name = 'Melody Pond';

/* List of all animals that are Pokemon */
SELECT a.name, b.name
	FROM animals a
	JOIN species b
		ON a.species_id = b.id
	WHERE b.name = 'Pokemon';

/* List of all owners and their animals */
SELECT a.name, b.full_name
  FROM animals a
  JOIN species b
    ON a.owner_id = b.id

/* How many animals are there from species */
SELECT b.name, COUNT (a.species_id)
	FROM animals a
	JOIN species b
		ON a.species_id = b.id
	GROUP BY b.name;

/* List of all Digimon owned by Jennifer Orwell */
SELECT a.name, o.full_name, s.name
  FROM animals a
  JOIN owners o
    ON a.owner_id = o.id
  JOIN species s
    ON a.species_id = s.id
  WHERE o.full_name = 'Jennifer Orwell'
  AND s.name = 'Digimon';

/* List of all animals owned by Dean Winchester and have never tried to escape */
SELECT a.name, o.full_name, a.escape_attempts
  FROM animals a
  JOIN owners o
    ON a.owner_id = o.id
  WHERE o.full_name = 'Dean Winchester'
  AND a.escape_attempts = 0;

/* Who owns the most animals? */
SELECT o.full_name, COUNT(o.full_name) namecount
  FROM animals a
  JOIN owners o
    ON a.owner_id = o.id
  GROUP BY o.full_name
  ORDER BY namecount desc
  LIMIT 1;