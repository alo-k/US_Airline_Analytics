🚀 Airline Data Analytics Project — Overview

Built an end-to-end Airline Analytics solution using SQL Server and Power BI, analyzing 5.8M+ flight records. Performed data cleaning, transformation, KPI development, and EDA, then created an interactive dashboard to monitor on-time performance, delays, cancellations, airline efficiency, airport performance, and travel trends.

Dataset Link - https://drive.google.com/file/d/1_Mt-OR_IxoIy7HVkvD4bW0-fm4MRY6og/view

📊 Dataset & Scale
Analyzed 5.8M+ flight records across multiple datasets (flights, airlines, airports)
Large-scale dataset (~5.8 million rows)
Multiple data sources integrated
Real-world airline operations data

🛠️ Data Engineering (SQL)
Designed and built a relational data model by integrating 3 datasets using SQL joins
Imported and structured data in SQL Server
Created a central analytical view (flight_analysis_view)
Joined:
Flights
Airlines
Airports

🧹 Data Cleaning & Transformation
Performed data cleaning and transformation using SQL to prepare data for analysis
Handled NULL values across multiple columns
Converted raw HHMM time fields into usable formats
Created new features:
FLIGHT_DATE
Cleaned time columns
Standardized categorical fields (e.g., cancellation reasons)

📊 Exploratory Data Analysis (SQL)
Conducted EDA using SQL to uncover trends and operational patterns
Total flights, cancellations, diversions
Delay statistics (avg, min, max)
Delay type distribution:
Airline
Weather
Air system
Security
Late aircraft

📈 KPI Development
Defined and calculated key airline performance metrics
On-Time Performance (OTP %)
Average Arrival & Departure Delay
Cancellation Rate
Delay contribution by type

📊 Dashboard Development (Power BI)
Used Microsoft Power BI
Developed an interactive multi-page dashboard for airline performance analysis
Dashboard Pages

1️⃣ Overview
KPI cards (Flights, OTP, Delay, Cancellation)
Delay distribution
Monthly trends

2️⃣ Airline Performance
Airline comparison (delay, OTP, cancellations)
Delay breakdown by airline

3️⃣ Airport Performance
Top airports by traffic
Delay & cancellation hotspots
Map visualization

4️⃣ Temporal Trends
Monthly, weekly, hourly delay patterns
Peak congestion periods
🎯 Key Insights Generated
Identified major operational inefficiencies and delay drivers
Late aircraft delay = largest contributor
Peak delays observed during evening hours
Certain airports consistently show higher congestion
Seasonal trends impact delays and cancellations

💡 Tools & Skills Used
SQL Server | Power BI | Data Cleaning | EDA | KPI Design | Data Visualization
