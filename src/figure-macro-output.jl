# (1) GDP and Weekly economic index by Lewis-Mertens-Stock 
gdpus = get_data(api_fred, "GDPC1"; units="pc1", frequency = "q", observation_start = "2008-01-01")
weius = get_data(api_fred, "WEI")

plot_wei = layer(weius.data, x = :date, y = :value, Geom.line, Theme(default_color=colorant"red"),
    xintercept = [Date("2020-02-08")], Geom.vline(color = "black", style=[[1mm,1mm]])
    );
plot_gdpus = layer(gdpus.data, x = :date, y = :value, Geom.line, Theme(default_color=colorant"deepskyblue"),
    xintercept = [Date("2008-09-01")], Geom.vline(color = "grey", size=[10.5mm])
    );
plt_output = plot(plot_wei, plot_gdpus,
        Guide.manual_color_key("Economic output", 
                                ["Weekly Economic Index (Lewis-Mertens-Stock)", 
                                 "Real U.S. GDP (vintage: $(maximum(gdpus.data[:realtime_end])))"], 
                                ["red", "deepskyblue"],
                                pos = [0.13w,0.28h]
                               ),
         Guide.xlabel("Time"), Guide.ylabel("Output change from a year ago, percent"), 
        Coord.cartesian(xmin=minimum(weius.data[:date]), xmax=maxvalue=maximum(weius.data[:date])),
        Scale.x_continuous(minvalue=minimum(weius.data[:date]), maxvalue=maximum(weius.data[:date]))
    )       
pngout = SVG("plt_output.svg", 5inch, 4inch)
draw(pngout, plt_output)