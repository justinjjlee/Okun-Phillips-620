## Functions to pull GeoFRED data
function fred_api_buildstr(series, apikey, date)
    url = "https://api.stlouisfed.org/geofred/series/data?"
    url = url * "series_id=$(series)&"; # Add series name
    url = url * "api_key=$(apikey)&"; # Add your API key
    url = url * "file_type=json&date=$(date)" # add file type and date
    return url
end

function fred_json_df(json_str, date_str)
    # Clean Fred specific JSON file to DataFrame of state level
    json_mat = JSON.parse(json_str);                          # Parse out json format.
    json_mat = json_mat["meta"]["data"][date_str]             # Pull data
    res_mat = DataFrame();
    for i = 1:length(json_mat)
        if i == 1
            res_mat = DataFrame(json_mat[i])
        end
        res_mat = vcat(res_mat, DataFrame(json_mat[i]));
    end
    res_mat["code"] = parse.(Float64, res_mat["code"])
    res_mat["value"] = parse.(Float64, res_mat["value"])
    return res_mat
end

# Unemployment, leveraging cal as the index, ***************************************************
unemp_map = "CAUR"

# Unemployment, baseline (2020 January) --------------------------------------------------------
# API request address build.
idx_url = fred_api_buildstr(unemp_map, my_api_key, date_baseline)
# API request
unemp_mapdata = HTTP.request("GET", idx_url);
unemp_mapdata = String(unemp_mapdata.body);
# Clean up data
map_data_unemp_start = fred_json_df(unemp_mapdata, date_baseline_txt)
# Unemployment, latest -------------------------------------------------------------------------
# API request address build.
idx_url = fred_api_buildstr(unemp_map, my_api_key, date_last)
# API request
unemp_mapdata = HTTP.request("GET", idx_url);
unemp_mapdata = String(unemp_mapdata.body);
# Clean up data
map_data_unemp_end = fred_json_df(unemp_mapdata, date_last_txt)

# Calculate the difference ---------------------------------------------------------------------
map_data_unemp = leftjoin(map_data_unemp_start, map_data_unemp_end,
                            on = :region, makeunique = true
                        );
map_data_unemp["Recovery"] = map_data_unemp["value_1"] - map_data_unemp["value"];

# Map the difference
map_unemp = @vlplot(
    :geoshape,
    width=500, height=300,
    data={
        values=us10m,
        format={
            type=:topojson,
            feature=:states
        }
    },
    transform=[{
        lookup=:id,
        from={
            data=map_data_unemp,
            key=:code,
            fields=["Recovery"]
        }
    }],
    projection={
        type=:albersUsa
    },
    color= {
        "Recovery:q",
        legend = {
            title = "$(date_last_txt)"
        }

    },
    title = "Percentage point change in unemployment rate since $(date_baseline_txt)",
    config = {
        view = {
            stroke = "transparent"
        }     
    }
)
VegaLite.save("map_unempdel.svg", map_unemp)

# Labor force participation rate, leveraging cal as the index, *********************************
lfptc_map = "LBSSA06"

# Labor force participation rate, baseline (2020 January) --------------------------------------
# API request address build.
idx_url = fred_api_buildstr(lfptc_map, my_api_key, date_baseline)
# API request
lfptc_mapdata = HTTP.request("GET", idx_url);
lfptc_mapdata = String(lfptc_mapdata.body);
# Clean up data
map_data_lfptc_start = fred_json_df(lfptc_mapdata, date_baseline_txt)
# Labor force participation rate, latest -------------------------------------------------------
# API request address build.
idx_url = fred_api_buildstr(lfptc_map, my_api_key, date_last)
# API request
lfptc_mapdata = HTTP.request("GET", idx_url);
lfptc_mapdata = String(lfptc_mapdata.body);
# Clean up data
map_data_lfptc_end = fred_json_df(lfptc_mapdata, date_last_txt)

# Calculate the difference ---------------------------------------------------------------------
map_data_lfptc = leftjoin(map_data_lfptc_start, map_data_lfptc_end,
                            on = :region, makeunique = true
                        );
map_data_lfptc["Recovery"] = map_data_lfptc["value_1"] - map_data_lfptc["value"];

# Map the difference
map_lfptc = @vlplot(
    :geoshape,
    width=500, height=300,
    data={
        values=us10m,
        format={
            type=:topojson,
            feature=:states
        }
    },
    transform=[{
        lookup=:id,
        from={
            data=map_data_lfptc,
            key=:code,
            fields=["Recovery"]
        }
    }],
    projection={
        type=:albersUsa
    },
    color= {
        bin = true,
        field = "Recovery",
        legend = {
            title = "$(date_last_txt)"
        }
    },
    title = "Percentage point change in labor force participation rate since $(date_baseline_txt)",
    config = {
        view = {
            stroke = "transparent"
        }     
    }
)
VegaLite.save("map_lfptcdel.svg", map_lfptc)