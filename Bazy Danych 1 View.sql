CREATE VIEW Animal_Information_View AS
SELECT a.id, a.name, a.date_of_arrival, a.care_notes, 
       l.type AS "location_type", l.name AS "location_name",
       s.common_name AS "species_common_name", s.conservation_status 
FROM animal a, location l, species s
WHERE a.location_id = l.id AND a.species_id = s.id;
