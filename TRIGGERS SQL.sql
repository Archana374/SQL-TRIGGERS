##Create the teachers table and insert 8 rows
CREATE TABLE teachers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    subject VARCHAR(50) NOT NULL,
    experience INT NOT NULL,
    salary DECIMAL(10, 2) NOT NULL
);

INSERT INTO teachers (name, subject, experience, salary) VALUES
('ARCHANA JAY', 'Math', 5, 50000.00),
('DIVYA KRISHNA', 'Science', 8, 55000.00),
('RITHIKA SOORAJ', 'English', 12, 60000.00),
('VAMIKA S', 'History', 3, 45000.00),
('DEVAGNI JAY', 'Math', 2, 40000.00),
('KASHI NATH', 'Science', 7, 48000.00),
('UNNI MUKUNDAN', 'English', 10, 62000.00),
('DEV DARSHITH', 'History', 15, 70000.00);

##Create the before_insert_teacher trigger

DELIMITER $$

CREATE TRIGGER before_insert_teacher
BEFORE INSERT ON teachers
FOR EACH ROW
BEGIN
    IF NEW.salary < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Salary cannot be negative';
    END IF;
END;

$$

DELIMITER ;
##Create the after_insert_teacher trigger

CREATE TABLE teacher_log (
    teacher_id INT,
    action VARCHAR(50),
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$

CREATE TRIGGER after_insert_teacher
AFTER INSERT ON teachers
FOR EACH ROW
BEGIN
    INSERT INTO teacher_log (teacher_id, action, timestamp)
    VALUES (NEW.id, 'INSERT', NOW());
END;

$$

DELIMITER ;


##Create the before_delete trigger
DELIMITER $$

CREATE TRIGGER before_delete_teacher
BEFORE DELETE ON teachers
FOR EACH ROW
BEGIN
    IF OLD.experience > 10 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete teacher with more than 10 years of experience';
    END IF;
END;

$$

DELIMITER ;

##Create the after_delete trigger

DELIMITER $$

CREATE TRIGGER after_delete_teacher
AFTER DELETE ON teachers
FOR EACH ROW
BEGIN
    INSERT INTO teacher_log (teacher_id, action, timestamp)
    VALUES (OLD.id, 'DELETE', NOW());
END;

$$

DELIMITER ;