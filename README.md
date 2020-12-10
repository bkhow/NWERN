# NWERN
Work flow for NWERN meteorological and flux data
-------------
-------------
These files include examples of importing aeolian sediment flux weights into DIMA, exporting a report from DIMA, then taking the DIMA report into an R function that will build site specific line graphs of sediment flux at four heights over time. 

I will work on a similar workflow for metorlogical summaries and graphs collected from NWERN met towers. 

Next, I will include Brandon Edwards Python flux integration program with a few additional instructions to run the program. 
We should have a discussion on criteria to reject integrated flux values because of poor fit (low R^2), and contrast advantages of presenting/analyzing integrated values over other expressions of horizontal flux.


## WORK FLOW

### importing sediment weights ----

Proabably easiest to just download this entire GitHub library and make this folder your Working Directory in a new R-project.

1. Unzip "DIMA 5.5a as of 2020-06-02.zip"
2. In most older versions of DIMA, the zip folder includes DIMA's import templates to import data from non-DIMA sources, but I included the Aeolian Flux template in here. This is the format necessary to import from Excel to the database, and also the format of "RH_DIMA_import_Dec2020.xlsx" and "TV_DIMA_import_Dec2020.xlsx" which contain data from Nevada's Red Hills and Twin Valley NWERN sites.
3. Once your sediment weights are entered and formated to the import template, open the DIMA database, set your password (usually "9999"), and go to "Administrative Functions". Click on the "Data Management" drop arrow and choose "Data Imports/Exports". 
4. Click "Import Method data from a non-DIMA source"
5. Select "Aeolian Sediment Collection"
6. Click Browse and select your file (i.e. RH_DIMA_import_Dec2020.xlsx)
7. Click "Do Import..."
8. If there are no errors, proceed with import and then your data should be in DIMA!

### exporting sediment flux ----
1. At the DIMA homescreen, clock on "Reports" under Data.
2. Click "Reset" on the Date Range at the top of the Report Manager.
3. In "Select Method", click "Aeolian Sediment Collection".
4. Select Site and Plot, then click "Select Report" tab.
5. Click "Aeolian Sediment Flux Data" with Excel as the output format.
6. Click "Go..." !
7. Save this file into your working folder, and this will be imported AS IS into R-studio.

### create graphs of horizontal sediment flux in R ----
there may be some packages you will have to install in R for the function to work properly

1. Open "nwern_graphing_function_BKH.R"
