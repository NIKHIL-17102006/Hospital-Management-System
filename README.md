# 🏥 Hospital Management System (DBMS Project)

## 📌 Overview

This project is a fully normalized **Hospital Management System database** designed as part of a DBMS course.
It demonstrates the complete transformation of data from **Unnormalized Form (UNF) to Boyce-Codd Normal Form (BCNF)**, followed by a full **performance and usability layer** using indexes, views, stored procedures, and triggers.

The system manages:

* Patients, Doctors, Nurses
* Appointments & Shift Scheduling
* Rooms & Assignments
* Prescriptions & Medicines
* Lab Tests & Reports
* Billing & Payments

---

## 🎯 Objectives

* Design a **real-world relational database**
* Apply **Normalization (UNF → 1NF → 2NF → 3NF → BCNF)**
* Eliminate redundancy and anomalies
* Ensure **data integrity and scalability**
* Optimize for performance using **indexes**
* Simplify complex queries using **views**
* Automate workflows using **stored procedures and triggers**

---

## 🧠 Normalization Process

### 🔹 1. Unnormalized Form (UNF)

* Single flat table with all hospital data
* Repeating groups (Medicine1, Medicine2, Medicine3 columns)
* High redundancy — doctor info duplicated in every row
* Insert, update, and delete anomalies present

📁 `01_UNF/`

---

### 🔹 2. First Normal Form (1NF)

* All attributes made atomic (no comma-separated values)
* Repeating medicine and lab test columns removed
* Each row is unique with a proper primary key
* Redundancy still present (fixed in 2NF)

📁 `02_1NF/`

---

### 🔹 3. Second Normal Form (2NF)

* Removed partial dependencies
* Non-key attributes now depend on the full primary key
* Data split into multiple related tables
* Reduced redundancy, improved consistency

📁 `03_2NF/`

---

### 🔹 4. Third Normal Form (3NF) & BCNF

* Removed transitive dependencies
* Every determinant is a candidate key (BCNF)
* Key BCNF fixes applied:
  * `room_type` table extracted — `Room_Type → Cost` was a BCNF violation
  * `insurance` promoted `Policy_Number` as natural primary key
  * `medicine_inventory` supports multiple batches per medicine
  * `doctor_qualification` extracted — degrees are now atomic rows

📁 `04_3NF_BCNF/`

---

### 🔹 5. Advanced SQL — Indexes, Views, Procedures & Triggers

Builds a performance and usability layer on top of the BCNF schema.

**Indexes (27)** — added on all foreign key join columns and high-traffic filter columns such as `Appointment_Date`, `Bill_Status`, `Discharge_Date`, `Expiry_Date`, and `Stock_Quantity`. Includes one composite index on `(Doctor_ID, Appointment_Date)` for the most common scheduling query.

**Views (10):**

| View | Purpose |
|---|---|
| `v_patient_summary` | Demographics + current room in one row |
| `v_doctor_schedule_today` | Today's full appointment list (uses `CURDATE()`) |
| `v_pending_bills` | Unpaid bills with insurance-adjusted patient payable |
| `v_patient_bill_summary` | Room / lab / medicine cost breakdown per bill |
| `v_doctor_workload` | Appointment counts per doctor split by status |
| `v_low_stock_medicines` | Medicines with stock below 200 units |
| `v_expiring_insurance` | Policies expiring within the next 90 days |
| `v_current_admissions` | Active patients with accrued room cost |
| `v_patient_lab_history` | Chronological lab results per patient |
| `v_revenue_by_dept` | Revenue generated per department |

**Stored Procedures (3):**

| Procedure | Purpose |
|---|---|
| `sp_admit_patient(patient_id, room_id, date)` | Validates room availability then assigns patient |
| `sp_discharge_patient(patient_id, date)` | Closes room assignment and updates patient record |
| `sp_get_patient_full_record(patient_id)` | Returns full patient snapshot in one call |

**Triggers (3):**

| Trigger | Fires | Purpose |
|---|---|---|
| `trg_bill_auto_status` | After INSERT on `payment` | Auto-marks bill as Paid when fully settled |
| `trg_prevent_double_room` | Before INSERT on `room_assignment` | Blocks double-booking a room |
| `trg_log_discharge` | After UPDATE on `room_assignment` | Writes length-of-stay record to `stay_log` |

📁 `05_Advanced_SQL/`

---

## 🧩 ER Diagram

The ER diagram represents all entities, attributes, and relationships across modules including staff, patient management, billing, and lab systems.

📁 `ER_Diagram/`

---

## 🛠️ Technologies Used

* **MySQL 8.0+**
* **SQL — DDL, DML, DCL**
* **Database Normalization (UNF through BCNF)**
* **Indexes, Views, Stored Procedures, Triggers**

---

## ▶️ How to Run

```bash
# Clone the repository
git clone https://github.com/NIKHIL-17102006/Hospital-Management-System.git
cd Hospital-Management-System

# Step 1 — Load the final BCNF schema with all data
mysql -u root -p < 04_3NF_BCNF/hospital_mgmt_3nf_bcnf.sql

# Step 2 — Add indexes, views, procedures and triggers
mysql -u root -p < 05_Advanced_SQL/indexes_and_views.sql

# Optional — explore individual normalization stages
mysql -u root -p < 01_UNF/unnormalized.sql
mysql -u root -p < 02_1NF/1nf.sql
mysql -u root -p < 03_2NF/2nf.sql
```

> Each stage uses its own database name (`hospital_mgmt_unf`, `hospital_mgmt_1nf`, etc.) so all stages can coexist without conflict.

---

## 📊 Key Features

* Complete normalization journey from UNF to BCNF with inline explanations of every anomaly
* 22 tables covering all hospital workflows
* 28 foreign key constraints for full referential integrity
* 27 performance indexes on high-traffic columns
* 10 ready-to-use views for common hospital queries
* Business logic enforced via stored procedures and triggers
* Realistic sample data for 18 patients across 11 departments

---

## 📂 Project Structure

```
Hospital-Management-System/
│
├── 01_UNF/                        ← Single flat table, all anomalies visible
│   ├── unnormalized.sql
│   └── explanation.md
│
├── 02_1NF/                        ← Atomic values, no repeating groups
│   ├── 1nf.sql
│   └── explanation.md
│
├── 03_2NF/                        ← Partial dependencies removed
│   ├── 2nf.sql
│   └── explanation.md
│
├── 04_3NF_BCNF/                   ← Final normalized schema (BCNF)
│   ├── hospital_mgmt_3nf_bcnf.sql
│   └── explanation.md
│
├── 05_Advanced_SQL/               ← Indexes, views, procedures, triggers
│   ├── indexes_and_views.sql
│   └── explanation.md
│
├── ER_Diagram/
│   ├── er_diagram.png
│   └── explanation.md
│
└── README.md
```

---

## 🧠 Learning Outcomes

* Deep understanding of database normalization (UNF → BCNF)
* Practical relational schema design skills
* Handling real-world functional dependencies
* Writing performant SQL with indexes and composite keys
* Building reusable database logic with views and stored procedures
* Enforcing business rules automatically with triggers

---

## 👨‍💻 Author

**Nikhil Upadhyay**
B.Tech CSE | DBMS Project
