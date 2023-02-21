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