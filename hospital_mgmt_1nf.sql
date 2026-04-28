-- ============================================================
-- Hospital Management System - First Normal Form (1NF)
-- Database: hospital_mgmt_1nf
-- ============================================================
--
-- What is 1NF (First Normal Form)?
-- A table is in 1NF when ALL of the following are true:
--   1. Every column contains ATOMIC (indivisible) values
--      — no comma-separated lists, no multi-valued cells
--   2. Every column contains values of a SINGLE TYPE
--   3. Every row is UNIQUE — each table has a PRIMARY KEY
--   4. NO REPEATING GROUPS — numbered columns like
--      Medicine1, Medicine2, Medicine3 are eliminated.
--      Instead each value gets its OWN ROW in a related table.
--
-- What 1NF does NOT fix (still present, fixed in 2NF):
--   - Redundancy: Doctor info still repeated in every record row
--   - Redundancy: Room cost still repeated for same room type
--   - Redundancy: Department head repeated for every doctor row
--   - Partial dependencies still exist (non-key columns depending
--     on only PART of a composite key)
--
-- Changes made from UNF → 1NF:
--   CHANGE 1: Removed Medicine1/Medicine2/Medicine3 repeating columns.
--             Created hospital_medicine table — each prescribed
--             medicine is now one atomic row linked to a record.
--
--   CHANGE 2: Removed Test1/Test2 repeating columns.
--             Created hospital_lab_test table — each lab test
--             is now one atomic row linked to a record.
--
--   CHANGE 3: Split Doctor_Qualifications VARCHAR(255) which stored
--             "MBBS, MD, DM Cardiology" as a single cell into
--             hospital_qualification table — each degree is one row.
--
--   CHANGE 4: Added proper PRIMARY KEYs to all tables.
--
-- Redundancy still present (intentional — this is only 1NF):
--   - Doctor_Name, Doctor_Email etc. still repeat per patient
--   - Department_Name, Department_Head still repeat per doctor row
--   - Room_Cost_Per_Day still repeats for same Room_Type
--   - Insurance info still repeats per patient per bill
-- ============================================================

CREATE DATABASE IF NOT EXISTS hospital_mgmt_1nf;
USE hospital_mgmt_1nf;

-- ============================================================
-- TABLE: hospital_record
-- The main flat table from UNF — kept mostly intact.
-- CHANGES FROM UNF:
--   - Removed: Medicine1/2/3 columns (moved to hospital_medicine)
--   - Removed: Test1/2 columns (moved to hospital_lab_test)
--   - Removed: Doctor_Qualifications (moved to hospital_qualification)
--   - All remaining columns are now atomic (one value per cell)
-- STILL NOT FIXED (will be fixed in 2NF):
--   - Doctor info repeats across rows (Records 1 & 11 have same doctor)
--   - Room_Cost_Per_Day repeats for same Room_Type
--   - Department_Head repeats for same Department_Name
-- ============================================================
CREATE TABLE IF NOT EXISTS hospital_record (

    Record_ID               INT PRIMARY KEY AUTO_INCREMENT,

    -- PATIENT INFO (still repeated per record row — 2NF will fix this)
    Patient_Name            VARCHAR(100),
    Patient_DOB             DATE,
    Patient_Gender          VARCHAR(10),
    Patient_Blood_Group     VARCHAR(5),
    Patient_Phone           VARCHAR(15),
    Patient_Email           VARCHAR(100),
    Patient_Address         VARCHAR(255),
    Patient_Admission_Date  DATE,
    Patient_Discharge_Date  DATE,

    -- DEPARTMENT INFO (still repeated per doctor row — 2NF will fix this)
    Department_Name         VARCHAR(100),
    Department_Head         VARCHAR(100),

    -- DOCTOR INFO (still repeated per patient row — 2NF will fix this)
    Doctor_Name             VARCHAR(100),
    Doctor_Email            VARCHAR(100),
    Doctor_Phone            VARCHAR(15),
    Doctor_Address          VARCHAR(255),
    Doctor_DOB              DATE,
    Doctor_Joining_Date     DATE,
    Doctor_Specialization   VARCHAR(100),
    -- Doctor_Qualifications REMOVED — moved to hospital_qualification table

    -- APPOINTMENT INFO
    Appointment_Date        DATE,
    Appointment_Time        TIME,
    Appointment_Status      VARCHAR(20),
    Appointment_Type        VARCHAR(20),

    -- DOCTOR SHIFT INFO (still repeated — 2NF will fix this)
    Doctor_Shift_Name       VARCHAR(50),
    Doctor_Shift_Start      TIME,
    Doctor_Shift_End        TIME,
    Doctor_Shift_Date       DATE,

    -- NURSE INFO (still repeated — 2NF will fix this)
    Nurse_Name              VARCHAR(100),
    Nurse_Email             VARCHAR(100),
    Nurse_Phone             VARCHAR(15),
    Nurse_Shift_Name        VARCHAR(50),
    Nurse_Shift_Start       TIME,
    Nurse_Shift_End         TIME,
    Nurse_Shift_Date        DATE,

    -- ROOM INFO (Room_Cost_Per_Day still repeats per Room_Type — 2NF will fix)
    Room_Type               VARCHAR(50),
    Room_Cost_Per_Day       DECIMAL(10,2),
    Room_Admit_Date         DATE,
    Room_Discharge_Date     DATE,

    -- INSURANCE INFO (still repeats per patient — 2NF will fix this)
    Insurance_Provider      VARCHAR(100),
    Insurance_Policy_Number VARCHAR(50),
    Insurance_Coverage_Pct  DECIMAL(5,2),
    Insurance_Valid_From    DATE,
    Insurance_Valid_To      DATE,

    -- BILLING INFO
    Bill_Date               DATE,
    Bill_Status             VARCHAR(20),
    Bill_Room_Charge        DECIMAL(10,2),
    Bill_Lab_Charge         DECIMAL(10,2),
    Bill_Medicine_Charge    DECIMAL(10,2),

    -- PAYMENT INFO
    Payment_Date            DATE,
    Payment_Amount          DECIMAL(10,2),
    Payment_Mode            VARCHAR(30),
    Transaction_ID          VARCHAR(50)
);

INSERT INTO hospital_record (
    Patient_Name, Patient_DOB, Patient_Gender, Patient_Blood_Group,
    Patient_Phone, Patient_Email, Patient_Address,
    Patient_Admission_Date, Patient_Discharge_Date,
    Department_Name, Department_Head,
    Doctor_Name, Doctor_Email, Doctor_Phone, Doctor_Address, Doctor_DOB, Doctor_Joining_Date, Doctor_Specialization,
    Appointment_Date, Appointment_Time, Appointment_Status, Appointment_Type,
    Doctor_Shift_Name, Doctor_Shift_Start, Doctor_Shift_End, Doctor_Shift_Date,
    Nurse_Name, Nurse_Email, Nurse_Phone,
    Nurse_Shift_Name, Nurse_Shift_Start, Nurse_Shift_End, Nurse_Shift_Date,
    Room_Type, Room_Cost_Per_Day, Room_Admit_Date, Room_Discharge_Date,
    Insurance_Provider, Insurance_Policy_Number, Insurance_Coverage_Pct, Insurance_Valid_From, Insurance_Valid_To,
    Bill_Date, Bill_Status, Bill_Room_Charge, Bill_Lab_Charge, Bill_Medicine_Charge,
    Payment_Date, Payment_Amount, Payment_Mode, Transaction_ID
) VALUES
-- Record 1
('Aarav Kumar','1985-03-12','Male','A+','9811001001','aarav.kumar@gmail.com','101 Sector 15 Noida','2025-01-05','2025-01-12',
 'Cardiology','Dr. Rajesh Sharma',
 'Dr. Rajesh Sharma','rajesh.sharma@hospital.com','9876543201','12 MG Road Delhi','1972-04-15','2005-06-01','Interventional Cardiology',
 '2025-01-05','10:00:00','Completed','OPD',
 'Morning','06:00:00','14:00:00','2025-01-06',
 'Kavya Reddy','kavya.reddy@hospital.com','9876543211','Morning','06:00:00','14:00:00','2025-01-06',
 'General',500.00,'2025-01-05','2025-01-12',
 'Star Health Insurance','STAR-2021-001',80.00,'2021-04-01','2026-03-31',
 '2025-01-12','Paid',3500.00,2900.00,360.00,'2025-01-12',1252.00,'UPI','TXN-UPI-20250112-001'),

-- Record 2
('Priya Sharma','1990-07-22','Female','B+','9811001002','priya.sharma@gmail.com','202 Dwarka Delhi','2025-01-06','2025-01-14',
 'Orthopedics','Dr. Priya Mehta',
 'Dr. Priya Mehta','priya.mehta@hospital.com','9876543202','34 Park Street Mumbai','1978-09-22','2008-03-15','Joint Replacement Surgery',
 '2025-01-06','11:30:00','Completed','OPD',
 'Afternoon','14:00:00','22:00:00','2025-01-06',
 'Ritu Sharma','ritu.sharma@hospital.com','9876543212','Afternoon','14:00:00','22:00:00','2025-01-06',
 'Semi-Private',1200.00,'2025-01-06','2025-01-14',
 'HDFC ERGO','HDFC-2022-002',75.00,'2022-01-01','2027-12-31',
 '2025-01-14','Paid',8400.00,350.00,200.00,'2025-01-14',2237.50,'Credit Card','TXN-CC-20250114-002'),

-- Record 3
('Rohit Verma','1978-11-08','Male','O+','9811001003','rohit.verma@gmail.com','303 Andheri Mumbai','2025-01-07','2025-01-10',
 'Neurology','Dr. Anil Kapoor',
 'Dr. Anil Kapoor','anil.kapoor@hospital.com','9876543203','56 Nehru Nagar Pune','1969-11-30','2002-01-10','Epilepsy & Stroke',
 '2025-01-07','09:00:00','Completed','Emergency',
 'Night','22:00:00','06:00:00','2025-01-06',
 'Pooja Tiwari','pooja.tiwari@hospital.com','9876543213','Night','22:00:00','06:00:00','2025-01-06',
 'Private',2500.00,'2025-01-07','2025-01-10',
 'Bajaj Allianz','BAJA-2020-003',70.00,'2020-06-01','2025-05-31',
 '2025-01-10','Paid',7500.00,5000.00,75.00,'2025-01-10',3772.50,'Cash','TXN-CSH-20250110-003'),

-- Record 4
('Sneha Patel','1995-05-30','Female','AB+','9811001004','sneha.patel@gmail.com','404 Navrangpura Ahmedabad','2025-01-08','2025-01-15',
 'Emergency','Dr. Sunita Rao',
 'Dr. Sunita Rao','sunita.rao@hospital.com','9876543204','78 Anna Salai Chennai','1980-07-05','2010-08-20','Emergency & Trauma',
 '2025-01-08','14:00:00','Completed','OPD',
 'Morning','06:00:00','14:00:00','2025-01-07',
 'Deepa Nair','deepa.nair@hospital.com','9876543214','Morning','06:00:00','14:00:00','2025-01-07',
 'ICU',8000.00,'2025-01-08','2025-01-15',
 'ICICI Lombard','ICICI-2023-004',85.00,'2023-03-01','2028-02-28',
 '2025-01-15','Pending',56000.00,700.00,375.00,NULL,NULL,NULL,NULL),

-- Record 5
('Mohit Agarwal','1982-09-17','Male','A-','9811001005','mohit.agarwal@gmail.com','505 Civil Lines Allahabad','2025-01-09',NULL,
 'Pediatrics','Dr. Vikram Singh',
 'Dr. Vikram Singh','vikram.singh@hospital.com','9876543205','90 Civil Lines Lucknow','1975-03-18','2007-05-12','Neonatology',
 '2025-01-09','10:30:00','Scheduled','Follow-up',
 'Afternoon','14:00:00','22:00:00','2025-01-07',
 'Suman Verma','suman.verma@hospital.com','9876543215','Afternoon','14:00:00','22:00:00','2025-01-07',
 'General',500.00,'2025-01-09',NULL,
 'Bajaj Allianz','BAJA-2022-005',75.00,'2022-04-01','2027-03-31',
 '2025-01-20','Pending',5500.00,150.00,210.00,NULL,NULL,NULL,NULL),

-- Record 6
('Kavita Jain','1975-02-14','Female','B-','9811001006','kavita.jain@gmail.com','606 Malviya Nagar Jaipur','2025-01-10','2025-01-18',
 'Dermatology','Dr. Neha Gupta',
 'Dr. Neha Gupta','neha.gupta@hospital.com','9876543206','23 Rajpath Jaipur','1983-12-25','2012-11-01','Cosmetic Dermatology',
 '2025-01-10','12:00:00','Completed','OPD',
 'Morning','06:00:00','14:00:00','2025-01-08',
 'Anita Pillai','anita.pillai@hospital.com','9876543216','Night','22:00:00','06:00:00','2025-01-07',
 'Semi-Private',1200.00,'2025-01-10','2025-01-18',
 'New India Assurance','NIA-2021-006',60.00,'2021-07-01','2026-06-30',
 '2025-01-18','Paid',9600.00,200.00,490.00,'2025-01-18',4073.60,'Net Banking','TXN-NB-20250118-006'),

-- Record 7
('Arjun Nair','1988-06-25','Male','O-','9811001007','arjun.nair@gmail.com','707 Ernakulam Kochi','2025-01-11','2025-01-20',
 'Oncology','Dr. Ramesh Iyer',
 'Dr. Ramesh Iyer','ramesh.iyer@hospital.com','9876543207','45 Brigade Road Bangalore','1968-08-14','2000-04-22','Surgical Oncology',
 '2025-01-11','15:00:00','Completed','OPD',
 'Night','22:00:00','06:00:00','2025-01-08',
 'Geeta Mishra','geeta.mishra@hospital.com','9876543217','Morning','06:00:00','14:00:00','2025-01-08',
 'Private',2500.00,'2025-01-11','2025-01-20',
 'United India Insurance','UII-2022-007',65.00,'2022-09-01','2027-08-31',
 '2025-01-20','Paid',22500.00,350.00,3000.00,'2025-01-20',8702.50,'Insurance','TXN-INS-20250120-007'),

-- Record 8
('Divya Reddy','1993-12-03','Female','A+','9811001008','divya.reddy@gmail.com','808 Banjara Hills Hyderabad','2025-01-12',NULL,
 'Gynecology','Dr. Anjali Bose',
 'Dr. Anjali Bose','anjali.bose@hospital.com','9876543208','67 Lake Town Kolkata','1977-06-09','2006-07-30','High Risk Pregnancy',
 '2025-01-12','09:30:00','Scheduled','Emergency',
 'Afternoon','14:00:00','22:00:00','2025-01-09',
 'Kavya Reddy','kavya.reddy@hospital.com','9876543211','Afternoon','14:00:00','22:00:00','2025-01-08',
 'ICU',8000.00,'2025-01-12',NULL,
 'ICICI Lombard','ICICI-2021-008',80.00,'2021-12-01','2026-11-30',
 '2025-01-22','Pending',80000.00,1200.00,1350.00,NULL,NULL,NULL,NULL),

-- Record 9
('Suresh Mishra','1970-04-19','Male','B+','9811001009','suresh.mishra@gmail.com','909 Hazratganj Lucknow','2025-01-13','2025-01-22',
 'Radiology','Dr. Suresh Nair',
 'Dr. Suresh Nair','suresh.nair@hospital.com','9876543209','89 MG Road Kochi','1981-02-28','2011-09-05','Interventional Radiology',
 '2025-01-13','11:00:00','Completed','OPD',
 'Morning','06:00:00','14:00:00','2025-01-09',
 'Ritu Sharma','ritu.sharma@hospital.com','9876543212','Night','22:00:00','06:00:00','2025-01-08',
 'General',500.00,'2025-01-13','2025-01-22',
 'Oriental Insurance','ORI-2020-009',70.00,'2020-11-01','2025-10-31',
 '2025-01-22','Paid',4500.00,4500.00,210.00,'2025-01-22',3220.50,'UPI','TXN-UPI-20250122-009'),

-- Record 10
('Ananya Singh','1999-08-07','Female','AB-','9811001010','ananya.singh@gmail.com','100 Koramangala Bangalore','2025-01-14','2025-01-21',
 'Psychiatry','Dr. Meena Joshi',
 'Dr. Meena Joshi','meena.joshi@hospital.com','9876543210','11 Banjara Hills Hyderabad','1974-10-17','2004-02-14','Child Psychiatry',
 '2025-01-14','13:30:00','Completed','Follow-up',
 'Night','22:00:00','06:00:00','2025-01-10',
 'Pooja Tiwari','pooja.tiwari@hospital.com','9876543213','Morning','06:00:00','14:00:00','2025-01-09',
 'Semi-Private',1200.00,'2025-01-14','2025-01-21',
 'Max Bupa','MAXB-2023-010',80.00,'2023-01-01','2028-12-31',
 '2025-01-21','Paid',8400.00,350.00,285.00,'2025-01-21',1827.00,'Debit Card','TXN-DC-20250121-010'),

-- Record 11 — SAME DOCTOR as Record 1 (Dr. Rajesh Sharma repeated — update anomaly still exists)
('Karan Mehta','1987-01-28','Male','O+','9811001011','karan.mehta@gmail.com','111 Salt Lake Kolkata','2025-01-15',NULL,
 'Cardiology','Dr. Rajesh Sharma',
 'Dr. Rajesh Sharma','rajesh.sharma@hospital.com','9876543201','12 MG Road Delhi','1972-04-15','2005-06-01','Interventional Cardiology',
 '2025-01-15','10:00:00','Scheduled','OPD',
 'Afternoon','14:00:00','22:00:00','2025-01-10',
 'Deepa Nair','deepa.nair@hospital.com','9876543214','Afternoon','14:00:00','22:00:00','2025-01-09',
 'Private',2500.00,'2025-01-15',NULL,
 'New India Assurance','NIA-2023-011',70.00,'2023-02-01','2028-01-31',
 '2025-01-25','Pending',12500.00,600.00,1900.00,NULL,NULL,NULL,NULL),

-- Record 12 — SAME DOCTOR as Record 2 (Dr. Priya Mehta repeated)
('Pooja Iyer','1992-10-11','Female','A+','9811001012','pooja.iyer@gmail.com','222 T Nagar Chennai','2025-01-16','2025-01-24',
 'Orthopedics','Dr. Priya Mehta',
 'Dr. Priya Mehta','priya.mehta@hospital.com','9876543202','34 Park Street Mumbai','1978-09-22','2008-03-15','Joint Replacement Surgery',
 '2025-01-16','14:30:00','Completed','OPD',
 'Morning','06:00:00','14:00:00','2025-01-11',
 'Suman Verma','suman.verma@hospital.com','9876543215','Night','22:00:00','06:00:00','2025-01-09',
 'ICU',8000.00,'2025-01-16','2025-01-24',
 'Reliance Health','REL-2021-012',75.00,'2021-05-01','2026-04-30',
 '2025-01-24','Paid',40000.00,500.00,560.00,'2025-01-24',10265.00,'Net Banking','TXN-NB-20250124-012'),

-- Record 13 — SAME DOCTOR as Record 3 (Dr. Anil Kapoor repeated)
('Nikhil Tiwari','1980-03-06','Male','B+','9811001013','nikhil.tiwari@gmail.com','333 Shivaji Nagar Pune','2025-01-17','2025-01-25',
 'Neurology','Dr. Anil Kapoor',
 'Dr. Anil Kapoor','anil.kapoor@hospital.com','9876543203','56 Nehru Nagar Pune','1969-11-30','2002-01-10','Epilepsy & Stroke',
 '2025-01-17','09:00:00','Completed','OPD',
 'Afternoon','14:00:00','22:00:00','2025-01-11',
 'Anita Pillai','anita.pillai@hospital.com','9876543216','Morning','06:00:00','14:00:00','2025-01-10',
 'NICU',10000.00,'2025-01-17','2025-01-25',
 'Aditya Birla Health','ABH-2022-013',85.00,'2022-08-01','2027-07-31',
 '2025-01-25','Paid',80000.00,5000.00,1875.00,'2025-01-25',73378.75,'Insurance','TXN-INS-20250125-013'),

-- Record 14 — SAME DOCTOR as Record 4 (Dr. Sunita Rao repeated)
('Ritu Bose','1996-07-15','Female','O+','9811001014','ritu.bose@gmail.com','444 Lake Garden Kolkata','2025-01-18',NULL,
 'Emergency','Dr. Sunita Rao',
 'Dr. Sunita Rao','sunita.rao@hospital.com','9876543204','78 Anna Salai Chennai','1980-07-05','2010-08-20','Emergency & Trauma',
 '2025-01-18','11:00:00','Scheduled','Follow-up',
 'Night','22:00:00','06:00:00','2025-01-12',
 'Geeta Mishra','geeta.mishra@hospital.com','9876543217','Afternoon','14:00:00','22:00:00','2025-01-10',
 'HDU',5000.00,'2025-01-18',NULL,
 'Oriental Insurance','ORI-2022-014',60.00,'2022-07-01','2027-06-30',
 '2025-01-28','Pending',40000.00,800.00,560.00,NULL,NULL,NULL,NULL),

-- Record 15 — SAME DOCTOR as Record 5 (Dr. Vikram Singh repeated)
('Vivek Pillai','1974-11-23','Male','A-','9811001015','vivek.pillai@gmail.com','555 Vile Parle Mumbai','2025-01-19','2025-01-27',
 'Pediatrics','Dr. Vikram Singh',
 'Dr. Vikram Singh','vikram.singh@hospital.com','9876543205','90 Civil Lines Lucknow','1975-03-18','2007-05-12','Neonatology',
 '2025-01-19','10:30:00','Completed','OPD',
 'Morning','06:00:00','14:00:00','2025-01-12',
 'Kavya Reddy','kavya.reddy@hospital.com','9876543211','Night','22:00:00','06:00:00','2025-01-10',
 'Deluxe',4000.00,'2025-01-19','2025-01-27',
 'Tata AIG','TATA-2021-015',70.00,'2021-02-01','2026-01-31',
 '2025-01-27','Paid',32000.00,500.00,245.00,'2025-01-27',9823.50,'Credit Card','TXN-CC-20250127-015'),

-- Record 16 — SAME DOCTOR as Record 6 (Dr. Neha Gupta repeated)
('Meera Choudhary','1989-05-09','Female','B+','9811001016','meera.choudhary@gmail.com','666 Malviya Nagar Bhopal','2025-01-20','2025-01-28',
 'Dermatology','Dr. Neha Gupta',
 'Dr. Neha Gupta','neha.gupta@hospital.com','9876543206','23 Rajpath Jaipur','1983-12-25','2012-11-01','Cosmetic Dermatology',
 '2025-01-20','15:30:00','Completed','OPD',
 'Afternoon','14:00:00','22:00:00','2025-01-13',
 'Ritu Sharma','ritu.sharma@hospital.com','9876543212','Morning','06:00:00','14:00:00','2025-01-11',
 'Suite',7000.00,'2025-01-20','2025-01-28',
 'Star Health Insurance','STAR-2023-016',80.00,'2023-06-01','2028-05-31',
 '2025-01-28','Paid',56000.00,200.00,245.00,'2025-01-28',11289.00,'UPI','TXN-UPI-20250128-016'),

-- Record 17 — SAME DOCTOR as Record 7 (Dr. Ramesh Iyer repeated)
('Rahul Saxena','1983-09-30','Male','AB+','9811001017','rahul.saxena@gmail.com','777 Gomti Nagar Lucknow','2025-01-21',NULL,
 'Oncology','Dr. Ramesh Iyer',
 'Dr. Ramesh Iyer','ramesh.iyer@hospital.com','9876543207','45 Brigade Road Bangalore','1968-08-14','2000-04-22','Surgical Oncology',
 '2025-01-21','12:00:00','Scheduled','OPD',
 'Morning','06:00:00','14:00:00','2025-01-13',
 'Pooja Tiwari','pooja.tiwari@hospital.com','9876543213','Afternoon','14:00:00','22:00:00','2025-01-11',
 'NICU',10000.00,'2025-01-21',NULL,
 'Max Bupa','MAXB-2021-017',85.00,'2021-09-01','2026-08-31',
 '2025-01-30','Pending',90000.00,350.00,1500.00,NULL,NULL,NULL,NULL),

-- Record 18 — SAME DOCTOR as Record 8 (Dr. Anjali Bose repeated)
('Sunita Pandey','1977-02-18','Female','O-','9811001018','sunita.pandey@gmail.com','888 Rajpur Road Dehradun','2025-01-22','2025-01-30',
 'Gynecology','Dr. Anjali Bose',
 'Dr. Anjali Bose','anjali.bose@hospital.com','9876543208','67 Lake Town Kolkata','1977-06-09','2006-07-30','High Risk Pregnancy',
 '2025-01-22','09:30:00','Completed','Emergency',
 'Night','22:00:00','06:00:00','2025-01-14',
 'Suman Verma','suman.verma@hospital.com','9876543215','Night','22:00:00','06:00:00','2025-01-11',
 'HDU',5000.00,'2025-01-22','2025-01-30',
 'HDFC ERGO','HDFC-2020-018',65.00,'2020-10-01','2025-09-30',
 '2025-01-30','Paid',40000.00,900.00,405.00,'2025-01-30',13910.25,'Cash','TXN-CSH-20250130-018');


-- ============================================================
-- TABLE: hospital_lab_test    [NEW — 1NF FIX]
-- CHANGE FROM UNF:
--   UNF had Test1_Name, Test1_Cost ... Test2_Name, Test2_Cost
--   as separate numbered columns in hospital_record.
--   This is a REPEATING GROUP — a direct 1NF violation.
--   Fix: each test is now its own row with a FK to the record.
--   A record can now have ANY number of tests (not limited to 2).
-- STILL NOT FIXED (2NF will fix):
--   Test_Name and Test_Cost still repeat whenever the same test
--   appears for different patients (e.g. CBC for Records 2,4,7,10...)
-- ============================================================
CREATE TABLE IF NOT EXISTS hospital_lab_test (
    Lab_Test_ID  INT PRIMARY KEY AUTO_INCREMENT,
    Record_ID    INT NOT NULL,
    Test_Name    VARCHAR(100),
    Test_Cost    DECIMAL(10,2),
    Test_Date    DATE,
    Test_Result  TEXT,
    FOREIGN KEY (Record_ID) REFERENCES hospital_record(Record_ID)
);

INSERT INTO hospital_lab_test (Record_ID, Test_Name, Test_Cost, Test_Date, Test_Result) VALUES
-- Record 1: 2 tests
(1,  'ECG',                          400.00,  '2025-01-05', 'Normal sinus rhythm. No ST changes.'),
(1,  '2D Echo',                      2500.00, '2025-01-06', 'EF 55%. Mild LVH noted.'),
-- Record 2: 1 test
(2,  'Complete Blood Count (CBC)',    350.00,  '2025-01-07', 'Hb 10.2 g/dL. WBC 8200. Platelets normal.'),
-- Record 3: 1 test
(3,  'MRI Brain',                    5000.00, '2025-01-07', 'Mild cortical atrophy. No bleed or infarct.'),
-- Record 4: 1 test
(4,  'Liver Function Test (LFT)',    700.00,  '2025-01-08', 'WBC 14500 elevated. Suggestive of infection.'),
-- Record 5: 1 test
(5,  'Blood Glucose Fasting',        150.00,  '2025-01-09', 'Fasting glucose 78 mg/dL. Normal.'),
-- Record 6: 1 test
(6,  'Urine Routine',                200.00,  '2025-01-10', 'RBC count normal. No casts. Slight protein.'),
-- Record 7: 1 test
(7,  'Complete Blood Count (CBC)',    350.00,  '2025-01-11', 'WBC 3200 low post-chemo. Monitor.'),
-- Record 8: 1 test
(8,  'Ultrasound Abdomen',           1200.00, '2025-01-12', 'Single live intrauterine fetus. 28 weeks.'),
-- Record 9: 1 test
(9,  'CT Scan Abdomen',              4500.00, '2025-01-13', 'No abdominal mass. Mild fatty liver.'),
-- Record 10: 1 test
(10, 'Complete Blood Count (CBC)',    350.00,  '2025-01-14', 'All parameters within normal limits.'),
-- Record 11: 1 test
(11, 'Lipid Profile',                600.00,  '2025-01-15', 'Total cholesterol 220 mg/dL. LDL 145 mg/dL.'),
-- Record 12: 1 test
(12, 'Chest X-Ray',                  500.00,  '2025-01-16', 'Fracture line visible. Callus formation beginning.'),
-- Record 13: 1 test
(13, 'MRI Brain',                    5000.00, '2025-01-17', 'Temporal lobe focus seen. Consistent with epilepsy.'),
-- Record 14: 1 test
(14, 'Dengue NS1 Antigen',           800.00,  '2025-01-18', 'Dengue NS1 Negative. IgM Positive.'),
-- Record 15: 1 test
(15, 'Chest X-Ray',                  500.00,  '2025-01-19', 'Hyperinflated lungs. Consistent with asthma.'),
-- Record 16: 1 test
(16, 'Urine Routine',                200.00,  '2025-01-20', 'Normal. No proteinuria.'),
-- Record 17: 1 test
(17, 'Complete Blood Count (CBC)',    350.00,  '2025-01-21', 'WBC 4100. RBC 3.8. Hb 11.0.'),
-- Record 18: 1 test
(18, 'Thyroid Function Test',        900.00,  '2025-01-22', NULL);


-- ============================================================
-- TABLE: hospital_medicine    [NEW — 1NF FIX]
-- CHANGE FROM UNF:
--   UNF had Medicine1_Name/Dosage/..., Medicine2_Name/Dosage/...,
--   Medicine3_Name/Dosage/... as 18 numbered columns in one row.
--   This is a REPEATING GROUP — a direct 1NF violation.
--   Fix: each prescribed medicine is now its own atomic row.
--   A record can now have ANY number of medicines.
-- STILL NOT FIXED (2NF will fix):
--   Medicine_Name, Manufacturer, Category repeat whenever the same
--   medicine is prescribed to different patients.
-- ============================================================
CREATE TABLE IF NOT EXISTS hospital_medicine (
    Medicine_ID    INT PRIMARY KEY AUTO_INCREMENT,
    Record_ID      INT          NOT NULL,
    Medicine_Name  VARCHAR(100),
    Manufacturer   VARCHAR(100),
    Category       VARCHAR(50),
    Dosage         VARCHAR(50),
    Frequency      VARCHAR(50),
    Duration       VARCHAR(50),
    FOREIGN KEY (Record_ID) REFERENCES hospital_record(Record_ID)
);

INSERT INTO hospital_medicine (Record_ID, Medicine_Name, Manufacturer, Category, Dosage, Frequency, Duration) VALUES
-- Record 1: 2 medicines
(1,  'Atorvastatin 10mg',   'Lupin',         'Antilipemic',     '10mg',      'Once daily',          '30 days'),
(1,  'Metoprolol 50mg',     'Cipla',         'Beta Blocker',    '50mg',      'Twice daily',         '30 days'),
-- Record 2: 2 medicines
(2,  'Diclofenac 50mg',     'Lupin',         'NSAID',           '50mg',      'Twice daily',         '5 days'),
(2,  'Paracetamol 500mg',   'Sun Pharma',    'Analgesic',       '500mg',     'Three times daily',   '5 days'),
-- Record 3: 2 medicines
(3,  'Paracetamol 500mg',   'Sun Pharma',    'Analgesic',       '500mg',     'As needed',           '7 days'),
(3,  'Cetirizine 10mg',     'Alkem',         'Antihistamine',   '10mg',      'Once daily',          '7 days'),
-- Record 4: 2 medicines
(4,  'Amoxicillin 250mg',   'Cipla',         'Antibiotic',      '250mg',     'Three times daily',   '7 days'),
(4,  'Pantoprazole 40mg',   'Sun Pharma',    'Antacid',         '40mg',      'Once daily',          '7 days'),
-- Record 5: 1 medicine
(5,  'Ondansetron 4mg',     'Zydus',         'Antiemetic',      '4mg',       'As needed',           '3 days'),
-- Record 6: 1 medicine
(6,  'Cetirizine 10mg',     'Alkem',         'Antihistamine',   '10mg',      'Once daily',          '14 days'),
-- Record 7: 1 medicine
(7,  'Clopidogrel 75mg',    'Dr. Reddy\'s',  'Antiplatelet',    '75mg',      'Once daily',          '30 days'),
-- Record 8: 1 medicine
(8,  'Insulin Glargine',    'Novo Nordisk',  'Antidiabetic',    '10 units',  'Once daily at night', '30 days'),
-- Record 9: 1 medicine
(9,  'Omeprazole 20mg',     'Zydus',         'Antacid',         '20mg',      'Once daily',          '14 days'),
-- Record 10: 1 medicine
(10, 'Amlodipine 5mg',      'Mankind',       'Antihypertensive','5mg',       'Once daily',          '30 days'),
-- Record 11: 2 medicines
(11, 'Amlodipine 5mg',      'Mankind',       'Antihypertensive','5mg',       'Once daily',          '60 days'),
(11, 'Losartan 50mg',       'Mankind',       'Antihypertensive','50mg',      'Once daily',          '60 days'),
-- Record 12: 1 medicine
(12, 'Diclofenac 50mg',     'Lupin',         'NSAID',           '50mg',      'Twice daily',         '7 days'),
-- Record 13: 1 medicine
(13, 'Azithromycin 500mg',  'Abbott',        'Antibiotic',      '500mg',     'Twice daily',         '90 days'),
-- Record 14: 1 medicine
(14, 'Amoxicillin 250mg',   'Cipla',         'Antibiotic',      '250mg',     'Twice daily',         '7 days'),
-- Record 15: 1 medicine
(15, 'Cetirizine 10mg',     'Alkem',         'Antihistamine',   '10mg',      'Once daily',          '7 days'),
-- Record 16: 1 medicine
(16, 'Cetirizine 10mg',     'Alkem',         'Antihistamine',   '10mg',      'Once daily',          '7 days'),
-- Record 17: 1 medicine
(17, 'Clopidogrel 75mg',    'Dr. Reddy\'s',  'Antiplatelet',    '75mg',      'Once daily',          '30 days'),
-- Record 18: 1 medicine
(18, 'Metformin 500mg',     'Dr. Reddy\'s',  'Antidiabetic',    '500mg',     'Twice daily',         '90 days');


-- ============================================================
-- TABLE: hospital_qualification    [NEW — 1NF FIX]
-- CHANGE FROM UNF:
--   UNF had Doctor_Qualifications VARCHAR(255) storing values
--   like "MBBS, MD, DM Cardiology" — multiple values in one cell.
--   This violates atomicity — a core 1NF rule.
--   Fix: each degree is now its own atomic row linked to a record.
-- STILL NOT FIXED (2NF will fix):
--   The same doctor's qualifications repeat across records
--   (e.g. Dr. Rajesh Sharma's MBBS appears in Records 1 AND 11)
-- ============================================================
CREATE TABLE IF NOT EXISTS hospital_qualification (
    Qual_ID   INT PRIMARY KEY AUTO_INCREMENT,
    Record_ID INT         NOT NULL,
    Degree    VARCHAR(50) NOT NULL,
    FOREIGN KEY (Record_ID) REFERENCES hospital_record(Record_ID)
);

INSERT INTO hospital_qualification (Record_ID, Degree) VALUES
-- Record 1: Dr. Rajesh Sharma
(1, 'MBBS'), (1, 'MD'), (1, 'DM Cardiology'),
-- Record 2: Dr. Priya Mehta
(2, 'MBBS'), (2, 'MS Orthopedics'),
-- Record 3: Dr. Anil Kapoor
(3, 'MBBS'), (3, 'MD'), (3, 'DM Neurology'),
-- Record 4: Dr. Sunita Rao
(4, 'MBBS'), (4, 'MD Emergency Medicine'),
-- Record 5: Dr. Vikram Singh
(5, 'MBBS'), (5, 'MD Pediatrics'),
-- Record 6: Dr. Neha Gupta
(6, 'MBBS'), (6, 'MD Dermatology'),
-- Record 7: Dr. Ramesh Iyer
(7, 'MBBS'), (7, 'MS'), (7, 'MCh Oncology'),
-- Record 8: Dr. Anjali Bose
(8, 'MBBS'), (8, 'MD Gynecology'),
-- Record 9: Dr. Suresh Nair
(9, 'MBBS'), (9, 'MD Radiology'),
-- Record 10: Dr. Meena Joshi
(10, 'MBBS'), (10, 'MD Psychiatry'),
-- Records 11-18: same doctors repeated (update anomaly — 2NF will fix)
(11, 'MBBS'), (11, 'MD'), (11, 'DM Cardiology'),     -- Dr. Rajesh Sharma again
(12, 'MBBS'), (12, 'MS Orthopedics'),                 -- Dr. Priya Mehta again
(13, 'MBBS'), (13, 'MD'), (13, 'DM Neurology'),       -- Dr. Anil Kapoor again
(14, 'MBBS'), (14, 'MD Emergency Medicine'),           -- Dr. Sunita Rao again
(15, 'MBBS'), (15, 'MD Pediatrics'),                  -- Dr. Vikram Singh again
(16, 'MBBS'), (16, 'MD Dermatology'),                 -- Dr. Neha Gupta again
(17, 'MBBS'), (17, 'MS'), (17, 'MCh Oncology'),       -- Dr. Ramesh Iyer again
(18, 'MBBS'), (18, 'MD Gynecology');                  -- Dr. Anjali Bose again

-- ============================================================
-- END OF 1NF DUMP
--
-- Summary of changes UNF → 1NF:
--
--   FIXED:
--   ✔ Repeating Medicine1/2/3 columns → hospital_medicine table
--   ✔ Repeating Test1/2 columns      → hospital_lab_test table
--   ✔ Multi-valued Qualifications    → hospital_qualification table
--   ✔ All tables now have PRIMARY KEYs
--   ✔ Every column holds one atomic value
--
--   STILL REMAINING (to be fixed in 2NF):
--   ✘ Doctor info duplicated across rows (Records 1 & 11, 2 & 12...)
--   ✘ Department head duplicated per department per record
--   ✘ Room_Cost_Per_Day repeated for same Room_Type
--   ✘ Insurance info repeated per patient
--   ✘ Nurse info repeated across records
--   ✘ Qualifications still repeat when same doctor appears twice
--   ✘ Partial dependencies exist throughout the main table
-- ============================================================
