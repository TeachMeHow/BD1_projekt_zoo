DROP TRIGGER update_animal_history;
DROP PROCEDURE add_animal_history;
DROP SEQUENCE seq_Equipment;
DROP SEQUENCE seq_Locations;
DROP SEQUENCE seq_Species;
DROP SEQUENCE seq_Tasks;
DROP SEQUENCE seq_Animals;
DROP SEQUENCE seq_Employees;
DROP TABLE Animals CASCADE CONSTRAINTS;
DROP TABLE Animal_History CASCADE CONSTRAINTS;
DROP TABLE Employees CASCADE CONSTRAINTS;
DROP TABLE Equipment CASCADE CONSTRAINTS;
DROP TABLE Locations CASCADE CONSTRAINTS;
DROP TABLE Species CASCADE CONSTRAINTS;
DROP TABLE Tasks CASCADE CONSTRAINTS;
DROP TABLE Work_Times CASCADE CONSTRAINTS;    
DROP VIEW Animal_Information_View;


CREATE SEQUENCE seq_Equipment;
CREATE SEQUENCE seq_Locations;
CREATE SEQUENCE seq_Species;
CREATE SEQUENCE seq_Tasks;
CREATE SEQUENCE seq_Animals;
CREATE SEQUENCE seq_Employees;

CREATE TABLE Animals (
  id              number(6) NOT NULL, 
  location_id     number(6) NOT NULL, 
  date_of_arrival date NOT NULL, 
  species_id      number(6) NOT NULL, 
  name            varchar2(255), 
  care_notes      varchar2(2047), 
  PRIMARY KEY (id));
CREATE TABLE Animal_History (
  animal_id     number(6) NOT NULL, 
  move_in_date  date NOT NULL, 
  location_id   number(6) NOT NULL, 
  move_out_date date, 
  PRIMARY KEY (animal_id, 
  move_in_date));
CREATE TABLE Employees (
  id                  number(6) NOT NULL, 
  location_id         number(6), 
  first_name          varchar2(255) NOT NULL, 
  last_name           varchar2(255) NOT NULL, 
  job_title           varchar2(255) NOT NULL, 
  supervisor_id       number(6), 
  PRIMARY KEY (id));
CREATE TABLE Equipment (
  id          number(6) NOT NULL, 
  location_id number(6) NOT NULL, 
  name        varchar2(255) NOT NULL, 
  description varchar2(1023), 
  PRIMARY KEY (id));
CREATE TABLE Locations (
  id                     number(6) NOT NULL, 
  parent_localization_id number(6), 
  type                   varchar2(63) NOT NULL, 
  name                   varchar2(255) NOT NULL, 
  PRIMARY KEY (id));
COMMENT ON COLUMN Locations.parent_localization_id IS 'for example, building is a parent localization of rooms';
COMMENT ON COLUMN Locations.type IS 'type as in building, cage, room, etc.';
COMMENT ON COLUMN Locations.name IS 'description, like room/building number';
CREATE TABLE Species (
  id                  number(6) NOT NULL, 
  common_name         varchar2(255) UNIQUE, 
  scientific_name     varchar2(255) NOT NULL UNIQUE, 
  conservation_status char(2) DEFAULT 'NE' NOT NULL, 
  description         varchar2(4000), 
  PRIMARY KEY (id), 
  CONSTRAINT check_conservation_status 
    CHECK (conservation_status IN ('EX','EW', 'CR', 'EN', 'VU', 'NT', 'LC', 'DD', 'NE')));
COMMENT ON COLUMN Species.description IS 'biology, georgraphical spread, etc.';
CREATE TABLE Tasks (
  task_id             number(6) NOT NULL, 
  animal_id           number(6), 
  employee_id         number(6) NOT NULL, 
  location_id         number(6), 
  assigned_at         timestamp(0) NOT NULL, 
  deadline            timestamp(0), 
  description         varchar2(1023) NOT NULL,
  PRIMARY KEY (task_id));
CREATE TABLE Work_Times (
  shift_start         timestamp(0) NOT NULL, 
  employee_id         number(6) NOT NULL, 
  shift_end           timestamp(0) NOT NULL,
  PRIMARY KEY (shift_start, 
  employee_id), 
  CONSTRAINT "start_must_be_before_end" 
    CHECK (shift_start <= shift_end));
    
    
CREATE VIEW Animal_Information_View AS
SELECT a.id, a.name, a.date_of_arrival, a.care_notes, 
       l.type AS "location_type", l.name AS "location_name",
       s.common_name AS "species_common_name", s.conservation_status 
FROM animals a, locations l, species s
WHERE a.location_id = l.id AND a.species_id = s.id;

ALTER TABLE Tasks ADD CONSTRAINT FKTasks163950 FOREIGN KEY (employee_id) REFERENCES Employees (id) ON DELETE Cascade;
ALTER TABLE Employees ADD CONSTRAINT FKEmployees843491 FOREIGN KEY (location_id) REFERENCES Locations (id) ON DELETE Set null;
ALTER TABLE Equipment ADD CONSTRAINT FKEquipment369050 FOREIGN KEY (location_id) REFERENCES Locations (id) ON DELETE Set null;
ALTER TABLE Tasks ADD CONSTRAINT FKTasks385950 FOREIGN KEY (animal_id) REFERENCES Animals (id) ON DELETE Cascade;
ALTER TABLE Tasks ADD CONSTRAINT FKTasks359156 FOREIGN KEY (location_id) REFERENCES Locations (id) ON DELETE Cascade;
ALTER TABLE Animals ADD CONSTRAINT FKAnimals761517 FOREIGN KEY (location_id) REFERENCES Locations (id);
ALTER TABLE Animals ADD CONSTRAINT FKAnimals849668 FOREIGN KEY (species_id) REFERENCES Species (id);
ALTER TABLE Employees ADD CONSTRAINT FKEmployees119678 FOREIGN KEY (supervisor_id) REFERENCES Employees (id) ON DELETE Set null;
ALTER TABLE Work_Times ADD CONSTRAINT "FKWork_Times593473" FOREIGN KEY (employee_id) REFERENCES Employees (id) ON DELETE Cascade;
ALTER TABLE Animal_History ADD CONSTRAINT "FKAnimal_His86946" FOREIGN KEY (animal_id) REFERENCES Animals (id) ON DELETE Cascade;
ALTER TABLE Animal_History ADD CONSTRAINT "FKAnimal_His60152" FOREIGN KEY (location_id) REFERENCES Locations (id);

-- LOCATIONS
INSERT INTO Locations(id, parent_localization_id, type, name) 
VALUES (SEQ_Locations.nextval, NULL, 'sector', 'sector A');
INSERT INTO Locations(id, parent_localization_id, type, name) 
VALUES (SEQ_Locations.nextval, (SELECT id FROM Locations l WHERE name = 'sector A'), 'building', 'A1');
INSERT INTO Locations(id, parent_localization_id, type, name) 
VALUES (SEQ_Locations.nextval, (SELECT id FROM Locations l WHERE name = 'building A1'), 'room', 'A1.1');
INSERT INTO Locations(id, parent_localization_id, type, name) 
VALUES (SEQ_Locations.nextval, (SELECT id FROM Locations l WHERE name = 'sector A'), 'enclosure', 'A2');
INSERT INTO Locations(id, parent_localization_id, type, name) 
VALUES (SEQ_Locations.nextval, (SELECT id FROM Locations l WHERE name = 'sector A'), 'enclosure', 'A3');
-- EMPLOYEES
INSERT INTO Employees (id, location_id, first_name, last_name, job_title, supervisor_id) 
VALUES (SEQ_Employees.nextval, (SELECT id FROM Locations l WHERE name = 'A1.1'), 'Alec', 'Pavlovsky', 'PRESIDENT', NULL);
INSERT INTO Employees (id, location_id, first_name, last_name, job_title, supervisor_id) 
VALUES (SEQ_Employees.nextval, NULL, 'Steve', 'Wozniak', 'CARETAKER', 
    (SELECT id FROM Employees e WHERE job_title = 'PRESIDENT'));
INSERT INTO Employees (id, location_id, first_name, last_name, job_title, supervisor_id) 
VALUES (SEQ_Employees.nextval, NULL, 'Steve', 'Kowalski', 'CARETAKER', 
    (SELECT id FROM Employees e WHERE job_title = 'PRESIDENT'));
INSERT INTO Employees (id, location_id, first_name, last_name, job_title, supervisor_id) 
VALUES (SEQ_Employees.nextval, NULL, 'Steve', 'Stevenson', 'SANITOR', 
    (SELECT id FROM Employees e WHERE job_title = 'PRESIDENT'));
INSERT INTO Employees (id, location_id, first_name, last_name, job_title, supervisor_id) 
VALUES (SEQ_Employees.nextval, NULL, 'Steve', 'Smith', 'SANITOR', 
    (SELECT id FROM Employees e WHERE job_title = 'PRESIDENT'));
--SPECIES
INSERT INTO Species(id, common_name, scientific_name, conservation_status, description) 
VALUES (SEQ_SPECIES.nextval, 'Plains Zebra' , 'Equus quagga', 'NT', 
    'the most common and geographically widespread species of zebra');
INSERT INTO Species(id, common_name, scientific_name, conservation_status, description) 
VALUES (SEQ_SPECIES.nextval, 'Masai giraffe' , 'Giraffa camelopardalis tippelskirchii', 'VU', 
    ' the largest subspecies of giraffe');
INSERT INTO Species(id, common_name, scientific_name, conservation_status, description) 
VALUES (SEQ_SPECIES.nextval, 'African bush elephant' , 'Loxodonta africana', 'VU', 
    'the largest living terrestrial animal with bulls reaching a shoulder height of up to 4 m (13 ft).');
INSERT INTO Species(id, common_name, scientific_name, conservation_status, description) 
VALUES (SEQ_SPECIES.nextval, 'Lion' , 'Panthera leo', 'VU', 
    ' it is a muscular, deep-chested cat with a short, rounded head, a reduced neck and 
    round ears, and a hairy tuft at the end of its tail.');
INSERT INTO Species(id, common_name, scientific_name, conservation_status, description) 
VALUES (SEQ_SPECIES.nextval, 'Siberian tiger' , 'Panthera tigris tigris', 'EN', 
    ' The population had been stable for more than a decade due to intensive conservation efforts, but partial surveys 
    conducted after 2005 indicate that the Russian tiger population was declining.');
-- ANIMALS
INSERT INTO Animals (id, location_id, date_of_arrival, species_id, name, care_notes) 
VALUES (SEQ_Animals.nextval, (SELECT id FROM Locations l WHERE name = 'A2'), sysdate - 4*7, 
    (SELECT s.id FROM species s WHERE LOWER(s.common_name) = 'masai giraffe'), 'Antek', 'male');
INSERT INTO Animals (id, location_id, date_of_arrival, species_id, name, care_notes) 
VALUES (SEQ_Animals.nextval, (SELECT id FROM Locations l WHERE name = 'A2'), sysdate - 4*7, 
    (SELECT s.id FROM species s WHERE LOWER(s.common_name) = 'masai giraffe'), 'Agata', 'female');
INSERT INTO Animals (id, location_id, date_of_arrival, species_id, name, care_notes) 
VALUES (SEQ_Animals.nextval, (SELECT id FROM Locations l WHERE name = 'A2'), sysdate - 4*7, 
    (SELECT s.id FROM species s WHERE LOWER(s.common_name) = 'masai giraffe'), NULL, 'male');
INSERT INTO Animals (id, location_id, date_of_arrival, species_id, name, care_notes) 
VALUES (SEQ_Animals.nextval, (SELECT id FROM Locations l WHERE name = 'A3'), sysdate - 2*7, 
    (SELECT s.id FROM species s WHERE LOWER(s.common_name) = 'lion'), 'Piotrek', 'male');
INSERT INTO Animals (id, location_id, date_of_arrival, species_id, name, care_notes) 
VALUES (SEQ_Animals.nextval, (SELECT id FROM Locations l WHERE name = 'A3'), sysdate - 2*7, 
    (SELECT s.id FROM species s WHERE LOWER(s.common_name) = 'lion'), 'Grzesiek', 'male');

-- TASKS
INSERT INTO Tasks(task_id, animal_id, employee_id, location_id, assigned_at, deadline, description) 
VALUES (SEQ_Tasks.nextval, (SELECT a.id FROM Animals a WHERE LOWER(name) = 'antek'),
    (SELECT id FROM Employees WHERE LOWER(last_name) = 'wozniak' AND LOWER(job_title) = 'caretaker'),
    NULL, sysdate - 1, sysdate + 1, 'give medicine');
INSERT INTO Tasks(task_id, animal_id, employee_id, location_id, assigned_at, deadline, description) 
VALUES (SEQ_Tasks.nextval, (SELECT a.id FROM Animals a WHERE LOWER(name) = 'agata'),
    (SELECT id FROM Employees WHERE LOWER(last_name) = 'wozniak' AND LOWER(job_title) = 'caretaker'),
    NULL, sysdate - 1, sysdate + 1, 'give medicine');
INSERT INTO Tasks(task_id, animal_id, Employee_id, location_id, assigned_at, deadline, description) 
VALUES (SEQ_Tasks.nextval, (SELECT a.id FROM Animals a WHERE name IS NULL),
    (SELECT id FROM Employees WHERE LOWER(last_name) = 'kowalski' AND LOWER(job_title) = 'caretaker'),
    NULL, sysdate, sysdate, 'feed');
INSERT INTO Tasks(Task_id, animal_id, Employee_id, location_id, assigned_at, deadline, description) 
VALUES (SEQ_Tasks.nextval, NULL,
    (SELECT id FROM Employees WHERE LOWER(last_name) = 'stevenson' AND LOWER(job_title) = 'sanitor'),
    (SELECT id FROM Locations WHERE LOWER(name) = 'a2'), sysdate - 1, sysdate + 1, 'clean enclosure');
INSERT INTO Tasks(task_id, animal_id, employee_id, location_id, assigned_at, deadline, description) 
VALUES (SEQ_Tasks.nextval, NULL,
    (SELECT id FROM Employees WHERE LOWER(last_name) = 'smith' AND LOWER(job_title) = 'sanitor'),
    (SELECT id FROM Locations WHERE name='A3'), sysdate - 1, sysdate + 1, 'clean enclosure');
    
-- WORK TIME  
INSERT INTO Work_Times(shift_start, employee_id, shift_end) 
VALUES (TO_TIMESTAMP('2019-06-01 09:0:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
    (SELECT id FROM Employees e WHERE last_name = 'Wozniak'), 
    TO_TIMESTAMP('2019-06-01 17:0:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
INSERT INTO Work_Times(shift_start, employee_id, shift_end) 
VALUES (TO_TIMESTAMP('2019-06-02 09:0:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
    (SELECT id FROM Employees e WHERE last_name = 'Wozniak'), 
    TO_TIMESTAMP('2019-06-02 17:0:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
INSERT INTO Work_Times(shift_start, employee_id, shift_end) 
VALUES (TO_TIMESTAMP('2019-06-03 09:0:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
    (SELECT id FROM Employees e WHERE last_name = 'Wozniak'), 
    TO_TIMESTAMP('2019-06-03 17:0:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
INSERT INTO Work_Times(shift_start, employee_id, shift_end) 
VALUES (TO_TIMESTAMP('2019-06-04 09:0:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
    (SELECT id FROM Employees e WHERE last_name = 'Wozniak'), 
    TO_TIMESTAMP('2019-06-05 17:0:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
INSERT INTO Work_Times(shift_start, Employee_id, shift_end) 
VALUES (TO_TIMESTAMP('2019-06-06 09:0:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
    (SELECT id FROM Employees e WHERE last_name = 'Wozniak'), 
    TO_TIMESTAMP('2019-06-06 17:0:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
      
-- EQUIPMENT
INSERT INTO Equipment(id, location_id, name, description) 
VALUES (SEQ_EQUIPMENT.nextval, (SELECT id FROM Locations WHERE name = 'A1'), 
    'very long stick', 'very long');
INSERT INTO Equipment(id, location_id, name, description) 
VALUES (SEQ_EQUIPMENT.nextval, (SELECT id FROM Locations WHERE name = 'A1'), 
    'long stick', 'long');
INSERT INTO Equipment(id, location_id, name, description) 
VALUES (SEQ_EQUIPMENT.nextval, (SELECT id FROM Locations WHERE name = 'A1'), 
    'medium sized stick', 'about average');
INSERT INTO Equipment(id, location_id, name, description) 
VALUES (SEQ_EQUIPMENT.nextval, (SELECT id FROM Locations WHERE name = 'A1'), 
    'short stick', 'short');
INSERT INTO Equipment(id, location_id, name, description) 
VALUES (SEQ_EQUIPMENT.nextval, (SELECT id FROM Locations WHERE name = 'A1'), 
    'very short stick', 'very short');

CREATE OR REPLACE PROCEDURE add_animal_history
( p_animal_id       animal_history.animal_id%type
, p_move_in_date      animal_history.move_in_date%type
, p_location_id        animal_history.location_id%type
)
IS
BEGIN
UPDATE animal_history
SET move_out_date = p_move_in_date
WHERE move_in_date = 
	(SELECT max(move_in_date) FROM Animal_History WHERE animal_id = p_animal_id);
INSERT INTO animal_history (animal_id, move_in_date, move_out_date, location_id)
VALUES(p_animal_id, p_move_in_date, NULL,  p_location_id);

END add_animal_history;
/
CREATE OR REPLACE TRIGGER update_animal_history
  AFTER UPDATE OF location_id ON Animals
  FOR EACH ROW
BEGIN
  add_animal_history(:old.id, sysdate,
                  :new.location_id);
END;
/
ALTER TRIGGER update_animal_history ENABLE;
/

-- FILL
UPDATE Animals
SET location_id = (SELECT id FROM Locations WHERE name = 'A3')
WHERE id = (SELECT id FROM Animals WHERE name = 'Antek');
UPDATE Animals
SET location_id = (SELECT id FROM Locations WHERE name = 'A3')
WHERE id = (SELECT id FROM Animals WHERE name = 'Agata');
UPDATE Animals
SET location_id = (SELECT id FROM Locations WHERE name = 'A3')
WHERE id = (SELECT id FROM Animals WHERE name IS NULL);
UPDATE Animals
SET location_id = (SELECT id FROM Locations WHERE name = 'A2')
WHERE id = (SELECT id FROM Animals WHERE name = 'Piotrek');
UPDATE Animals
SET location_id = (SELECT id FROM Locations WHERE name = 'A3')
WHERE id = (SELECT id FROM Animals WHERE name = 'Grzesiek');
