# Food insecurity data from Census Household Pulse Survey =================================================
# NOTE: Percentage calculated from Table 2.b of each period (Week 1 pre-COVID, Week 12, and Week 20)
#       https://www.census.gov/programs-surveys/household-pulse-survey/data.html
#   Percentage calculation of total household with children
df_hps = DataFrame();
df_hps[:Time]   = ["Pre-pandemic", "Pre-pandemic", "Jul. 16 - Jul. 21", "Jul. 16 - Jul. 21", "Nov. 25 - Dec. 7", "Nov. 25 - Dec. 7"];
df_hps[:Income] = ["Less than \$25,000", "\$25,000 - \$34,999", "Less than \$25,000", "\$25,000 - \$34,999", "Less than \$25,000", "\$25,000 - \$34,999"];
df_hps[:value]  = [27.141, 19.324, 30.738, 20.408, 31.511, 22.957];

plt_hps = plot(df_hps, x="Time", y="value", color="Income", Geom.line,
    Guide.colorkey(title="Annual income"
    ),
    Guide.xlabel("Survey period (2020 Calendar year)"), Guide.ylabel("Household with food shortage, percent"), 
)
pngout = SVG("plt_hps.svg", 5inch, 4inch)
draw(pngout, plt_hps)