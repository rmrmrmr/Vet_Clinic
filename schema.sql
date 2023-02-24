/* Database schema to keep the structure of entire database. */

CREATE DATABASE vet_clinic;

\c vet_clinic


CREATE TABLE animals (
  id INT GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(250), 
  date_of_birth DATE,
  escape_attempts INT, 
  neutered BOOLEAN,
  weight DECIMAL,
  PRIMARY KEY(id)
);

ALTER TABLE animals
  ADD species VARCHAR(250);

CREATE TABLE owners (
  id INT GENERATED ALWAYS AS IDENTITY,
  full_name VARCHAR(250),
  age INT,
  PRIMARY KEY(id),
);

CREATE TABLE species (
  id INT GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(250),
  PRIMARY KEY(id)
);

ALTER TABLE animals
  DROP COLUMN species;

ALTER TABLE animals ADD COLUMN species_id INT;
ALTER TABLE animals ADD CONSTRAINT fk_species FOREIGN KEY (species_id) REFERENCES species(id);

ALTER TABLE animals ADD COLUMN owner_id INT;
ALTER TABLE animals ADD CONSTRAINT fk_owner FOREIGN KEY (owner_id) REFERENCES owners(id);

CREATE TABLE vets (
  id INT GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(250),
  age INT,
  date_of_graduation DATE,
  PRIMARY KEY(id)
);

CREATE TABLE specializations (
  species_id INT,
  vets_id INT,
  PRIMARY KEY (species_id, vets_id),
  CONSTRAINT fk_species FOREIGN KEY (species_id) REFERENCES species(id),
  CONSTRAINT fk_vets FOREIGN KEY (vets_id) REFERENCES vets(id)
);

CREATE TABLE visits (
  animals_id INT,
  vets_id INT,
  date_of_visit DATE,
  PRIMARY KEY (animals_id, vets_id, date_of_visit),
  CONSTRAINT fk_animals FOREIGN KEY (animals_id) REFERENCES animals(id),
  CONSTRAINT fk_vets FOREIGN KEY (vets_id) REFERENCES vets(id)
);