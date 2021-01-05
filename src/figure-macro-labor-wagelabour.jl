# (2) Wage and labor force participation 
labfpus = get_data(api_fred, "CIVPART"; units = "ch1", observation_start = "2008-01-01")
wageus = get_data(api_fred, "ECIWAG"; units = "ch1", observation_start = "2008-01-01")

plot_unempus = layer(labfpus.data, x = :date, y = :value, Geom.line, Theme(default_color=colorant"red"),
    xintercept = [Date("2020-02-08")], Geom.vline(color = "black", style=[[1mm,1mm]])
    );
plot_ptempus = layer(wageus.data, x = :date, y = :value, Geom.line, Theme(default_color=colorant"deepskyblue"),
    xintercept = [Date("2008-09-01")], Geom.vline(color = "grey", size=[10.5mm])
    );
plt_labour0 = plot(plot_unempus, plot_ptempus,
        Guide.manual_color_key("Labor market", 
                                ["Labor force participation rate ($(maximum(labfpus.data[:date])): $(round(last(labfpus.data[:value]), digits = 1)))", 
                                 "Employment cost - wage and salary ($(maximum(wageus.data[:date])): $(round(last(wageus.data[:value]), digits = 1)))"], 
                                ["red", "deepskyblue"],
                                pos = [0.2w,0.38h]
                               ),
         Guide.xlabel("Time"), Guide.ylabel("Change from a year ago, percent"), 
        Coord.cartesian(xmin=minimum(weius.data[:date]), xmax=maxvalue=maximum(weius.data[:date])),
        Scale.x_continuous(minvalue=minimum(weius.data[:date]), maxvalue=maximum(weius.data[:date]))
    )       
pngout = SVG("plt_labour0.svg", 5inch, 4inch)
draw(pngout, plt_labour0)