# Mini SQL test

Hello! 👋 

This is a mini test I did for a Junior Data Analyst position I applied. Since it covers important SQL notions such as Joins, Windows Functions, Aggregate Functions, Converting Data Types, COALESCE, I decided to include it on my portfolio.

## Data

There are three datasets containing data about a made-up consult company's clients, their business IDs, their sales, subscription date, renewal and cancellation, business categories and so on.  

## Here's what I did...

Before importing the datasets into PgAdmin4 (PostgreSQL), I did some cleaning of the data on Excel:
- Changed the date format from dd/mm/yyyy to **yyyy-mm-dd** as it is accepted by PostgreSQL;
- and replaced the commas (,) to **period points (.)** in the **NUMERIC** values.
  
Next, I created the database on PgAdmin4 and its datasets where I determined the data types, so it would be imported correctly.
After these steps, I proceeded to analyse the datasets as it follows [here](https://github.com/marianaobmorais/test_ueni/blob/main/mini_sql_test_ueni.sql).
