# SQL-Bank
This repository host a collection of SQL test that I have encountered.
While most of the time you'll be asked to write out the SQL query given a set of table schema, creating a mock up table in BigQuery will help a lot (if time allows for it) 

### How to create a temporary SQL table in BigQuery (BQ)

Login to your GCP console and Navigate to the BigQuery UI using the hamburger menu.

![](C:\Users\Bernard\Desktop\Bernard-MLab\SQL-Bank\_media\1_BQ.png)

Once inside BQ environment, select on `CREATE DATASET`

![](C:\Users\Bernard\Desktop\Bernard-MLab\SQL-Bank\_media\2_CreateDataset.png)

Give a name to your Dataset which will be holding the tables which you will be creating within the sandbox environment. As we are using a free version of BQ without any credits, tables hosted under the sandbox dataset instance have an maximum expiry of <u>60 days</u>.

![](C:\Users\Bernard\Desktop\Bernard-MLab\SQL-Bank\_media\2a_CreateDataset.png)

After creating the dataset, we will then create a BQ table that will contain our incoming data from sheets. 

We select on `CREATE TABLE`. 

![](C:\Users\Bernard\Desktop\Bernard-MLab\SQL-Bank\_media\3_CreateTable.png)

Then in the source window, we choose `Drive` as our source and paste your Google Sheets link  into `Select Drive URI`. Give a name to your table (*`tbl1` in the example*), and select the Dataset which you have created earlier to hold this table. 

If you don't want to specify the table schema manually, check on `Auto-detect Schema and input parameters`, and if the rows where the headers are in. (*in this case the header are in row 1 of the Google Sheet*)

Once done, select `Create table`  button to import the data from Google Sheet into BigQuery table.

With your sheets linked to your BigQuery, you can always commit changes to your sheet and it will automatically appear in BigQuery.

![](C:\Users\Bernard\Desktop\Bernard-MLab\SQL-Bank\_media\3a_CreateTable.png)

### To Note

- This process cannot support volumes of data greater than 10,000 rows in a single spreadsheet. 