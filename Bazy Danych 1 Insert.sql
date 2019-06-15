INSERT INTO Animal
  (id, 
  location_id, 
  date_of_arrival, 
  species_id, 
  name, 
  care_notes) 
VALUES 
  (?, 
  ?, 
  ?, 
  ?, 
  ?, 
  ?);
INSERT INTO "Animal History"
  (animal_id, 
  move_in_date, 
  location_id, 
  move_out_date) 
VALUES 
  (?, 
  ?, 
  ?, 
  ?);
INSERT INTO Employee
  (id, 
  location_id, 
  first_name, 
  last_name, 
  job_title, 
  supervisor_id, 
  Employeelocation_id) 
VALUES 
  (?, 
  ?, 
  ?, 
  ?, 
  ?, 
  ?, 
  ?);
INSERT INTO Equipment
  (id, 
  location_id, 
  name, 
  description) 
VALUES 
  (?, 
  ?, 
  ?, 
  ?);
INSERT INTO Location
  (id, 
  parent_localization_id, 
  type, 
  name) 
VALUES 
  (?, 
  ?, 
  ?, 
  ?);
INSERT INTO Species
  (id, 
  common_name, 
  scientific_name, 
  conservation_status, 
  description) 
VALUES 
  (?, 
  ?, 
  ?, 
  ?, 
  ?);
INSERT INTO Task
  (task_id, 
  animal_id, 
  employee_id, 
  location_id, 
  assigned_at, 
  deadline, 
  description, 
  Employeelocation_id) 
VALUES 
  (?, 
  ?, 
  ?, 
  ?, 
  ?, 
  ?, 
  ?, 
  ?);
INSERT INTO "Work Time"
  (shift_start, 
  employee_id, 
  shift_end, 
  Employeelocation_id) 
VALUES 
  (?, 
  ?, 
  ?, 
  ?);
