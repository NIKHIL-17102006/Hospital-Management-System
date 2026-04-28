-- ============================================================
-- Hospital Management System - Second Normal Form (2NF)
-- Database: hospital_mgmt_2nf
-- ============================================================
--
-- What is 2NF (Second Normal Form)?
-- A table is in 2NF when:
--   1. It is already in 1NF
--   2. Every non-key attribute is FULLY FUNCTIONALLY DEPENDENT
--      on the ENTIRE primary key — no partial dependencies.
--
-- In simpler terms: every column in a table must describe
-- the entity that the table is ABOUT — nothing more.
-- If a column describes a DIFFERENT entity, it belongs in
-- a different table.
--
-- Partial Dependencies found in 1NF and fixed here:
--
--   PROBLEM 1 — Doctor info in hospital_record:
--     Doctor_Name, Doctor_Email, Doctor_Phone etc. describe
--     the DOCTOR, not the visit/record. They repeat every time
--     the same doctor sees a new patient.
--     FIX: Extract into a separate `doctor` table.
--
--   PROBLEM 2 — Department info in hospital_record:
--     Department_Name, Department_Head describe the DEPARTMENT.
--     They repeat for every doctor in that department.
--     FIX: Extract into a separate `department` table.
--
--   PROBLEM 3 — Patient info in hospital_record:
--     Patient_Name, Patient_DOB etc. describe the PATIENT.
--     They would repeat for every visit the same patient makes.
--     FIX: Extract into a separate `patient` table.
--
--   PROBLEM 4 — Nurse info in hospital_record:
--     Nurse_Name, Nurse_Email etc. describe the NURSE.
--     They repeat every time the nurse is assigned a patient.
--     FIX: Extract into a separate `nurse` table.
--
--   PROBLEM 5 — Room cost in hospital_record:
--     Room_Cost_Per_Day depends only on Room_Type, not on
--     which patient is in the room. It repeats for every
--     patient in a General/ICU/Private room etc.
--     FIX: Extract into a separate `room_type` table.
--
--   PROBLEM 6 — Medicine catalogue in hospital_medicine:
--     Manufacturer and Category describe the MEDICINE itself,
--     not the prescription. They repeat every time that
--     medicine is prescribed to any patient.
--     FIX: Extract into a separate `medicine` table.
--     hospital_medicine keeps only prescription-specific data:
--     Dosage, Frequency, Duration.
--
--   PROBLEM 7 — Test cost in hospital_lab_test:
--     Test_Cost describes the TEST itself, not the patient's
--     result. It repeats every time the same test is ordered.
--     FIX: Extract into a separate `lab_test` table.
--     hospital_lab_test keeps only result-specific data:
--     Test_Date, Test_Result.
--
--   PROBLEM 8 — Qualifications in hospital_qualification:
--     Degrees are doctor-specific, not record-specific.
--     They repeated whenever the same doctor appeared in
--     multiple records (Records 1 & 11 both had Dr. Rajesh
--     Sharma's MBBS, MD, DM Cardiology).
--     FIX: Link qualifications to doctor, not to record.
--
--   PROBLEM 9 — Insurance info in hospital_record:
--     Insurance_Provider, Coverage_Pct etc. describe the
--     POLICY, not the visit. Repeats per patient per record.
--     FIX: Extract into a separate `insurance` table.
--
-- What 2NF does NOT fix (still present, fixed in 3NF):
--   - Transitive dependencies:
--     e.g. Patient_ID → Insurance_Policy → Insurance_Provider
--     e.g. Doctor_ID  → Dept_ID → Department_Head
--   These are not partial dependencies but transitive ones —
--   that is a 3NF concern.
-- ============================================================

CREATE DATABASE IF NOT EXISTS hospital_mgmt_2nf;
USE hospital_mgmt_2nf;

-- ============================================================
-- TABLE: department  [NEW — 2NF FIX for PROBLEM 2]
-- Department info extracted from hospital_record.
-- Dept_Head still lives here — transitive dependency
-- (Dept_ID → Dept_Head) will be addressed in 3NF.
-- ============================================================
CREATE TABLE IF NOT EXISTS department (
    Dept_ID     INT PRIMARY KEY AUTO_INCREMENT,
    Dept_Name   VARCHAR(100) NOT NULL,
    Dept_Head   VARCHAR(100)
);

INSERT INTO department (Dept_ID, Dept_Name, Dept_Head) VALUES
(1,  'Cardiology',    'Dr. Rajesh Sharma'),
(2,  'Orthopedics',   'Dr. Priya Mehta'),
(3,  'Neurology',     'Dr. Anil Kapoor'),
(4,  'Emergency',     'Dr. Sunita Rao'),
(5,  'Pediatrics',    'Dr. Vikram Singh'),
(6,  'Dermatology',   'Dr. Neha Gupta'),
(7,  'Oncology',      'Dr. Ramesh Iyer'),
(8,  'Gynecology',    'Dr. Anjali Bose'),
(9,  'Radiology',     'Dr. Suresh Nair'),
(10, 'Psychiatry',    'Dr. Meena Joshi');


-- ============================================================
-- TABLE: doctor  [NEW — 2NF FIX for PROBLEM 1]
-- Doctor info extracted from hospital_record.
-- Each doctor appears ONCE only — no more repeating rows.
-- Now references department via Dept_ID foreign key.
-- ============================================================
CREATE TABLE IF NOT EXISTS doctor (
    Doctor_ID         INT PRIMARY KEY AUTO_INCREMENT,
    Doctor_Name       VARCHAR(100),
    Doctor_Email      VARCHAR(100),
    Doctor_Phone      VARCHAR(15),
    Doctor_Address    VARCHAR(255),
    Doctor_DOB        DATE,
    Doctor_Joining    DATE,
    Specialization    VARCHAR(100),
    Dept_ID           INT,
    -- Shift info for the doctor
    Shift_Name        VARCHAR(50),
    Shift_Start       TIME,
    Shift_End         TIME,
    Shift_Date        DATE,
    FOREIGN KEY (Dept_ID) REFERENCES department(Dept_ID)
);

INSERT INTO doctor (Doctor_ID, Doctor_Name, Doctor_Email, Doctor_Phone, Doctor_Address, Doctor_DOB, Doctor_Joining, Specialization, Dept_ID, Shift_Name, Shift_Start, Shift_End, Shift_Date) VALUES
(1,  'Dr. Rajesh Sharma', 'rajesh.sharma@hospital.com', '9876543201', '12 MG Road Delhi',            '1972-04-15', '2005-06-01', 'Interventional Cardiology',  1,  'Morning',   '06:00:00', '14:00:00', '2025-01-06'),
(2,  'Dr. Priya Mehta',   'priya.mehta@hospital.com',   '9876543202', '34 Park Street Mumbai',        '1978-09-22', '2008-03-15', 'Joint Replacement Surgery',  2,  'Afternoon', '14:00:00', '22:00:00', '2025-01-06'),
(3,  'Dr. Anil Kapoor',   'anil.kapoor@hospital.com',   '9876543203', '56 Nehru Nagar Pune',          '1969-11-30', '2002-01-10', 'Epilepsy & Stroke',          3,  'Night',     '22:00:00', '06:00:00', '2025-01-06'),
(4,  'Dr. Sunita Rao',    'sunita.rao@hospital.com',    '9876543204', '78 Anna Salai Chennai',         '1980-07-05', '2010-08-20', 'Emergency & Trauma',         4,  'Morning',   '06:00:00', '14:00:00', '2025-01-07'),
(5,  'Dr. Vikram Singh',  'vikram.singh@hospital.com',  '9876543205', '90 Civil Lines Lucknow',        '1975-03-18', '2007-05-12', 'Neonatology',                5,  'Afternoon', '14:00:00', '22:00:00', '2025-01-07'),
(6,  'Dr. Neha Gupta',    'neha.gupta@hospital.com',    '9876543206', '23 Rajpath Jaipur',             '1983-12-25', '2012-11-01', 'Cosmetic Dermatology',       6,  'Morning',   '06:00:00', '14:00:00', '2025-01-08'),
(7,  'Dr. Ramesh Iyer',   'ramesh.iyer@hospital.com',   '9876543207', '45 Brigade Road Bangalore',     '1968-08-14', '2000-04-22', 'Surgical Oncology',          7,  'Night',     '22:00:00', '06:00:00', '2025-01-08'),
(8,  'Dr. Anjali Bose',   'anjali.bose@hospital.com',   '9876543208', '67 Lake Town Kolkata',          '1977-06-09', '2006-07-30', 'High Risk Pregnancy',        8,  'Afternoon', '14:00:00', '22:00:00', '2025-01-09'),
(9,  'Dr. Suresh Nair',   'suresh.nair@hospital.com',   '9876543209', '89 MG Road Kochi',              '1981-02-28', '2011-09-05', 'Interventional Radiology',   9,  'Morning',   '06:00:00', '14:00:00', '2025-01-09'),
(10, 'Dr. Meena Joshi',   'meena.joshi@hospital.com',   '9876543210', '11 Banjara Hills Hyderabad',    '1974-10-17', '2004-02-14', 'Child Psychiatry',           10, 'Night',     '22:00:00', '06:00:00', '2025-01-10');


-- ============================================================
-- TABLE: doctor_qualification  [MODIFIED — 2NF FIX for PROBLEM 8]
-- In 1NF, qualifications were linked to Record_ID — so the same
-- doctor's degrees were repeated for every record they appeared in.
-- Now qualifications are linked to Doctor_ID — stored once per doctor.
-- ============================================================
CREATE TABLE IF NOT EXISTS doctor_qualification (
    Qual_ID   INT PRIMARY KEY AUTO_INCREMENT,
    Doctor_ID INT         NOT NULL,
    Degree    VARCHAR(50) NOT NULL,
    FOREIGN KEY (Doctor_ID) REFERENCES doctor(Doctor_ID)
);

INSERT INTO doctor_qualification (Doctor_ID, Degree) VALUES
(1, 'MBBS'), (1, 'MD'), (1, 'DM Cardiology'),
(2, 'MBBS'), (2, 'MS Orthopedics'),
(3, 'MBBS'), (3, 'MD'), (3, 'DM Neurology'),
(4, 'MBBS'), (4, 'MD Emergency Medicine'),
(5, 'MBBS'), (5, 'MD Pediatrics'),
(6, 'MBBS'), (6, 'MD Dermatology'),
(7, 'MBBS'), (7, 'MS'), (7, 'MCh Oncology'),
(8, 'MBBS'), (8, 'MD Gynecology'),
(9, 'MBBS'), (9, 'MD Radiology'),
(10,'MBBS'), (10,'MD Psychiatry');


-- ============================================================
-- TABLE: nurse  [NEW — 2NF FIX for PROBLEM 4]
-- Nurse info extracted from hospital_record.
-- Each nurse appears ONCE — no more repeating rows.
-- ============================================================
CREATE TABLE IF NOT EXISTS nurse (
    Nurse_ID        INT PRIMARY KEY AUTO_INCREMENT,
    Nurse_Name      VARCHAR(100),
    Nurse_Email     VARCHAR(100),
    Nurse_Phone     VARCHAR(15),
    Shift_Name      VARCHAR(50),
    Shift_Start     TIME,
    Shift_End       TIME,
    Shift_Date      DATE
);

INSERT INTO nurse (Nurse_ID, Nurse_Name, Nurse_Email, Nurse_Phone, Shift_Name, Shift_Start, Shift_End, Shift_Date) VALUES
(1, 'Kavya Reddy',  'kavya.reddy@hospital.com',  '9876543211', 'Morning',   '06:00:00', '14:00:00', '2025-01-06'),
(2, 'Ritu Sharma',  'ritu.sharma@hospital.com',  '9876543212', 'Afternoon', '14:00:00', '22:00:00', '2025-01-06'),
(3, 'Pooja Tiwari', 'pooja.tiwari@hospital.com', '9876543213', 'Night',     '22:00:00', '06:00:00', '2025-01-06'),
(4, 'Deepa Nair',   'deepa.nair@hospital.com',   '9876543214', 'Morning',   '06:00:00', '14:00:00', '2025-01-07'),
(5, 'Suman Verma',  'suman.verma@hospital.com',  '9876543215', 'Afternoon', '14:00:00', '22:00:00', '2025-01-07'),
(6, 'Anita Pillai', 'anita.pillai@hospital.com', '9876543216', 'Night',     '22:00:00', '06:00:00', '2025-01-07'),
(7, 'Geeta Mishra', 'geeta.mishra@hospital.com', '9876543217', 'Morning',   '06:00:00', '14:00:00', '2025-01-08');


-- ============================================================
-- TABLE: patient  [NEW — 2NF FIX for PROBLEM 3]
-- Patient info extracted from hospital_record.
-- Each patient appears ONCE — no more repeating rows.
-- ============================================================
CREATE TABLE IF NOT EXISTS patient (
    Patient_ID        INT PRIMARY KEY AUTO_INCREMENT,
    Patient_Name      VARCHAR(100),
    Patient_DOB       DATE,
    Patient_Gender    VARCHAR(10),
    Patient_BloodGrp  VARCHAR(5),
    Patient_Phone     VARCHAR(15),
    Patient_Email     VARCHAR(100),
    Patient_Address   VARCHAR(255),
    Admission_Date    DATE,
    Discharge_Date    DATE
);

INSERT INTO patient (Patient_ID, Patient_Name, Patient_DOB, Patient_Gender, Patient_BloodGrp, Patient_Phone, Patient_Email, Patient_Address, Admission_Date, Discharge_Date) VALUES
(1,  'Aarav Kumar',      '1985-03-12', 'Male',   'A+',  '9811001001', 'aarav.kumar@gmail.com',     '101 Sector 15 Noida',         '2025-01-05', '2025-01-12'),
(2,  'Priya Sharma',     '1990-07-22', 'Female', 'B+',  '9811001002', 'priya.sharma@gmail.com',    '202 Dwarka Delhi',            '2025-01-06', '2025-01-14'),
(3,  'Rohit Verma',      '1978-11-08', 'Male',   'O+',  '9811001003', 'rohit.verma@gmail.com',     '303 Andheri Mumbai',          '2025-01-07', '2025-01-10'),
(4,  'Sneha Patel',      '1995-05-30', 'Female', 'AB+', '9811001004', 'sneha.patel@gmail.com',     '404 Navrangpura Ahmedabad',   '2025-01-08', '2025-01-15'),
(5,  'Mohit Agarwal',    '1982-09-17', 'Male',   'A-',  '9811001005', 'mohit.agarwal@gmail.com',   '505 Civil Lines Allahabad',   '2025-01-09', NULL),
(6,  'Kavita Jain',      '1975-02-14', 'Female', 'B-',  '9811001006', 'kavita.jain@gmail.com',     '606 Malviya Nagar Jaipur',    '2025-01-10', '2025-01-18'),
(7,  'Arjun Nair',       '1988-06-25', 'Male',   'O-',  '9811001007', 'arjun.nair@gmail.com',      '707 Ernakulam Kochi',         '2025-01-11', '2025-01-20'),
(8,  'Divya Reddy',      '1993-12-03', 'Female', 'A+',  '9811001008', 'divya.reddy@gmail.com',     '808 Banjara Hills Hyderabad', '2025-01-12', NULL),
(9,  'Suresh Mishra',    '1970-04-19', 'Male',   'B+',  '9811001009', 'suresh.mishra@gmail.com',   '909 Hazratganj Lucknow',      '2025-01-13', '2025-01-22'),
(10, 'Ananya Singh',     '1999-08-07', 'Female', 'AB-', '9811001010', 'ananya.singh@gmail.com',    '100 Koramangala Bangalore',   '2025-01-14', '2025-01-21'),
(11, 'Karan Mehta',      '1987-01-28', 'Male',   'O+',  '9811001011', 'karan.mehta@gmail.com',     '111 Salt Lake Kolkata',       '2025-01-15', NULL),
(12, 'Pooja Iyer',       '1992-10-11', 'Female', 'A+',  '9811001012', 'pooja.iyer@gmail.com',      '222 T Nagar Chennai',         '2025-01-16', '2025-01-24'),
(13, 'Nikhil Tiwari',    '1980-03-06', 'Male',   'B+',  '9811001013', 'nikhil.tiwari@gmail.com',   '333 Shivaji Nagar Pune',      '2025-01-17', '2025-01-25'),
(14, 'Ritu Bose',        '1996-07-15', 'Female', 'O+',  '9811001014', 'ritu.bose@gmail.com',       '444 Lake Garden Kolkata',     '2025-01-18', NULL),
(15, 'Vivek Pillai',     '1974-11-23', 'Male',   'A-',  '9811001015', 'vivek.pillai@gmail.com',    '555 Vile Parle Mumbai',       '2025-01-19', '2025-01-27'),
(16, 'Meera Choudhary',  '1989-05-09', 'Female', 'B+',  '9811001016', 'meera.choudhary@gmail.com', '666 Malviya Nagar Bhopal',    '2025-01-20', '2025-01-28'),
(17, 'Rahul Saxena',     '1983-09-30', 'Male',   'AB+', '9811001017', 'rahul.saxena@gmail.com',    '777 Gomti Nagar Lucknow',     '2025-01-21', NULL),
(18, 'Sunita Pandey',    '1977-02-18', 'Female', 'O-',  '9811001018', 'sunita.pandey@gmail.com',   '888 Rajpur Road Dehradun',    '2025-01-22', '2025-01-30');


-- ============================================================
-- TABLE: room_type  [NEW — 2NF FIX for PROBLEM 5]
-- Room_Cost_Per_Day depends only on Room_Type, not on any patient.
-- Extracted so cost is stored ONCE per room type.
-- ============================================================
CREATE TABLE IF NOT EXISTS room_type (
    Room_Type         VARCHAR(50)   PRIMARY KEY,
    Room_Cost_Per_Day DECIMAL(10,2) NOT NULL
);

INSERT INTO room_type (Room_Type, Room_Cost_Per_Day) VALUES
('General',      500.00),
('Semi-Private', 1200.00),
('Private',      2500.00),
('ICU',          8000.00),
('NICU',         10000.00),
('HDU',          5000.00),
('Deluxe',       4000.00),
('Suite',        7000.00);


-- ============================================================
-- TABLE: insurance  [NEW — 2NF FIX for PROBLEM 9]
-- Insurance info extracted from hospital_record.
-- Linked to patient — each policy stored once.
-- Note: Patient_ID → Insurance info is still a transitive
-- dependency chain that 3NF will further refine.
-- ============================================================
CREATE TABLE IF NOT EXISTS insurance (
    Insurance_ID          INT PRIMARY KEY AUTO_INCREMENT,
    Patient_ID            INT NOT NULL,
    Policy_Number         VARCHAR(50) UNIQUE,
    Provider              VARCHAR(100),
    Coverage_Percentage   DECIMAL(5,2),
    Valid_From            DATE,
    Valid_To              DATE,
    FOREIGN KEY (Patient_ID) REFERENCES patient(Patient_ID)
);

INSERT INTO insurance (Insurance_ID, Patient_ID, Policy_Number, Provider, Coverage_Percentage, Valid_From, Valid_To) VALUES
(1,  1,  'STAR-2021-001',  'Star Health Insurance',  80.00, '2021-04-01', '2026-03-31'),
(2,  2,  'HDFC-2022-002',  'HDFC ERGO',              75.00, '2022-01-01', '2027-12-31'),
(3,  3,  'BAJA-2020-003',  'Bajaj Allianz',           70.00, '2020-06-01', '2025-05-31'),
(4,  4,  'ICICI-2023-004', 'ICICI Lombard',           85.00, '2023-03-01', '2028-02-28'),
(5,  5,  'BAJA-2022-005',  'Bajaj Allianz',           75.00, '2022-04-01', '2027-03-31'),
(6,  6,  'NIA-2021-006',   'New India Assurance',     60.00, '2021-07-01', '2026-06-30'),
(7,  7,  'UII-2022-007',   'United India Insurance',  65.00, '2022-09-01', '2027-08-31'),
(8,  8,  'ICICI-2021-008', 'ICICI Lombard',           80.00, '2021-12-01', '2026-11-30'),
(9,  9,  'ORI-2020-009',   'Oriental Insurance',      70.00, '2020-11-01', '2025-10-31'),
(10, 10, 'MAXB-2023-010',  'Max Bupa',                80.00, '2023-01-01', '2028-12-31'),
(11, 11, 'NIA-2023-011',   'New India Assurance',     70.00, '2023-02-01', '2028-01-31'),
(12, 12, 'REL-2021-012',   'Reliance Health',         75.00, '2021-05-01', '2026-04-30'),
(13, 13, 'ABH-2022-013',   'Aditya Birla Health',     85.00, '2022-08-01', '2027-07-31'),
(14, 14, 'ORI-2022-014',   'Oriental Insurance',      60.00, '2022-07-01', '2027-06-30'),
(15, 15, 'TATA-2021-015',  'Tata AIG',                70.00, '2021-02-01', '2026-01-31'),
(16, 16, 'STAR-2023-016',  'Star Health Insurance',   80.00, '2023-06-01', '2028-05-31'),
(17, 17, 'MAXB-2021-017',  'Max Bupa',                85.00, '2021-09-01', '2026-08-31'),
(18, 18, 'HDFC-2020-018',  'HDFC ERGO',               65.00, '2020-10-01', '2025-09-30');


-- ============================================================
-- TABLE: lab_test  [NEW — 2NF FIX for PROBLEM 7]
-- Test_Name and Test_Cost describe the TEST ITSELF,
-- not the patient's result. Extracted into its own table.
-- hospital_lab_result (below) stores only patient-specific data.
-- ============================================================
CREATE TABLE IF NOT EXISTS lab_test (
    Test_ID   INT PRIMARY KEY AUTO_INCREMENT,
    Test_Name VARCHAR(100) NOT NULL,
    Test_Cost DECIMAL(10,2)
);

INSERT INTO lab_test (Test_ID, Test_Name, Test_Cost) VALUES
(1,  'ECG',                          400.00),
(2,  '2D Echo',                      2500.00),
(3,  'Complete Blood Count (CBC)',    350.00),
(4,  'MRI Brain',                    5000.00),
(5,  'Liver Function Test (LFT)',     700.00),
(6,  'Blood Glucose Fasting',         150.00),
(7,  'Urine Routine',                 200.00),
(8,  'Ultrasound Abdomen',           1200.00),
(9,  'CT Scan Abdomen',              4500.00),
(10, 'Lipid Profile',                 600.00),
(11, 'Chest X-Ray',                   500.00),
(12, 'Dengue NS1 Antigen',            800.00),
(13, 'Thyroid Function Test',         900.00);


-- ============================================================
-- TABLE: medicine  [NEW — 2NF FIX for PROBLEM 6]
-- Medicine_Name, Manufacturer, Category describe the MEDICINE.
-- They don't depend on who it was prescribed to.
-- Extracted so medicine details are stored ONCE.
-- ============================================================
CREATE TABLE IF NOT EXISTS medicine (
    Medicine_ID   INT PRIMARY KEY AUTO_INCREMENT,
    Medicine_Name VARCHAR(100) NOT NULL,
    Manufacturer  VARCHAR(100),
    Category      VARCHAR(50)
);

INSERT INTO medicine (Medicine_ID, Medicine_Name, Manufacturer, Category) VALUES
(1,  'Atorvastatin 10mg',   'Lupin',         'Antilipemic'),
(2,  'Metoprolol 50mg',     'Cipla',         'Beta Blocker'),
(3,  'Diclofenac 50mg',     'Lupin',         'NSAID'),
(4,  'Paracetamol 500mg',   'Sun Pharma',    'Analgesic'),
(5,  'Amoxicillin 250mg',   'Cipla',         'Antibiotic'),
(6,  'Pantoprazole 40mg',   'Sun Pharma',    'Antacid'),
(7,  'Ondansetron 4mg',     'Zydus',         'Antiemetic'),
(8,  'Cetirizine 10mg',     'Alkem',         'Antihistamine'),
(9,  'Clopidogrel 75mg',    'Dr. Reddy\'s',  'Antiplatelet'),
(10, 'Insulin Glargine',    'Novo Nordisk',  'Antidiabetic'),
(11, 'Omeprazole 20mg',     'Zydus',         'Antacid'),
(12, 'Amlodipine 5mg',      'Mankind',       'Antihypertensive'),
(13, 'Losartan 50mg',       'Mankind',       'Antihypertensive'),
(14, 'Azithromycin 500mg',  'Abbott',        'Antibiotic'),
(15, 'Metformin 500mg',     'Dr. Reddy\'s',  'Antidiabetic');


-- ============================================================
-- TABLE: visit  [RENAMED & SLIMMED — core of 2NF]
-- Previously hospital_record held EVERYTHING.
-- Now it only holds what is truly about the VISIT itself:
--   - Which patient, which doctor, which nurse
--   - Appointment details
--   - Room assignment
--   - Bill and payment info
-- All entity-specific data has been moved to their own tables.
-- ============================================================
CREATE TABLE IF NOT EXISTS visit (
    Visit_ID       INT PRIMARY KEY AUTO_INCREMENT,
    Patient_ID     INT  NOT NULL,
    Doctor_ID      INT  NOT NULL,
    Nurse_ID       INT,
    Insurance_ID   INT,
    -- Appointment
    Appt_Date      DATE,
    Appt_Time      TIME,
    Appt_Status    VARCHAR(20),
    Appt_Type      VARCHAR(20),
    -- Room
    Room_Type      VARCHAR(50),
    Room_Admit     DATE,
    Room_Discharge DATE,
    -- Bill
    Bill_Date          DATE,
    Bill_Status        VARCHAR(20),
    Bill_Room_Charge   DECIMAL(10,2),
    Bill_Lab_Charge    DECIMAL(10,2),
    Bill_Medicine_Charge DECIMAL(10,2),
    -- Payment
    Payment_Date   DATE,
    Payment_Amount DECIMAL(10,2),
    Payment_Mode   VARCHAR(30),
    Transaction_ID VARCHAR(50),
    FOREIGN KEY (Patient_ID)   REFERENCES patient(Patient_ID),
    FOREIGN KEY (Doctor_ID)    REFERENCES doctor(Doctor_ID),
    FOREIGN KEY (Nurse_ID)     REFERENCES nurse(Nurse_ID),
    FOREIGN KEY (Insurance_ID) REFERENCES insurance(Insurance_ID),
    FOREIGN KEY (Room_Type)    REFERENCES room_type(Room_Type)
);

INSERT INTO visit (Visit_ID, Patient_ID, Doctor_ID, Nurse_ID, Insurance_ID, Appt_Date, Appt_Time, Appt_Status, Appt_Type, Room_Type, Room_Admit, Room_Discharge, Bill_Date, Bill_Status, Bill_Room_Charge, Bill_Lab_Charge, Bill_Medicine_Charge, Payment_Date, Payment_Amount, Payment_Mode, Transaction_ID) VALUES
(1,  1,  1,  1, 1,  '2025-01-05', '10:00:00', 'Completed', 'OPD',       'General',     '2025-01-05', '2025-01-12', '2025-01-12', 'Paid',    3500.00,  2900.00,  360.00,  '2025-01-12', 1252.00,   'UPI',          'TXN-UPI-20250112-001'),
(2,  2,  2,  2, 2,  '2025-01-06', '11:30:00', 'Completed', 'OPD',       'Semi-Private','2025-01-06', '2025-01-14', '2025-01-14', 'Paid',    8400.00,   350.00,  200.00,  '2025-01-14', 2237.50,   'Credit Card',  'TXN-CC-20250114-002'),
(3,  3,  3,  3, 3,  '2025-01-07', '09:00:00', 'Completed', 'Emergency', 'Private',     '2025-01-07', '2025-01-10', '2025-01-10', 'Paid',    7500.00,  5000.00,   75.00,  '2025-01-10', 3772.50,   'Cash',         'TXN-CSH-20250110-003'),
(4,  4,  4,  4, 4,  '2025-01-08', '14:00:00', 'Completed', 'OPD',       'ICU',         '2025-01-08', '2025-01-15', '2025-01-15', 'Pending', 56000.00,  700.00,  375.00,  NULL,         NULL,       NULL,           NULL),
(5,  5,  5,  5, 5,  '2025-01-09', '10:30:00', 'Scheduled', 'Follow-up', 'General',     '2025-01-09', NULL,         '2025-01-20', 'Pending', 5500.00,   150.00,  210.00,  NULL,         NULL,       NULL,           NULL),
(6,  6,  6,  6, 6,  '2025-01-10', '12:00:00', 'Completed', 'OPD',       'Semi-Private','2025-01-10', '2025-01-18', '2025-01-18', 'Paid',    9600.00,   200.00,  490.00,  '2025-01-18', 4073.60,   'Net Banking',  'TXN-NB-20250118-006'),
(7,  7,  7,  7, 7,  '2025-01-11', '15:00:00', 'Completed', 'OPD',       'Private',     '2025-01-11', '2025-01-20', '2025-01-20', 'Paid',    22500.00,  350.00, 3000.00,  '2025-01-20', 8702.50,   'Insurance',    'TXN-INS-20250120-007'),
(8,  8,  8,  1, 8,  '2025-01-12', '09:30:00', 'Scheduled', 'Emergency', 'ICU',         '2025-01-12', NULL,         '2025-01-22', 'Pending', 80000.00, 1200.00, 1350.00,  NULL,         NULL,       NULL,           NULL),
(9,  9,  9,  2, 9,  '2025-01-13', '11:00:00', 'Completed', 'OPD',       'General',     '2025-01-13', '2025-01-22', '2025-01-22', 'Paid',    4500.00,  4500.00,  210.00,  '2025-01-22', 3220.50,   'UPI',          'TXN-UPI-20250122-009'),
(10, 10, 10, 3, 10, '2025-01-14', '13:30:00', 'Completed', 'Follow-up', 'Semi-Private','2025-01-14', '2025-01-21', '2025-01-21', 'Paid',    8400.00,   350.00,  285.00,  '2025-01-21', 1827.00,   'Debit Card',   'TXN-DC-20250121-010'),
(11, 11, 1,  4, 11, '2025-01-15', '10:00:00', 'Scheduled', 'OPD',       'Private',     '2025-01-15', NULL,         '2025-01-25', 'Pending', 12500.00,  600.00, 1900.00,  NULL,         NULL,       NULL,           NULL),
(12, 12, 2,  5, 12, '2025-01-16', '14:30:00', 'Completed', 'OPD',       'ICU',         '2025-01-16', '2025-01-24', '2025-01-24', 'Paid',    40000.00,  500.00,  560.00,  '2025-01-24', 10265.00,  'Net Banking',  'TXN-NB-20250124-012'),
(13, 13, 3,  6, 13, '2025-01-17', '09:00:00', 'Completed', 'OPD',       'NICU',        '2025-01-17', '2025-01-25', '2025-01-25', 'Paid',    80000.00, 5000.00, 1875.00,  '2025-01-25', 73378.75,  'Insurance',    'TXN-INS-20250125-013'),
(14, 14, 4,  7, 14, '2025-01-18', '11:00:00', 'Scheduled', 'Follow-up', 'HDU',         '2025-01-18', NULL,         '2025-01-28', 'Pending', 40000.00,  800.00,  560.00,  NULL,         NULL,       NULL,           NULL),
(15, 15, 5,  1, 15, '2025-01-19', '10:30:00', 'Completed', 'OPD',       'Deluxe',      '2025-01-19', '2025-01-27', '2025-01-27', 'Paid',    32000.00,  500.00,  245.00,  '2025-01-27', 9823.50,   'Credit Card',  'TXN-CC-20250127-015'),
(16, 16, 6,  2, 16, '2025-01-20', '15:30:00', 'Completed', 'OPD',       'Suite',       '2025-01-20', '2025-01-28', '2025-01-28', 'Paid',    56000.00,  200.00,  245.00,  '2025-01-28', 11289.00,  'UPI',          'TXN-UPI-20250128-016'),
(17, 17, 7,  3, 17, '2025-01-21', '12:00:00', 'Scheduled', 'OPD',       'NICU',        '2025-01-21', NULL,         '2025-01-30', 'Pending', 90000.00,  350.00, 1500.00,  NULL,         NULL,       NULL,           NULL),
(18, 18, 8,  5, 18, '2025-01-22', '09:30:00', 'Completed', 'Emergency', 'HDU',         '2025-01-22', '2025-01-30', '2025-01-30', 'Paid',    40000.00,  900.00,  405.00,  '2025-01-30', 13910.25,  'Cash',         'TXN-CSH-20250130-018');


-- ============================================================
-- TABLE: visit_lab_result  [MODIFIED — 2NF FIX for PROBLEM 7]
-- Previously hospital_lab_test stored Test_Name and Test_Cost
-- alongside patient-specific Test_Date and Test_Result.
-- Test_Name and Test_Cost have been moved to lab_test table.
-- This table now stores ONLY what is specific to this visit's test:
--   which test was done, when, and what the result was.
-- ============================================================
CREATE TABLE IF NOT EXISTS visit_lab_result (
    Result_ID INT PRIMARY KEY AUTO_INCREMENT,
    Visit_ID  INT NOT NULL,
    Test_ID   INT NOT NULL,
    Test_Date DATE,
    Result    TEXT,
    FOREIGN KEY (Visit_ID) REFERENCES visit(Visit_ID),
    FOREIGN KEY (Test_ID)  REFERENCES lab_test(Test_ID)
);

INSERT INTO visit_lab_result (Visit_ID, Test_ID, Test_Date, Result) VALUES
(1,  1,  '2025-01-05', 'Normal sinus rhythm. No ST changes.'),
(1,  2,  '2025-01-06', 'EF 55%. Mild LVH noted.'),
(2,  3,  '2025-01-07', 'Hb 10.2 g/dL. WBC 8200. Platelets normal.'),
(3,  4,  '2025-01-07', 'Mild cortical atrophy. No bleed or infarct.'),
(4,  5,  '2025-01-08', 'WBC 14500 elevated. Suggestive of infection.'),
(5,  6,  '2025-01-09', 'Fasting glucose 78 mg/dL. Normal.'),
(6,  7,  '2025-01-10', 'RBC count normal. No casts. Slight protein.'),
(7,  3,  '2025-01-11', 'WBC 3200 low post-chemo. Monitor.'),
(8,  8,  '2025-01-12', 'Single live intrauterine fetus. 28 weeks.'),
(9,  9,  '2025-01-13', 'No abdominal mass. Mild fatty liver.'),
(10, 3,  '2025-01-14', 'All parameters within normal limits.'),
(11, 10, '2025-01-15', 'Total cholesterol 220 mg/dL. LDL 145 mg/dL.'),
(12, 11, '2025-01-16', 'Fracture line visible. Callus formation beginning.'),
(13, 4,  '2025-01-17', 'Temporal lobe focus seen. Consistent with epilepsy.'),
(14, 12, '2025-01-18', 'Dengue NS1 Negative. IgM Positive.'),
(15, 11, '2025-01-19', 'Hyperinflated lungs. Consistent with asthma.'),
(16, 7,  '2025-01-20', 'Normal. No proteinuria.'),
(17, 3,  '2025-01-21', 'WBC 4100. RBC 3.8. Hb 11.0.'),
(18, 13, '2025-01-22', NULL);


-- ============================================================
-- TABLE: visit_prescription  [MODIFIED — 2NF FIX for PROBLEM 6]
-- Previously hospital_medicine stored Medicine_Name, Manufacturer,
-- Category alongside prescription-specific Dosage/Frequency/Duration.
-- Medicine details moved to medicine table.
-- This table stores ONLY what is specific to this visit's prescription:
--   which medicine, what dose, how often, for how long.
-- ============================================================
CREATE TABLE IF NOT EXISTS visit_prescription (
    Prescription_ID INT PRIMARY KEY AUTO_INCREMENT,
    Visit_ID        INT NOT NULL,
    Medicine_ID     INT NOT NULL,
    Dosage          VARCHAR(50),
    Frequency       VARCHAR(50),
    Duration        VARCHAR(50),
    FOREIGN KEY (Visit_ID)    REFERENCES visit(Visit_ID),
    FOREIGN KEY (Medicine_ID) REFERENCES medicine(Medicine_ID)
);

INSERT INTO visit_prescription (Visit_ID, Medicine_ID, Dosage, Frequency, Duration) VALUES
(1,  1,  '10mg',     'Once daily',          '30 days'),
(1,  2,  '50mg',     'Twice daily',         '30 days'),
(2,  3,  '50mg',     'Twice daily',         '5 days'),
(2,  4,  '500mg',    'Three times daily',   '5 days'),
(3,  4,  '500mg',    'As needed',           '7 days'),
(3,  8,  '10mg',     'Once daily',          '7 days'),
(4,  5,  '250mg',    'Three times daily',   '7 days'),
(4,  6,  '40mg',     'Once daily',          '7 days'),
(5,  7,  '4mg',      'As needed',           '3 days'),
(6,  8,  '10mg',     'Once daily',          '14 days'),
(7,  9,  '75mg',     'Once daily',          '30 days'),
(8,  10, '10 units', 'Once daily at night', '30 days'),
(9,  11, '20mg',     'Once daily',          '14 days'),
(10, 12, '5mg',      'Once daily',          '30 days'),
(11, 12, '5mg',      'Once daily',          '60 days'),
(11, 13, '50mg',     'Once daily',          '60 days'),
(12, 3,  '50mg',     'Twice daily',         '7 days'),
(13, 14, '500mg',    'Twice daily',         '90 days'),
(14, 5,  '250mg',    'Twice daily',         '7 days'),
(15, 8,  '10mg',     'Once daily',          '7 days'),
(16, 8,  '10mg',     'Once daily',          '7 days'),
(17, 9,  '75mg',     'Once daily',          '30 days'),
(18, 15, '500mg',    'Twice daily',         '90 days');

-- ============================================================
-- END OF 2NF DUMP
--
-- Summary of changes 1NF → 2NF:
--
--   NEW TABLES CREATED:
--   ✔ department        — dept info no longer repeats per doctor row
--   ✔ doctor            — doctor info stored once, not per patient
--   ✔ nurse             — nurse info stored once, not per record
--   ✔ patient           — patient info stored once, not per record
--   ✔ room_type         — room cost stored once, not per patient row
--   ✔ insurance         — policy info stored once per patient
--   ✔ lab_test          — test name/cost stored once, not per result
--   ✔ medicine          — medicine details stored once, not per prescription
--
--   TABLES MODIFIED:
--   ✔ hospital_record   → renamed to visit (now slim: only FK references
--                          and visit-specific data)
--   ✔ hospital_lab_test → renamed to visit_lab_result (only date+result)
--   ✔ hospital_medicine → renamed to visit_prescription (only dosage+freq+dur)
--   ✔ hospital_qualification → now linked to Doctor_ID not Record_ID
--
--   STILL REMAINING (to be fixed in 3NF):
--   ✘ Transitive dependency: Doctor_ID → Dept_ID → Dept_Head
--     (Dept_Head is about the department, not the doctor)
--   ✘ Transitive dependency: Visit_ID → Insurance_ID → Provider/Coverage
--     (Insurance details depend on Policy, not on Visit)
--   ✘ Bill and Payment info are in the visit table — they are separate
--     entities with their own transitive chains (3NF will split them out)
-- ============================================================
