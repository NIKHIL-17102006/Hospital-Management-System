-- ============================================================
-- Hospital Management System - Unnormalized Form (UNF)
-- Database: hospital_mgmt_unf
-- ============================================================
--
-- What is UNF (Unnormalized Form)?
-- A table is in UNF when it has NO normalization applied at all.
-- This means:
--   - All data is in ONE single flat table
--   - Repeating groups exist (multiple doctors, medicines, tests
--     for one patient are stuffed into numbered columns)
--   - Duplicate data everywhere (patient info repeated for
--     every appointment they have)
--   - Multi-valued attributes in single cells
--     (e.g. all qualifications in one comma-separated column)
--   - No foreign keys — everything is stored by value not by ID
--
-- Problems with UNF (why we normalize):
--   INSERT anomaly : Cannot add a doctor without a patient
--   UPDATE anomaly : Changing a room cost means updating hundreds of rows
--   DELETE anomaly : Deleting a patient deletes the doctor's shift info too
--   Redundancy     : Patient name/address repeated in every row
--
-- This file represents how the data would look if a non-database
-- person stored everything in one big Excel-like table.
-- ============================================================

CREATE DATABASE IF NOT EXISTS hospital_mgmt_unf;
USE hospital_mgmt_unf;

-- ============================================================
-- THE SINGLE UNNORMALIZED TABLE
-- Notice:
--   - Patient info columns repeat in every row
--   - Doctor info columns repeat in every row
--   - Department info stored as plain text (not referenced)
--   - Up to 3 medicines per row stored in numbered columns
--     (Medicine1_Name, Medicine2_Name, Medicine3_Name...)
--   - Up to 2 lab tests per row in numbered columns
--   - Doctor qualifications jammed into one comma-separated column
--   - Room cost duplicated for every patient in that room type
--   - Insurance info repeated in every row for that patient
--   - Shift times stored as plain text repeatedly
-- ============================================================

CREATE TABLE IF NOT EXISTS hospital_record (

    -- ---- RECORD IDENTITY ----
    Record_ID               INT PRIMARY KEY AUTO_INCREMENT,

    -- ---- PATIENT INFO (repeated for every appointment/record) ----
    Patient_Name            VARCHAR(100),
    Patient_DOB             DATE,
    Patient_Gender          VARCHAR(10),
    Patient_Blood_Group     VARCHAR(5),
    Patient_Phone           VARCHAR(15),
    Patient_Email           VARCHAR(100),
    Patient_Address         VARCHAR(255),
    Patient_Admission_Date  DATE,
    Patient_Discharge_Date  DATE,

    -- ---- DEPARTMENT INFO (repeated for every doctor in that dept) ----
    Department_Name         VARCHAR(100),
    Department_Head         VARCHAR(100),

    -- ---- DOCTOR INFO (repeated for every patient they see) ----
    Doctor_Name             VARCHAR(100),
    Doctor_Email            VARCHAR(100),
    Doctor_Phone            VARCHAR(15),
    Doctor_Address          VARCHAR(255),
    Doctor_DOB              DATE,
    Doctor_Joining_Date     DATE,
    Doctor_Specialization   VARCHAR(100),
    Doctor_Qualifications   VARCHAR(255),   -- e.g. "MBBS, MD, DM Cardiology" all in one cell

    -- ---- APPOINTMENT INFO ----
    Appointment_Date        DATE,
    Appointment_Time        TIME,
    Appointment_Status      VARCHAR(20),
    Appointment_Type        VARCHAR(20),

    -- ---- SHIFT INFO (doctor shift — repeated text every row) ----
    Doctor_Shift_Name       VARCHAR(50),
    Doctor_Shift_Start      TIME,
    Doctor_Shift_End        TIME,
    Doctor_Shift_Date       DATE,

    -- ---- NURSE INFO (repeated for every patient they are assigned to) ----
    Nurse_Name              VARCHAR(100),
    Nurse_Email             VARCHAR(100),
    Nurse_Phone             VARCHAR(15),
    Nurse_Shift_Name        VARCHAR(50),
    Nurse_Shift_Start       TIME,
    Nurse_Shift_End         TIME,
    Nurse_Shift_Date        DATE,

    -- ---- ROOM INFO (cost repeated for every patient in same room type) ----
    Room_Type               VARCHAR(50),
    Room_Cost_Per_Day       DECIMAL(10,2),
    Room_Admit_Date         DATE,
    Room_Discharge_Date     DATE,

    -- ---- LAB TESTS (repeating group — up to 2 tests per record) ----
    Test1_Name              VARCHAR(100),
    Test1_Cost              DECIMAL(10,2),
    Test1_Date              DATE,
    Test1_Result            TEXT,

    Test2_Name              VARCHAR(100),
    Test2_Cost              DECIMAL(10,2),
    Test2_Date              DATE,
    Test2_Result            TEXT,

    -- ---- MEDICINES PRESCRIBED (repeating group — up to 3 per record) ----
    Medicine1_Name          VARCHAR(100),
    Medicine1_Manufacturer  VARCHAR(100),
    Medicine1_Category      VARCHAR(50),
    Medicine1_Dosage        VARCHAR(50),
    Medicine1_Frequency     VARCHAR(50),
    Medicine1_Duration      VARCHAR(50),

    Medicine2_Name          VARCHAR(100),
    Medicine2_Manufacturer  VARCHAR(100),
    Medicine2_Category      VARCHAR(50),
    Medicine2_Dosage        VARCHAR(50),
    Medicine2_Frequency     VARCHAR(50),
    Medicine2_Duration      VARCHAR(50),

    Medicine3_Name          VARCHAR(100),
    Medicine3_Manufacturer  VARCHAR(100),
    Medicine3_Category      VARCHAR(50),
    Medicine3_Dosage        VARCHAR(50),
    Medicine3_Frequency     VARCHAR(50),
    Medicine3_Duration      VARCHAR(50),

    -- ---- INSURANCE INFO (repeated for every bill of that patient) ----
    Insurance_Provider      VARCHAR(100),
    Insurance_Policy_Number VARCHAR(50),
    Insurance_Coverage_Pct  DECIMAL(5,2),
    Insurance_Valid_From    DATE,
    Insurance_Valid_To      DATE,

    -- ---- BILLING INFO ----
    Bill_Date               DATE,
    Bill_Status             VARCHAR(20),
    Bill_Room_Charge        DECIMAL(10,2),
    Bill_Lab_Charge         DECIMAL(10,2),
    Bill_Medicine_Charge    DECIMAL(10,2),

    -- ---- PAYMENT INFO ----
    Payment_Date            DATE,
    Payment_Amount          DECIMAL(10,2),
    Payment_Mode            VARCHAR(30),
    Transaction_ID          VARCHAR(50)
);

-- ============================================================
-- DATA: 18 hospital records (one per patient visit)
-- All information denormalized into flat rows.
-- Notice how doctor info, department info, room cost, insurance
-- details are all duplicated across multiple rows.
-- ============================================================

INSERT INTO hospital_record (
    Patient_Name, Patient_DOB, Patient_Gender, Patient_Blood_Group,
    Patient_Phone, Patient_Email, Patient_Address,
    Patient_Admission_Date, Patient_Discharge_Date,
    Department_Name, Department_Head,
    Doctor_Name, Doctor_Email, Doctor_Phone, Doctor_Address, Doctor_DOB, Doctor_Joining_Date,
    Doctor_Specialization, Doctor_Qualifications,
    Appointment_Date, Appointment_Time, Appointment_Status, Appointment_Type,
    Doctor_Shift_Name, Doctor_Shift_Start, Doctor_Shift_End, Doctor_Shift_Date,
    Nurse_Name, Nurse_Email, Nurse_Phone,
    Nurse_Shift_Name, Nurse_Shift_Start, Nurse_Shift_End, Nurse_Shift_Date,
    Room_Type, Room_Cost_Per_Day, Room_Admit_Date, Room_Discharge_Date,
    Test1_Name, Test1_Cost, Test1_Date, Test1_Result,
    Test2_Name, Test2_Cost, Test2_Date, Test2_Result,
    Medicine1_Name, Medicine1_Manufacturer, Medicine1_Category, Medicine1_Dosage, Medicine1_Frequency, Medicine1_Duration,
    Medicine2_Name, Medicine2_Manufacturer, Medicine2_Category, Medicine2_Dosage, Medicine2_Frequency, Medicine2_Duration,
    Medicine3_Name, Medicine3_Manufacturer, Medicine3_Category, Medicine3_Dosage, Medicine3_Frequency, Medicine3_Duration,
    Insurance_Provider, Insurance_Policy_Number, Insurance_Coverage_Pct, Insurance_Valid_From, Insurance_Valid_To,
    Bill_Date, Bill_Status, Bill_Room_Charge, Bill_Lab_Charge, Bill_Medicine_Charge,
    Payment_Date, Payment_Amount, Payment_Mode, Transaction_ID
) VALUES

-- Record 1: Aarav Kumar — Cardiology — Dr. Rajesh Sharma
-- Notice: Room cost 500.00 will repeat for every General room patient
-- Doctor info will repeat again in Record 11 (Karan Mehta, same doctor)
(
    'Aarav Kumar',       '1985-03-12', 'Male',   'A+',
    '9811001001', 'aarav.kumar@gmail.com',    '101 Sector 15 Noida',
    '2025-01-05', '2025-01-12',
    'Cardiology', 'Dr. Rajesh Sharma',
    'Dr. Rajesh Sharma', 'rajesh.sharma@hospital.com', '9876543201', '12 MG Road Delhi', '1972-04-15', '2005-06-01',
    'Interventional Cardiology', 'MBBS, MD, DM Cardiology',
    '2025-01-05', '10:00:00', 'Completed', 'OPD',
    'Morning', '06:00:00', '14:00:00', '2025-01-06',
    'Kavya Reddy', 'kavya.reddy@hospital.com', '9876543211',
    'Morning', '06:00:00', '14:00:00', '2025-01-06',
    'General', 500.00, '2025-01-05', '2025-01-12',
    'ECG',    400.00, '2025-01-05', 'Normal sinus rhythm. No ST changes.',
    '2D Echo', 2500.00, '2025-01-06', 'EF 55%. Mild LVH noted.',
    'Atorvastatin 10mg', 'Lupin',     'Antilipemic',     '10mg',  'Once daily',    '30 days',
    'Metoprolol 50mg',   'Cipla',     'Beta Blocker',    '50mg',  'Twice daily',   '30 days',
    NULL, NULL, NULL, NULL, NULL, NULL,
    'Star Health Insurance', 'STAR-2021-001', 80.00, '2021-04-01', '2026-03-31',
    '2025-01-12', 'Paid', 3500.00, 2900.00, 360.00,
    '2025-01-12', 1252.00, 'UPI', 'TXN-UPI-20250112-001'
),

-- Record 2: Priya Sharma — Orthopedics — Dr. Priya Mehta
-- Room cost 1200.00 will repeat for every Semi-Private room patient
(
    'Priya Sharma',      '1990-07-22', 'Female', 'B+',
    '9811001002', 'priya.sharma@gmail.com',   '202 Dwarka Delhi',
    '2025-01-06', '2025-01-14',
    'Orthopedics', 'Dr. Priya Mehta',
    'Dr. Priya Mehta', 'priya.mehta@hospital.com', '9876543202', '34 Park Street Mumbai', '1978-09-22', '2008-03-15',
    'Joint Replacement Surgery', 'MBBS, MS Orthopedics',
    '2025-01-06', '11:30:00', 'Completed', 'OPD',
    'Afternoon', '14:00:00', '22:00:00', '2025-01-06',
    'Ritu Sharma', 'ritu.sharma@hospital.com', '9876543212',
    'Afternoon', '14:00:00', '22:00:00', '2025-01-06',
    'Semi-Private', 1200.00, '2025-01-06', '2025-01-14',
    'Complete Blood Count (CBC)', 350.00, '2025-01-07', 'Hb 10.2 g/dL. WBC 8200. Platelets normal.',
    NULL, NULL, NULL, NULL,
    'Diclofenac 50mg', 'Lupin',     'NSAID',      '50mg',  'Twice daily',        '5 days',
    'Paracetamol 500mg','Sun Pharma','Analgesic',  '500mg', 'Three times daily',  '5 days',
    NULL, NULL, NULL, NULL, NULL, NULL,
    'HDFC ERGO', 'HDFC-2022-002', 75.00, '2022-01-01', '2027-12-31',
    '2025-01-14', 'Paid', 8400.00, 350.00, 200.00,
    '2025-01-14', 2237.50, 'Credit Card', 'TXN-CC-20250114-002'
),

-- Record 3: Rohit Verma — Neurology — Dr. Anil Kapoor
(
    'Rohit Verma',       '1978-11-08', 'Male',   'O+',
    '9811001003', 'rohit.verma@gmail.com',    '303 Andheri Mumbai',
    '2025-01-07', '2025-01-10',
    'Neurology', 'Dr. Anil Kapoor',
    'Dr. Anil Kapoor', 'anil.kapoor@hospital.com', '9876543203', '56 Nehru Nagar Pune', '1969-11-30', '2002-01-10',
    'Epilepsy & Stroke', 'MBBS, MD, DM Neurology',
    '2025-01-07', '09:00:00', 'Completed', 'Emergency',
    'Night', '22:00:00', '06:00:00', '2025-01-06',
    'Pooja Tiwari', 'pooja.tiwari@hospital.com', '9876543213',
    'Night', '22:00:00', '06:00:00', '2025-01-06',
    'Private', 2500.00, '2025-01-07', '2025-01-10',
    'MRI Brain', 5000.00, '2025-01-07', 'Mild cortical atrophy. No bleed or infarct.',
    NULL, NULL, NULL, NULL,
    'Paracetamol 500mg', 'Sun Pharma', 'Analgesic',  '500mg', 'As needed',   '7 days',
    'Cetirizine 10mg',   'Alkem',      'Antihistamine','10mg','Once daily',  '7 days',
    NULL, NULL, NULL, NULL, NULL, NULL,
    'Bajaj Allianz', 'BAJA-2020-003', 70.00, '2020-06-01', '2025-05-31',
    '2025-01-10', 'Paid', 7500.00, 5000.00, 75.00,
    '2025-01-10', 3772.50, 'Cash', 'TXN-CSH-20250110-003'
),

-- Record 4: Sneha Patel — Emergency — Dr. Sunita Rao
-- ICU room cost 8000.00 — will repeat for Records 8, 11, 12
(
    'Sneha Patel',       '1995-05-30', 'Female', 'AB+',
    '9811001004', 'sneha.patel@gmail.com',    '404 Navrangpura Ahmedabad',
    '2025-01-08', '2025-01-15',
    'Emergency', 'Dr. Sunita Rao',
    'Dr. Sunita Rao', 'sunita.rao@hospital.com', '9876543204', '78 Anna Salai Chennai', '1980-07-05', '2010-08-20',
    'Emergency & Trauma', 'MBBS, MD Emergency Medicine',
    '2025-01-08', '14:00:00', 'Completed', 'OPD',
    'Morning', '06:00:00', '14:00:00', '2025-01-07',
    'Deepa Nair', 'deepa.nair@hospital.com', '9876543214',
    'Morning', '06:00:00', '14:00:00', '2025-01-07',
    'ICU', 8000.00, '2025-01-08', '2025-01-15',
    'Liver Function Test (LFT)', 700.00, '2025-01-08', 'WBC 14500 elevated. Suggestive of infection.',
    NULL, NULL, NULL, NULL,
    'Amoxicillin 250mg',  'Cipla',    'Antibiotic', '250mg', 'Three times daily', '7 days',
    'Pantoprazole 40mg',  'Sun Pharma','Antacid',   '40mg',  'Once daily',        '7 days',
    NULL, NULL, NULL, NULL, NULL, NULL,
    'ICICI Lombard', 'ICICI-2023-004', 85.00, '2023-03-01', '2028-02-28',
    '2025-01-15', 'Pending', 56000.00, 700.00, 375.00,
    NULL, NULL, NULL, NULL
),

-- Record 5: Mohit Agarwal — Pediatrics — Dr. Vikram Singh
(
    'Mohit Agarwal',     '1982-09-17', 'Male',   'A-',
    '9811001005', 'mohit.agarwal@gmail.com',  '505 Civil Lines Allahabad',
    '2025-01-09', NULL,
    'Pediatrics', 'Dr. Vikram Singh',
    'Dr. Vikram Singh', 'vikram.singh@hospital.com', '9876543205', '90 Civil Lines Lucknow', '1975-03-18', '2007-05-12',
    'Neonatology', 'MBBS, MD Pediatrics',
    '2025-01-09', '10:30:00', 'Scheduled', 'Follow-up',
    'Afternoon', '14:00:00', '22:00:00', '2025-01-07',
    'Suman Verma', 'suman.verma@hospital.com', '9876543215',
    'Afternoon', '14:00:00', '22:00:00', '2025-01-07',
    'General', 500.00, '2025-01-09', NULL,
    'Blood Glucose Fasting', 150.00, '2025-01-09', 'Fasting glucose 78 mg/dL. Normal.',
    NULL, NULL, NULL, NULL,
    'Ondansetron 4mg', 'Zydus', 'Antiemetic', '4mg', 'As needed', '3 days',
    NULL, NULL, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    'Bajaj Allianz', 'BAJA-2022-005', 75.00, '2022-04-01', '2027-03-31',
    '2025-01-20', 'Pending', 5500.00, 150.00, 210.00,
    NULL, NULL, NULL, NULL
),

-- Record 6: Kavita Jain — Dermatology — Dr. Neha Gupta
(
    'Kavita Jain',       '1975-02-14', 'Female', 'B-',
    '9811001006', 'kavita.jain@gmail.com',    '606 Malviya Nagar Jaipur',
    '2025-01-10', '2025-01-18',
    'Dermatology', 'Dr. Neha Gupta',
    'Dr. Neha Gupta', 'neha.gupta@hospital.com', '9876543206', '23 Rajpath Jaipur', '1983-12-25', '2012-11-01',
    'Cosmetic Dermatology', 'MBBS, MD Dermatology',
    '2025-01-10', '12:00:00', 'Completed', 'OPD',
    'Morning', '06:00:00', '14:00:00', '2025-01-08',
    'Anita Pillai', 'anita.pillai@hospital.com', '9876543216',
    'Night', '22:00:00', '06:00:00', '2025-01-07',
    'Semi-Private', 1200.00, '2025-01-10', '2025-01-18',
    'Urine Routine', 200.00, '2025-01-10', 'RBC count normal. No casts. Slight protein.',
    NULL, NULL, NULL, NULL,
    'Cetirizine 10mg', 'Alkem', 'Antihistamine', '10mg', 'Once daily', '14 days',
    NULL, NULL, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    'New India Assurance', 'NIA-2021-006', 60.00, '2021-07-01', '2026-06-30',
    '2025-01-18', 'Paid', 9600.00, 200.00, 490.00,
    '2025-01-18', 4073.60, 'Net Banking', 'TXN-NB-20250118-006'
),

-- Record 7: Arjun Nair — Oncology — Dr. Ramesh Iyer
(
    'Arjun Nair',        '1988-06-25', 'Male',   'O-',
    '9811001007', 'arjun.nair@gmail.com',     '707 Ernakulam Kochi',
    '2025-01-11', '2025-01-20',
    'Oncology', 'Dr. Ramesh Iyer',
    'Dr. Ramesh Iyer', 'ramesh.iyer@hospital.com', '9876543207', '45 Brigade Road Bangalore', '1968-08-14', '2000-04-22',
    'Surgical Oncology', 'MBBS, MS, MCh Oncology',
    '2025-01-11', '15:00:00', 'Completed', 'OPD',
    'Night', '22:00:00', '06:00:00', '2025-01-08',
    'Geeta Mishra', 'geeta.mishra@hospital.com', '9876543217',
    'Morning', '06:00:00', '14:00:00', '2025-01-08',
    'Private', 2500.00, '2025-01-11', '2025-01-20',
    'Complete Blood Count (CBC)', 350.00, '2025-01-11', 'WBC 3200 low post-chemo. Monitor.',
    NULL, NULL, NULL, NULL,
    'Clopidogrel 75mg', 'Dr. Reddy\'s', 'Antiplatelet', '75mg', 'Once daily', '30 days',
    NULL, NULL, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    'United India Insurance', 'UII-2022-007', 65.00, '2022-09-01', '2027-08-31',
    '2025-01-20', 'Paid', 22500.00, 350.00, 3000.00,
    '2025-01-20', 8702.50, 'Insurance', 'TXN-INS-20250120-007'
),

-- Record 8: Divya Reddy — Gynecology — Dr. Anjali Bose
-- ICU cost 8000.00 again — same value repeated from Record 4
(
    'Divya Reddy',       '1993-12-03', 'Female', 'A+',
    '9811001008', 'divya.reddy@gmail.com',    '808 Banjara Hills Hyderabad',
    '2025-01-12', NULL,
    'Gynecology', 'Dr. Anjali Bose',
    'Dr. Anjali Bose', 'anjali.bose@hospital.com', '9876543208', '67 Lake Town Kolkata', '1977-06-09', '2006-07-30',
    'High Risk Pregnancy', 'MBBS, MD Gynecology',
    '2025-01-12', '09:30:00', 'Scheduled', 'Emergency',
    'Afternoon', '14:00:00', '22:00:00', '2025-01-09',
    'Kavya Reddy', 'kavya.reddy@hospital.com', '9876543211',
    'Afternoon', '14:00:00', '22:00:00', '2025-01-08',
    'ICU', 8000.00, '2025-01-12', NULL,
    'Ultrasound Abdomen', 1200.00, '2025-01-12', 'Single live intrauterine fetus. 28 weeks.',
    NULL, NULL, NULL, NULL,
    'Insulin Glargine', 'Novo Nordisk', 'Antidiabetic', '10 units', 'Once daily at night', '30 days',
    NULL, NULL, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    'ICICI Lombard', 'ICICI-2021-008', 80.00, '2021-12-01', '2026-11-30',
    '2025-01-22', 'Pending', 80000.00, 1200.00, 1350.00,
    NULL, NULL, NULL, NULL
),

-- Record 9: Suresh Mishra — Radiology — Dr. Suresh Nair
(
    'Suresh Mishra',     '1970-04-19', 'Male',   'B+',
    '9811001009', 'suresh.mishra@gmail.com',  '909 Hazratganj Lucknow',
    '2025-01-13', '2025-01-22',
    'Radiology', 'Dr. Suresh Nair',
    'Dr. Suresh Nair', 'suresh.nair@hospital.com', '9876543209', '89 MG Road Kochi', '1981-02-28', '2011-09-05',
    'Interventional Radiology', 'MBBS, MD Radiology',
    '2025-01-13', '11:00:00', 'Completed', 'OPD',
    'Morning', '06:00:00', '14:00:00', '2025-01-09',
    'Ritu Sharma', 'ritu.sharma@hospital.com', '9876543212',
    'Night', '22:00:00', '06:00:00', '2025-01-08',
    'General', 500.00, '2025-01-13', '2025-01-22',
    'CT Scan Abdomen', 4500.00, '2025-01-13', 'No abdominal mass. Mild fatty liver.',
    NULL, NULL, NULL, NULL,
    'Omeprazole 20mg', 'Zydus', 'Antacid', '20mg', 'Once daily', '14 days',
    NULL, NULL, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    'Oriental Insurance', 'ORI-2020-009', 70.00, '2020-11-01', '2025-10-31',
    '2025-01-22', 'Paid', 4500.00, 4500.00, 210.00,
    '2025-01-22', 3220.50, 'UPI', 'TXN-UPI-20250122-009'
),

-- Record 10: Ananya Singh — Psychiatry — Dr. Meena Joshi
(
    'Ananya Singh',      '1999-08-07', 'Female', 'AB-',
    '9811001010', 'ananya.singh@gmail.com',   '100 Koramangala Bangalore',
    '2025-01-14', '2025-01-21',
    'Psychiatry', 'Dr. Meena Joshi',
    'Dr. Meena Joshi', 'meena.joshi@hospital.com', '9876543210', '11 Banjara Hills Hyderabad', '1974-10-17', '2004-02-14',
    'Child Psychiatry', 'MBBS, MD Psychiatry',
    '2025-01-14', '13:30:00', 'Completed', 'Follow-up',
    'Night', '22:00:00', '06:00:00', '2025-01-10',
    'Pooja Tiwari', 'pooja.tiwari@hospital.com', '9876543213',
    'Morning', '06:00:00', '14:00:00', '2025-01-09',
    'Semi-Private', 1200.00, '2025-01-14', '2025-01-21',
    'Complete Blood Count (CBC)', 350.00, '2025-01-14', 'All parameters within normal limits.',
    NULL, NULL, NULL, NULL,
    'Amlodipine 5mg', 'Mankind', 'Antihypertensive', '5mg', 'Once daily', '30 days',
    NULL, NULL, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    'Max Bupa', 'MAXB-2023-010', 80.00, '2023-01-01', '2028-12-31',
    '2025-01-21', 'Paid', 8400.00, 350.00, 285.00,
    '2025-01-21', 1827.00, 'Debit Card', 'TXN-DC-20250121-010'
),

-- Record 11: Karan Mehta — Cardiology — Dr. Rajesh Sharma
-- DUPLICATE ANOMALY: Dr. Rajesh Sharma info is repeated here
-- exactly as in Record 1. If his phone number changes, we must
-- update BOTH rows (and any other rows) — update anomaly!
(
    'Karan Mehta',       '1987-01-28', 'Male',   'O+',
    '9811001011', 'karan.mehta@gmail.com',    '111 Salt Lake Kolkata',
    '2025-01-15', NULL,
    'Cardiology', 'Dr. Rajesh Sharma',
    'Dr. Rajesh Sharma', 'rajesh.sharma@hospital.com', '9876543201', '12 MG Road Delhi', '1972-04-15', '2005-06-01',
    'Interventional Cardiology', 'MBBS, MD, DM Cardiology',
    '2025-01-15', '10:00:00', 'Scheduled', 'OPD',
    'Afternoon', '14:00:00', '22:00:00', '2025-01-10',
    'Deepa Nair', 'deepa.nair@hospital.com', '9876543214',
    'Afternoon', '14:00:00', '22:00:00', '2025-01-09',
    'Private', 2500.00, '2025-01-15', NULL,
    'Lipid Profile', 600.00, '2025-01-15', 'Total cholesterol 220 mg/dL. LDL 145 mg/dL.',
    NULL, NULL, NULL, NULL,
    'Amlodipine 5mg', 'Mankind', 'Antihypertensive', '5mg',  'Once daily', '60 days',
    'Losartan 50mg',  'Mankind', 'Antihypertensive', '50mg', 'Once daily', '60 days',
    NULL, NULL, NULL, NULL, NULL, NULL,
    'New India Assurance', 'NIA-2023-011', 70.00, '2023-02-01', '2028-01-31',
    '2025-01-25', 'Pending', 12500.00, 600.00, 1900.00,
    NULL, NULL, NULL, NULL
),

-- Record 12: Pooja Iyer — Orthopedics — Dr. Priya Mehta
-- DUPLICATE ANOMALY: Dr. Priya Mehta info repeated from Record 2
-- ICU cost 8000.00 repeated again
(
    'Pooja Iyer',        '1992-10-11', 'Female', 'A+',
    '9811001012', 'pooja.iyer@gmail.com',     '222 T Nagar Chennai',
    '2025-01-16', '2025-01-24',
    'Orthopedics', 'Dr. Priya Mehta',
    'Dr. Priya Mehta', 'priya.mehta@hospital.com', '9876543202', '34 Park Street Mumbai', '1978-09-22', '2008-03-15',
    'Joint Replacement Surgery', 'MBBS, MS Orthopedics',
    '2025-01-16', '14:30:00', 'Completed', 'OPD',
    'Morning', '06:00:00', '14:00:00', '2025-01-11',
    'Suman Verma', 'suman.verma@hospital.com', '9876543215',
    'Night', '22:00:00', '06:00:00', '2025-01-09',
    'ICU', 8000.00, '2025-01-16', '2025-01-24',
    'Chest X-Ray', 500.00, '2025-01-16', 'Fracture line visible. Callus formation beginning.',
    NULL, NULL, NULL, NULL,
    'Diclofenac 50mg', 'Lupin', 'NSAID', '50mg', 'Twice daily', '7 days',
    NULL, NULL, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    'Reliance Health', 'REL-2021-012', 75.00, '2021-05-01', '2026-04-30',
    '2025-01-24', 'Paid', 40000.00, 500.00, 560.00,
    '2025-01-24', 10265.00, 'Net Banking', 'TXN-NB-20250124-012'
),

-- Record 13: Nikhil Tiwari — Neurology — Dr. Anil Kapoor
-- DUPLICATE ANOMALY: Dr. Anil Kapoor info repeated from Record 3
-- NICU cost 10000.00
(
    'Nikhil Tiwari',     '1980-03-06', 'Male',   'B+',
    '9811001013', 'nikhil.tiwari@gmail.com',  '333 Shivaji Nagar Pune',
    '2025-01-17', '2025-01-25',
    'Neurology', 'Dr. Anil Kapoor',
    'Dr. Anil Kapoor', 'anil.kapoor@hospital.com', '9876543203', '56 Nehru Nagar Pune', '1969-11-30', '2002-01-10',
    'Epilepsy & Stroke', 'MBBS, MD, DM Neurology',
    '2025-01-17', '09:00:00', 'Completed', 'OPD',
    'Afternoon', '14:00:00', '22:00:00', '2025-01-11',
    'Anita Pillai', 'anita.pillai@hospital.com', '9876543216',
    'Morning', '06:00:00', '14:00:00', '2025-01-10',
    'NICU', 10000.00, '2025-01-17', '2025-01-25',
    'MRI Brain', 5000.00, '2025-01-17', 'Temporal lobe focus seen. Consistent with epilepsy.',
    NULL, NULL, NULL, NULL,
    'Azithromycin 500mg', 'Abbott', 'Antibiotic', '500mg', 'Twice daily', '90 days',
    NULL, NULL, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    'Aditya Birla Health', 'ABH-2022-013', 85.00, '2022-08-01', '2027-07-31',
    '2025-01-25', 'Paid', 80000.00, 5000.00, 1875.00,
    '2025-01-25', 73378.75, 'Insurance', 'TXN-INS-20250125-013'
),

-- Record 14: Ritu Bose — Emergency — Dr. Sunita Rao
-- DUPLICATE ANOMALY: Dr. Sunita Rao info repeated from Record 4
(
    'Ritu Bose',         '1996-07-15', 'Female', 'O+',
    '9811001014', 'ritu.bose@gmail.com',      '444 Lake Garden Kolkata',
    '2025-01-18', NULL,
    'Emergency', 'Dr. Sunita Rao',
    'Dr. Sunita Rao', 'sunita.rao@hospital.com', '9876543204', '78 Anna Salai Chennai', '1980-07-05', '2010-08-20',
    'Emergency & Trauma', 'MBBS, MD Emergency Medicine',
    '2025-01-18', '11:00:00', 'Scheduled', 'Follow-up',
    'Night', '22:00:00', '06:00:00', '2025-01-12',
    'Geeta Mishra', 'geeta.mishra@hospital.com', '9876543217',
    'Afternoon', '14:00:00', '22:00:00', '2025-01-10',
    'HDU', 5000.00, '2025-01-18', NULL,
    'Dengue NS1 Antigen', 800.00, '2025-01-18', 'Dengue NS1 Negative. IgM Positive.',
    NULL, NULL, NULL, NULL,
    'Amoxicillin 250mg', 'Cipla', 'Antibiotic', '250mg', 'Twice daily', '7 days',  -- NOTE: different frequency than Record 4!
    NULL, NULL, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    'Oriental Insurance', 'ORI-2022-014', 60.00, '2022-07-01', '2027-06-30',
    '2025-01-28', 'Pending', 40000.00, 800.00, 560.00,
    NULL, NULL, NULL, NULL
),

-- Record 15: Vivek Pillai — Pediatrics — Dr. Vikram Singh
-- DUPLICATE ANOMALY: Dr. Vikram Singh info repeated from Record 5
(
    'Vivek Pillai',      '1974-11-23', 'Male',   'A-',
    '9811001015', 'vivek.pillai@gmail.com',   '555 Vile Parle Mumbai',
    '2025-01-19', '2025-01-27',
    'Pediatrics', 'Dr. Vikram Singh',
    'Dr. Vikram Singh', 'vikram.singh@hospital.com', '9876543205', '90 Civil Lines Lucknow', '1975-03-18', '2007-05-12',
    'Neonatology', 'MBBS, MD Pediatrics',
    '2025-01-19', '10:30:00', 'Completed', 'OPD',
    'Morning', '06:00:00', '14:00:00', '2025-01-12',
    'Kavya Reddy', 'kavya.reddy@hospital.com', '9876543211',
    'Night', '22:00:00', '06:00:00', '2025-01-10',
    'Deluxe', 4000.00, '2025-01-19', '2025-01-27',
    'Chest X-Ray', 500.00, '2025-01-19', 'Hyperinflated lungs. Consistent with asthma.',
    NULL, NULL, NULL, NULL,
    'Cetirizine 10mg', 'Alkem', 'Antihistamine', '10mg', 'Once daily', '7 days',
    NULL, NULL, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    'Tata AIG', 'TATA-2021-015', 70.00, '2021-02-01', '2026-01-31',
    '2025-01-27', 'Paid', 32000.00, 500.00, 245.00,
    '2025-01-27', 9823.50, 'Credit Card', 'TXN-CC-20250127-015'
),

-- Record 16: Meera Choudhary — Dermatology — Dr. Neha Gupta
-- DUPLICATE ANOMALY: Dr. Neha Gupta info repeated from Record 6
(
    'Meera Choudhary',   '1989-05-09', 'Female', 'B+',
    '9811001016', 'meera.choudhary@gmail.com','666 Malviya Nagar Bhopal',
    '2025-01-20', '2025-01-28',
    'Dermatology', 'Dr. Neha Gupta',
    'Dr. Neha Gupta', 'neha.gupta@hospital.com', '9876543206', '23 Rajpath Jaipur', '1983-12-25', '2012-11-01',
    'Cosmetic Dermatology', 'MBBS, MD Dermatology',
    '2025-01-20', '15:30:00', 'Completed', 'OPD',
    'Afternoon', '14:00:00', '22:00:00', '2025-01-13',
    'Ritu Sharma', 'ritu.sharma@hospital.com', '9876543212',
    'Morning', '06:00:00', '14:00:00', '2025-01-11',
    'Suite', 7000.00, '2025-01-20', '2025-01-28',
    'Urine Routine', 200.00, '2025-01-20', 'Normal. No proteinuria.',
    NULL, NULL, NULL, NULL,
    'Cetirizine 10mg', 'Alkem', 'Antihistamine', '10mg', 'Once daily', '7 days',
    NULL, NULL, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    'Star Health Insurance', 'STAR-2023-016', 80.00, '2023-06-01', '2028-05-31',
    '2025-01-28', 'Paid', 56000.00, 200.00, 245.00,
    '2025-01-28', 11289.00, 'UPI', 'TXN-UPI-20250128-016'
),

-- Record 17: Rahul Saxena — Oncology — Dr. Ramesh Iyer
-- DUPLICATE ANOMALY: Dr. Ramesh Iyer info repeated from Record 7
-- NICU cost 10000.00 repeated from Record 13
(
    'Rahul Saxena',      '1983-09-30', 'Male',   'AB+',
    '9811001017', 'rahul.saxena@gmail.com',   '777 Gomti Nagar Lucknow',
    '2025-01-21', NULL,
    'Oncology', 'Dr. Ramesh Iyer',
    'Dr. Ramesh Iyer', 'ramesh.iyer@hospital.com', '9876543207', '45 Brigade Road Bangalore', '1968-08-14', '2000-04-22',
    'Surgical Oncology', 'MBBS, MS, MCh Oncology',
    '2025-01-21', '12:00:00', 'Scheduled', 'OPD',
    'Morning', '06:00:00', '14:00:00', '2025-01-13',
    'Pooja Tiwari', 'pooja.tiwari@hospital.com', '9876543213',
    'Afternoon', '14:00:00', '22:00:00', '2025-01-11',
    'NICU', 10000.00, '2025-01-21', NULL,
    'Complete Blood Count (CBC)', 350.00, '2025-01-21', 'WBC 4100. RBC 3.8. Hb 11.0.',
    NULL, NULL, NULL, NULL,
    'Clopidogrel 75mg', 'Dr. Reddy\'s', 'Antiplatelet', '75mg', 'Once daily', '30 days',
    NULL, NULL, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    'Max Bupa', 'MAXB-2021-017', 85.00, '2021-09-01', '2026-08-31',
    '2025-01-30', 'Pending', 90000.00, 350.00, 1500.00,
    NULL, NULL, NULL, NULL
),

-- Record 18: Sunita Pandey — Gynecology — Dr. Anjali Bose
-- DUPLICATE ANOMALY: Dr. Anjali Bose info repeated from Record 8
-- HDU cost 5000.00 repeated from Record 14
(
    'Sunita Pandey',     '1977-02-18', 'Female', 'O-',
    '9811001018', 'sunita.pandey@gmail.com',  '888 Rajpur Road Dehradun',
    '2025-01-22', '2025-01-30',
    'Gynecology', 'Dr. Anjali Bose',
    'Dr. Anjali Bose', 'anjali.bose@hospital.com', '9876543208', '67 Lake Town Kolkata', '1977-06-09', '2006-07-30',
    'High Risk Pregnancy', 'MBBS, MD Gynecology',
    '2025-01-22', '09:30:00', 'Completed', 'Emergency',
    'Night', '22:00:00', '06:00:00', '2025-01-14',
    'Suman Verma', 'suman.verma@hospital.com', '9876543215',
    'Night', '22:00:00', '06:00:00', '2025-01-11',
    'HDU', 5000.00, '2025-01-22', '2025-01-30',
    'Thyroid Function Test', 900.00, '2025-01-22', NULL,
    NULL, NULL, NULL, NULL,
    'Metformin 500mg', 'Dr. Reddy\'s', 'Antidiabetic', '500mg', 'Twice daily', '90 days',
    NULL, NULL, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    'HDFC ERGO', 'HDFC-2020-018', 65.00, '2020-10-01', '2025-09-30',
    '2025-01-30', 'Paid', 40000.00, 900.00, 405.00,
    '2025-01-30', 13910.25, 'Cash', 'TXN-CSH-20250130-018'
);

-- ============================================================
-- END OF UNF DUMP
--
-- Problems visible in this data (that normalization solves):
--
-- 1. REDUNDANCY
--    Dr. Rajesh Sharma's full details appear in Records 1 AND 11.
--    Dr. Priya Mehta's details appear in Records 2 AND 12.
--    Room cost 500.00 for General appears in Records 1, 5, 9.
--    ICU cost 8000.00 appears in Records 4, 8, 12.
--
-- 2. UPDATE ANOMALY
--    If Dr. Rajesh Sharma changes his phone number, we must find
--    and update every row where he appears — miss one = inconsistency.
--
-- 3. INSERT ANOMALY
--    Cannot add a new doctor to the system without also having
--    a patient record to attach them to.
--
-- 4. DELETE ANOMALY
--    If Record 7 (Arjun Nair) is deleted, we lose all information
--    about Dr. Ramesh Iyer's shift on 2025-01-08 — unless he
--    also appears in Record 17.
--
-- 5. REPEATING GROUPS
--    Medicine1/Medicine2/Medicine3 columns — what if a patient
--    needs 4 medicines? We'd need to add Medicine4_* columns
--    and ALTER the entire table.
--
-- 6. NULL WASTE
--    Many Medicine2/Medicine3 and Test2 columns are NULL because
--    most patients need only 1-2 medicines. Wasted storage.
-- ============================================================
