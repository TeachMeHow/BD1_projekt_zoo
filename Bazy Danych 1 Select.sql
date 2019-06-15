SELECT id, location_id, date_of_arrival, species_id, name, care_notes 
  FROM Animal;
SELECT animal_id, move_in_date, location_id, move_out_date 
  FROM "Animal History";
SELECT id, location_id, first_name, last_name, job_title, supervisor_id, Employeelocation_id 
  FROM Employee;
SELECT id, location_id, name, description 
  FROM Equipment;
SELECT id, parent_localization_id, type, name 
  FROM Location;
SELECT id, common_name, scientific_name, conservation_status, description 
  FROM Species;
SELECT task_id, animal_id, employee_id, location_id, assigned_at, deadline, description, Employeelocation_id 
  FROM Task;
SELECT shift_start, employee_id, shift_end, Employeelocation_id 
  FROM "Work Time";

