UPDATE Animal SET 
  location_id = ?, 
  date_of_arrival = ?, 
  species_id = ?, 
  name = ?, 
  care_notes = ? 
WHERE
  id = ?;
UPDATE "Animal History" SET 
  location_id = ?, 
  move_out_date = ? 
WHERE
  animal_id = ? AND move_in_date = ?;
UPDATE Employee SET 
  location_id = ?, 
  first_name = ?, 
  last_name = ?, 
  job_title = ?, 
  supervisor_id = ?, 
  Employeelocation_id = ? 
WHERE
  id = ?;
UPDATE Equipment SET 
  location_id = ?, 
  name = ?, 
  description = ? 
WHERE
  id = ?;
UPDATE Location SET 
  parent_localization_id = ?, 
  type = ?, 
  name = ? 
WHERE
  id = ?;
UPDATE Species SET 
  common_name = ?, 
  scientific_name = ?, 
  conservation_status = ?, 
  description = ? 
WHERE
  id = ?;
UPDATE Task SET 
  animal_id = ?, 
  employee_id = ?, 
  location_id = ?, 
  assigned_at = ?, 
  deadline = ?, 
  description = ?, 
  Employeelocation_id = ? 
WHERE
  task_id = ?;
UPDATE "Work Time" SET 
  shift_end = ? 
WHERE
  shift_start = ? AND employee_id = ? AND Employeelocation_id = ?;

