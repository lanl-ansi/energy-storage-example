
colors = c("dodgerblue", "darkorange", "forestgreen", "darkslateblue",
    "firebrick1", "blue3", "darkorange4", "darkgreen", "dodgerblue4",
    "firebrick4", "lightblue1")

data_file = "ac.csv"

data_dc = read.csv(data_file, header=TRUE, sep=",")
data_dc$time = as.POSIXct(data_dc$time, format="%H:%M:%S")

print(data_dc)

file_name = gsub(".csv", "-power.pdf", data_file)
pdf(file_name, pointsize=14, width=8, height=5)
    xlim = range(data_dc$time)
    ylim = c(min(data_dc$ps), max(data_dc$pd))

    plot(xlim, ylim, type="n", xlab="Time", ylab="Power (MW)", main="Title")
    points(data_dc$time, data_dc$pg, type="l", col=colors[1])
    points(data_dc$time, data_dc$pd, type="l", col=colors[2])
    points(data_dc$time, data_dc$ps, type="l", col=colors[3])
    #legend("topleft", leg=display_names, fill=colors[1:3], bg="white")
dev.off()


file_name = gsub(".csv", "-charge.pdf", data_file)
pdf(file_name, pointsize=14, width=8, height=5)
    xlim = range(data_dc$time)
    ylim = range(data_dc$se)

    plot(xlim, ylim, type="n", xlab="Time", ylab="Energy (MWh)", main="Title")
    points(data_dc$time, data_dc$se, type="l", col=colors[4])
    #legend("topleft", leg=display_names, fill=colors[1:3], bg="white")
dev.off()