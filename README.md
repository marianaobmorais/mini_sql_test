# Mini SQL test for UENI

I decided to share the SQL code through GitHub as it allows a better readability.

Before importing the datasets into PgAdmin4 (PostgreSQL), I did some cleaning of the data on Excel:
- Changed the date format from dd/mm/yyyy to **yyyy-mm-dd** as it is accepted by PostgreSQL;
- and replaced the commas (,) to period points (.) in the NUMERIC values.
  
Next, I proceeded to create the database on PgAdmin4 and its datasets where I determined the data types, so it would be imported correctly.
After these steps, I proceed to analyse the datasets as it follows [here](https://github.com/marianaobmorais/test_ueni/blob/main/mini_sql_test_ueni.sql).
