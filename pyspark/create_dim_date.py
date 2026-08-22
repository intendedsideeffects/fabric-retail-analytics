# ============================================================
# CREATE DATE DIMENSION
# Olist Retail Analysis
# Creates a continuous calendar table for time intelligence
# and stores it as a Delta table in the Fabric Lakehouse.
# ============================================================

from pyspark.sql import functions as F


# ------------------------------------------------------------
# 1. Read source order data
# ------------------------------------------------------------

orders = spark.table("olist_orders_dataset")


# ------------------------------------------------------------
# 2. Determine calendar range
# ------------------------------------------------------------

date_range = orders.select(
    F.min(F.to_date("order_purchase_timestamp")).alias("min_date"),
    F.max(F.to_date("order_purchase_timestamp")).alias("max_order_date")
).first()

min_date = date_range["min_date"]
max_order_date = date_range["max_order_date"]

# Extend the calendar to the end of the final year so that
# incomplete years still display a full Jan–Dec axis.
max_date = max_order_date.replace(month=12, day=31)

print(f"Actual order range: {min_date} to {max_order_date}")
print(f"Calendar range: {min_date} to {max_date}")


# ------------------------------------------------------------
# 3. Create continuous date dimension
# ------------------------------------------------------------

dim_date = (
    spark.sql(
        f"""
        SELECT explode(
            sequence(
                to_date('{min_date}'),
                to_date('{max_date}'),
                interval 1 day
            )
        ) AS date
        """
    )
    .withColumn("year", F.year("date"))
    .withColumn("quarter", F.quarter("date"))
    .withColumn("month_number", F.month("date"))
    .withColumn("month_name", F.date_format("date", "MMMM"))
    .withColumn("day", F.dayofmonth("date"))
    .withColumn("year_month", F.date_format("date", "yyyy-MM"))
    .withColumn(
        "jan_dec_clean",
        F.when(F.col("month_number") == 1, F.lit("J "))
        .when(F.col("month_number") == 12, F.lit("D "))
        .otherwise(
            F.expr("repeat('\u200b', month_number)")
        )
    )
)


# ------------------------------------------------------------
# 4. Persist as Delta table in the Lakehouse
# ------------------------------------------------------------

(
    dim_date.write
    .mode("overwrite")
    .format("delta")
    .option("overwriteSchema", "true")
    .saveAsTable("dim_date")
)


# Preview result in Fabric notebook
display(dim_date)
