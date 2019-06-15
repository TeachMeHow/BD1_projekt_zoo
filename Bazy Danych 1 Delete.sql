DELETE FROM Animal 
  WHERE id = ?;
DELETE FROM "Animal History" 
  WHERE animal_id = ? AND move_in_date = ?;
DELETE FROM Employee 
  WHERE id = ?;
DELETE FROM Equipment 
  WHERE id = ?;
DELETE FROM Location 
  WHERE id = ?;
DELETE FROM Species 
  WHERE id = ?;
DELETE FROM Task 
  WHERE task_id = ?;
DELETE FROM "Work Time" 
  WHERE shift_start = ? AND employee_id = ? AND Employeelocation_id = ?;

