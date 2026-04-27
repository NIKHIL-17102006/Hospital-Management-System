-- ============================================================
-- Hospital Management System - Full SQL Dump
-- Database: hospital_mgmt
-- Generated: 2026-04-27
-- ============================================================

CREATE DATABASE IF NOT EXISTS hospital_mgmt;
USE hospital_mgmt;

-- ============================================================
-- TABLE: department
-- ============================================================
CREATE TABLE IF NOT EXISTS department (
    Dept_ID   INT PRIMARY KEY AUTO_INCREMENT,
    Dept_Name VARCHAR(100) NOT NULL,
    Dept_Head VARCHAR(100)
);

INSERT INTO department (Dept_ID, Dept_Name, Dept_Head) VALUES
(1,  'Cardiology',       'Dr. Rajesh Sharma'),
(2,  'Orthopedics',      'Dr. Priya Mehta'),
(3,  'Neurology',        'Dr. Anil Kapoor'),
(4,  'Emergency',        'Dr. Sunita Rao'),
(5,  'Pediatrics',       'Dr. Vikram Singh'),
(6,  'Dermatology',      'Dr. Neha Gupta'),
(7,  'Oncology',         'Dr. Ramesh Iyer'),
(8,  'Gynecology',       'Dr. Anjali Bose'),
(9,  'Radiology',        'Dr. Suresh Nair'),
(10, 'Psychiatry',       'Dr. Meena Joshi'),
(11, 'Gastroenterology', 'Dr. Deepak Verma'),
(12, 'Urology',          'Dr. Kavita Pillai'),
(13, 'ENT',              'Dr. Ashok Tiwari'),
(14, 'Ophthalmology',    'Dr. Rekha Das'),
(15, 'Nephrology',       'Dr. Sanjay Pandey'),
(16, 'Pulmonology',      'Dr. Lalita Choudhary'),
(17, 'Endocrinology',    'Dr. Harish Kumar'),
(18, 'Hematology',       'Dr. Pooja Saxena');


-- ============================================================
-- TABLE: staff
-- ============================================================
CREATE TABLE IF NOT EXISTS staff (
    Emp_ID          INT PRIMARY KEY AUTO_INCREMENT,
    First_Name      VARCHAR(50)  NOT NULL,
    Last_Name       VARCHAR(50)  NOT NULL,
    DOB             DATE,
    Email           VARCHAR(100) UNIQUE,
    Phone           VARCHAR(15),
    Address         VARCHAR(255),
    Date_Joining    DATE,
    Date_Separation DATE,
    Role_Type       ENUM('Doctor','Nurse','Admin','Other') NOT NULL,
    Dept_ID         INT,
    FOREIGN KEY (Dept_ID) REFERENCES department(Dept_ID)
);

INSERT INTO staff (Emp_ID, First_Name, Last_Name, DOB, Email, Phone, Address, Date_Joining, Date_Separation, Role_Type, Dept_ID) VALUES
(1,  'Rajesh',  'Sharma',    '1972-04-15', 'rajesh.sharma@hospital.com', '9876543201', '12 MG Road Delhi',             '2005-06-01', NULL, 'Doctor', 1),
(2,  'Priya',   'Mehta',     '1978-09-22', 'priya.mehta@hospital.com',   '9876543202', '34 Park Street Mumbai',         '2008-03-15', NULL, 'Doctor', 2),
(3,  'Anil',    'Kapoor',    '1969-11-30', 'anil.kapoor@hospital.com',   '9876543203', '56 Nehru Nagar Pune',           '2002-01-10', NULL, 'Doctor', 3),
(4,  'Sunita',  'Rao',       '1980-07-05', 'sunita.rao@hospital.com',    '9876543204', '78 Anna Salai Chennai',         '2010-08-20', NULL, 'Doctor', 4),
(5,  'Vikram',  'Singh',     '1975-03-18', 'vikram.singh@hospital.com',  '9876543205', '90 Civil Lines Lucknow',        '2007-05-12', NULL, 'Doctor', 5),
(6,  'Neha',    'Gupta',     '1983-12-25', 'neha.gupta@hospital.com',    '9876543206', '23 Rajpath Jaipur',             '2012-11-01', NULL, 'Doctor', 6),
(7,  'Ramesh',  'Iyer',      '1968-08-14', 'ramesh.iyer@hospital.com',   '9876543207', '45 Brigade Road Bangalore',     '2000-04-22', NULL, 'Doctor', 7),
(8,  'Anjali',  'Bose',      '1977-06-09', 'anjali.bose@hospital.com',   '9876543208', '67 Lake Town Kolkata',          '2006-07-30', NULL, 'Doctor', 8),
(9,  'Suresh',  'Nair',      '1981-02-28', 'suresh.nair@hospital.com',   '9876543209', '89 MG Road Kochi',              '2011-09-05', NULL, 'Doctor', 9),
(10, 'Meena',   'Joshi',     '1974-10-17', 'meena.joshi@hospital.com',   '9876543210', '11 Banjara Hills Hyderabad',   '2004-02-14', NULL, 'Doctor', 10),
(11, 'Kavya',   'Reddy',     '1990-05-20', 'kavya.reddy@hospital.com',   '9876543211', '22 Koramangala Bangalore',      '2015-06-10', NULL, 'Nurse',  1),
(12, 'Ritu',    'Sharma',    '1992-08-11', 'ritu.sharma@hospital.com',   '9876543212', '33 Lajpat Nagar Delhi',         '2016-03-22', NULL, 'Nurse',  2),
(13, 'Pooja',   'Tiwari',    '1991-01-15', 'pooja.tiwari@hospital.com',  '9876543213', '44 Andheri Mumbai',             '2014-09-01', NULL, 'Nurse',  3),
(14, 'Deepa',   'Nair',      '1993-07-04', 'deepa.nair@hospital.com',    '9876543214', '55 T Nagar Chennai',            '2017-01-15', NULL, 'Nurse',  4),
(15, 'Suman',   'Verma',     '1989-11-22', 'suman.verma@hospital.com',   '9876543215', '66 Hazratganj Lucknow',         '2013-08-20', NULL, 'Nurse',  5),
(16, 'Anita',   'Pillai',    '1994-03-30', 'anita.pillai@hospital.com',  '9876543216', '77 Indiranagar Bangalore',      '2018-05-11', NULL, 'Nurse',  7),
(17, 'Geeta',   'Mishra',    '1988-09-16', 'geeta.mishra@hospital.com',  '9876543217', '88 Karol Bagh Delhi',           '2012-10-05', NULL, 'Nurse',  8),
(18, 'Deepak',  'Verma',     '1971-05-12', 'deepak.verma@hospital.com',  '9876543218', '99 Salt Lake Kolkata',          '2003-03-18', NULL, 'Doctor', 11);


-- ============================================================
-- TABLE: doctor
-- ============================================================
CREATE TABLE IF NOT EXISTS doctor (
    Doctor_ID      INT PRIMARY KEY AUTO_INCREMENT,
    Emp_ID         INT NOT NULL UNIQUE,
    Specialization VARCHAR(100),
    Qualification  VARCHAR(150),
    FOREIGN KEY (Emp_ID) REFERENCES staff(Emp_ID)
);

INSERT INTO doctor (Doctor_ID, Emp_ID, Specialization, Qualification) VALUES
(1,  1,  'Interventional Cardiology', 'MBBS MD DM Cardiology'),
(2,  2,  'Joint Replacement Surgery', 'MBBS MS Orthopedics'),
(3,  3,  'Epilepsy & Stroke',         'MBBS MD DM Neurology'),
(4,  4,  'Emergency & Trauma',        'MBBS MD Emergency Medicine'),
(5,  5,  'Neonatology',               'MBBS MD Pediatrics'),
(6,  6,  'Cosmetic Dermatology',      'MBBS MD Dermatology'),
(7,  7,  'Surgical Oncology',         'MBBS MS MCh Oncology'),
(8,  8,  'High Risk Pregnancy',       'MBBS MD Gynecology'),
(9,  9,  'Interventional Radiology',  'MBBS MD Radiology'),
(10, 10, 'Child Psychiatry',          'MBBS MD Psychiatry');


-- ============================================================
-- TABLE: nurse
-- ============================================================
CREATE TABLE IF NOT EXISTS nurse (
    Nurse_ID INT PRIMARY KEY AUTO_INCREMENT,
    Emp_ID   INT NOT NULL UNIQUE,
    FOREIGN KEY (Emp_ID) REFERENCES staff(Emp_ID)
);

INSERT INTO nurse (Nurse_ID, Emp_ID) VALUES
(1, 11),
(2, 12),
(3, 13),
(4, 14),
(5, 15),
(6, 16),
(7, 17);


-- ============================================================
-- TABLE: shift
-- ============================================================
CREATE TABLE IF NOT EXISTS shift (
    Shift_ID   INT PRIMARY KEY AUTO_INCREMENT,
    Shift_Name VARCHAR(50),
    Start_Time TIME,
    End_Time   TIME
);

INSERT INTO shift (Shift_ID, Shift_Name, Start_Time, End_Time) VALUES
(1, 'Morning',       '06:00:00', '14:00:00'),
(2, 'Afternoon',     '14:00:00', '22:00:00'),
(3, 'Night',         '22:00:00', '06:00:00'),
(4, 'Early Morning', '05:00:00', '13:00:00'),
(5, 'Late Evening',  '18:00:00', '02:00:00');


-- ============================================================
-- TABLE: doctor_shift_assignment
-- ============================================================
CREATE TABLE IF NOT EXISTS doctor_shift_assignment (
    Assignment_ID INT PRIMARY KEY AUTO_INCREMENT,
    Doctor_ID     INT NOT NULL,
    Shift_ID      INT NOT NULL,
    Shift_Date    DATE NOT NULL,
    FOREIGN KEY (Doctor_ID) REFERENCES doctor(Doctor_ID),
    FOREIGN KEY (Shift_ID)  REFERENCES shift(Shift_ID)
);

INSERT INTO doctor_shift_assignment (Assignment_ID, Doctor_ID, Shift_ID, Shift_Date) VALUES
(1,  1,  1, '2025-01-06'),
(2,  2,  2, '2025-01-06'),
(3,  3,  3, '2025-01-06'),
(4,  4,  1, '2025-01-07'),
(5,  5,  2, '2025-01-07'),
(6,  6,  1, '2025-01-08'),
(7,  7,  3, '2025-01-08'),
(8,  8,  2, '2025-01-09'),
(9,  9,  1, '2025-01-09'),
(10, 10, 3, '2025-01-10'),
(11, 1,  2, '2025-01-10'),
(12, 2,  1, '2025-01-11'),
(13, 3,  2, '2025-01-11'),
(14, 4,  3, '2025-01-12'),
(15, 5,  1, '2025-01-12'),
(16, 6,  2, '2025-01-13'),
(17, 7,  1, '2025-01-13'),
(18, 8,  3, '2025-01-14');


-- ============================================================
-- TABLE: nurse_shift_assignment
-- ============================================================
CREATE TABLE IF NOT EXISTS nurse_shift_assignment (
    Assignment_ID INT PRIMARY KEY AUTO_INCREMENT,
    Nurse_ID      INT NOT NULL,
    Shift_ID      INT NOT NULL,
    Shift_Date    DATE NOT NULL,
    FOREIGN KEY (Nurse_ID) REFERENCES nurse(Nurse_ID),
    FOREIGN KEY (Shift_ID) REFERENCES shift(Shift_ID)
);

INSERT INTO nurse_shift_assignment (Assignment_ID, Nurse_ID, Shift_ID, Shift_Date) VALUES
(1,  1, 1, '2025-01-06'),
(2,  2, 2, '2025-01-06'),
(3,  3, 3, '2025-01-06'),
(4,  4, 1, '2025-01-07'),
(5,  5, 2, '2025-01-07'),
(6,  6, 3, '2025-01-07'),
(7,  7, 1, '2025-01-08'),
(8,  1, 2, '2025-01-08'),
(9,  2, 3, '2025-01-08'),
(10, 3, 1, '2025-01-09'),
(11, 4, 2, '2025-01-09'),
(12, 5, 3, '2025-01-09'),
(13, 6, 1, '2025-01-10'),
(14, 7, 2, '2025-01-10'),
(15, 1, 3, '2025-01-10'),
(16, 2, 1, '2025-01-11'),
(17, 3, 2, '2025-01-11'),
(18, 4, 3, '2025-01-11');


-- ============================================================
-- TABLE: patient
-- ============================================================
CREATE TABLE IF NOT EXISTS patient (
    Patient_ID      INT PRIMARY KEY AUTO_INCREMENT,
    First_Name      VARCHAR(50)  NOT NULL,
    Last_Name       VARCHAR(50)  NOT NULL,
    DOB             DATE,
    Gender          ENUM('Male','Female','Other'),
    Blood_Group     VARCHAR(5),
    Phone           VARCHAR(15),
    Email           VARCHAR(100),
    Address         VARCHAR(255),
    Admission_Date  DATE,
    Discharge_Date  DATE
);

INSERT INTO patient (Patient_ID, First_Name, Last_Name, DOB, Gender, Blood_Group, Phone, Email, Address, Admission_Date, Discharge_Date) VALUES
(1,  'Aarav',  'Kumar',     '1985-03-12', 'Male',   'A+',  '9811001001', 'aarav.kumar@gmail.com',     '101 Sector 15 Noida',         '2025-01-05', '2025-01-12'),
(2,  'Priya',  'Sharma',    '1990-07-22', 'Female', 'B+',  '9811001002', 'priya.sharma@gmail.com',    '202 Dwarka Delhi',            '2025-01-06', '2025-01-14'),
(3,  'Rohit',  'Verma',     '1978-11-08', 'Male',   'O+',  '9811001003', 'rohit.verma@gmail.com',     '303 Andheri Mumbai',          '2025-01-07', '2025-01-10'),
(4,  'Sneha',  'Patel',     '1995-05-30', 'Female', 'AB+', '9811001004', 'sneha.patel@gmail.com',     '404 Navrangpura Ahmedabad',   '2025-01-08', '2025-01-15'),
(5,  'Mohit',  'Agarwal',   '1982-09-17', 'Male',   'A-',  '9811001005', 'mohit.agarwal@gmail.com',   '505 Civil Lines Allahabad',   '2025-01-09', NULL),
(6,  'Kavita', 'Jain',      '1975-02-14', 'Female', 'B-',  '9811001006', 'kavita.jain@gmail.com',     '606 Malviya Nagar Jaipur',    '2025-01-10', '2025-01-18'),
(7,  'Arjun',  'Nair',      '1988-06-25', 'Male',   'O-',  '9811001007', 'arjun.nair@gmail.com',      '707 Ernakulam Kochi',         '2025-01-11', '2025-01-20'),
(8,  'Divya',  'Reddy',     '1993-12-03', 'Female', 'A+',  '9811001008', 'divya.reddy@gmail.com',     '808 Banjara Hills Hyderabad', '2025-01-12', NULL),
(9,  'Suresh', 'Mishra',    '1970-04-19', 'Male',   'B+',  '9811001009', 'suresh.mishra@gmail.com',   '909 Hazratganj Lucknow',      '2025-01-13', '2025-01-22'),
(10, 'Ananya', 'Singh',     '1999-08-07', 'Female', 'AB-', '9811001010', 'ananya.singh@gmail.com',    '100 Koramangala Bangalore',   '2025-01-14', '2025-01-21'),
(11, 'Karan',  'Mehta',     '1987-01-28', 'Male',   'O+',  '9811001011', 'karan.mehta@gmail.com',     '111 Salt Lake Kolkata',       '2025-01-15', NULL),
(12, 'Pooja',  'Iyer',      '1992-10-11', 'Female', 'A+',  '9811001012', 'pooja.iyer@gmail.com',      '222 T Nagar Chennai',         '2025-01-16', '2025-01-24'),
(13, 'Nikhil', 'Tiwari',    '1980-03-06', 'Male',   'B+',  '9811001013', 'nikhil.tiwari@gmail.com',   '333 Shivaji Nagar Pune',      '2025-01-17', '2025-01-25'),
(14, 'Ritu',   'Bose',      '1996-07-15', 'Female', 'O+',  '9811001014', 'ritu.bose@gmail.com',       '444 Lake Garden Kolkata',     '2025-01-18', NULL),
(15, 'Vivek',  'Pillai',    '1974-11-23', 'Male',   'A-',  '9811001015', 'vivek.pillai@gmail.com',    '555 Vile Parle Mumbai',       '2025-01-19', '2025-01-27'),
(16, 'Meera',  'Choudhary', '1989-05-09', 'Female', 'B+',  '9811001016', 'meera.choudhary@gmail.com', '666 Malviya Nagar Bhopal',    '2025-01-20', '2025-01-28'),
(17, 'Rahul',  'Saxena',    '1983-09-30', 'Male',   'AB+', '9811001017', 'rahul.saxena@gmail.com',    '777 Gomti Nagar Lucknow',     '2025-01-21', NULL),
(18, 'Sunita', 'Pandey',    '1977-02-18', 'Female', 'O-',  '9811001018', 'sunita.pandey@gmail.com',   '888 Rajpur Road Dehradun',    '2025-01-22', '2025-01-30');


-- ============================================================
-- TABLE: appointment
-- ============================================================
CREATE TABLE IF NOT EXISTS appointment (
    Appointment_ID   INT PRIMARY KEY AUTO_INCREMENT,
    Patient_ID       INT NOT NULL,
    Doctor_ID        INT NOT NULL,
    Appointment_Date DATE NOT NULL,
    Appointment_Time TIME NOT NULL,
    Status           ENUM('Scheduled','Completed','Cancelled') NOT NULL,
    Type             ENUM('OPD','Emergency','Follow-up') NOT NULL,
    FOREIGN KEY (Patient_ID) REFERENCES patient(Patient_ID),
    FOREIGN KEY (Doctor_ID)  REFERENCES doctor(Doctor_ID)
);

INSERT INTO appointment (Appointment_ID, Patient_ID, Doctor_ID, Appointment_Date, Appointment_Time, Status, Type) VALUES
(1,  1,  1,  '2025-01-05', '10:00:00', 'Completed', 'OPD'),
(2,  2,  2,  '2025-01-06', '11:30:00', 'Completed', 'OPD'),
(3,  3,  3,  '2025-01-07', '09:00:00', 'Completed', 'Emergency'),
(4,  4,  4,  '2025-01-08', '14:00:00', 'Completed', 'OPD'),
(5,  5,  5,  '2025-01-09', '10:30:00', 'Scheduled', 'Follow-up'),
(6,  6,  6,  '2025-01-10', '12:00:00', 'Completed', 'OPD'),
(7,  7,  7,  '2025-01-11', '15:00:00', 'Completed', 'OPD'),
(8,  8,  8,  '2025-01-12', '09:30:00', 'Scheduled', 'Emergency'),
(9,  9,  9,  '2025-01-13', '11:00:00', 'Completed', 'OPD'),
(10, 10, 10, '2025-01-14', '13:30:00', 'Completed', 'Follow-up'),
(11, 11, 1,  '2025-01-15', '10:00:00', 'Scheduled', 'OPD'),
(12, 12, 2,  '2025-01-16', '14:30:00', 'Completed', 'OPD'),
(13, 13, 3,  '2025-01-17', '09:00:00', 'Completed', 'OPD'),
(14, 14, 4,  '2025-01-18', '11:00:00', 'Scheduled', 'Follow-up'),
(15, 15, 5,  '2025-01-19', '10:30:00', 'Completed', 'OPD'),
(16, 16, 6,  '2025-01-20', '15:30:00', 'Completed', 'OPD'),
(17, 17, 7,  '2025-01-21', '12:00:00', 'Scheduled', 'OPD'),
(18, 18, 8,  '2025-01-22', '09:30:00', 'Completed', 'Emergency');


-- ============================================================
-- TABLE: insurance
-- ============================================================
CREATE TABLE IF NOT EXISTS insurance (
    Insurance_ID         INT PRIMARY KEY AUTO_INCREMENT,
    Patient_ID           INT NOT NULL,
    Provider             VARCHAR(100),
    Policy_Number        VARCHAR(50) UNIQUE,
    Coverage_Percentage  DECIMAL(5,2),
    Valid_From           DATE,
    Valid_To             DATE,
    FOREIGN KEY (Patient_ID) REFERENCES patient(Patient_ID)
);

INSERT INTO insurance (Insurance_ID, Patient_ID, Provider, Policy_Number, Coverage_Percentage, Valid_From, Valid_To) VALUES
(1,  1,  'Star Health Insurance',  'STAR-2021-001',  80.00, '2021-04-01', '2026-03-31'),
(2,  2,  'HDFC ERGO',              'HDFC-2022-002',  75.00, '2022-01-01', '2027-12-31'),
(3,  3,  'Bajaj Allianz',          'BAJA-2020-003',  70.00, '2020-06-01', '2025-05-31'),
(4,  4,  'ICICI Lombard',          'ICICI-2023-004', 85.00, '2023-03-01', '2028-02-28'),
(5,  6,  'New India Assurance',    'NIA-2021-006',   60.00, '2021-07-01', '2026-06-30'),
(6,  7,  'United India Insurance', 'UII-2022-007',   65.00, '2022-09-01', '2027-08-31'),
(7,  9,  'Oriental Insurance',     'ORI-2020-009',   70.00, '2020-11-01', '2025-10-31'),
(8,  10, 'Max Bupa',               'MAXB-2023-010',  80.00, '2023-01-01', '2028-12-31'),
(9,  12, 'Reliance Health',        'REL-2021-012',   75.00, '2021-05-01', '2026-04-30'),
(10, 13, 'Aditya Birla Health',    'ABH-2022-013',   85.00, '2022-08-01', '2027-07-31'),
(11, 15, 'Tata AIG',               'TATA-2021-015',  70.00, '2021-02-01', '2026-01-31'),
(12, 16, 'Star Health Insurance',  'STAR-2023-016',  80.00, '2023-06-01', '2028-05-31'),
(13, 18, 'HDFC ERGO',              'HDFC-2020-018',  65.00, '2020-10-01', '2025-09-30'),
(14, 5,  'Bajaj Allianz',          'BAJA-2022-005',  75.00, '2022-04-01', '2027-03-31'),
(15, 8,  'ICICI Lombard',          'ICICI-2021-008', 80.00, '2021-12-01', '2026-11-30'),
(16, 11, 'New India Assurance',    'NIA-2023-011',   70.00, '2023-02-01', '2028-01-31'),
(17, 14, 'Oriental Insurance',     'ORI-2022-014',   60.00, '2022-07-01', '2027-06-30'),
(18, 17, 'Max Bupa',               'MAXB-2021-017',  85.00, '2021-09-01', '2026-08-31');


-- ============================================================
-- TABLE: room
-- ============================================================
CREATE TABLE IF NOT EXISTS room (
    Room_ID            INT PRIMARY KEY AUTO_INCREMENT,
    Room_Type          VARCHAR(50),
    Room_Cost_Per_Day  DECIMAL(10,2)
);

INSERT INTO room (Room_ID, Room_Type, Room_Cost_Per_Day) VALUES
(1,  'General',     500.00),
(2,  'General',     500.00),
(3,  'General',     500.00),
(4,  'Semi-Private', 1200.00),
(5,  'Semi-Private', 1200.00),
(6,  'Semi-Private', 1200.00),
(7,  'Private',     2500.00),
(8,  'Private',     2500.00),
(9,  'Private',     2500.00),
(10, 'ICU',         8000.00),
(11, 'ICU',         8000.00),
(12, 'ICU',         8000.00),
(13, 'NICU',        10000.00),
(14, 'NICU',        10000.00),
(15, 'HDU',         5000.00),
(16, 'HDU',         5000.00),
(17, 'Deluxe',      4000.00),
(18, 'Suite',       7000.00);


-- ============================================================
-- TABLE: room_assignment
-- ============================================================
CREATE TABLE IF NOT EXISTS room_assignment (
    Assignment_ID   INT PRIMARY KEY AUTO_INCREMENT,
    Room_ID         INT NOT NULL,
    Patient_ID      INT NOT NULL,
    Admit_Date      DATE NOT NULL,
    Discharge_Date  DATE,
    FOREIGN KEY (Room_ID)    REFERENCES room(Room_ID),
    FOREIGN KEY (Patient_ID) REFERENCES patient(Patient_ID)
);

INSERT INTO room_assignment (Assignment_ID, Room_ID, Patient_ID, Admit_Date, Discharge_Date) VALUES
(1,  1,  1,  '2025-01-05', '2025-01-12'),
(2,  4,  2,  '2025-01-06', '2025-01-14'),
(3,  7,  3,  '2025-01-07', '2025-01-10'),
(4,  10, 4,  '2025-01-08', '2025-01-15'),
(5,  2,  5,  '2025-01-09', NULL),
(6,  5,  6,  '2025-01-10', '2025-01-18'),
(7,  8,  7,  '2025-01-11', '2025-01-20'),
(8,  11, 8,  '2025-01-12', NULL),
(9,  3,  9,  '2025-01-13', '2025-01-22'),
(10, 6,  10, '2025-01-14', '2025-01-21'),
(11, 9,  11, '2025-01-15', NULL),
(12, 12, 12, '2025-01-16', '2025-01-24'),
(13, 13, 13, '2025-01-17', '2025-01-25'),
(14, 15, 14, '2025-01-18', NULL),
(15, 17, 15, '2025-01-19', '2025-01-27'),
(16, 18, 16, '2025-01-20', '2025-01-28'),
(17, 14, 17, '2025-01-21', NULL),
(18, 16, 18, '2025-01-22', '2025-01-30');


-- ============================================================
-- TABLE: lab_test
-- ============================================================
CREATE TABLE IF NOT EXISTS lab_test (
    Test_ID   INT PRIMARY KEY AUTO_INCREMENT,
    Test_Name VARCHAR(100) NOT NULL,
    Test_Cost DECIMAL(10,2)
);

INSERT INTO lab_test (Test_ID, Test_Name, Test_Cost) VALUES
(1,  'Complete Blood Count (CBC)', 350.00),
(2,  'Blood Glucose Fasting',      150.00),
(3,  'Lipid Profile',              600.00),
(4,  'Liver Function Test (LFT)',  700.00),
(5,  'Kidney Function Test (KFT)', 700.00),
(6,  'Thyroid Function Test',      900.00),
(7,  'ECG',                        400.00),
(8,  'Chest X-Ray',                500.00),
(9,  'MRI Brain',                  5000.00),
(10, 'CT Scan Abdomen',            4500.00),
(11, 'Urine Routine',              200.00),
(12, 'HbA1c',                      550.00),
(13, 'Dengue NS1 Antigen',         800.00),
(14, 'COVID-19 RT-PCR',            900.00),
(15, 'Ultrasound Abdomen',         1200.00),
(16, '2D Echo',                    2500.00),
(17, 'Blood Culture',              1200.00),
(18, 'Vitamin D Level',            800.00);


-- ============================================================
-- TABLE: lab_report
-- ============================================================
CREATE TABLE IF NOT EXISTS lab_report (
    Report_ID  INT PRIMARY KEY AUTO_INCREMENT,
    Patient_ID INT NOT NULL,
    Doctor_ID  INT NOT NULL,
    Test_ID    INT NOT NULL,
    Test_Date  DATE,
    Result     TEXT,
    FOREIGN KEY (Patient_ID) REFERENCES patient(Patient_ID),
    FOREIGN KEY (Doctor_ID)  REFERENCES doctor(Doctor_ID),
    FOREIGN KEY (Test_ID)    REFERENCES lab_test(Test_ID)
);

INSERT INTO lab_report (Report_ID, Patient_ID, Doctor_ID, Test_ID, Test_Date, Result) VALUES
(1,  1,  1,  7,  '2025-01-05', 'Normal sinus rhythm. No ST changes.'),
(2,  1,  1,  16, '2025-01-06', 'EF 55%. Mild LVH noted.'),
(3,  2,  2,  1,  '2025-01-07', 'Hb 10.2 g/dL. WBC 8200. Platelets normal.'),
(4,  3,  3,  9,  '2025-01-07', 'Mild cortical atrophy. No bleed or infarct.'),
(5,  4,  4,  1,  '2025-01-08', 'WBC 14500 elevated. Suggestive of infection.'),
(6,  5,  5,  2,  '2025-01-09', 'Fasting glucose 78 mg/dL. Normal.'),
(7,  6,  6,  11, '2025-01-10', 'RBC count normal. No casts. Slight protein.'),
(8,  7,  7,  1,  '2025-01-11', 'WBC 3200 low post-chemo. Monitor.'),
(9,  8,  8,  15, '2025-01-12', 'Single live intrauterine fetus. 28 weeks.'),
(10, 9,  9,  10, '2025-01-13', 'No abdominal mass. Mild fatty liver.'),
(11, 10, 10, 1,  '2025-01-14', 'All parameters within normal limits.'),
(12, 11, 1,  3,  '2025-01-15', 'Total cholesterol 220 mg/dL. LDL 145 mg/dL.'),
(13, 12, 2,  8,  '2025-01-16', 'Fracture line visible. Callus formation beginning.'),
(14, 13, 3,  9,  '2025-01-17', 'Temporal lobe focus seen. Consistent with epilepsy.'),
(15, 14, 4,  13, '2025-01-18', 'Dengue NS1 Negative. IgM Positive.'),
(16, 15, 5,  8,  '2025-01-19', 'Hyperinflated lungs. Consistent with asthma.'),
(17, 16, 6,  11, '2025-01-20', 'Normal. No proteinuria.'),
(18, 17, 7,  1,  '2025-01-21', 'WBC 4100. RBC 3.8. Hb 11.0.');


-- ============================================================
-- TABLE: medicine
-- ============================================================
CREATE TABLE IF NOT EXISTS medicine (
    Medicine_ID   INT PRIMARY KEY AUTO_INCREMENT,
    Medicine_Name VARCHAR(100) NOT NULL,
    Manufacturer  VARCHAR(100),
    Category      VARCHAR(50)
);

INSERT INTO medicine (Medicine_ID, Medicine_Name, Manufacturer, Category) VALUES
(1,  'Paracetamol 500mg',   'Sun Pharma',   'Analgesic'),
(2,  'Amoxicillin 250mg',   'Cipla',        'Antibiotic'),
(3,  'Metformin 500mg',     'Dr. Reddy\'s', 'Antidiabetic'),
(4,  'Atorvastatin 10mg',   'Lupin',        'Antilipemic'),
(5,  'Omeprazole 20mg',     'Zydus',        'Antacid'),
(6,  'Amlodipine 5mg',      'Mankind',      'Antihypertensive'),
(7,  'Azithromycin 500mg',  'Abbott',       'Antibiotic'),
(8,  'Cetirizine 10mg',     'Alkem',        'Antihistamine'),
(9,  'Pantoprazole 40mg',   'Sun Pharma',   'Antacid'),
(10, 'Metoprolol 50mg',     'Cipla',        'Beta Blocker'),
(11, 'Clopidogrel 75mg',    'Dr. Reddy\'s', 'Antiplatelet'),
(12, 'Levothyroxine 50mcg', 'Merck',        'Thyroid'),
(13, 'Insulin Glargine',    'Novo Nordisk', 'Antidiabetic'),
(14, 'Ondansetron 4mg',     'Zydus',        'Antiemetic'),
(15, 'Diclofenac 50mg',     'Lupin',        'NSAID'),
(16, 'Losartan 50mg',       'Mankind',      'Antihypertensive'),
(17, 'Doxycycline 100mg',   'Alkem',        'Antibiotic'),
(18, 'Ranitidine 150mg',    'Abbott',       'Antacid');


-- ============================================================
-- TABLE: medicine_inventory
-- ============================================================
CREATE TABLE IF NOT EXISTS medicine_inventory (
    Inventory_ID    INT PRIMARY KEY AUTO_INCREMENT,
    Medicine_ID     INT NOT NULL UNIQUE,
    Stock_Quantity  INT,
    Batch_No        VARCHAR(50),
    Expiry_Date     DATE,
    Purchase_Cost   DECIMAL(10,2),
    FOREIGN KEY (Medicine_ID) REFERENCES medicine(Medicine_ID)
);

INSERT INTO medicine_inventory (Inventory_ID, Medicine_ID, Stock_Quantity, Batch_No, Expiry_Date, Purchase_Cost) VALUES
(1,  1,  500, 'BATCH-PCM-001', '2026-12-31',  2.50),
(2,  2,  300, 'BATCH-AMX-001', '2026-06-30',  8.00),
(3,  3,  400, 'BATCH-MET-001', '2026-09-30',  4.50),
(4,  4,  250, 'BATCH-ATO-001', '2027-03-31', 12.00),
(5,  5,  350, 'BATCH-OME-001', '2026-11-30',  6.00),
(6,  6,  200, 'BATCH-AML-001', '2027-01-31',  9.50),
(7,  7,  150, 'BATCH-AZI-001', '2026-08-31', 25.00),
(8,  8,  400, 'BATCH-CET-001', '2026-10-31',  3.50),
(9,  9,  300, 'BATCH-PAN-001', '2026-12-31',  7.50),
(10, 10, 180, 'BATCH-MTO-001', '2027-02-28', 11.00),
(11, 11, 220, 'BATCH-CLO-001', '2026-07-31', 15.00),
(12, 12, 160, 'BATCH-LEV-001', '2027-04-30', 18.50),
(13, 13, 100, 'BATCH-INS-001', '2026-05-31', 45.00),
(14, 14, 280, 'BATCH-OND-001', '2026-09-30',  5.00),
(15, 15, 320, 'BATCH-DCL-001', '2026-11-30',  4.00),
(16, 16, 190, 'BATCH-LOS-001', '2027-01-31', 10.00),
(17, 17, 240, 'BATCH-DOX-001', '2026-08-31', 14.00),
(18, 18, 360, 'BATCH-RAN-001', '2026-10-31',  3.00);


-- ============================================================
-- TABLE: prescription
-- ============================================================
CREATE TABLE IF NOT EXISTS prescription (
    Prescription_ID INT PRIMARY KEY AUTO_INCREMENT,
    Patient_ID      INT NOT NULL,
    Doctor_ID       INT NOT NULL,
    Date            DATE,
    Notes           TEXT,
    FOREIGN KEY (Patient_ID) REFERENCES patient(Patient_ID),
    FOREIGN KEY (Doctor_ID)  REFERENCES doctor(Doctor_ID)
);

INSERT INTO prescription (Prescription_ID, Patient_ID, Doctor_ID, Date, Notes) VALUES
(1,  1,  1,  '2025-01-05', 'Patient presents with chest pain. Monitor BP closely.'),
(2,  2,  2,  '2025-01-06', 'Post knee surgery. Avoid weight bearing for 2 weeks.'),
(3,  3,  3,  '2025-01-07', 'Migraine episode. Rest advised. Avoid screen time.'),
(4,  4,  4,  '2025-01-08', 'Mild fever and infection. Full course of antibiotics required.'),
(5,  5,  5,  '2025-01-09', 'Routine checkup. Growth parameters normal.'),
(6,  6,  6,  '2025-01-10', 'Allergic dermatitis. Avoid allergens.'),
(7,  7,  7,  '2025-01-11', 'Post-chemo cycle 2. Monitor blood counts.'),
(8,  8,  8,  '2025-01-12', 'Prenatal visit. Iron supplements continued.'),
(9,  9,  9,  '2025-01-13', 'Follow-up after CT scan. Results reviewed.'),
(10, 10, 10, '2025-01-14', 'Anxiety disorder. CBT recommended alongside medication.'),
(11, 11, 1,  '2025-01-15', 'Hypertension management. Lifestyle changes advised.'),
(12, 12, 2,  '2025-01-16', 'Fracture healing well. Physiotherapy to begin.'),
(13, 13, 3,  '2025-01-17', 'Epilepsy. Medication adjusted.'),
(14, 14, 4,  '2025-01-18', 'Viral infection. Symptomatic treatment.'),
(15, 15, 5,  '2025-01-19', 'Asthma. Inhaler technique reviewed.'),
(16, 16, 6,  '2025-01-20', 'Eczema flare-up. Steroid cream prescribed.'),
(17, 17, 7,  '2025-01-21', 'Lung cancer follow-up. Next chemo in 3 weeks.'),
(18, 18, 8,  '2025-01-22', 'PCOS management. Diet chart provided.');


-- ============================================================
-- TABLE: prescription_items
-- ============================================================
CREATE TABLE IF NOT EXISTS prescription_items (
    Item_ID         INT PRIMARY KEY AUTO_INCREMENT,
    Prescription_ID INT NOT NULL,
    Medicine_ID     INT NOT NULL,
    Dosage          VARCHAR(50),
    Frequency       VARCHAR(50),
    Duration        VARCHAR(50),
    FOREIGN KEY (Prescription_ID) REFERENCES prescription(Prescription_ID),
    FOREIGN KEY (Medicine_ID)     REFERENCES medicine(Medicine_ID)
);

INSERT INTO prescription_items (Item_ID, Prescription_ID, Medicine_ID, Dosage, Frequency, Duration) VALUES
(1,  1,  4,  '10mg',     'Once daily',          '30 days'),
(2,  1,  10, '50mg',     'Twice daily',          '30 days'),
(3,  2,  15, '50mg',     'Twice daily',          '5 days'),
(4,  2,  1,  '500mg',    'Three times daily',    '5 days'),
(5,  3,  1,  '500mg',    'As needed',            '7 days'),
(6,  3,  8,  '10mg',     'Once daily',           '7 days'),
(7,  4,  2,  '250mg',    'Three times daily',    '7 days'),
(8,  4,  9,  '40mg',     'Once daily',           '7 days'),
(9,  5,  14, '4mg',      'As needed',            '3 days'),
(10, 6,  8,  '10mg',     'Once daily',           '14 days'),
(11, 7,  11, '75mg',     'Once daily',           '30 days'),
(12, 8,  13, '10 units', 'Once daily at night',  '30 days'),
(13, 9,  5,  '20mg',     'Once daily',           '14 days'),
(14, 10, 6,  '5mg',      'Once daily',           '30 days'),
(15, 11, 6,  '5mg',      'Once daily',           '60 days'),
(16, 11, 16, '50mg',     'Once daily',           '60 days'),
(17, 12, 15, '50mg',     'Twice daily',          '7 days'),
(18, 13, 3,  '500mg',    'Twice daily',          '90 days');


-- ============================================================
-- TABLE: bill
-- ============================================================
CREATE TABLE IF NOT EXISTS bill (
    Bill_ID      INT PRIMARY KEY AUTO_INCREMENT,
    Patient_ID   INT NOT NULL,
    Bill_Date    DATE,
    Insurance_ID INT,
    Status       ENUM('Paid','Pending','Cancelled') NOT NULL,
    FOREIGN KEY (Patient_ID)   REFERENCES patient(Patient_ID),
    FOREIGN KEY (Insurance_ID) REFERENCES insurance(Insurance_ID)
);

INSERT INTO bill (Bill_ID, Patient_ID, Bill_Date, Insurance_ID, Status) VALUES
(1,  1,  '2025-01-12', 1,  'Paid'),
(2,  2,  '2025-01-14', 2,  'Paid'),
(3,  3,  '2025-01-10', 3,  'Paid'),
(4,  4,  '2025-01-15', 4,  'Pending'),
(5,  5,  '2025-01-20', 14, 'Pending'),
(6,  6,  '2025-01-18', 5,  'Paid'),
(7,  7,  '2025-01-20', 6,  'Paid'),
(8,  8,  '2025-01-22', 15, 'Pending'),
(9,  9,  '2025-01-22', 7,  'Paid'),
(10, 10, '2025-01-21', 8,  'Paid'),
(11, 11, '2025-01-25', 16, 'Pending'),
(12, 12, '2025-01-24', 9,  'Paid'),
(13, 13, '2025-01-25', 10, 'Paid'),
(14, 14, '2025-01-28', 17, 'Pending'),
(15, 15, '2025-01-27', 11, 'Paid'),
(16, 16, '2025-01-28', 12, 'Paid'),
(17, 17, '2025-01-30', 18, 'Pending'),
(18, 18, '2025-01-30', 13, 'Paid');


-- ============================================================
-- TABLE: bill_items
-- ============================================================
CREATE TABLE IF NOT EXISTS bill_items (
    Item_ID      INT PRIMARY KEY AUTO_INCREMENT,
    Bill_ID      INT NOT NULL,
    Item_Type    ENUM('Room','Lab Test','Medicine','Other') NOT NULL,
    Reference_ID INT,
    Amount       DECIMAL(10,2),
    FOREIGN KEY (Bill_ID) REFERENCES bill(Bill_ID)
);

INSERT INTO bill_items (Item_ID, Bill_ID, Item_Type, Reference_ID, Amount) VALUES
(1,  1,  'Room',     1,  3500.00),
(2,  1,  'Lab Test', 7,   400.00),
(3,  1,  'Lab Test', 16, 2500.00),
(4,  1,  'Medicine', 4,   360.00),
(5,  2,  'Room',     4,  8400.00),
(6,  2,  'Lab Test', 3,   350.00),
(7,  2,  'Medicine', 15,  200.00),
(8,  3,  'Room',     7,  7500.00),
(9,  3,  'Lab Test', 9,  5000.00),
(10, 3,  'Medicine', 5,    75.00),
(11, 4,  'Room',     10, 56000.00),
(12, 4,  'Lab Test', 5,   700.00),
(13, 4,  'Medicine', 7,   375.00),
(14, 5,  'Room',     2,  5500.00),
(15, 5,  'Lab Test', 2,   150.00),
(16, 5,  'Medicine', 9,   210.00),
(17, 6,  'Room',     5,  9600.00),
(18, 6,  'Lab Test', 11,  200.00),
(19, 6,  'Medicine', 8,   490.00),
(20, 7,  'Room',     8,  22500.00),
(21, 7,  'Lab Test', 1,   350.00),
(22, 7,  'Medicine', 11, 3000.00),
(23, 8,  'Room',     11, 80000.00),
(24, 8,  'Lab Test', 15, 1200.00),
(25, 8,  'Medicine', 13, 1350.00),
(26, 9,  'Room',     3,  4500.00),
(27, 9,  'Lab Test', 10, 4500.00),
(28, 9,  'Medicine', 5,   210.00),
(29, 10, 'Room',     6,  8400.00),
(30, 10, 'Lab Test', 1,   350.00),
(31, 10, 'Medicine', 6,   285.00),
(32, 11, 'Room',     9,  12500.00),
(33, 11, 'Lab Test', 3,   600.00),
(34, 11, 'Medicine', 16, 1900.00),
(35, 12, 'Room',     12, 40000.00),
(36, 12, 'Lab Test', 8,   500.00),
(37, 12, 'Medicine', 15,  560.00),
(38, 13, 'Room',     13, 80000.00),
(39, 13, 'Lab Test', 9,  5000.00),
(40, 13, 'Medicine', 7,  1875.00),
(41, 14, 'Room',     15, 40000.00),
(42, 14, 'Lab Test', 13,  800.00),
(43, 14, 'Medicine', 2,   560.00),
(44, 15, 'Room',     17, 32000.00),
(45, 15, 'Lab Test', 8,   500.00),
(46, 15, 'Medicine', 8,   245.00),
(47, 16, 'Room',     18, 56000.00),
(48, 16, 'Lab Test', 11,  200.00),
(49, 16, 'Medicine', 8,   245.00),
(50, 17, 'Room',     14, 90000.00),
(51, 17, 'Lab Test', 1,   350.00),
(52, 17, 'Medicine', 11, 1500.00),
(53, 18, 'Room',     16, 40000.00),
(54, 18, 'Lab Test', 6,   900.00),
(55, 18, 'Medicine', 3,   405.00);


-- ============================================================
-- TABLE: payment
-- ============================================================
CREATE TABLE IF NOT EXISTS payment (
    Payment_ID      INT PRIMARY KEY AUTO_INCREMENT,
    Bill_ID         INT NOT NULL,
    Payment_Date    DATE,
    Amount          DECIMAL(10,2),
    Payment_Mode    ENUM('Cash','UPI','Credit Card','Debit Card','Net Banking','Insurance') NOT NULL,
    Transaction_ID  VARCHAR(50) UNIQUE,
    FOREIGN KEY (Bill_ID) REFERENCES bill(Bill_ID)
);

INSERT INTO payment (Payment_ID, Bill_ID, Payment_Date, Amount, Payment_Mode, Transaction_ID) VALUES
(1,  1,  '2025-01-12',  1252.00,  'UPI',          'TXN-UPI-20250112-001'),
(2,  2,  '2025-01-14',  2237.50,  'Credit Card',   'TXN-CC-20250114-002'),
(3,  3,  '2025-01-10',  3772.50,  'Cash',          'TXN-CSH-20250110-003'),
(4,  6,  '2025-01-18',  4073.60,  'Net Banking',   'TXN-NB-20250118-006'),
(5,  7,  '2025-01-20',  8702.50,  'Insurance',     'TXN-INS-20250120-007'),
(6,  9,  '2025-01-22',  3220.50,  'UPI',           'TXN-UPI-20250122-009'),
(7,  10, '2025-01-21',  1827.00,  'Debit Card',    'TXN-DC-20250121-010'),
(8,  12, '2025-01-24', 10265.00,  'Net Banking',   'TXN-NB-20250124-012'),
(9,  13, '2025-01-25', 73378.75,  'Insurance',     'TXN-INS-20250125-013'),
(10, 15, '2025-01-27',  9823.50,  'Credit Card',   'TXN-CC-20250127-015'),
(11, 16, '2025-01-28', 11289.00,  'UPI',           'TXN-UPI-20250128-016'),
(12, 18, '2025-01-30', 13910.25,  'Cash',          'TXN-CSH-20250130-018'),
(13, 1,  '2025-01-12',  5008.00,  'Insurance',     'TXN-INS-20250112-001B'),
(14, 2,  '2025-01-14',  6712.50,  'Insurance',     'TXN-INS-20250114-002B'),
(15, 3,  '2025-01-10',  8952.50,  'Insurance',     'TXN-INS-20250110-003B'),
(16, 6,  '2025-01-18',  5626.40,  'Insurance',     'TXN-INS-20250118-006B'),
(17, 9,  '2025-01-22',  5929.50,  'Insurance',     'TXN-INS-20250122-009B'),
(18, 10, '2025-01-21',  7208.00,  'Insurance',     'TXN-INS-20250121-010B');


-- ============================================================
-- TABLE: nurse_patient_assignment
-- ============================================================
CREATE TABLE IF NOT EXISTS nurse_patient_assignment (
    NP_Assignment_ID           INT PRIMARY KEY AUTO_INCREMENT,
    Nurse_Shift_Assignment_ID  INT NOT NULL,
    Patient_ID                 INT NOT NULL,
    FOREIGN KEY (Nurse_Shift_Assignment_ID) REFERENCES nurse_shift_assignment(Assignment_ID),
    FOREIGN KEY (Patient_ID)               REFERENCES patient(Patient_ID)
);

INSERT INTO nurse_patient_assignment (NP_Assignment_ID, Nurse_Shift_Assignment_ID, Patient_ID) VALUES
(1,  1, 1),
(2,  1, 2),
(3,  2, 3),
(4,  2, 4),
(5,  3, 5),
(6,  3, 6),
(7,  4, 7),
(8,  4, 8),
(9,  5, 9),
(10, 5, 10),
(11, 6, 11),
(12, 6, 12),
(13, 7, 13),
(14, 7, 14),
(15, 1, 15),
(16, 2, 16),
(17, 3, 17),
(18, 4, 18);

-- ============================================================
-- END OF DUMP
-- ============================================================
