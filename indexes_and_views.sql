-- ============================================================
-- Hospital Management System - Indexes & Views
-- Database: hospital_mgmt_bcnf
-- Stage   : 05 — Performance & Usability Layer
-- ============================================================
--
-- This file builds ON TOP of the BCNF schema (04_3NF_BCNF/).
-- Run hospital_mgmt_3nf_bcnf.sql first, then run this file.
--
-- WHAT THIS FILE ADDS:
--   SECTION 1 — INDEXES   (speed up SELECT queries)
--   SECTION 2 — VIEWS     (simplify complex joins for real use)
--   SECTION 3 — STORED PROCEDURES (automate common operations)
--   SECTION 4 — TRIGGERS  (enforce business rules automatically)
--   SECTION 5 — SAMPLE QUERIES (show the views in action)
--
-- WHY INDEXES MATTER:
--   Without an index, MySQL scans EVERY row to find matches.
--   This is called a "full table scan" — fine for 18 rows,
--   disastrous for 1,000,000 rows. An index is like a book's
--   index: instead of reading every page, you jump directly
--   to the right page. Trade-off: indexes use extra disk space
--   and slow down INSERT/UPDATE slightly.
--
-- WHEN TO ADD AN INDEX:
--   Add indexes on columns that appear in:
--     WHERE col = ?          → lookup
--     JOIN ... ON col = ?    → join condition
--     ORDER BY col           → sort
--     GROUP BY col           → aggregate
--   Do NOT index columns with very few distinct values
--   (e.g. Gender has only 3 values — index not useful there).
-- ============================================================

USE hospital_mgmt_bcnf;


-- ============================================================
-- SECTION 1: INDEXES
-- ============================================================
--
-- Naming convention used: idx_<table>_<column(s)>
-- MySQL automatically creates indexes for PRIMARY KEY and
-- UNIQUE constraints, so we skip those here.
-- ============================================================


-- ----------------------------------------------------------
-- 1.1  patient table
-- ----------------------------------------------------------
-- Admission_Date: used in date-range queries like
--   "show all patients admitted this month"
-- Discharge_Date: used to find currently admitted patients
--   WHERE Discharge_Date IS NULL
-- Last_Name: used in name-search lookups
-- Blood_Group: used in emergency blood-match queries
-- ----------------------------------------------------------
CREATE INDEX idx_patient_admission   ON patient (Admission_Date);
CREATE INDEX idx_patient_discharge   ON patient (Discharge_Date);
CREATE INDEX idx_patient_lastname    ON patient (Last_Name);
CREATE INDEX idx_patient_bloodgroup  ON patient (Blood_Group);


-- ----------------------------------------------------------
-- 1.2  appointment table
-- ----------------------------------------------------------
-- Patient_ID, Doctor_ID: FK join columns — always index FKs
--   that are not already covered by a PRIMARY KEY.
-- Appointment_Date: filtered constantly ("today's schedule")
-- Status: filtered to find 'Scheduled' appointments
-- Composite (Doctor_ID, Appointment_Date): covers the very
--   common query "get all appointments for doctor X on date Y"
-- ----------------------------------------------------------
CREATE INDEX idx_appt_patient   ON appointment (Patient_ID);
CREATE INDEX idx_appt_doctor    ON appointment (Doctor_ID);
CREATE INDEX idx_appt_date      ON appointment (Appointment_Date);
CREATE INDEX idx_appt_status    ON appointment (Status);
CREATE INDEX idx_appt_doc_date  ON appointment (Doctor_ID, Appointment_Date);


-- ----------------------------------------------------------
-- 1.3  bill and payment tables
-- ----------------------------------------------------------
-- bill.Patient_ID : "fetch all bills for this patient"
-- bill.Status     : "show all pending bills"
-- bill.Bill_Date  : date-range financial reports
-- payment.Bill_ID : "fetch all payments for this bill"
-- payment.Payment_Date: daily/monthly revenue reports
-- ----------------------------------------------------------
CREATE INDEX idx_bill_patient      ON bill (Patient_ID);
CREATE INDEX idx_bill_status       ON bill (Status);
CREATE INDEX idx_bill_date         ON bill (Bill_Date);
CREATE INDEX idx_payment_bill      ON payment (Bill_ID);
CREATE INDEX idx_payment_date      ON payment (Payment_Date);


-- ----------------------------------------------------------
-- 1.4  room_assignment table
-- ----------------------------------------------------------
-- Patient_ID : "which room is this patient in?"
-- Room_ID    : "who is in this room?"
-- Discharge_Date IS NULL : find currently occupied rooms
-- Composite (Room_ID, Discharge_Date): covers occupancy check
-- ----------------------------------------------------------
CREATE INDEX idx_roomassign_patient   ON room_assignment (Patient_ID);
CREATE INDEX idx_roomassign_room      ON room_assignment (Room_ID);
CREATE INDEX idx_roomassign_discharge ON room_assignment (Discharge_Date);
CREATE INDEX idx_roomassign_room_disc ON room_assignment (Room_ID, Discharge_Date);


-- ----------------------------------------------------------
-- 1.5  lab_report table
-- ----------------------------------------------------------
-- Patient_ID : "all lab reports for this patient"
-- Doctor_ID  : "all reports ordered by this doctor"
-- Test_ID    : "all reports of type CBC" etc.
-- Test_Date  : date-range filtering
-- ----------------------------------------------------------
CREATE INDEX idx_labreport_patient ON lab_report (Patient_ID);
CREATE INDEX idx_labreport_doctor  ON lab_report (Doctor_ID);
CREATE INDEX idx_labreport_test    ON lab_report (Test_ID);
CREATE INDEX idx_labreport_date    ON lab_report (Test_Date);


-- ----------------------------------------------------------
-- 1.6  prescription and prescription_items tables
-- ----------------------------------------------------------
CREATE INDEX idx_prescription_patient ON prescription (Patient_ID);
CREATE INDEX idx_prescription_doctor  ON prescription (Doctor_ID);
CREATE INDEX idx_prescription_date    ON prescription (Date);
CREATE INDEX idx_pi_prescription      ON prescription_items (Prescription_ID);
CREATE INDEX idx_pi_medicine          ON prescription_items (Medicine_ID);


-- ----------------------------------------------------------
-- 1.7  shift assignment tables
-- ----------------------------------------------------------
CREATE INDEX idx_dsa_doctor     ON doctor_shift_assignment (Doctor_ID);
CREATE INDEX idx_dsa_date       ON doctor_shift_assignment (Shift_Date);
CREATE INDEX idx_nsa_nurse      ON nurse_shift_assignment (Nurse_ID);
CREATE INDEX idx_nsa_date       ON nurse_shift_assignment (Shift_Date);
CREATE INDEX idx_npa_patient    ON nurse_patient_assignment (Patient_ID);


-- ----------------------------------------------------------
-- 1.8  medicine_inventory table
-- ----------------------------------------------------------
-- Expiry_Date: "find medicines expiring within 3 months"
-- Stock_Quantity: "find low-stock medicines"
-- ----------------------------------------------------------
CREATE INDEX idx_inventory_expiry ON medicine_inventory (Expiry_Date);
CREATE INDEX idx_inventory_stock  ON medicine_inventory (Stock_Quantity);


-- ----------------------------------------------------------
-- 1.9  insurance table
-- ----------------------------------------------------------
-- Patient_ID: "get insurance for this patient"
-- Valid_To: "find expiring policies"
-- ----------------------------------------------------------
CREATE INDEX idx_insurance_patient  ON insurance (Patient_ID);
CREATE INDEX idx_insurance_validto  ON insurance (Valid_To);


-- ----------------------------------------------------------
-- 1.10  staff table
-- ----------------------------------------------------------
CREATE INDEX idx_staff_dept     ON staff (Dept_ID);
CREATE INDEX idx_staff_role     ON staff (Role_Type);
CREATE INDEX idx_staff_joining  ON staff (Date_Joining);


-- ============================================================
-- SECTION 2: VIEWS
-- ============================================================
--
-- A VIEW is a saved SELECT query you can treat like a table.
-- It does NOT store data — it runs the query fresh each time.
--
-- Benefits:
--   1. Simplify complex multi-table JOINs into one name
--   2. Hide implementation details (users query the view,
--      not the raw tables)
--   3. Re-use logic without copy-pasting SQL everywhere
--   4. Can restrict which columns are visible (security)
--
-- Views defined here:
--   v_patient_summary         — current patient details + room
--   v_doctor_schedule_today   — today's doctor appointments
--   v_pending_bills           — unpaid bills with totals
--   v_patient_bill_summary    — full bill breakdown per patient
--   v_doctor_workload         — appointment count per doctor
--   v_low_stock_medicines     — medicines needing restock
--   v_expiring_insurance      — policies expiring in 90 days
--   v_current_admissions      — patients currently admitted
--   v_patient_lab_history     — all lab results per patient
--   v_revenue_by_dept         — revenue contribution by dept
-- ============================================================


-- ----------------------------------------------------------
-- 2.1  v_patient_summary
--      One row per patient. Shows demographics + current
--      room assignment. NULL room_type = not yet assigned.
-- ----------------------------------------------------------
CREATE OR REPLACE VIEW v_patient_summary AS
SELECT
    p.Patient_ID,
    CONCAT(p.First_Name, ' ', p.Last_Name)  AS Full_Name,
    p.Gender,
    p.Blood_Group,
    p.Phone,
    p.Email,
    p.Admission_Date,
    p.Discharge_Date,
    CASE
        WHEN p.Discharge_Date IS NULL THEN 'Currently Admitted'
        ELSE 'Discharged'
    END                                      AS Admission_Status,
    rt.Room_Type,
    rt.Room_Cost_Per_Day,
    ra.Admit_Date                            AS Room_Admit_Date
FROM patient p
LEFT JOIN room_assignment ra
    ON ra.Patient_ID = p.Patient_ID
    AND ra.Discharge_Date IS NULL            -- only the active room
LEFT JOIN room r
    ON r.Room_ID = ra.Room_ID
LEFT JOIN room_type rt
    ON rt.Room_Type = r.Room_Type;

-- Usage: SELECT * FROM v_patient_summary WHERE Admission_Status = 'Currently Admitted';


-- ----------------------------------------------------------
-- 2.2  v_doctor_schedule_today
--      All scheduled appointments for today, with full
--      doctor and patient names. Refresh this each morning.
-- ----------------------------------------------------------
CREATE OR REPLACE VIEW v_doctor_schedule_today AS
SELECT
    a.Appointment_ID,
    a.Appointment_Time,
    a.Type                                         AS Appointment_Type,
    a.Status,
    CONCAT(ps.First_Name, ' ', ps.Last_Name)       AS Doctor_Name,
    d.Specialization,
    dept.Dept_Name                                 AS Department,
    CONCAT(p.First_Name, ' ', p.Last_Name)         AS Patient_Name,
    p.Phone                                        AS Patient_Phone,
    p.Blood_Group
FROM appointment a
JOIN doctor d       ON d.Doctor_ID    = a.Doctor_ID
JOIN staff  ps      ON ps.Emp_ID      = d.Emp_ID
JOIN department dept ON dept.Dept_ID  = ps.Dept_ID
JOIN patient p      ON p.Patient_ID   = a.Patient_ID
WHERE a.Appointment_Date = CURDATE()
ORDER BY a.Appointment_Time;

-- Usage: SELECT * FROM v_doctor_schedule_today;


-- ----------------------------------------------------------
-- 2.3  v_pending_bills
--      All unpaid bills with itemised totals.
--      Useful for the billing department's daily task list.
-- ----------------------------------------------------------
CREATE OR REPLACE VIEW v_pending_bills AS
SELECT
    b.Bill_ID,
    b.Bill_Date,
    CONCAT(p.First_Name, ' ', p.Last_Name)   AS Patient_Name,
    p.Phone                                  AS Patient_Phone,
    b.Policy_Number,
    ins.Provider                             AS Insurance_Provider,
    ins.Coverage_Percentage,
    SUM(bi.Amount)                           AS Total_Bill_Amount,
    ROUND(
        SUM(bi.Amount) * (1 - COALESCE(ins.Coverage_Percentage, 0) / 100),
        2
    )                                        AS Patient_Payable,
    DATEDIFF(CURDATE(), b.Bill_Date)         AS Days_Pending
FROM bill b
JOIN patient p      ON p.Patient_ID   = b.Patient_ID
LEFT JOIN insurance ins ON ins.Policy_Number = b.Policy_Number
LEFT JOIN bill_items bi ON bi.Bill_ID  = b.Bill_ID
WHERE b.Status = 'Pending'
GROUP BY
    b.Bill_ID, b.Bill_Date,
    p.First_Name, p.Last_Name, p.Phone,
    b.Policy_Number, ins.Provider, ins.Coverage_Percentage
ORDER BY Days_Pending DESC;

-- Usage: SELECT * FROM v_pending_bills ORDER BY Patient_Payable DESC;


-- ----------------------------------------------------------
-- 2.4  v_patient_bill_summary
--      Complete bill breakdown for every patient, including
--      room charges, lab charges, and medicine charges.
--      Great for a patient's discharge summary printout.
-- ----------------------------------------------------------
CREATE OR REPLACE VIEW v_patient_bill_summary AS
SELECT
    b.Bill_ID,
    CONCAT(p.First_Name, ' ', p.Last_Name)          AS Patient_Name,
    b.Bill_Date,
    b.Status                                         AS Bill_Status,
    SUM(CASE WHEN bi.Item_Type = 'Room'     THEN bi.Amount ELSE 0 END) AS Room_Charges,
    SUM(CASE WHEN bi.Item_Type = 'Lab Test' THEN bi.Amount ELSE 0 END) AS Lab_Charges,
    SUM(CASE WHEN bi.Item_Type = 'Medicine' THEN bi.Amount ELSE 0 END) AS Medicine_Charges,
    SUM(bi.Amount)                                   AS Total_Amount,
    COALESCE(ins.Coverage_Percentage, 0)             AS Insurance_Coverage_Pct,
    ROUND(
        SUM(bi.Amount) * COALESCE(ins.Coverage_Percentage, 0) / 100,
        2
    )                                                AS Insurance_Covers,
    ROUND(
        SUM(bi.Amount) * (1 - COALESCE(ins.Coverage_Percentage, 0) / 100),
        2
    )                                                AS Patient_Payable
FROM bill b
JOIN patient p          ON p.Patient_ID    = b.Patient_ID
LEFT JOIN insurance ins ON ins.Policy_Number = b.Policy_Number
LEFT JOIN bill_items bi ON bi.Bill_ID      = b.Bill_ID
GROUP BY
    b.Bill_ID, p.First_Name, p.Last_Name,
    b.Bill_Date, b.Status, ins.Coverage_Percentage
ORDER BY b.Bill_ID;

-- Usage: SELECT * FROM v_patient_bill_summary WHERE Patient_Name = 'Aarav Kumar';


-- ----------------------------------------------------------
-- 2.5  v_doctor_workload
--      Number of appointments per doctor, split by status.
--      Helps management see which doctors are overloaded.
-- ----------------------------------------------------------
CREATE OR REPLACE VIEW v_doctor_workload AS
SELECT
    d.Doctor_ID,
    CONCAT(s.First_Name, ' ', s.Last_Name)      AS Doctor_Name,
    d.Specialization,
    dept.Dept_Name                              AS Department,
    COUNT(a.Appointment_ID)                     AS Total_Appointments,
    SUM(CASE WHEN a.Status = 'Completed'  THEN 1 ELSE 0 END) AS Completed,
    SUM(CASE WHEN a.Status = 'Scheduled'  THEN 1 ELSE 0 END) AS Scheduled,
    SUM(CASE WHEN a.Status = 'Cancelled'  THEN 1 ELSE 0 END) AS Cancelled
FROM doctor d
JOIN staff s            ON s.Emp_ID    = d.Emp_ID
JOIN department dept    ON dept.Dept_ID = s.Dept_ID
LEFT JOIN appointment a ON a.Doctor_ID = d.Doctor_ID
GROUP BY d.Doctor_ID, s.First_Name, s.Last_Name, d.Specialization, dept.Dept_Name
ORDER BY Total_Appointments DESC;

-- Usage: SELECT * FROM v_doctor_workload;


-- ----------------------------------------------------------
-- 2.6  v_low_stock_medicines
--      Medicines with stock below 200 units.
--      Change the threshold (200) to suit real needs.
-- ----------------------------------------------------------
CREATE OR REPLACE VIEW v_low_stock_medicines AS
SELECT
    m.Medicine_ID,
    m.Medicine_Name,
    m.Manufacturer,
    m.Category,
    mi.Batch_No,
    mi.Stock_Quantity,
    mi.Expiry_Date,
    mi.Purchase_Cost,
    DATEDIFF(mi.Expiry_Date, CURDATE())      AS Days_Until_Expiry
FROM medicine m
JOIN medicine_inventory mi ON mi.Medicine_ID = m.Medicine_ID
WHERE mi.Stock_Quantity < 200
ORDER BY mi.Stock_Quantity ASC;

-- Usage: SELECT * FROM v_low_stock_medicines;


-- ----------------------------------------------------------
-- 2.7  v_expiring_insurance
--      Insurance policies expiring within the next 90 days.
--      Useful to alert patients to renew before admission.
-- ----------------------------------------------------------
CREATE OR REPLACE VIEW v_expiring_insurance AS
SELECT
    ins.Policy_Number,
    ins.Provider,
    ins.Coverage_Percentage,
    ins.Valid_To,
    DATEDIFF(ins.Valid_To, CURDATE())       AS Days_Until_Expiry,
    CONCAT(p.First_Name, ' ', p.Last_Name) AS Patient_Name,
    p.Phone                                AS Patient_Phone,
    p.Email                                AS Patient_Email
FROM insurance ins
JOIN patient p ON p.Patient_ID = ins.Patient_ID
WHERE ins.Valid_To BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 90 DAY)
ORDER BY ins.Valid_To ASC;

-- Usage: SELECT * FROM v_expiring_insurance;


-- ----------------------------------------------------------
-- 2.8  v_current_admissions
--      All patients currently inside the hospital with
--      their room, assigned nurse, and attending doctor.
-- ----------------------------------------------------------
CREATE OR REPLACE VIEW v_current_admissions AS
SELECT
    p.Patient_ID,
    CONCAT(p.First_Name, ' ', p.Last_Name)       AS Patient_Name,
    p.Blood_Group,
    ra.Admit_Date,
    DATEDIFF(CURDATE(), ra.Admit_Date)            AS Days_Admitted,
    r.Room_ID,
    rt.Room_Type,
    rt.Room_Cost_Per_Day,
    ROUND(DATEDIFF(CURDATE(), ra.Admit_Date) * rt.Room_Cost_Per_Day, 2) AS Accrued_Room_Cost,
    CONCAT(ds.First_Name, ' ', ds.Last_Name)     AS Doctor_Name,
    d.Specialization,
    CONCAT(ns.First_Name, ' ', ns.Last_Name)     AS Nurse_Name
FROM patient p
JOIN room_assignment ra     ON ra.Patient_ID  = p.Patient_ID AND ra.Discharge_Date IS NULL
JOIN room r                 ON r.Room_ID      = ra.Room_ID
JOIN room_type rt           ON rt.Room_Type   = r.Room_Type
LEFT JOIN appointment a     ON a.Patient_ID   = p.Patient_ID
    AND a.Appointment_Date  = (
        SELECT MAX(a2.Appointment_Date)
        FROM appointment a2
        WHERE a2.Patient_ID = p.Patient_ID
    )
LEFT JOIN doctor d          ON d.Doctor_ID    = a.Doctor_ID
LEFT JOIN staff ds          ON ds.Emp_ID      = d.Emp_ID
LEFT JOIN nurse_patient_assignment npa ON npa.Patient_ID = p.Patient_ID
LEFT JOIN nurse_shift_assignment nsa   ON nsa.Assignment_ID = npa.Nurse_Shift_Assignment_ID
    AND nsa.Shift_Date = (
        SELECT MAX(nsa2.Shift_Date)
        FROM nurse_shift_assignment nsa2
        JOIN nurse_patient_assignment npa2 ON npa2.Nurse_Shift_Assignment_ID = nsa2.Assignment_ID
        WHERE npa2.Patient_ID = p.Patient_ID
    )
LEFT JOIN nurse n           ON n.Nurse_ID     = nsa.Nurse_ID
LEFT JOIN staff ns          ON ns.Emp_ID      = n.Emp_ID
ORDER BY ra.Admit_Date ASC;

-- Usage: SELECT * FROM v_current_admissions ORDER BY Accrued_Room_Cost DESC;


-- ----------------------------------------------------------
-- 2.9  v_patient_lab_history
--      All lab test results per patient with test name
--      and ordering doctor. Useful for a patient portal.
-- ----------------------------------------------------------
CREATE OR REPLACE VIEW v_patient_lab_history AS
SELECT
    lr.Report_ID,
    CONCAT(p.First_Name, ' ', p.Last_Name)   AS Patient_Name,
    lt.Test_Name,
    lt.Test_Cost,
    lr.Test_Date,
    lr.Result,
    CONCAT(s.First_Name, ' ', s.Last_Name)   AS Ordered_By_Doctor,
    d.Specialization
FROM lab_report lr
JOIN patient p      ON p.Patient_ID  = lr.Patient_ID
JOIN lab_test lt    ON lt.Test_ID    = lr.Test_ID
JOIN doctor d       ON d.Doctor_ID   = lr.Doctor_ID
JOIN staff s        ON s.Emp_ID      = d.Emp_ID
ORDER BY lr.Test_Date DESC;

-- Usage: SELECT * FROM v_patient_lab_history WHERE Patient_Name = 'Aarav Kumar';


-- ----------------------------------------------------------
-- 2.10  v_revenue_by_dept
--       Total revenue generated per department.
--       Joins bills through appointments to departments.
-- ----------------------------------------------------------
CREATE OR REPLACE VIEW v_revenue_by_dept AS
SELECT
    dept.Dept_Name                           AS Department,
    CONCAT(s.First_Name, ' ', s.Last_Name)  AS Doctor_Name,
    d.Specialization,
    COUNT(DISTINCT a.Appointment_ID)         AS Total_Appointments,
    COUNT(DISTINCT b.Bill_ID)               AS Total_Bills,
    COALESCE(SUM(bi.Amount), 0)             AS Total_Revenue
FROM department dept
JOIN staff s            ON s.Dept_ID    = dept.Dept_ID  AND s.Role_Type = 'Doctor'
JOIN doctor d           ON d.Emp_ID     = s.Emp_ID
LEFT JOIN appointment a ON a.Doctor_ID  = d.Doctor_ID
LEFT JOIN bill b        ON b.Patient_ID = a.Patient_ID
LEFT JOIN bill_items bi ON bi.Bill_ID   = b.Bill_ID
GROUP BY dept.Dept_Name, s.First_Name, s.Last_Name, d.Specialization
ORDER BY Total_Revenue DESC;

-- Usage: SELECT Department, SUM(Total_Revenue) FROM v_revenue_by_dept GROUP BY Department;


-- ============================================================
-- SECTION 3: STORED PROCEDURES
-- ============================================================
--
-- A stored procedure is a named block of SQL you can CALL
-- like a function. Benefits:
--   - Encapsulate multi-step logic in one place
--   - Accept parameters (like function arguments)
--   - Reduce repeated SQL in application code
-- ============================================================

DELIMITER $$

-- ----------------------------------------------------------
-- 3.1  sp_admit_patient
--      Assigns a patient to a room on admission.
--      Checks that the room is currently unoccupied.
--      Parameters:
--        p_patient_id INT  — existing patient
--        p_room_id    INT  — room to assign
--        p_admit_date DATE — admission date
-- ----------------------------------------------------------
CREATE PROCEDURE sp_admit_patient(
    IN p_patient_id INT,
    IN p_room_id    INT,
    IN p_admit_date DATE
)
BEGIN
    DECLARE v_occupied INT DEFAULT 0;

    -- Check if room already has an active (non-discharged) occupant
    SELECT COUNT(*) INTO v_occupied
    FROM room_assignment
    WHERE Room_ID = p_room_id
      AND Discharge_Date IS NULL;

    IF v_occupied > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Room is currently occupied. Choose a different room.';
    ELSE
        INSERT INTO room_assignment (Room_ID, Patient_ID, Admit_Date)
        VALUES (p_room_id, p_patient_id, p_admit_date);

        SELECT CONCAT('Patient ', p_patient_id,
                      ' successfully admitted to Room ', p_room_id,
                      ' on ', p_admit_date) AS Result;
    END IF;
END$$


-- ----------------------------------------------------------
-- 3.2  sp_discharge_patient
--      Sets the discharge date for a patient's room
--      assignment and updates the patient record.
--      Parameters:
--        p_patient_id     INT  — patient to discharge
--        p_discharge_date DATE — discharge date
-- ----------------------------------------------------------
CREATE PROCEDURE sp_discharge_patient(
    IN p_patient_id     INT,
    IN p_discharge_date DATE
)
BEGIN
    DECLARE v_rows INT DEFAULT 0;

    -- Close the active room assignment
    UPDATE room_assignment
    SET    Discharge_Date = p_discharge_date
    WHERE  Patient_ID     = p_patient_id
      AND  Discharge_Date IS NULL;

    GET DIAGNOSTICS v_rows = ROW_COUNT;

    IF v_rows = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No active room assignment found for this patient.';
    ELSE
        -- Update the patient table discharge date
        UPDATE patient
        SET    Discharge_Date = p_discharge_date
        WHERE  Patient_ID     = p_patient_id;

        SELECT CONCAT('Patient ', p_patient_id,
                      ' discharged on ', p_discharge_date,
                      '. Room assignment closed.') AS Result;
    END IF;
END$$


-- ----------------------------------------------------------
-- 3.3  sp_get_patient_full_record
--      Returns all key information about a patient in one
--      call: demographics, current room, latest appointment,
--      prescriptions, and pending bill.
--      Parameters:
--        p_patient_id INT — the patient to look up
-- ----------------------------------------------------------
CREATE PROCEDURE sp_get_patient_full_record(
    IN p_patient_id INT
)
BEGIN
    -- Demographics
    SELECT
        Patient_ID,
        CONCAT(First_Name, ' ', Last_Name) AS Full_Name,
        DOB,
        Gender,
        Blood_Group,
        Phone,
        Email,
        Admission_Date,
        Discharge_Date
    FROM patient
    WHERE Patient_ID = p_patient_id;

    -- Current room
    SELECT
        r.Room_ID,
        rt.Room_Type,
        rt.Room_Cost_Per_Day,
        ra.Admit_Date,
        DATEDIFF(CURDATE(), ra.Admit_Date) AS Days_Stayed
    FROM room_assignment ra
    JOIN room r      ON r.Room_ID    = ra.Room_ID
    JOIN room_type rt ON rt.Room_Type = r.Room_Type
    WHERE ra.Patient_ID    = p_patient_id
      AND ra.Discharge_Date IS NULL;

    -- Most recent prescription with medicines
    SELECT
        pi.Item_ID,
        m.Medicine_Name,
        pi.Dosage,
        pi.Frequency,
        pi.Duration,
        pr.Date AS Prescribed_On
    FROM prescription pr
    JOIN prescription_items pi ON pi.Prescription_ID = pr.Prescription_ID
    JOIN medicine m            ON m.Medicine_ID       = pi.Medicine_ID
    WHERE pr.Patient_ID = p_patient_id
      AND pr.Date = (
          SELECT MAX(Date) FROM prescription WHERE Patient_ID = p_patient_id
      );

    -- Pending bill summary
    SELECT * FROM v_patient_bill_summary
    WHERE Patient_Name = (
        SELECT CONCAT(First_Name, ' ', Last_Name) FROM patient WHERE Patient_ID = p_patient_id
    )
    AND Bill_Status = 'Pending';
END$$


DELIMITER ;

-- Usage:
--   CALL sp_admit_patient(5, 3, '2025-02-01');
--   CALL sp_discharge_patient(5, '2025-02-10');
--   CALL sp_get_patient_full_record(1);


-- ============================================================
-- SECTION 4: TRIGGERS
-- ============================================================
--
-- A TRIGGER fires automatically BEFORE or AFTER an
-- INSERT / UPDATE / DELETE on a specific table.
-- Use them to enforce business rules the schema alone
-- cannot express.
-- ============================================================

DELIMITER $$

-- ----------------------------------------------------------
-- 4.1  trg_bill_auto_status
--      When a new payment is inserted, check if the total
--      payments for that bill now cover the patient-payable
--      amount. If so, automatically mark the bill as Paid.
-- ----------------------------------------------------------
CREATE TRIGGER trg_bill_auto_status
AFTER INSERT ON payment
FOR EACH ROW
BEGIN
    DECLARE v_total_paid     DECIMAL(10,2);
    DECLARE v_bill_total     DECIMAL(10,2);
    DECLARE v_coverage_pct   DECIMAL(5,2);
    DECLARE v_patient_owes   DECIMAL(10,2);

    -- Sum all payments received for this bill
    SELECT COALESCE(SUM(Amount), 0) INTO v_total_paid
    FROM payment
    WHERE Bill_ID = NEW.Bill_ID;

    -- Get the total bill amount and insurance coverage
    SELECT
        COALESCE(SUM(bi.Amount), 0),
        COALESCE(ins.Coverage_Percentage, 0)
    INTO v_bill_total, v_coverage_pct
    FROM bill b
    LEFT JOIN bill_items bi ON bi.Bill_ID = b.Bill_ID
    LEFT JOIN insurance ins ON ins.Policy_Number = b.Policy_Number
    WHERE b.Bill_ID = NEW.Bill_ID
    GROUP BY ins.Coverage_Percentage;

    -- Calculate what the patient actually owes
    SET v_patient_owes = ROUND(v_bill_total * (1 - v_coverage_pct / 100), 2);

    -- Mark bill as Paid if fully settled
    IF v_total_paid >= v_patient_owes THEN
        UPDATE bill
        SET Status = 'Paid'
        WHERE Bill_ID = NEW.Bill_ID;
    END IF;
END$$


-- ----------------------------------------------------------
-- 4.2  trg_prevent_double_room
--      Before inserting a room assignment, check that the
--      room does not already have an active occupant.
--      (Duplicate safety alongside sp_admit_patient.)
-- ----------------------------------------------------------
CREATE TRIGGER trg_prevent_double_room
BEFORE INSERT ON room_assignment
FOR EACH ROW
BEGIN
    DECLARE v_occupied INT DEFAULT 0;

    SELECT COUNT(*) INTO v_occupied
    FROM room_assignment
    WHERE Room_ID      = NEW.Room_ID
      AND Discharge_Date IS NULL;

    IF v_occupied > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot assign room: room is already occupied.';
    END IF;
END$$


-- ----------------------------------------------------------
-- 4.3  trg_log_discharge
--      After a patient is discharged (Discharge_Date updated
--      from NULL to a date), record the length of stay.
--      Note: requires a stay_log table (created below).
-- ----------------------------------------------------------

CREATE TABLE IF NOT EXISTS stay_log (
    Log_ID         INT PRIMARY KEY AUTO_INCREMENT,
    Patient_ID     INT,
    Room_ID        INT,
    Admit_Date     DATE,
    Discharge_Date DATE,
    Days_Stayed    INT,
    Logged_At      DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER trg_log_discharge
AFTER UPDATE ON room_assignment
FOR EACH ROW
BEGIN
    -- Only fire when Discharge_Date changes from NULL to a real date
    IF OLD.Discharge_Date IS NULL AND NEW.Discharge_Date IS NOT NULL THEN
        INSERT INTO stay_log (Patient_ID, Room_ID, Admit_Date, Discharge_Date, Days_Stayed)
        VALUES (
            NEW.Patient_ID,
            NEW.Room_ID,
            NEW.Admit_Date,
            NEW.Discharge_Date,
            DATEDIFF(NEW.Discharge_Date, NEW.Admit_Date)
        );
    END IF;
END$$


DELIMITER ;


-- ============================================================
-- SECTION 5: SAMPLE QUERIES
-- ============================================================
-- These show how to USE the views and procedures above.
-- Run them after the schema + this file are fully loaded.
-- ============================================================

-- Q1: Who is currently admitted and how much have they accrued?
SELECT Patient_Name, Room_Type, Days_Admitted, Accrued_Room_Cost
FROM   v_current_admissions
ORDER  BY Accrued_Room_Cost DESC;

-- Q2: Show today's full appointment schedule
SELECT Appointment_Time, Doctor_Name, Department, Patient_Name, Appointment_Type, Status
FROM   v_doctor_schedule_today;

-- Q3: Which bills are pending and for how many days?
SELECT Patient_Name, Total_Bill_Amount, Patient_Payable, Days_Pending
FROM   v_pending_bills
ORDER  BY Days_Pending DESC;

-- Q4: Which medicines need restocking urgently?
SELECT Medicine_Name, Stock_Quantity, Expiry_Date, Days_Until_Expiry
FROM   v_low_stock_medicines
ORDER  BY Stock_Quantity ASC;

-- Q5: Insurance policies expiring soon
SELECT Patient_Name, Provider, Policy_Number, Valid_To, Days_Until_Expiry
FROM   v_expiring_insurance;

-- Q6: Revenue leaderboard by department
SELECT Department, SUM(Total_Revenue) AS Dept_Revenue
FROM   v_revenue_by_dept
GROUP  BY Department
ORDER  BY Dept_Revenue DESC;

-- Q7: Full lab history for one patient
SELECT Test_Name, Test_Date, Result, Ordered_By_Doctor
FROM   v_patient_lab_history
WHERE  Patient_Name = 'Aarav Kumar';

-- Q8: Doctor workload — who has the most appointments?
SELECT Doctor_Name, Department, Total_Appointments, Completed, Scheduled
FROM   v_doctor_workload
ORDER  BY Scheduled DESC;

-- Q9: Full discharge summary for Bill #1
SELECT * FROM v_patient_bill_summary WHERE Bill_ID = 1;

-- Q10: Admit a new patient to room 6 (using the stored procedure)
-- CALL sp_admit_patient(5, 6, CURDATE());

-- Q11: Get the complete record for patient 1
-- CALL sp_get_patient_full_record(1);

-- ============================================================
-- END OF FILE
-- ============================================================
