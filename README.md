# 🏥 Hospital Management System (DBMS Project)

## 📌 Overview

This project is a fully normalized **Hospital Management System database** designed as part of a DBMS course.
It demonstrates the complete transformation of data from **Unnormalized Form (UNF) to Boyce-Codd Normal Form (BCNF)**.

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

---

## 🧠 Normalization Process

### 🔹 1. Unnormalized Form (UNF)

* Single flat table
* Repeating groups (multiple medicines, tests)
* High redundancy

📁 `01_UNF/`

---

### 🔹 2. First Normal Form (1NF)

* Atomic attributes
* No repeating groups

📁 `02_1NF/`

---

### 🔹 3. Second Normal Form (2NF)

* Removed partial dependencies
* Tables split based on functional dependencies

📁 `03_2NF/`

---

### 🔹 4. Third Normal Form (3NF) & BCNF

* Removed transitive dependencies
* Fully structured relational schema

📁 `04_3NF_BCNF/`

---

## 🧩 ER Diagram

The ER diagram represents entities, attributes, and relationships across modules.

📁 `ER_Diagram/`

---

## 🛠️ Technologies Used

* **MySQL**
* **SQL (DDL & DML)**
* **Database Normalization Techniques**

---

## 📊 Key Features

* Fully normalized schema (up to BCNF)
* Real-world hospital workflow modeling
* Modular database design
* Supports complex queries and reporting

---

## 📂 Project Structure

```
Hospital-Management-System/
│
├── 01_UNF/
├── 02_1NF/
├── 03_2NF/
├── 04_3NF_BCNF/
├── ER_Diagram/
└── README.md
```

---

## 🧠 Learning Outcomes

* Deep understanding of normalization
* Practical database design skills
* Handling real-world data dependencies
* Structuring scalable database systems

---

## 👨‍💻 Author

**Nikhil Upadhyay**
B.Tech CSE | DBMS Project
