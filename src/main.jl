using Pkg
using FredData, HTTP, DataFrames, JSON, Dates;
using Gadfly, Cairo, Compose, VegaLite, VegaDatasets
using CSV

cd(@__DIR__)
cd("C:\\Users\\justin_lee\\Desktop\\src")
# Add Fred API key: 
my_api_key = "-------------------------- USE YOUR FRED API KEY HERE --------------------------"
api_fred = Fred(my_api_key);

# Specific date for mapping
date_last = "2020-11-01"; date_last_txt = "2020 November";
date_baseline = "2020-01-01"; date_baseline_txt = "2020 January";

us10m = dataset("us-10m") # Guide map tool


# (1) GDP and Weekly economic index by Lewis-Mertens-Stock =====================================================
include("srcfigure-macro-output.jl");
# (2) Wage and labor force participation =======================================================================
include("figure-macro-labor-wagelabour.jl");
# (3) Unemployment and part time emp for econ reason ==========================================================
include("figure-macro-labor-unemp.jl");
# (4) Retail sales, excl. food services =======================================================================
include("figure-macro-retail.jl");
# (5) Maps - state level labor force particiaption and unemployment since 2020 January ========================
include("figure-macro-labor-maps.jl");
# (6) State-level employment - Texas & Nevada =================================================================
include("figure-macro-labor-state-industrytxnv.jl");
# (7) Census - Household Pulse Survey plotting calculation ====================================================
include("figure-micro-census-foodinseq.jl");