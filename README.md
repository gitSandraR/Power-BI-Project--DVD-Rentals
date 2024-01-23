# Power BI Project: DVD Rentals

 
## Environment Setup:

To run the project, copy the whole folder ***DVD Rental Project*** to
your computer. This folder contains all the files necessary for the
project including *Data Source Files* folder with data sources. Under
assumption that the Power BI Desktop is already installed on the
computer, run the main project ***DVD_Rental.pbix*** file. This file
will connect to the mentioned data source files. I have created a
parameter ***pProjectPath*** that holds the project root folder, so you
only need to change this parameter to the location where you have copied
the *DVD Rental Project* folder, no individual data source locations are
needed to change. In Power BI Desktop go to Power Query (in Home ribbon
choose *Transform Data*), and from there go to Home ribbon and choose
*Manage Parameters \> Edit Parameters* to change the path of your
project. Choose *Close and Apply*.

***Note:*** Since the semantic model from this project won't be reused for
future reports, both the semantic model and the report are part of the
same ***.pbix*** file.
<br/> <br/>

## Data Source Files:

All the data comes from PostgreSQL sample database (***dvdrental.tar***
file included with the SQL queries run to extract the necessary data;
queries saved in ***Database and SQL Queries*** folder). After initial
inspection of the data, I realized that the data doesn't resemble a
real-world scenario and cannot be used to draw meaningful insights. So,
I have manually adjusted the extracted **.csv** files. Most of the
adjustments were related to the correction of the dates and locations
(after all who rents DVDs to customers in every single country in the
world). Finally, the results are saved as **.csv** files in the ***Data
Source Files*** folder. All the further transformations were done in
Power BI Desktop, and every single step is documented in Power Query
editor.

There is one more **.csv** file additionally made to support the
creation of a tooltip page (***Country Flags.csv***). Starting with a
*Customer.csv*, all the columns except *country_id* and *Country* were
removed. Then, after downloading small pictures of country flags from
<https://www.worldometers.info/geography/flags-of-the-world/> website,
the image URLs were created using an online image to URL converter.
These image URLs were then matched with corresponding countries in the
*Country Flags.csv* file (*Country Flag* column). Finally, the file was
imported to Power BI and relationship was made with an appropriate table
in the model.
<br/> <br/>

***Query dependencies screenshot:***

![Source Files - Query Dependencies screenshot](https://github.com/gitSandraR/Power-BI-Project--DVD-Rentals/assets/133241677/9d311859-6b10-4a5b-9847-dfdaea3dc743)
<br/> <br/> <br/>

## Modeling and DAX:
<br/>

![Data Model](https://github.com/gitSandraR/Power-BI-Project--DVD-Rentals/assets/133241677/659c13f9-650d-4d95-9073-e46ab2ff77cc)

<br/>

### Few points worth mentioning here:
<br/>

 🔷 **1.**  Bidirectional relationship was made between *Country Flags* and
    *Customer*, so the *Customer* table can filter the Country Flags and
    get the picture of a flag for a given country. The sole purpose for
    *Country Flags* in this project is to support the tooltip visual.

🔷 **2.**  *Rentals* and *Payments* table contains both rented DVDs that
    weren't paid and those with payments. All the revenue (that is all
    the payments) came in 2007. Rentals without payments are from prior
    dates. Although not reflecting a usual scenario in a real world,
    this is important to know for the analysis of revenue vs. analysis
    of rentals (i.e. rental durations, per category, overdue, by region,
    and especially over time).

🔷 **3.**  *Film Text Analysis* is a table made starting from the *Film* table.
    **AI Text Analysis** in Power Query is invoked to extract key
    phrases from film descriptions. These key phrases can be later used
    for further analysis. Here, a simple *Word Cloud* custom visual is
    made in a report page.

🔷 **4.**  *Date* table has one active and two inactive relationships with
    *Rentals and Payments* table. Active relationship is related to
    *Payment Date* column (for the analysis of sales), while inactive
    relationships were related to *Rental Date* and *Return Date* (for
    the analysis of films and rentals). *Date* table is a calculated
    table made in DAX and marked as a date table: <br/> <br/>
    

> **Date** = <br/>
> ***ADDCOLUMNS*** ( <br/>
> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ***CALENDARAUTO ()***, <br/>
> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; "Day", ***DAY*** ([Date]), <br/>
> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; "Month", ***MONTH*** ([Date]), <br/>
> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; "Year", ***YEAR*** ([Date]), <br/>
> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; "Month/Year", ***EOMONTH*** ([Date], 0), <br/>
> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; "Year/Quarter", ***YEAR*** ([Date]) & " " & "Q" & ***QUARTER*** ([Date]) <br/>
> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  ) <br/> <br/>
 

🔷 **5.**  Other measures used in visuals: <br/> <br/>

> **Total Sales** = ***SUM*** (\'Rentals and Payments\'\[Amount\])
<br/> <br/>

> **YTD Sales** = ***CALCULATE*** (\[Total Sales\], ***DATESYTD*** (\'Date\'\[Date\]))
<br/> <br/>

> **Previous Month Sale** = ***CALCULATE*** (\[Total Sales\], ***PREVIOUSMONTH*** (\'Date\'\[Date\]))
<br/> <br/>

> **Average Rental Duration (in days)** = <br/>
> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ***SUM*** (\'Rentals and Payments\'\[Rental Duration in days\]) <br/>
> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; / ***COUNTROWS*** (\'Rentals and Payments\')
<br/> <br/>

> **Average of Replacement Cost (by Return Date)** = <br/>
> ***CALCULATE*** ( <br/>
>  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ***AVERAGEX*** (Film, Film\[Replacement Cost\]), <br/>
> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ***CROSSFILTER*** (\'Rentals and Payments\'\[film_id\], \'Film\'\[film_id\], Both), <br/>
> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ***USERELATIONSHIP*** (\'Date\'\[Date\], \'Rentals and Payments\'\[Return Date\]) <br/>
> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  )
<br/> <br/>

> **\# of Rentals (by Rental Date)** = <br/>
 > ***CALCULATE*** ( <br/>
 > &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ***COUNTROWS*** (\'Rentals and Payments\'), <br/>
 > &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ***ALL*** (\'Rentals and Payments\'\[Is Overdue\]), <br/>
 > &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ***USERELATIONSHIP*** (\'Date\'\[Date\], \'Rentals and Payments\'\[Rental Date\]) <br/>
> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;         )
<br/> <br/>

> **\# of Overdue Rentals (by Rental Date)** = <br/>
> ***CALCULATE*** ( <br/>
> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ***COUNTROWS*** (\'Rentals and Payments\'), <br/>
> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; \'Rentals and Payments\'\[Is Overdue\] = \"Yes\", <br/>
> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ***USERELATIONSHIP*** (\'Date\'\[Date\], \'Rentals and Payments\'\[Rental Date\]) <br/>
> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;     )
<br/> <br/>

 > **% of Overdue Rentals** = <br/>
 > ***DIVIDE*** ( <br/>
 > &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; \'Rentals and Payments\'\[# of Overdue Rentals (by Rental Date)\], <br/>
 > &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; \'Rentals and Payments\'\[# of Rentals (by Rental Date)\], <br/>
 > &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 0 <br/>
 > &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;    )
 <br/> <br/>

## Visuals Pages / Tooltips Screenshots:
<br/>

Report opens on a ***Customers*** page:

-   Navigation is done through page navigator in the top left corner
    (and includes only visible pages in the report).

-   Table visual is filtered to show only top 10 customers by sales so
    the performance of the report is not affected much. For good
    performance, recommendation is also that one page should contain no
    more than 8 visuals per page.

-   Map visual can be drilled down to show sales by city for a given
    country.

-   Although scatter plots are used show the existence of correlation
    between two measures, here it is used in a bit creative way to show
    total sales and number of customers for each country. It is
    supplemented with a custom tooltip that pops-up with more details
    including a country flag.

<br/>

![Customers Page](https://github.com/gitSandraR/Power-BI-Project--DVD-Rentals/assets/133241677/c50549a8-dc0a-42a8-ad13-1a2b9d5622ed)
<br/> <br/>
---

<br/>

***Sales*** page:

-   Month/Year slicer in the top right was filtered to include only
    months in which there was a sale. Then that filter is hidden so the
    report consumers cannot change or even see it. Also, interactions
    were set between slicers and other visuals.

-   A KPI and a card visual change values to reflect selected choices in
    slicers and other visuals.

-   Total sales by region visual can be further drilled down. For the
    selected data point (region; *Country (group)* field was created in
    the model for this functionality) a new drill-through page is open
    with details related to that region's stats.

-   Total sales line chart shows sales over time. Unfortunately, the
    underlying data is not complete and as such not useful for a
    comprehensive time series analysis, anomaly detection or maybe
    forecast. In this example more appropriate chart to use would be
    clustered column chart because it distinguishes days with and
    without sales. Line chart gives a false impression of continuous
    sales.

<br/>

![Sales Page](https://github.com/gitSandraR/Power-BI-Project--DVD-Rentals/assets/133241677/8182ecbb-fcab-4de7-8072-e127fdde9562)
<br/> <br/>
---

<br/>

***Films*** and ***Rentals*** pages:

-   Analysis over time here is done by rental and return dates. For
    this, DAX measures used USERELATIONSHIP function to activate two
    inactive relationships between *Date* and *Films,* and *Date* and
    *Rentals* tables. Films were rented in 2005 and early 2006.
<br/> <br/>

![Films Page](https://github.com/gitSandraR/Power-BI-Project--DVD-Rentals/assets/133241677/e346843c-e63f-4cf8-8cd5-24c1a74e68f4)
<br/> <br/>

![Rentals Page](https://github.com/gitSandraR/Power-BI-Project--DVD-Rentals/assets/133241677/f4df9f6e-7ac0-406d-aed3-43eb82b740e9)
<br/> <br/>
---

<br/>

Drill-through ***Region*** page:

-   For the selected region (for example Europe) new details are shown
    in a separate page. This declutters the *Sales* page and improves
    performance. Here *Total Sales by Country* visual instantly shows
    the worst performers and calls for an action to investigate and
    remedy this.
<br/> <br/>

![DrillThroughRegion Page](https://github.com/gitSandraR/Power-BI-Project--DVD-Rentals/assets/133241677/ac0d3bc1-34d1-49d2-a056-1973cc3fc68d)
<br/> <br/>
---

<br/>

Custom ***tooltip*** pages:

-   Left: custom tooltip used on the *Customers* page. A custom *Simple
    Image* visual is used to hold a picture of a flag, and a multi row
    card to hold relevant details.

-   Right: this tooltip was used for bar and line combo chart on the
    *Rentals* page. This chart has two default tooltips that are shown
    separately for bar and for line chart. To put everything together in
    one combo tooltip I used a custom tooltip page.
<br/> <br/>

![Customers Tooltip](https://github.com/gitSandraR/Power-BI-Project--DVD-Rentals/assets/133241677/f4e60ca7-713c-4573-ad78-d6e1bf8e7911)  &nbsp; &nbsp; ![Rentals Tooltip](https://github.com/gitSandraR/Power-BI-Project--DVD-Rentals/assets/133241677/cfbc36d3-c1f3-42bf-a1eb-35296ae9b59c)
<br/> <br/>
---


