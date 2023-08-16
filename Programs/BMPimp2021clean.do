* BMP implementation data from CBPO
* Split out the County and state variable
clear
global BMPData "C:\Users\pwalsh01\OneDrive - Environmental Protection Agency (EPA)\Documents\EPA2\Water\Ches Bay EJ\Data\BMP\"
import excel "${BMPData}C19 2021 Progress BMP Summary 20230414.xlsx", sheet("Sheet1") firstrow clear
rename County CountyState 
split CountyState, p(", ")
rename CountyState1 County
rename CountyState2 State
drop ScenarioName

* There are 197 observations of each. 
* 112 different BMPs. 
* Fuck. Need to create a Varname for each...






