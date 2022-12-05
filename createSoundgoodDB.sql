CREATE DATABASE soundgood;

\c soundgood

CREATE TYPE SKILL AS ENUM ('beginner', 'intermediate', 'advanced');

CREATE TABLE instrument_type (
 instrument_type VARCHAR(100) NOT NULL
);

ALTER TABLE instrument_type ADD CONSTRAINT PK_instrument_type PRIMARY KEY (instrument_type);

CREATE TABLE instruments_in_stock (
 id SERIAL,
 instrument_type VARCHAR(100) NOT NULL,
 brand VARCHAR(100),
 model VARCHAR(100),
 information VARCHAR(250),
 price VARCHAR(10000) NOT NULL
);

ALTER TABLE instruments_in_stock ADD CONSTRAINT PK_instruments_in_stock PRIMARY KEY (id);


CREATE TABLE person (
 id SERIAL,
 first_name VARCHAR(100) NOT NULL,
 last_name VARCHAR(250) NOT NULL,
 social_security_number  VARCHAR(12) NOT NULL UNIQUE,
 email  VARCHAR(100) NOT NULL UNIQUE,
 city VARCHAR(100) NOT NULL,
 street VARCHAR(100) NOT NULL,
 zip_code VARCHAR(5) NOT NULL,
 house_number VARCHAR(10)
);

ALTER TABLE person ADD CONSTRAINT PK_person PRIMARY KEY (id);


CREATE TABLE person_phone (
 phone_number  VARCHAR(12) NOT NULL,
 person_id INT NOT NULL
);

ALTER TABLE person_phone ADD CONSTRAINT PK_person_phone PRIMARY KEY (phone_number ,person_id);


CREATE TABLE physical_instrument (
 id SERIAL,
 instruments_in_stock_id INT NOT NULL
);

ALTER TABLE physical_instrument ADD CONSTRAINT PK_physical_instrument PRIMARY KEY (id);


CREATE TABLE price (
 id SERIAL,
 amount VARCHAR(10) NOT NULL,
 pricing_scheme VARCHAR(250)
);

ALTER TABLE price ADD CONSTRAINT PK_price PRIMARY KEY (id);


CREATE TABLE student (
 id SERIAL,
 person_id INT NOT NULL
);

ALTER TABLE student ADD CONSTRAINT PK_student PRIMARY KEY (id);


CREATE TABLE student_instrument_skill_level (
 student_id INT NOT NULL,
 instrument_type VARCHAR(100) NOT NULL,
 skill_level SKILL NOT NULL
);

ALTER TABLE student_instrument_skill_level ADD CONSTRAINT PK_student_instrument_skill_level PRIMARY KEY (student_id,instrument_type,skill_level);


CREATE TABLE time_slot (
 id SERIAL,
 date DATE NOT NULL,
 start_time TIME(6) NOT NULL,
 end_time  TIME(6) NOT NULL
);

ALTER TABLE time_slot ADD CONSTRAINT PK_time_slot PRIMARY KEY (id);


CREATE TABLE emergency_contact (
 student_id INT NOT NULL,
 student_relation VARCHAR(250),
 phone_number VARCHAR(12) NOT NULL
);

ALTER TABLE emergency_contact ADD CONSTRAINT PK_emergency_contact PRIMARY KEY (student_id);


CREATE TABLE instructor (
 id SERIAL,
 person_id INT NOT NULL
);

ALTER TABLE instructor ADD CONSTRAINT PK_instructor PRIMARY KEY (id);


CREATE TABLE instructor_instrument_type (
 instructor_id INT NOT NULL,
 instrument_type VARCHAR(100) NOT NULL
);

ALTER TABLE instructor_instrument_type ADD CONSTRAINT PK_instructor_instrument_type PRIMARY KEY (instructor_id,instrument_type);


CREATE TABLE private_lesson (
 student_id INT NOT NULL,
 instructor_id INT NOT NULL,
 time_slot_id INT NOT NULL,
 instrument_type VARCHAR(100) NOT NULL,
 price_id INT NOT NULL,
 skill_level SKILL NOT NULL
);

ALTER TABLE private_lesson ADD CONSTRAINT PK_private_lesson PRIMARY KEY (student_id,instructor_id,time_slot_id);


CREATE TABLE rental (
 student_id INT NOT NULL,
 physical_instrument_id INT NOT NULL,
 start_date DATE NOT NULL,
 end_date DATE NOT NULL
);

ALTER TABLE rental ADD CONSTRAINT PK_rental PRIMARY KEY (student_id,physical_instrument_id);


CREATE TABLE sibling (
 student_id INT NOT NULL,
 sibling_id INT NOT NULL
);

ALTER TABLE sibling ADD CONSTRAINT PK_sibling PRIMARY KEY (student_id,sibling_id);


CREATE TABLE ensemble (
 id SERIAL,
 instructor_id INT NOT NULL,
 min_number_of_students INT NOT NULL,
 max_number_of_students INT NOT NULL,
 genre VARCHAR(100),
 price_id INT NOT NULL,
 skill_level SKILL NOT NULL,
 time_slot_id INT NOT NULL
);

ALTER TABLE ensemble ADD CONSTRAINT PK_ensemble PRIMARY KEY (id);


CREATE TABLE ensemble_instrument_type (
 instrument_type VARCHAR(100) NOT NULL,
 ensemble_id INT NOT NULL
);

ALTER TABLE ensemble_instrument_type ADD CONSTRAINT PK_ensemble_instrument_type PRIMARY KEY (instrument_type,ensemble_id);


CREATE TABLE ensemble_student (
 student_id INT NOT NULL,
 ensemble_id INT NOT NULL
);

ALTER TABLE ensemble_student ADD CONSTRAINT PK_ensemble_student PRIMARY KEY (student_id,ensemble_id);


CREATE TABLE group_lesson (
 id SERIAL,
 min_number_of_students INT NOT NULL,
 max_number_of_students INT NOT NULL,
 instrument_type VARCHAR(100) NOT NULL,
 instructor_id INT NOT NULL,
 price_id INT NOT NULL,
 skill_level SKILL NOT NULL,
 time_slot_id INT NOT NULL
);

ALTER TABLE group_lesson ADD CONSTRAINT PK_group_lesson PRIMARY KEY (id);


CREATE TABLE group_lesson_student (
 student_id INT NOT NULL,
 group_lesson_id INT NOT NULL
);

ALTER TABLE group_lesson_student ADD CONSTRAINT PK_group_lesson_student PRIMARY KEY (student_id,group_lesson_id);


ALTER TABLE person_phone ADD CONSTRAINT FK_person_phone_0 FOREIGN KEY (person_id) REFERENCES person (id) ON DELETE CASCADE;


ALTER TABLE physical_instrument ADD CONSTRAINT FK_physical_instrument_0 FOREIGN KEY (instruments_in_stock_id) REFERENCES instruments_in_stock (id);


ALTER TABLE student ADD CONSTRAINT FK_student_0 FOREIGN KEY (person_id) REFERENCES person (id);


ALTER TABLE student_instrument_skill_level ADD CONSTRAINT FK_student_instrument_skill_level_0 FOREIGN KEY (student_id) REFERENCES student (id) ON DELETE CASCADE;
ALTER TABLE student_instrument_skill_level ADD CONSTRAINT FK_student_instrument_skill_level_1 FOREIGN KEY (instrument_type) REFERENCES instrument_type (instrument_type) ON DELETE CASCADE;


ALTER TABLE emergency_contact ADD CONSTRAINT FK_emergency_contact_0 FOREIGN KEY (student_id) REFERENCES student (id) ON DELETE CASCADE;


ALTER TABLE instructor ADD CONSTRAINT FK_instructor_0 FOREIGN KEY (person_id) REFERENCES person (id);


ALTER TABLE instructor_instrument_type ADD CONSTRAINT FK_instructor_instrument_type_0 FOREIGN KEY (instructor_id) REFERENCES instructor (id) ON DELETE CASCADE;
ALTER TABLE instructor_instrument_type ADD CONSTRAINT FK_instructor_instrument_type_1 FOREIGN KEY (instrument_type) REFERENCES instrument_type (instrument_type) ON DELETE CASCADE;


ALTER TABLE private_lesson ADD CONSTRAINT FK_private_lesson_0 FOREIGN KEY (student_id) REFERENCES student (id) ON DELETE CASCADE;
ALTER TABLE private_lesson ADD CONSTRAINT FK_private_lesson_1 FOREIGN KEY (instructor_id) REFERENCES instructor (id) ON DELETE CASCADE;
ALTER TABLE private_lesson ADD CONSTRAINT FK_private_lesson_2 FOREIGN KEY (time_slot_id) REFERENCES time_slot (id);
ALTER TABLE private_lesson ADD CONSTRAINT FK_private_lesson_3 FOREIGN KEY (instrument_type) REFERENCES instrument_type (instrument_type);
ALTER TABLE private_lesson ADD CONSTRAINT FK_private_lesson_4 FOREIGN KEY (price_id) REFERENCES price (id);


ALTER TABLE rental ADD CONSTRAINT FK_rental_0 FOREIGN KEY (student_id) REFERENCES student (id) ON DELETE CASCADE;
ALTER TABLE rental ADD CONSTRAINT FK_rental_1 FOREIGN KEY (physical_instrument_id) REFERENCES physical_instrument (id) ON DELETE CASCADE;


ALTER TABLE sibling ADD CONSTRAINT FK_sibling_0 FOREIGN KEY (student_id) REFERENCES student (id);
ALTER TABLE sibling ADD CONSTRAINT FK_sibling_1 FOREIGN KEY (sibling_id) REFERENCES student (id);


ALTER TABLE ensemble ADD CONSTRAINT FK_ensemble_0 FOREIGN KEY (instructor_id) REFERENCES instructor (id);
ALTER TABLE ensemble ADD CONSTRAINT FK_ensemble_1 FOREIGN KEY (price_id) REFERENCES price (id);
ALTER TABLE ensemble ADD CONSTRAINT FK_ensemble_2 FOREIGN KEY (time_slot_id) REFERENCES time_slot (id);


ALTER TABLE ensemble_instrument_type ADD CONSTRAINT FK_ensemble_instrument_type_0 FOREIGN KEY (instrument_type) REFERENCES instrument_type (instrument_type) ON DELETE CASCADE;
ALTER TABLE ensemble_instrument_type ADD CONSTRAINT FK_ensemble_instrument_type_1 FOREIGN KEY (ensemble_id) REFERENCES ensemble (id) ON DELETE CASCADE;


ALTER TABLE ensemble_student ADD CONSTRAINT FK_ensemble_student_0 FOREIGN KEY (student_id) REFERENCES student (id) ON DELETE CASCADE;
ALTER TABLE ensemble_student ADD CONSTRAINT FK_ensemble_student_1 FOREIGN KEY (ensemble_id) REFERENCES ensemble (id) ON DELETE CASCADE;


ALTER TABLE group_lesson ADD CONSTRAINT FK_group_lesson_0 FOREIGN KEY (instrument_type) REFERENCES instrument_type (instrument_type);
ALTER TABLE group_lesson ADD CONSTRAINT FK_group_lesson_1 FOREIGN KEY (instructor_id) REFERENCES instructor (id);
ALTER TABLE group_lesson ADD CONSTRAINT FK_group_lesson_2 FOREIGN KEY (price_id) REFERENCES price (id);
ALTER TABLE group_lesson ADD CONSTRAINT FK_group_lesson_3 FOREIGN KEY (time_slot_id) REFERENCES time_slot (id);


ALTER TABLE group_lesson_student ADD CONSTRAINT FK_group_lesson_student_0 FOREIGN KEY (student_id) REFERENCES student (id) ON DELETE CASCADE;
ALTER TABLE group_lesson_student ADD CONSTRAINT FK_group_lesson_student_1 FOREIGN KEY (group_lesson_id) REFERENCES group_lesson (id) ON DELETE CASCADE;


