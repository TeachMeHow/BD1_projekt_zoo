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
CREATE TABLE "Animal History" (
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
  Employeelocation_id number(6), 
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
  conservation_status char(2) DEFAULT 'NE' NOT NULL CHECK(${check_conservation_status}), 
  description         varchar2(4095), 
  PRIMARY KEY (id), 
  CONSTRAINT check_conservation_status 
    CHECK (IN ('EX','EW', 'CR', 'EN', 'VU', 'NT', 'LC', 'DD', 'NE')));
COMMENT ON COLUMN Species.description IS 'biology, georgraphical spread, etc.';
CREATE TABLE Task (
  task_id             number(6) NOT NULL, 
  animal_id           number(6), 
  employee_id         number(6) NOT NULL, 
  location_id         number(6), 
  assigned_at         timestamp(0) NOT NULL, 
  deadline            timestamp(0), 
  description         varchar2(1023) NOT NULL, 
  Employeelocation_id number(6) NOT NULL, 
  PRIMARY KEY (task_id));
CREATE TABLE "Work Time" (
  shift_start         timestamp(0) NOT NULL, 
  employee_id         number(6) NOT NULL, 
  shift_end           timestamp(0) NOT NULL, 
  Employeelocation_id number(6) NOT NULL, 
  PRIMARY KEY (shift_start, 
  employee_id, 
  Employeelocation_id), 
  CONSTRAINT "shift start must be before shift end" 
    CHECK (shift_start <= shift_end));
ALTER TABLE Task ADD CONSTRAINT FKTask163950 FOREIGN KEY (employee_id) REFERENCES Employee (id) ON DELETE Cascade;
ALTER TABLE Employee ADD CONSTRAINT FKEmployee843491 FOREIGN KEY (location_id) REFERENCES Location (id) ON DELETE Set null;
ALTER TABLE Equipment ADD CONSTRAINT FKEquipment369050 FOREIGN KEY (location_id) REFERENCES Location (id) ON DELETE Set null;
ALTER TABLE Task ADD CONSTRAINT FKTask385950 FOREIGN KEY (animal_id) REFERENCES Animal (id) ON DELETE Cascade;
ALTER TABLE Task ADD CONSTRAINT FKTask359156 FOREIGN KEY (location_id) REFERENCES Location (id) ON DELETE Cascade;
ALTER TABLE Animal ADD CONSTRAINT FKAnimal761517 FOREIGN KEY (location_id) REFERENCES Location (id);
ALTER TABLE Animal ADD CONSTRAINT FKAnimal849668 FOREIGN KEY (species_id) REFERENCES Species (id);
ALTER TABLE Employee ADD CONSTRAINT FKEmployee119678 FOREIGN KEY (supervisor_id) REFERENCES Employee (id) ON DELETE Set null;
ALTER TABLE "Work Time" ADD CONSTRAINT "FKWork Time593473" FOREIGN KEY (employee_id) REFERENCES Employee (id) ON DELETE Cascade;
ALTER TABLE "Animal History" ADD CONSTRAINT "FKAnimal His86946" FOREIGN KEY (animal_id) REFERENCES Animal (id) ON DELETE Cascade;
ALTER TABLE "Animal History" ADD CONSTRAINT "FKAnimal His60152" FOREIGN KEY (location_id) REFERENCES Location (id);
  CREATE OR REPLACE PROCEDURE "update_animal_history" 
  ( p_animal_id       animal_history.animal_id%type
   , p_move_in_date      animal_history.move_in_date%type
   , location_id        animal_history.location_id%type
   )
IS
BEGIN
INSERT INTO animal_history (animal_id, move_in_date, move_out_date, location_id)
 VALUES(p_animal_id, p_move_in_date, NULL,  p_location_id);
IF EXISTS (SELECT * FROM animal_history WHERE animal_id = p_animal_id)
UPDATE animal_history
SET move_out_date = p_move_in_date
WHERE move_in_date = 
	(SELECT max(move_in_date) FROM animal_history WHERE animal_id = p_animal_id);
END add_job_history;;
CREATE OR REPLACE TRIGGER "UPDATE_ANIMAL_HISTORY" 
  AFTER UPDATE OF location_id ON animals
  FOR EACH ROW
BEGIN
  add_job_history(:old.employee_id, :old.hire_date, sysdate,
                  :old.job_id, :old.department_id);
END;

ALTER TRIGGER "UPDATE_JOB_HISTORY" ENABLE;;

