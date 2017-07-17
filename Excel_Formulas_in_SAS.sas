/* Create programData */
data programData;
length business $7 measure $18;
infile datalines dlm = ',';
input business $ measure $
installs kWhSavings;
label business = 'Business Type'
measure = 'Measure'
installs = 'Installations'
kWhSavings = 'kWh Savings';
datalines;
Grocery, T8, 406, 24365
Grocery, Strip Curtains, 32, 11985
Office, CFL, 97, 16510
Office, LED Exit Signs, 105, 35412
Office, T8, 41, 1811
Office, Occupancy Sensor, 493, 218976
Retail, CFL, 158, 27991
Retail, LED Exit Signs, 4, 1124
Retail, T8, 601, 35089
;
run;

/* creating data template
The first is that the order of the variables needs to be exactly as they will appear in Excel. 
If one wanted the savings per measure to come last, it would need to be last in the query. 
The second is that the placeholders for the three formula variables—even though they resolve to numeric values 
in Excel—need to be character variables, since they will eventually contain text strings. The third is
that the formula placeholders should have a length sufficient to accommodate the formulas they will contain.
*/
proc sql;
CREATE TABLE dataTemplate AS
SELECT business 'Business',
measure 'Measure',
installs 'Installs',
kWhSavings 'Total kWh Savings',
' ' AS kWhPerMeasure length 100 'kWh Savings per Measure'
' ' AS cumBizSavings length 100 'Cumulative kWh Savings for Business',
' ' AS pctOfBiz length 100 'kWh Savings as % of Business',
' ' AS pctOfMeasure length 100 'kWh Savings as % of Measure'
FROM programData
ORDER BY business, measure;
quit;

proc sql;
SELECT name INTO :finalQuery
SEPARATED BY ', '
FROM sashelp.vcolumn
WHERE libname = "WORK" AND
memname = "DATATEMPLATE"
ORDER BY varNum;
quit;

data excelColumns(where = (start <= 256));
length label $2;
do c1 = -1 to 25;
do c2 = 0 to 25;
alpha1 = byte(rank('A')+ c1);
alpha2 = byte(rank('A')+ c2);
label = compress(alpha1||alpha2, " @");
start + 1;
fmtName = "column";
output;
end;
end;
run;
proc format cntlin = excelColumns;
run;

proc sql;
CREATE TABLE addressFmt AS
SELECT strip(upcase(name)) AS start,
strip(put(varnum, column.)) AS label length 2,
"var2Excel" AS fmtName,
"J" AS type,
type AS varType,
varNum
FROM sashelp.vcolumn
WHERE libname = "WORK" AND
memname = "DATATEMPLATE"
ORDER BY varNum;
quit;
proc format cntlin = addressFmt;
run;
proc print data = addressFmt;
title 'Address Format';
run;

%macro arrayMacros(arrayType);
%global excel&arrayType;
proc sql noprint;
SELECT strip(start)||"&arrayType" INTO :excel&arrayType
SEPARATED BY " "
FROM addressFmt
ORDER BY varnum;
quit;
%mend arrayMacros;
%arrayMacros(_X);
%arrayMacros(_G);
%arrayMacros(_R);
%arrayMacros(_C);

%let rowAdder = 3;
proc sql;
SELECT strip(put(count(*) + &rowAdder, best.)) INTO :lastRow
FROM dataTemplate;
quit;
data dataTemplate2;
length &excel_X &excel_G &excel_R &excel_C $40;
retain firstBizRow;
set dataTemplate;
by business measure;
array addr_X {*} $ &excel_X;
array addr_G {*} $ &excel_G;
array addr_R {*} $ &excel_R;
array addr_C {*} $ &excel_C;
firstRow = strip(put(1 + &rowAdder, best.));
lastRow = "&lastRow";
currentRow = strip(put(_N_ + &rowAdder, best.));
if first.business then firstBizRow = currentRow;
do i = 1 to dim(addr_X);
xlsName = upcase(scan(vname(addr_x(i)), 1, '_'));
xlsColumn = strip(input(xlsName, $var2excel.));
addr_x(i) = cats(xlsColumn, currentRow);
addr_g(i) = cats(xlsColumn, firstBizRow);
addr_r(i) = strip(addr_g(i))||":"||strip(addr_x(i));
addr_c(i) = compress(cats(xlsColumn, firstRow, ':', xlsColumn, lastRow));
end;
run;

data dataTemplate3;
set dataTemplate2;
kWhPerMeasure = cats('=', kWhSavings_X, ' / ', installs_x);
cumBizSavings = cats('=sum(', kWhSavings_r, ')');
pctOfBiz = cats('=', kWhSavings_x, '/ sumif(', business_c, ',',
business_x, ',', kWhSavings_c, ')');
pctOfMeasure = cats('=', kWhSavings_x, '/ sumif(', measure_c, ',',
measure_x, ',', kWhSavings_c, ')');
run;

title 'Example of Final Output';
proc sql;
CREATE TABLE finalData AS
SELECT &finalQuery
FROM dataTemplate3;
quit;

/*********************************************************************************/

options noxwait noxsync;

data _null_; rc=system('start excel'); run;

data _null_; x=sleep(3); run;

filename EXCEL DDE 'EXCEL|SYSTEM';

%let path = "\\dom1\Core\Dept\GED\SSBA\Group\GSS\STATS\TrendsSupport\SoftwareAutomation\testexcel.xlsx"; 
/* Open Excel workbook */
data _null_; file EXCEL;
put '[open("'&path'")]';
run;

/* See Formating Excel Spreadsheets SAS whitepaper by Watts, 2004 (SUGI 30) */
filename planyr dde "Excel|[testexcel.xlsx]Sheet1!R4C1:R12C7" notab; /* Transferring SAS data to Excel with DDE Triplet */
data work.dossout; 
  retain b (-1) t '09'x;
  set work.finaldata;
  file planyr;
  put business t+b measure t+b installs t+b kWhSavings t+b cumBizSavings t+b pctOfBiz t+b pctOfMeasure t+b;
run;

/* Save and close the excel workbook */
filename ddecmds dde 'excel|system '; /* Format with DDE Doublet */
data _null_; file ddecmds;
 put '[workbook.activate("Sheet1")]';
 put '[select("r4c1:r12c1")]';
 /* FORMAT.FONT(name_text, size_num, bold, italic, underline, strike, color, outline, shadow) */
 put '[FORMAT.FONT("Arial", 11, true)]';
 put '[alignment(7)]'; /* Center across selection.*/
 put '[select("r4c1:r12c7")]';
 /* BORDER(outline, left, right, top, bottom, shade, outline_color, left_color, right_color, top_color, bottom_color)*/
 put '[border(5,,,,,,1)]'; 
 put '[select("r5c2:r12c2")]';
 put '[border(,1,1,1,,,1)]'; /* blue border */
 put '[Save()]';
 put '[File.Close()]';
run;

%put Worksheet has been saved;

data _null_; file EXCEL;
 put "[Quit()]";
run;

/* Clean up filerefs */
filename EXCEL clear;
