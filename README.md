# User Retention & Cohort Analysis Project
End-to-end user retention and cohort analysis using raw database logs (PostgreSQL) and interactive charts (Excel) to compare organic and promotional channels.
# User Retention & Cohort Analysis Project (End-to-End)

## 📌 Project Overview
This project focuses on analyzing user retention and cohort behavior dynamics using raw database logs. The main goal was to track user engagement over a 6-month period (January 2025 - June 2025) and compare the performance of organic vs. promotional marketing channels.

The project follows an **end-to-end analytics workflow**:
1. **Data Cleaning & Aggregation (SQL):** Processing irregular dates and formatting raw logs.
2. **Business Logic Calculation (SQL):** Defining user cohorts and active month offsets.
3. **Data Visualization & Insights (Excel / Google Sheets):** Building interactive cohort tables and calculating Retention Rate.

---

## 🛠️ Tools & Technologies Used
* **Database Management:** PostgreSQL / DBeaver
* **Data Presentation:** Microsoft Excel / Google Sheets
* **Key SQL Techniques:** Common Table Expressions (CTEs), Regular Expressions (RegEx) for string parsing, Window Functions, Conditional Logic (`CASE WHEN`), Date/Time manipulation.

---

## 📂 Repository Structure
* `3c926e35-717b-44eb-80dc-46156f4f3aedЗавдання 1 Проєкт з ментором Delehan.sql` — Contains the complete structured SQL script for data preparation, aggregation, and final querying.
* `Завдання 2 Проєкт з ментором Delehan (1)_2.xlsx` — Includes processed pivot tables, month-over-month retention metrics, and visualization charts.

---

## 🔬 Methodology & SQL Logic
The analytics pipeline was built in 4 distinct database steps:
* **Step 1 (Users Preparation):** Cleans irregular registration datetimes, handling format inconsistencies via robust Regex pattern matching.
* **Step 2 (Events Preparation):** Cleans user activity logs, formatting timestamps, and filtering out internal system testing actions (`test_event`).
* **Step 3 (Cohort Definition):** Merges users and activity metrics to compute `cohort_month` and calculate the lifetime `month_offset`.
* **Step 4 (Final Aggregation):** Extracts distinct user groups active between January and June 2025, segmented by `promo_signup_flag`.

---

## 📊 Key Insights & Business Results
* **Channel Performance:** User groups acquired through promo campaigns demonstrated distinct behavioral patterns compared to organic sign-ups.
* **Retention Dynamics:** Calculated exact month-over-month retention and churn velocity, uncovering critical drops during the second and third months of user lifecycles.
* **Data Optimization:** Replaced highly unstable raw text dates with indexed timestamps, creating a clean, reproducible SQL pipeline for automated future reporting.
