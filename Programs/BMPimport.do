/* Title: BMPimport.do
   Author: Patrick Walsh
   Date Created: 4/27/23
   Date Updated: 
   Purpose: This file imports the BMP data, assigns names, pivots wide, and 
        then exports for R. 

*/

global DataBMP "C:\Users\pwalsh01\OneDrive - Environmental Protection Agency (EPA)\Documents\EPA2\Water\Ches Bay EJ\Data\BMP\"
clear
import excel "${DataBMP}C19 2021 Progress BMP Summary 20230414.xlsx", sheet("Sheet1") firstrow
* Deal with naming. 
gen BMPshort ="AbandonMineRecl" if BmpSummaryBmp == "Abandoned Mine Reclamation"
replace BMPshort ="AgStrmwatMgt" if BmpSummaryBmp == "Ag Stormwater Management"
replace BMPshort ="AgriculturalCons" if BmpSummaryBmp == "Agricultural Conservation"
replace BMPshort ="AgDrainageMgt" if BmpSummaryBmp == "Agricultural Drainage Management"
replace BMPshort ="AlternativeCrops" if BmpSummaryBmp == "Alternative Crops"
replace BMPshort ="AmniaEmisRdceBiofilt" if BmpSummaryBmp == "Ammonia Emission Reductions (Biofilters)"
replace BMPshort ="AmniaEmisRdceLagnCov" if BmpSummaryBmp == "Ammonia Emission Reductions (Lagoon Covers)"
replace BMPshort ="AmniaEmisRedLitAmd" if BmpSummaryBmp == "Ammonia Emission Reductions (Litter Amendments)"
replace BMPshort ="BarnyardRunoffControl" if BmpSummaryBmp == "Barnyard Runoff Control"
replace BMPshort ="BioRetention" if BmpSummaryBmp == "BioRetention"
replace BMPshort ="BioSwale" if BmpSummaryBmp == "BioSwale"
replace BMPshort ="BroilerMortltyFrzrs" if BmpSummaryBmp == "Broiler Mortality Freezers"
replace BMPshort ="CaptureAndReuse" if BmpSummaryBmp == "Capture & Reuse"
replace BMPshort ="CmdityANDCoverCrop" if BmpSummaryBmp == "Commodity + Cover Crop"
replace BMPshort ="CommodityCoverCrop" if BmpSummaryBmp == "Commodity Cover Crop"
replace BMPshort ="ConsvLowRsidHighResTill" if BmpSummaryBmp == "Conservation + LowResidue + High Residue Tillage"
replace BMPshort ="ConsLandscPract" if BmpSummaryBmp == "Conservation Landscaping Practices"
replace BMPshort ="ConservationTillage" if BmpSummaryBmp == "Conservation Tillage"
replace BMPshort ="CoverCrop" if BmpSummaryBmp == "Cover Crop"
replace BMPshort ="CoverCropwithFallNutr" if BmpSummaryBmp == "Cover Crop with Fall Nutrients"
replace BMPshort ="CropIrrigationMgt" if BmpSummaryBmp == "Crop Irrigation Management"
replace BMPshort ="DCPolicy" if BmpSummaryBmp == "DC Policy"
replace BMPshort ="DairyPrecisionFeeding" if BmpSummaryBmp == "Dairy Precision Feeding"
replace BMPshort ="DelawarePolicy" if BmpSummaryBmp == "Delaware Policy"
replace BMPshort ="DirtandGravelRoadES" if BmpSummaryBmp == "Dirt&Gravel Road E&S"
replace BMPshort ="DryPonds" if BmpSummaryBmp == "Dry Ponds"
replace BMPshort ="ErosionSedimentControl" if BmpSummaryBmp == "Erosion and Sediment Control"
replace BMPshort ="ExtendedDryPonds" if BmpSummaryBmp == "Extended Dry Ponds"
replace BMPshort ="FilteringPractices" if BmpSummaryBmp == "Filtering Practices"
replace BMPshort ="FloatingTreatWetland" if BmpSummaryBmp == "Floating Treatment Wetlands"
replace BMPshort ="ForestBuffers" if BmpSummaryBmp == "Forest Buffers"
replace BMPshort ="ForestBuffOnFncdPastCor" if BmpSummaryBmp == "Forest Buffers on Fenced Pasture Corridor"
replace BMPshort ="ForestConservation" if BmpSummaryBmp == "Forest Conservation"
replace BMPshort ="ForestHarvestingPract" if BmpSummaryBmp == "Forest Harvesting Practices"
replace BMPshort ="GrassBuffers" if BmpSummaryBmp == "Grass Buffers"
replace BMPshort ="GrassBufonFncPasCorr" if BmpSummaryBmp == "Grass Buffers on Fenced Pasture Corridor"
replace BMPshort ="GreyInfNutrDischElim" if BmpSummaryBmp == "Grey Infrastructure Nutrient Discharge Elimination"
replace BMPshort ="GreyInfNutrDscvyProg" if BmpSummaryBmp == "Grey Infrastructure Nutrient Discovery Program"
replace BMPshort ="GrowthManagement" if BmpSummaryBmp == "Growth Management"
replace BMPshort ="HighResidueTillage" if BmpSummaryBmp == "High Residue Tillage"
replace BMPshort ="HorsePastureMgt" if BmpSummaryBmp == "Horse Pasture Management"
replace BMPshort ="ImpervDisconnect" if BmpSummaryBmp == "Impervious Disconnection"
replace BMPshort ="ImpervSurfReduction" if BmpSummaryBmp == "Impervious Surface Reduction"
replace BMPshort ="InfiltrationPractices" if BmpSummaryBmp == "Infiltration Practices"
replace BMPshort ="LandRetireToOpenSpace" if BmpSummaryBmp == "Land Retirement to Open Space"
replace BMPshort ="LandRetirementToPast" if BmpSummaryBmp == "Land Retirement to Pasture"
replace BMPshort ="LivstkPoultWstManSys" if BmpSummaryBmp == "Livestock + Poultry Waste Management Systems"
replace BMPshort ="LvstkMrtltyCompost" if BmpSummaryBmp == "Livestock Mortality Composting"
replace BMPshort ="LivestockWasteManSys" if BmpSummaryBmp == "Livestock Waste Management Systems"
replace BMPshort ="LoafingLotMgt" if BmpSummaryBmp == "Loafing Lot Management"
replace BMPshort ="LowResidueTill" if BmpSummaryBmp == "Low Residue Tillage"
replace BMPshort ="ManureIncorp" if BmpSummaryBmp == "Manure Incorporation"
replace BMPshort ="MnurTransIntoArea" if BmpSummaryBmp == "Manure Transport Into Area"
replace BMPshort ="MnurTransOutOfArea" if BmpSummaryBmp == "Manure Transport Out Of Area"
replace BMPshort ="MnurTreatTechIntoArea" if BmpSummaryBmp == "Manure Treatment Technologies Into Area"
replace BMPshort ="MnurTreatTechOut" if BmpSummaryBmp == "Manure Treatment Technologies Out Of Area"
replace BMPshort ="MarylandActions" if BmpSummaryBmp == "Maryland Actions"
replace BMPshort ="MarylandPolicy" if BmpSummaryBmp == "Maryland Policy"
replace BMPshort ="NarrowForestBuffers" if BmpSummaryBmp == "Narrow Forest Buffers"
replace BMPshort ="NarrForBuffsFncPasCor" if BmpSummaryBmp == "Narrow Forest Buffers on Fenced Pasture Corridor"
replace BMPshort ="NarrowGrassBuffers" if BmpSummaryBmp == "Narrow Grass Buffers"
replace BMPshort ="NarrGrsBufsFncPastCor" if BmpSummaryBmp == "Narrow Grass Buffers on Fenced Pasture Corridor"
replace BMPshort ="NonUrbShoreMgt" if BmpSummaryBmp == "Non Urban Shoreline Management"
replace BMPshort ="NonUrbStrmRest" if BmpSummaryBmp == "Non Urban Stream Restoration"
replace BMPshort ="NonTidalAlglFlowway" if BmpSummaryBmp == "Non-Tidal Algal Flow-way"
replace BMPshort ="NutrAppMgtCoreNitr" if BmpSummaryBmp == "Nutrient Application Management Core Nitrogen"
replace BMPshort ="NutrAppMgtCorePhos" if BmpSummaryBmp == "Nutrient Application Management Core Phosphorus"
replace BMPshort ="NutrAppMgtPlaceNitr" if BmpSummaryBmp == "Nutrient Application Management Placement Nitrogen"
replace BMPshort ="NutrAppMgtPlacePhos" if BmpSummaryBmp == "Nutrient Application Management Placement Phosphorus"
replace BMPshort ="NutrAppMgtRateNitr" if BmpSummaryBmp == "Nutrient Application Management Rate Nitrogen"
replace BMPshort ="NutrAppMgtRatePhos" if BmpSummaryBmp == "Nutrient Application Management Rate Phosphorus"
replace BMPshort ="NutrAppMgtTmngNitr" if BmpSummaryBmp == "Nutrient Application Management Timing Nitrogen"
replace BMPshort ="NutrAppMgtTmngPhos" if BmpSummaryBmp == "Nutrient Application Management Timing Phosphorus"
replace BMPshort ="OysterAquaculture" if BmpSummaryBmp == "Oyster Aquaculture"
replace BMPshort ="OysterReefRestoration" if BmpSummaryBmp == "Oyster Reef Restoration"
replace BMPshort ="PastureAltWatering" if BmpSummaryBmp == "Pasture Alternative Watering"
replace BMPshort ="PastureMgtCmposite" if BmpSummaryBmp == "Pasture Management Composite"
replace BMPshort ="PennsylvaniaPolicy" if BmpSummaryBmp == "Pennsylvania Policy"
replace BMPshort ="PermeablePavement" if BmpSummaryBmp == "Permeable Pavement"
replace BMPshort ="PoultryMrtltyCompost" if BmpSummaryBmp == "Poultry Mortality Composting"
replace BMPshort ="PoultryWsteMgtSyst" if BmpSummaryBmp == "Poultry Waste Management Systems"
replace BMPshort ="PrescribedGrazing" if BmpSummaryBmp == "Prescribed Grazing"
replace BMPshort ="RunoffRedPerfStd" if BmpSummaryBmp == "Runoff Reduction Performance Standard"
replace BMPshort ="SepticConnections" if BmpSummaryBmp == "Septic Connections"
replace BMPshort ="SepticDenitrification" if BmpSummaryBmp == "Septic Denitrification"
replace BMPshort ="SepticEffluent" if BmpSummaryBmp == "Septic Effluent"
replace BMPshort ="SepticPumping" if BmpSummaryBmp == "Septic Pumping"
replace BMPshort ="SepticScdryTreat" if BmpSummaryBmp == "Septic Secondary Treatment"
replace BMPshort ="SoilWaterConsPlan" if BmpSummaryBmp == "Soil and Water Conservation Plan"
replace BMPshort ="StormDrainCleanout" if BmpSummaryBmp == "Storm Drain Cleanout"
replace BMPshort ="StrmWatTrtPrfStd" if BmpSummaryBmp == "Storm Water Treatment Performance Standard"
replace BMPshort ="StrmwatMgtCmpsit" if BmpSummaryBmp == "Stormwater Management Composite"
replace BMPshort ="StreetSweeping" if BmpSummaryBmp == "Street Sweeping"
replace BMPshort ="TidalAlgalFlowway" if BmpSummaryBmp == "Tidal Algal Flow-way"
replace BMPshort ="TotalForestBuffers" if BmpSummaryBmp == "Total Forest Buffers"
replace BMPshort ="TotalGrassBuffers" if BmpSummaryBmp == "Total Grass Buffers"
replace BMPshort ="TreePlanting" if BmpSummaryBmp == "Tree Planting"
replace BMPshort ="UrbanFilterStrips" if BmpSummaryBmp == "Urban Filter Strips"
replace BMPshort ="UrbanForestBuffers" if BmpSummaryBmp == "Urban Forest Buffers"
replace BMPshort ="UrbanForestPlanting" if BmpSummaryBmp == "Urban Forest Planting"
replace BMPshort ="UrbanGrassBuffers" if BmpSummaryBmp == "Urban Grass Buffers"
replace BMPshort ="UrbanNutrMgt" if BmpSummaryBmp == "Urban Nutrient Management"
replace BMPshort ="UrbanShoreMgt" if BmpSummaryBmp == "Urban Shoreline Management"
replace BMPshort ="UrbanStreamRest" if BmpSummaryBmp == "Urban Stream Restoration"
replace BMPshort ="UrbanTreePlanting" if BmpSummaryBmp == "Urban Tree Planting"
replace BMPshort ="VegOpenChannel" if BmpSummaryBmp == "Vegetated Open Channel"
replace BMPshort ="VirginiaPolicy" if BmpSummaryBmp == "Virginia Policy"
replace BMPshort ="WestVirginiaPolicy" if BmpSummaryBmp == "West Virginia Policy"
replace BMPshort ="WetPondsWetlands" if BmpSummaryBmp == "Wet Ponds & Wetlands"
replace BMPshort ="WetlandCreation" if BmpSummaryBmp == "Wetland Creation"
replace BMPshort ="WetlandRehab" if BmpSummaryBmp == "Wetland Rehabilitation"
replace BMPshort ="WetlandRestor" if BmpSummaryBmp == "Wetland Restoration"

drop BmpSummaryBmp ScenarioName Unit County

* Now for the reshape
destring FractionImplementation, replace force
rename FractionImplementation Impl
rename Credited Cred
reshape wide Cred Impl, i(FIPS) j(BMPshort) string

* Some of these don't have any observations. Get rid of
misstable summarize, showzeros
drop CredBroilerMortltyFrzrs ImplBroilerMortltyFrzrs CredGreyInfNutrDischElim ImplGreyInfNutrDischElim CredGreyInfNutrDscvyProg ImplGreyInfNutrDscvyProg
drop CredMnurTreatTechIntoArea ImplMnurTreatTechIntoArea CredNonTidalAlglFlowway ImplNonTidalAlglFlowway CredStormDrainCleanout ImplStormDrainCleanout
drop CredMnurTreatTechOut ImplMnurTreatTechOut CredOysterReefRestoration ImplOysterReefRestoration CredTidalAlgalFlowway ImplTidalAlgalFlowway


* with ImplDirtandGravelRoadES CredDirtandGravelRoadES, why are there entries
* for credited but not implemented?
* same with all of these:
drop ImplDirtandGravelRoadES CredDirtandGravelRoadES CredMnurTransIntoArea ImplMnurTransIntoArea CredMnurTransOutOfArea ImplMnurTransOutOfArea
* With this one especially, there are a bunch in the credited area... why no implementation?
drop CredOysterAquaculture ImplOysterAquaculture

* Save and export
save "${DataBMP}BMPImplemented2021.dta", replace
export delimited using "${DataBMP}BMPImplemented2021.csv", replace

