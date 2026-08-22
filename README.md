# Microsoft Fabric Retail Analytics

An end-to-end retail analytics project built with Microsoft Fabric, SQL, PySpark and Power BI.

## Project Overview

This project explores Brazilian e-commerce data from Olist and demonstrates an end-to-end analytics workflow in Microsoft Fabric.

The goal was to build a complete analytical solution, from raw data ingestion and transformation to data modeling and an interactive Power BI dashboard.

## Architecture

**Source Data → Dataflow Gen2 → Lakehouse → SQL Views → Semantic Model → Power BI**

The solution combines:

- **Dataflow Gen2** for data ingestion and transformation
- **Microsoft Fabric Lakehouse** for centralized data storage
- **SQL** for data exploration, quality checks and analytical views
- **PySpark** for creating the date dimension
- **Semantic modeling and DAX** for business logic and time intelligence
- **Power BI** for the final analytical dashboard

## Dashboard

The final report provides an overview of retail performance across:

- Revenue
- Orders
- Average Order Value
- Items Sold
- Product Categories
- Customer Geography
- Customer Review Scores

The dashboard includes year-over-year comparisons, monthly trends and category-level performance analysis.

## Data Modeling

The analytical model follows a star-schema approach with a central sales fact table and dimensions for:

- Products
- Customers
- Sellers
- Date

Review data required additional modeling because reviews are recorded at order level while sales are stored at order-item level.

Reviews were therefore aggregated to the correct grain before being integrated into the analytical model, preventing duplicated review weighting and inflated sales results.

## Repository Structure

```text
sql/          SQL exploration, quality checks and analytical views
notebooks/    PySpark transformations
docs/         Architecture, semantic model and dashboard screenshots
