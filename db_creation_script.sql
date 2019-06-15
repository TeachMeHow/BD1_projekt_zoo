DROP TRIGGER update_animal_history;
DROP PROCEDURE add_animal_history;
DROP SEQUENCE seq_Equipment;
DROP SEQUENCE seq_Location;
DROP SEQUENCE seq_Species;
DROP SEQUENCE seq_Task;
DROP SEQUENCE seq_Animal;
DROP SEQUENCE seq_Employee;
DROP TABLE Animal CASCADE CONSTRAINTS;
DROP TABLE Animal_History CASCADE CONSTRAINTS;
DROP TABLE Employee CASCADE CONSTRAINTS;
DROP TABLE Equipment CASCADE CONSTRAINTS;
DROP TABLE Location CASCADE CONSTRAINTS;
DROP TABLE Species CASCADE CONSTRAINTS;
DROP TABLE Task CASCADE CONSTRAINTS;
DROP TABLE Work_Time CASCADE CONSTRAINTS;

CREATE SEQUENCE seq_Equipment;
CREATE SEQUENCE seq_Location;
CREATE SEQUENCE seq_Species;
CREATE SEQUENCE seq_Task;
CREATE SEQUENCE seq_Animal;
CREATE SEQUENCE seq_Employee;

CREATE TABLE Animal (
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
  move_out_date date UNIQUE, 
  PRIMARY KEY (animal_id, 
  move_in_date));
CREATE TABLE Employee (
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
CREATE TABLE Location (
  id                     number(6) NOT NULL, 
  parent_localization_id number(6), 
  type                   varchar2(63) NOT NULL, 
  name                   varchar2(255) NOT NULL, 
  PRIMARY KEY (id));
COMMENT ON COLUMN Location.parent_localization_id IS 'for example, building is a parent localization of rooms';
COMMENT ON COLUMN Location.type IS 'type as in building, cage, room, etc.';
COMMENT ON COLUMN Location.name IS 'description, like room/building number';
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
CREATE TABLE Task (
  task_id             number(6) NOT NULL, 
  animal_id           number(6), 
  employee_id         number(6) NOT NULL, 
  location_id         number(6), 
  assigned_at         timestamp(0) NOT NULL, 
  deadline            timestamp(0), 
  description         varchar2(1023) NOT NULL,
  PRIMARY KEY (task_id));
CREATE TABLE Work_Time (
  shift_start         timestamp(0) NOT NULL, 
  employee_id         number(6) NOT NULL, 
  shift_end           timestamp(0) NOT NULL,
  PRIMARY KEY (shift_start, 
  employee_id), 
  CONSTRAINT "start_must_be_before_end" 
    CHECK (shift_start <= shift_end));

ALTER TABLE Task ADD CONSTRAINT FKTask163950 FOREIGN KEY (employee_id) REFERENCES Employee (id) ON DELETE Cascade;
ALTER TABLE Employee ADD CONSTRAINT FKEmployee843491 FOREIGN KEY (location_id) REFERENCES Location (id) ON DELETE Set null;
ALTER TABLE Equipment ADD CONSTRAINT FKEquipment369050 FOREIGN KEY (location_id) REFERENCES Location (id) ON DELETE Set null;
ALTER TABLE Task ADD CONSTRAINT FKTask385950 FOREIGN KEY (animal_id) REFERENCES Animal (id) ON DELETE Cascade;
ALTER TABLE Task ADD CONSTRAINT FKTask359156 FOREIGN KEY (location_id) REFERENCES Location (id) ON DELETE Cascade;
ALTER TABLE Animal ADD CONSTRAINT FKAnimal761517 FOREIGN KEY (location_id) REFERENCES Location (id);
ALTER TABLE Animal ADD CONSTRAINT FKAnimal849668 FOREIGN KEY (species_id) REFERENCES Species (id);
ALTER TABLE Employee ADD CONSTRAINT FKEmployee119678 FOREIGN KEY (supervisor_id) REFERENCES Employee (id) ON DELETE Set null;
ALTER TABLE Work_Time ADD CONSTRAINT "FKWork_Time593473" FOREIGN KEY (employee_id) REFERENCES Employee (id) ON DELETE Cascade;
ALTER TABLE Animal_History ADD CONSTRAINT "FKAnimal_His86946" FOREIGN KEY (animal_id) REFERENCES Animal (id) ON DELETE Cascade;
ALTER TABLE Animal_History ADD CONSTRAINT "FKAnimal_His60152" FOREIGN KEY (location_id) REFERENCES Location (id);

-- LOCATIONS
INSERT INTO Location(id, parent_localization_id, type, name) 
VALUES (SEQ_LOCATION.nextval, NULL, 'sector', 'sector A');
INSERT INTO Location(id, parent_localization_id, type, name) 
VALUES (SEQ_LOCATION.nextval, (SELECT l.id FROM Location l WHERE l.name = 'sector A'), 'building', 'A1');
INSERT INTO Location(id, parent_localization_id, type, name) 
VALUES (SEQ_LOCATION.nextval, (SELECT l.id FROM Location l WHERE l.name = 'building A1'), 'room', 'A1.1');
INSERT INTO Location(id, parent_localization_id, type, name) 
VALUES (SEQ_LOCATION.nextval, (SELECT l.id FROM Location l WHERE l.name = 'sector A'), 'enclosure', 'A2');
INSERT INTO Location(id, parent_localization_id, type, name) 
VALUES (SEQ_LOCATION.nextval, (SELECT l.id FROM Location l WHERE l.name = 'sector A'), 'enclosure', 'A3');
-- EMPLOYEES
INSERT INTO Employee (id, location_id, first_name, last_name, job_title, supervisor_id) 
VALUES (SEQ_EMPLOYEE.nextval, (SELECT l.id FROM Location l WHERE name = 'A1.1'), 'Alec', 'Pavlovsky', 'PRESIDENT', NULL);
INSERT INTO Employee (id, location_id, first_name, last_name, job_title, supervisor_id) 
VALUES (SEQ_EMPLOYEE.nextval, NULL, 'Steve', 'Wozniak', 'CARETAKER', 
    (SELECT e.id FROM employee e WHERE e.job_title = 'PRESIDENT'));
INSERT INTO Employee (id, location_id, first_name, last_name, job_title, supervisor_id) 
VALUES (SEQ_EMPLOYEE.nextval, NULL, 'Steve', 'Kowalski', 'CARETAKER', 
    (SELECT e.id FROM employee e WHERE e.job_title = 'PRESIDENT'));
INSERT INTO Employee (id, location_id, first_name, last_name, job_title, supervisor_id) 
VALUES (SEQ_EMPLOYEE.nextval, NULL, 'Steve', 'Stevenson', 'SANITOR', 
    (SELECT e.id FROM employee e WHERE e.job_title = 'PRESIDENT'));
INSERT INTO Employee (id, location_id, first_name, last_name, job_title, supervisor_id) 
VALUES (SEQ_EMPLOYEE.nextval, NULL, 'Steve', 'Smith', 'SANITOR', 
    (SELECT e.id FROM employee e WHERE e.job_title = 'PRESIDENT'));
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
INSERT INTO Animal (id, location_id, date_of_arrival, species_id, name, care_notes) 
VALUES (SEQ_ANIMAL.nextval, (SELECT l.id FROM Location l WHERE l.name = 'A2'), sysdate - 4*7, 
    (SELECT s.id FROM species s WHERE LOWER(s.common_name) = 'masai giraffe'), 'Antek', 'male');
INSERT INTO Animal (id, location_id, date_of_arrival, species_id, name, care_notes) 
VALUES (SEQ_ANIMAL.nextval, (SELECT l.id FROM Location l WHERE l.name = 'A2'), sysdate - 4*7, 
    (SELECT s.id FROM species s WHERE LOWER(s.common_name) = 'masai giraffe'), 'Agata', 'female');
INSERT INTO Animal (id, location_id, date_of_arrival, species_id, name, care_notes) 
VALUES (SEQ_ANIMAL.nextval, (SELECT l.id FROM Location l WHERE l.name = 'A2'), sysdate - 4*7, 
    (SELECT s.id FROM species s WHERE LOWER(s.common_name) = 'masai giraffe'), NULL, 'male');
INSERT INTO Animal (id, location_id, date_of_arrival, species_id, name, care_notes) 
VALUES (SEQ_ANIMAL.nextval, (SELECT l.id FROM Location l WHERE l.name = 'A3'), sysdate - 2*7, 
    (SELECT s.id FROM species s WHERE LOWER(s.common_name) = 'lion'), 'Piotrek', 'male');
INSERT INTO Animal (id, location_id, date_of_arrival, species_id, name, care_notes) 
VALUES (SEQ_ANIMAL.nextval, (SELECT l.id FROM Location l WHERE l.name = 'A3'), sysdate - 2*7, 
    (SELECT s.id FROM species s WHERE LOWER(s.common_name) = 'lion'), 'Grzesiek', 'male');

-- TASKS
INSERT INTO Task(task_id, animal_id, employee_id, location_id, assigned_at, deadline, description) 
VALUES (SEQ_TASK.nextval, (SELECT a.id FROM animal a WHERE LOWER(a.name) = 'antek'),
    (SELECT e.id FROM employee WHERE LOWER(e.last_name) = 'wozniak' AND LOWER(job_title) = 'caretaker'),
    NULL, sysdate - 1, sysdate + 1, 'give medicine');
INSERT INTO Task(task_id, animal_id, employee_id, location_id, assigned_at, deadline, description) 
VALUES (SEQ_TASK.nextval, (SELECT a.id FROM animal a WHERE LOWER(a.name) = 'agata'),
    (SELECT e.id FROM employee WHERE LOWER(e.last_name) = 'wozniak' AND LOWER(job_title) = 'caretaker'),
    NULL, sysdate - 1, sysdate + 1, 'give medicine');
INSERT INTO Task(task_id, animal_id, employee_id, location_id, assigned_at, deadline, description) 
VALUES (SEQ_TASK.nextval, (SELECT a.id FROM animal a WHERE name IS NULL),
    (SELECT e.id FROM employee WHERE LOWER(e.last_name) = 'kowalski' AND LOWER(job_title) = 'caretaker'),
    NULL, sysdate, sysdate, 'feed');
INSERT INTO Task(task_id, animal_id, employee_id, location_id, assigned_at, deadline, description) 
VALUES (SEQ_TASK.nextval, NULL,
    (SELECT e.id FROM employee WHERE LOWER(e.last_name) = 'stevenson' AND LOWER(job_title) = 'sanitor'),
    (SELECT l.id FROM location l WHERE LOWER(a.name) = 'a2'), sysdate - 1, sysdate + 1, 'clean enclosure');
INSERT INTO Task(task_id, animal_id, employee_id, location_id, assigned_at, deadline, description) 
VALUES (SEQ_TASK.nextval, NULL,
    (SELECT e.id FROM employee WHERE LOWER(e.last_name) = 'smith' AND LOWER(job_title) = 'sanitor'),
    (SELECT l.id FROM location l WHERE name='A3'), sysdate - 1, sysdate + 1, 'clean enclosure');
    
-- WORK TIME  
INSERT INTO Work_Time(shift_start, employee_id, shift_end) 
VALUES (TO_TIMESTAMP('2019-06-01 09:0:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
    (SELECT e.id FROM employee e WHERE e.last_name = 'Wozniak'), 
    TO_TIMESTAMP('2019-06-01 17:0:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
INSERT INTO Work_Time(shift_start, employee_id, shift_end) 
VALUES (TO_TIMESTAMP('2019-06-02 09:0:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
    (SELECT e.id FROM employee e WHERE e.last_name = 'Wozniak'), 
    TO_TIMESTAMP('2019-06-02 17:0:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
INSERT INTO Work_Time(shift_start, employee_id, shift_end) 
VALUES (TO_TIMESTAMP('2019-06-03 09:0:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
    (SELECT e.id FROM employee e WHERE e.last_name = 'Wozniak'), 
    TO_TIMESTAMP('2019-06-03 17:0:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
INSERT INTO Work_Time(shift_start, employee_id, shift_end) 
VALUES (TO_TIMESTAMP('2019-06-04 09:0:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
    (SELECT e.id FROM employee e WHERE e.last_name = 'Wozniak'), 
    TO_TIMESTAMP('2019-06-05 17:0:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
INSERT INTO Work_Time(shift_start, employee_id, shift_end) 
VALUES (TO_TIMESTAMP('2019-06-06 09:0:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
    (SELECT e.id FROM employee e WHERE e.last_name = 'Wozniak'), 
    TO_TIMESTAMP('2019-06-06 17:0:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
      
-- EQUIPMENT
INSERT INTO Equipment(id, location_id, name, description) 
VALUES (SEQ_EQUIPMENT.nextval, (SELECT l.id FROM location l WHERE l.name = 'A1'), 
    'very long stick', 'very long');
INSERT INTO Equipment(id, location_id, name, description) 
VALUES (SEQ_EQUIPMENT.nextval, (SELECT l.id FROM location l WHERE l.name = 'A1'), 
    'long stick', 'long');
INSERT INTO Equipment(id, location_id, name, description) 
VALUES (SEQ_EQUIPMENT.nextval, (SELECT l.id FROM location l WHERE l.name = 'A1'), 
    'medium sized stick', 'about average');
INSERT INTO Equipment(id, location_id, name, description) 
VALUES (SEQ_EQUIPMENT.nextval, (SELECT l.id FROM location l WHERE l.name = 'A1'), 
    'short stick', 'short');
INSERT INTO Equipment(id, location_id, name, description) 
VALUES (SEQ_EQUIPMENT.nextval, (SELECT l.id FROM location l WHERE l.name = 'A1'), 
    'very short stick', 'very short');

CREATE OR REPLACE PROCEDURE add_animal_history
( p_animal_id       animal_history.animal_id%type
, p_move_in_date      animal_history.move_in_date%type
, p_location_id        animal_history.location_id%type
)
IS
BEGIN
INSERT INTO animal_history (animal_id, move_in_date, move_out_date, location_id)
VALUES(p_animal_id, p_move_in_date, NULL,  p_location_id);
UPDATE animal_history
SET move_out_date = p_move_in_date
WHERE move_in_date = 
	(SELECT max(move_in_date) FROM Animal_History WHERE animal_id = p_animal_id);
END add_animal_history;
/
CREATE OR REPLACE TRIGGER update_animal_history
  AFTER UPDATE OF location_id ON animal
  FOR EACH ROW
BEGIN
  add_animal_history(:old.id, sysdate,
                  :new.location_id);
END;
/
ALTER TRIGGER update_animal_history ENABLE;
/

UPDATE animal
SET location = 'A3'
WHERE id = (SELECT id FROM animal WHERE name = 'Antek');
UPDATE animal
SET location = 'A2'
WHERE id = (SELECT id FROM animal WHERE name = 'Antek');
UPDATE animal
SET location = 'A3'
WHERE id = (SELECT id FROM animal WHERE name = 'Antek');
UPDATE animal
SET location = 'A2'
WHERE id = (SELECT id FROM animal WHERE name = 'Antek');
UPDATE animal
SET location = 'A3'
WHERE id = (SELECT id FROM animal WHERE name = 'Antek');

