# (7) Labor market specific industry =======================================================================
nvcasino08 = get_data(api_fred, "NVLEIH"; units="pc1", observation_start = "2008-06-01", observation_end = "2011-03-01")
nvcasino20 = get_data(api_fred, "NVLEIH"; units="pc1", observation_start = "2020-02-01")

txoil08 = get_data(api_fred, "SMU48000001021000001SA"; units="pc1", observation_start = "2008-06-01", observation_end = "2011-03-01")
txoil20 = get_data(api_fred, "SMU48000001021000001SA"; units="pc1", observation_start = "2020-02-01")

# Date index, just need one, same data source.
len08 = length(nvcasino08.data[:, :value])
len20 = length(nvcasino20.data[:, :value])

plot_nvcasino08 = layer(nvcasino08.data, x = 1:len08, y = :value, Geom.line, 
                        Theme(default_color=colorant"red", line_style = [:dash])
                    );
plot_nvcasino20 = layer(nvcasino20.data, x = 1:len20, y = :value, Geom.line, 
                        Theme(default_color=colorant"red", line_style = [:solid])
                    );
plot_txoil08 = layer(txoil08.data, x = 1:len08, y = :value, Geom.line, 
                    Theme(default_color=colorant"deepskyblue", line_style = [:dash])
                );
plot_txoil20 = layer(txoil20.data, x = 1:len20, y = :value, Geom.line, 
                    Theme(default_color=colorant"deepskyblue", line_style = [:solid])
                );
plt_emplystate = plot(plot_nvcasino08, plot_nvcasino20, plot_txoil08, plot_txoil20,
        Guide.manual_color_key("Employment by state: industry", 
                                ["Nevada: Leisure and hospitality", 
                                 "Texas: Oil and gas", 
                                 ], 
                                ["red", "deepskyblue"],
                                pos = [0.13w,0.38h]
                               ),
         Guide.xlabel("Month(s) since the start of the recession"), Guide.ylabel("Year over year growth, percent"), 
         Coord.cartesian(xmin=1, xmax=len08),
         Guide.annotation(compose(context(), Compose.text(22, 16, "Dash - 2008 Recession"))),
         Guide.annotation(compose(context(), Compose.text(9, -30, "Solid - 2020 Pandemic")))
    )    
pngout = SVG("plt_emplystate.svg", 5inch, 4inch)
draw(pngout, plt_emplystate)