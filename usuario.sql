CREATE USER 'quickstock_desarrollador'@'localhost' IDENTIFIED BY 'quickstock';

GRANT SELECT, INSERT, UPDATE, DELETE ON quickstock.* TO 'quickstock_desarrollador'@'localhost'; 

GRANT EXECUTE, CREATE ROUTINE, TRIGGER, CREATE VIEW ON quickstock.* TO 'quickstock_desarrollador'@'localhost';
