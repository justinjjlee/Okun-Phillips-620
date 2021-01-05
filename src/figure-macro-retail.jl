# (4) Retail sales, excl. food services
retail08 = get_data(api_fred, "RSXFS"; observation_start = "2008-06-01", observation_end = "2011-03-01")
retail20 = get_data(api_fred, "RSXFS"; observation_start = "2020-02-01")

idx08 = retail08.data[1, :value]
retail08.data[:, :value] = retail08.data[:, :value] ./ idx08 * 100

idx20 = retail20.data[1, :value]
retail20.data[:, :value] = retail20.data[:, :value] ./ idx20 * 100

len08 = length(retail08.data[:, :value])
len20 = length(retail20.data[:, :value])

plot_retail08 = layer(retail08.data, x = 1:len08, y = :value, Geom.line, Theme(default_color=colorant"red"));
plot_retail20 = layer(retail20.data, x = 1:len20, y = :value, Geom.line, Theme(default_color=colorant"deepskyblue"));
plt_retail = plot(plot_retail08, plot_retail20,
        Guide.manual_color_key("Retail sales, excluding food services", 
                                ["2008 Recession", 
                                 "2020 Pandemic ($(maximum(retail20.data[:date])): $(round(last(retail20.data[:value]), digits = 1)))"], 
                                ["red", "deepskyblue"],
                                pos = [0.13w,0.38h]
                               ),
         Guide.xlabel("Month(s) since the start of the recession"), Guide.ylabel("Index (100: pre-decline peak)"), 
         Coord.cartesian(xmin=1, xmax=len08)
    )    
pngout = SVG("plt_retail.svg", 5inch, 4inch)
draw(pngout, plt_retail)