DROP TRIGGER update_animal_history;
DROP PROCEDURE add_animal_history;
DROP SEQUENCE seq_Equipment;
DROP SEQUENCE seq_Location;
DROP SEQUENCE seq_Species;
DROP SEQUENCE seq_Task;
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
  location_id         number(6) NOT NULL, 
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

