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
SELECT a.name, o.full_name
  FROM animals a
  RIGHT JOIN owners o
    ON a.owner_id = o.id

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

/* Who was the last animal seen by William Tatcher */
SELECT a.name, vis.date_of_visit dates, vet.name  
  FROM visits vis
  JOIN animals a
    ON vis.animals_id = a.id
  JOIN vets vet
    ON vis.vets_id = vet.id
  WHERE vet.name = 'William Tatcher'
  GROUP BY o.full_name
  ORDER BY dates desc
  LIMIT 1;

/* How many different animals did Stephanie Mendez see? */
SELECT vet.name veterinary, COUNT(vis.animals_id) animals_seen
  FROM visits vis
  JOIN vets vet
    ON vis.vets_id = vet.id
  WHERE vet.name = 'Stephanie Mendez'
  GROUP BY vet.name;

/* List of all vets and their specialties (including vets with no specialties) */
SELECT v.name, sp.name
FROM specializations specs
RIGHT JOIN vets v
  ON specs.vets_id = v.id
LEFT JOIN species sp
  ON specs.species_id = sp.id;

/* List of all animals that visited Stephanie Mendez between April 1st and August 30th, 2020 */
SELECT a.name, vis.date_of_visit
FROM visits vis
JOIN vets vet
  ON vis.vets_id = vet.id
JOIN animals a
  ON vis.animals_id = a.id
WHERE vet.name = 'Stephanie Mendez'
AND vis.date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';

/* What animal has the most visits to vets */
SELECT a.name, COUNT(a.name) times_visited
FROM visits vis
JOIN animals a
  ON vis.animals_id = a.id
GROUP BY a.name
ORDER BY times_visited desc
LIMIT 1;

/* Who was Maisy Smith's first visit? */
SELECT a.name, vis.date_of_visit vi
FROM visits vis
JOIN vets vet
  ON vis.vets_id = vet.id
JOIN animals a
  ON vis.animals_id = a.id
WHERE vet.name = 'Maisy Smith'
ORDER BY vi asc
LIMIT 1;

/* Details for most recent visit: animal info, vet info, date of visit */
SELECT vis.date_of_visit most_recent_visit, a.name animal_name, vet.name vet_name, a.date_of_birth animal_birthday, a.escape_attempts animal_escape_attempts, a.neutered animal_neutered, a.weight animal_weight, vet.age vet_age, vet.date_of_graduation vet_date_of_grad 
FROM visits vis
JOIN animals a
  ON vis.animals_id = a.id
JOIN vets vet
  ON vis.vets_id = vet.id
ORDER BY most_recent_visit desc
LIMIT 1;

/* How many visits were with a vet that did not specialize in that animal's species? */
SELECT COUNT(vis.animals_id)
FROM visits vis
JOIN animals a
  ON vis.animals_id = a.id
JOIN vets v
  ON  vis.vets_id = v.id
JOIN specializations specs
  ON v.id = specs.vets_id
WHERE a.species_id != specs.species_id

/* What specialty should Maisy Smith consider getting? Look for the species she gets the most */
SELECT species.name, COUNT(animals.species_id)
FROM visits
JOIN animals
  ON visits.animals_id = animals.id
JOIN vets
  ON visits.vets_id = vets.id
JOIN species
  ON species.id = animals.species_id
WHERE vets.name = 'Maisy Smith'
GROUP BY species.name
ORDER BY COUNT(animals.species_id) desc
LIMIT 1;