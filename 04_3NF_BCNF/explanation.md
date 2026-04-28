# Third Normal Form (3NF) and BCNF

This folder contains the final normalized schema of the Hospital Management System.

## What was done

### 3NF (Third Normal Form)
- Removed transitive dependencies
- Non-key attributes depend only on primary keys
- Example:
  - Department details separated from Staff
  - Doctor and Nurse separated from Staff

### BCNF (Boyce-Codd Normal Form)
- Every determinant is a candidate key
- All tables are structured such that:
  - No functional dependency violates BCNF rules

## Key Improvements from 2NF
- Eliminated hidden dependencies
- Data stored in logically independent tables
- Improved consistency and integrity

## Final Design Features
- Separate tables for:
  - Patient, Doctor, Nurse, Staff
  - Appointment, Prescription, Lab, Billing
- Use of Primary Keys and Foreign Keys
- No redundancy
- Efficient querying and scalability

## Conclusion
The final schema is fully normalized up to BCNF and represents a robust real-world database design.
