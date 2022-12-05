CREATE VIEW monthly_lessons AS
SELECT
    EXTRACT(YEAR FROM DATE(ts.date)) AS year,
    EXTRACT(MONTH FROM DATE(ts.date)) AS month,
	COUNT(DISTINCT private_lesson) AS private_lesson_count,
	COUNT(DISTINCT group_lesson) AS group_lesson_count,
    COUNT(DISTINCT ensemble) AS ensemble_count,
    (SELECT 
        COUNT(DISTINCT private_lesson) 
        + COUNT(DISTINCT group_lesson) 
        + COUNT(DISTINCT ensemble)
    ) AS total_lessons_ensembles
FROM time_slot AS ts
  LEFT JOIN private_lesson ON private_lesson.time_slot_id = ts.id
  LEFT JOIN group_lesson ON group_lesson.time_slot_id = ts.id
  LEFT JOIN ensemble ON ensemble.time_slot_id = ts.id
GROUP BY year, month;






CREATE MATERIALIZED VIEW student_sibling_count AS
SELECT nmbr_of_siblings, COUNT(*) AS nmbr_of_students FROM(
SELECT COUNT(*)-1 AS nmbr_of_siblings
FROM (
    SELECT sibling.student_id FROM sibling
    UNION ALL
    SELECT sibling.sibling_id FROM sibling
    UNION ALL
    SELECT student.id FROM student
) AS siblings
GROUP BY siblings.student_id
) AS student_number_of_siblings
GROUP BY nmbr_of_siblings   
ORDER BY nmbr_of_siblings ASC;





CREATE VIEW current_month_instructor_lessons AS
SELECT instructor.id, CONCAT(person.first_name, ' ', person.last_name) AS instructor_name, COUNT(*) AS lesson_count
FROM (
    SELECT instructor_id, time_slot_id  FROM private_lesson
    UNION ALL
    SELECT instructor_id, time_slot_id  FROM group_lesson
    UNION ALL
    SELECT instructor_id, time_slot_id  FROM ensemble
) AS all_lessons
LEFT JOIN time_slot AS ts ON all_lessons.time_slot_id = ts.id
LEFT JOIN instructor ON instructor.id = instructor_id
LEFT JOIN person ON person.id = instructor.person_id
RIGHT JOIN CURRENT_DATE ON EXTRACT(MONTH FROM DATE(ts.date)) = EXTRACT(MONTH FROM DATE(CURRENT_DATE))
GROUP BY instructor.id, instructor_name
ORDER BY lesson_count DESC;





CREATE VIEW ensemble_nmbr_of_enrollments AS
SELECT COUNT(*), ensemble_id FROm ensemble_student GROUP BY ensemble_id;

CREATE VIEW remaining_seats_for_ensembles AS
SELECT to_char(DATE(ts.date), 'Day') AS day, genre,
CASE
    WHEN 
    ensemble.max_number_of_students <= ensemble_nmbr_of_enrollments.count
    THEN
    'FULL'
    WHEN
    ensemble.max_number_of_students-2 <= ensemble_nmbr_of_enrollments.count
    THEN
    '1-2 SEATS LEFT'
    ELSE
    'SEATS LEFT'
    END seats
FROM ensemble
LEFT JOIN time_slot AS ts 
ON ts.id = ensemble.time_slot_id
LEFT JOIN ensemble_nmbr_of_enrollments
ON ensemble_nmbr_of_enrollments.ensemble_id = ensemble.id
WHERE (SELECT EXTRACT(WEEK FROM DATE(ts.date)))
    =(SELECT EXTRACT(WEEK FROM DATE(CURRENT_DATE)))+1
ORDER BY ts.date ASC, genre ASC;
