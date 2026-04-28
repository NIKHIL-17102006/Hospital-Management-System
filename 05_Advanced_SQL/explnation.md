# Indexes, Views, Stored Procedures & Triggers

This stage builds a **performance and usability layer** on top of the BCNF schema.

## How to run

```bash
# Step 1 — load the BCNF schema first
mysql -u root -p < 04_3NF_BCNF/hospital_mgmt_3nf_bcnf.sql

# Step 2 — add indexes, views, procedures and triggers
mysql -u root -p < 05_indexes_views/indexes_and_views.sql
```

---

## Section 1 — Indexes (27 indexes)

An index lets MySQL find rows without scanning the whole table.

| Analogy | Without index | With index |
|---|---|---|
| Finding a word in a book | Read every page | Jump to the index page |

**Key indexes added:**

| Table | Column(s) | Reason |
|---|---|---|
| `patient` | `Admission_Date`, `Discharge_Date` | Date-range queries, find current admissions |
| `patient` | `Last_Name`, `Blood_Group` | Name search, emergency blood-match |
| `appointment` | `Patient_ID`, `Doctor_ID` | FK join columns |
| `appointment` | `Appointment_Date`, `Status` | Today's schedule, filter Scheduled |
| `appointment` | `(Doctor_ID, Appointment_Date)` | Composite — one doctor on one date |
| `bill` | `Patient_ID`, `Status`, `Bill_Date` | Billing queries, pending filter |
| `room_assignment` | `Room_ID`, `Discharge_Date` | Occupancy checks |
| `medicine_inventory` | `Expiry_Date`, `Stock_Quantity` | Expiry alerts, restock checks |

---

## Section 2 — Views (10 views)

| View | Purpose |
|---|---|
| `v_patient_summary` | Demographics + current room in one row |
| `v_doctor_schedule_today` | Today's full appointment list |
| `v_pending_bills` | Unpaid bills with insurance deductions |
| `v_patient_bill_summary` | Room / lab / medicine cost breakdown |
| `v_doctor_workload` | Appointment counts per doctor |
| `v_low_stock_medicines` | Stock below 200 units |
| `v_expiring_insurance` | Policies expiring within 90 days |
| `v_current_admissions` | All active patients with accrued room cost |
| `v_patient_lab_history` | Chronological lab results per patient |
| `v_revenue_by_dept` | Revenue generated per department |

---

## Section 3 — Stored Procedures (3)

| Procedure | What it does |
|---|---|
| `sp_admit_patient(patient_id, room_id, date)` | Checks availability then assigns room |
| `sp_discharge_patient(patient_id, date)` | Closes room assignment, updates patient |
| `sp_get_patient_full_record(patient_id)` | Returns full patient snapshot in one call |

---

## Section 4 — Triggers (3)

| Trigger | Fires | What it does |
|---|---|---|
| `trg_bill_auto_status` | After payment inserted | Auto-marks bill Paid when fully settled |
| `trg_prevent_double_room` | Before room assignment | Blocks double-booking a room |
| `trg_log_discharge` | After room assignment updated | Writes to `stay_log` on discharge |

---

These additions do not alter the BCNF normalization — they are a performance and usability layer on top of the normalized schema.
