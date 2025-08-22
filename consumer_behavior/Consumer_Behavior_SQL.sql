-- 1) CREATE DATABASE (jalankan dulu terpisah)
CREATE DATABASE gc2_consumer_behavior;
\c gc2_consumer_behavior;\n\n-- 2) DIM TABLES
CREATE TABLE dim_gender (
  gender_id INTEGER PRIMARY KEY,
  gender TEXT NOT NULL
);\n\nCREATE TABLE dim_time (
  time_id INTEGER PRIMARY KEY,
  time_of_purchase TIMESTAMP NOT NULL,
  date DATE,
  year INT,
  month INT,
  day INT,
  hour INT
);\n\nCREATE TABLE dim_payment_method (
  payment_method_id INTEGER PRIMARY KEY,
  payment_method TEXT
);\n\nCREATE TABLE dim_product_category (
  product_category_id INTEGER PRIMARY KEY,
  product_category TEXT
);\n\nCREATE TABLE dim_location (
  location_id INTEGER PRIMARY KEY,
  location TEXT
);\n\nCREATE TABLE main_fact (
  main_id SERIAL PRIMARY KEY,
  age INT NOT NULL,
  purchase_amount NUMERIC,
  categorical_purchase_amount TEXT,
  gender_id INT REFERENCES dim_gender(gender_id),
  time_id INT REFERENCES dim_time(time_id),
  payment_method_id INT REFERENCES dim_payment_method(payment_method_id),
  product_category_id INT REFERENCES dim_product_category(product_category_id),
  location_id INT REFERENCES dim_location(location_id)
);\n\n-- 3) COPY CSVs into tables (pastikan CSV sudah ada di /tmp)\nCOPY dim_gender(gender, gender_id) FROM '/tmp/dim_gender.csv' CSV HEADER;\nCOPY dim_time(time_of_purchase, date, year, month, day, hour, time_id) FROM '/tmp/dim_time.csv' CSV HEADER;\nCOPY dim_payment_method(payment_method, payment_method_id) FROM '/tmp/dim_payment_method.csv' CSV HEADER;\nCOPY dim_product_category(product_category, product_category_id) FROM '/tmp/dim_product_category.csv' CSV HEADER;\nCOPY dim_location(location, location_id) FROM '/tmp/dim_location.csv' CSV HEADER;\nCOPY main_fact(main_id, age, purchase_amount, categorical_purchase_amount, gender_id, time_id, payment_method_id, product_category_id, location_id) FROM '/tmp/main_fact.csv' CSV HEADER;\n\n-- 4) Database Testing

-- a) Total Purchase Amount per Gender for Age <= 30
SELECT g.gender, SUM(f.purchase_amount) AS total_purchase_amount
FROM main_fact f
JOIN dim_gender g ON f.gender_id = g.gender_id
JOIN dim_time t ON f.time_id = t.time_id
WHERE f.age <= 30
GROUP BY g.gender
ORDER BY g.gender;

-- b) Summary statistics (avg, min, max) by one categorical column (e.g., product_category)
SELECT p.product_category,
       AVG(f.purchase_amount) AS avg_amount,
       MIN(f.purchase_amount) AS min_amount,
       MAX(f.purchase_amount) AS max_amount
FROM main_fact f
JOIN dim_product_category p ON f.product_category_id = p.product_category_id
GROUP BY p.product_category
ORDER BY avg_amount DESC;