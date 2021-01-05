# (3) Unemployment and part time emp for econ reason
unempus = get_data(api_fred, "UNEMPLOY"; observation_start = "2008-01-01")
ptempus = get_data(api_fred, "LNS12032194"; observation_start = "2008-01-01")

#Adjust scale to millions of Persons
unempus.data[:value] = unempus.data[:value]./1000;
ptempus.data[:value] = ptempus.data[:value]./1000;

plot_unempus = layer(unempus.data, x = :date, y = :value, Geom.line, Theme(default_color=colorant"red"),
    xintercept = [Date("2020-02-08")], Geom.vline(color = "black", style=[[1mm,1mm]])
    );
plot_ptempus = layer(ptempus.data, x = :date, y = :value, Geom.line, Theme(default_color=colorant"deepskyblue"),
    xintercept = [Date("2008-09-01")], Geom.vline(color = "grey", size=[10.5mm])
    );
plt_labour1 = plot(plot_unempus, plot_ptempus,
        Guide.manual_color_key("Labor market", 
                                ["Unemployment level ($(maximum(unempus.data[:date])): $(round(last(unempus.data[:value]), digits = 1)))", 
                                 "Employment: Part-time, economic reasons ($(maximum(ptempus.data[:date])): $(round(last(ptempus.data[:value]), digits = 1)))"], 
                                ["red", "deepskyblue"],
                                pos = [0.13w,0.38h]
                               ),
         Guide.xlabel("Time"), Guide.ylabel("Millions of Persons"), 
        Coord.cartesian(xmin=minimum(weius.data[:date]), xmax=maxvalue=maximum(weius.data[:date])),
        Scale.x_continuous(minvalue=minimum(weius.data[:date]), maxvalue=maximum(weius.data[:date]))
    )       
pngout = SVG("plt_labour1.svg", 5inch, 4inch)
draw(pngout, plt_labour1)