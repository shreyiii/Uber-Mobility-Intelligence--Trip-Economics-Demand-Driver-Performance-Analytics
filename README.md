🚕 Uber Data Analytics

End-to-end data analytics project transforming raw Uber trip data into business insights using Python, PostgreSQL, SQL, and Power BI.

📌 Overview

This project analyzes 100,000 Uber trip records to understand trip demand, revenue performance, payment behavior, trip economics, and geographic activity.

The project follows a complete analytics workflow — from data preparation and exploratory analysis to analytical modeling, SQL-based business analysis, and interactive Power BI reporting.

The primary objective is to move beyond descriptive charts and answer practical business questions around revenue, demand, operations, and customer trip behavior.

🎯 Business Objectives

The analysis focuses on:

Understanding trip demand across time
Identifying revenue patterns and key revenue drivers
Comparing payment methods and trip economics
Analyzing pickup and dropoff concentration
Identifying high-volume routes
Evaluating distance, duration, speed, and trip value
Comparing same-area and different-area trips
Identifying data-quality issues affecting analysis
🔄 Analytics Workflow
Raw Data
   ↓
Data Cleaning & Validation
   ↓
Exploratory Data Analysis
   ↓
Feature Engineering
   ↓
Analytical Data Modeling
   ↓
PostgreSQL
   ↓
SQL Business Analysis
   ↓
Power BI Dashboard
   ↓
Business Insights
📊 Dataset
100,000 raw trip records
99,930 records used in the revenue-focused analytical dataset
Trip-level timestamps, distance, passenger, geographic, payment, and financial information
Data covers March 1–10, 2016
Unique trip_id generated for analytical tracking

The analysis also identifies data-quality conditions such as zero-duration trips, zero-distance trips, and negative financial values.

🧹 Data Preparation

Python and Pandas were used to prepare the analytical dataset.

Key steps included:

Datetime standardization
Duplicate validation
Unique trip identification
Missing-value assessment
Data-quality validation
Trip duration calculation
Average-speed calculation
Revenue efficiency metrics
Tip percentage calculation
Pickup/dropoff area creation
Same-area trip classification

Financially invalid records were separated from the revenue-analysis population rather than allowing them to distort revenue KPIs.

📐 Analytical Metrics

The project derives business metrics including:

Metric	Purpose
Trip Duration	Measures journey time
Average Speed	Evaluates distance relative to duration
Average Trip Value	Measures average transaction value
Revenue per Mile	Measures distance-based revenue efficiency
Revenue per Minute	Measures time-based revenue efficiency
Tip Percentage	Measures tipping behavior
Same-Area Trips	Identifies short/local movement patterns
🗄️ Data Architecture

The analytical workflow uses a dimensional modeling approach before loading the final analytical dataset into PostgreSQL.

                  ┌─────────────────┐
                  │  Date / Time    │
                  └────────┬────────┘
                           │
┌───────────────┐          │          ┌─────────────────┐
│ Passenger     │          │          │ Payment         │
│ Dimension     │──────────┼──────────│ Dimension       │
└───────────────┘          │          └─────────────────┘
                           │
                    ┌──────▼──────┐
                    │ Fact Trips  │
                    │             │
                    │ Revenue     │
                    │ Distance    │
                    │ Duration    │
                    │ Tips        │
                    └──────┬──────┘
                           │
                 ┌─────────┴─────────┐
                 │                   │
          Pickup Location     Dropoff Location

The final analytical dataset is stored in PostgreSQL as:

Database: uber_analytics
Table: public.uber_trips
🧠 Business Analysis

SQL was used to answer 24 business questions covering:

Demand & Time
Trip volume by hour
Revenue by hour
Daily trip and revenue trends
Cumulative revenue progression
Revenue & Payments
Revenue by payment type
Payment-type revenue contribution
Average trip value
Revenue per mile
High-value trips
Tip behavior
Operations
Vendor performance
Passenger behavior
Distance distribution
Trip duration and speed
Geography
Top pickup areas
Top dropoff areas
High-volume routes
High-revenue routes
Same-area vs different-area trips
Data Quality
Zero-duration trips
Zero-distance trips
Negative financial values
📍 Geographic Analysis

Geographic analysis uses rounded latitude/longitude combinations as analytical areas to identify concentration and route patterns.

The analysis found strong activity across a relatively concentrated set of pickup and dropoff areas.

Among trips with valid coordinates:

98,936 trips were available for route analysis
The top 10 routes represented approximately 6.03% of valid-coordinate trips
Those routes generated approximately 3.56% of route revenue

This analysis helps identify recurring movement patterns without treating coordinate buckets as official geographic zones.

💰 Revenue & Trip Economics

The project evaluates revenue from multiple perspectives rather than relying only on total revenue.

Key dimensions include:

Revenue by time
Revenue by payment method
Revenue by geographic area
Revenue by route
Revenue by trip distance
Revenue per mile
Revenue per minute
Average trip value
Tip percentage

This provides a more complete view of volume versus value.

📊 Power BI Dashboard

The final analytical layer is connected to Power BI to provide an interactive reporting experience.

Executive Overview

Focuses on core KPIs:

Total Trips
Total Revenue
Average Trip Value
Average Distance
Average Duration
Total Tips
Operations & Location

Focuses on:

Trip demand by hour
Revenue by hour
Pickup-area performance
Dropoff-area performance
Route activity
Payments & Trip Economics

Focuses on:

Payment-method performance
Revenue contribution
Average trip value
Tip behavior
Trip-value distribution
Same-area vs different-area trips
🛠️ Tech Stack

Data Analysis

Python · Pandas · NumPy · Jupyter Notebook

Database & SQL

PostgreSQL · SQL · SQLAlchemy · Psycopg2

Business Intelligence

Power BI

Analytics Concepts

EDA · Data Cleaning · Feature Engineering · Dimensional Modeling · KPI Development · Business Analysis

📁 Project Structure
Uber-Data-Analytics/
│
├── data/
├── notebooks/
├── sql/
├── powerbi/
├── docs/
├── requirements.txt
└── README.md
📌 Key Takeaway

This project demonstrates an end-to-end approach to turning raw transactional data into business intelligence.

Rather than stopping at data visualization, the workflow connects:

Data Quality → Analytics → SQL → Data Modeling → BI → Business Insights

making the project representative of a practical Data Analyst / BI Analyst workflow.

👨‍💻 Author

Shrey Srivastava
