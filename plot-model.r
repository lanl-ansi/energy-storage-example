
colors = c("dodgerblue", "darkorange", "forestgreen", "darkslateblue",
    "firebrick1", "blue3", "darkorange4", "darkgreen", "dodgerblue4",
    "firebrick4", "lightblue1")

data_ac_ns = read.csv("ac-ns.csv", header=TRUE, sep=",")
data_ac_ns$time = as.POSIXct(data_ac_ns$time, format="%H:%M:%S")

data_ac = read.csv("ac.csv", header=TRUE, sep=",")
#data_ac = read.csv("soc.csv", header=TRUE, sep=",")
data_ac$time = as.POSIXct(data_ac$time, format="%H:%M:%S")

data_soc = read.csv("soc.csv", header=TRUE, sep=",")
data_soc$time = as.POSIXct(data_soc$time, format="%H:%M:%S")

data_dc = read.csv("dc.csv", header=TRUE, sep=",")
data_dc$time = as.POSIXct(data_dc$time, format="%H:%M:%S")


file_name = "ac-power.pdf"
pdf(file_name, pointsize=12, width=8, height=5)
    xlim = range(data_ac$time)
    ylim = c(min(data_ac$ps), max(data_ac_ns$pg))

    #plot(xlim, 100*ylim, type="n", xlab="Time", ylab="Active Power Dispatch (MW)", main="Impacts of Storage on AC-OPF")
    plot(xlim, 100*ylim, type="n", xlab="Time", ylab="Active Power Dispatch (MW)")
    points(data_ac$time, 100*data_ac_ns$pg, type="l", lwd=2, col=rgb(0,0,0,0.5), lty=11)
    points(data_ac$time, 100*data_ac$pg, type="l", lwd=2, col=colors[1])
    points(data_ac$time, 100*data_ac$pd, type="l", lwd=2, col=colors[2])
    points(data_ac$time, 100*data_ac$ps, type="l", lwd=2, col=colors[3])
    abline(h=0, col=rgb(0,0,0,0.33), lty=1, lwd=1)
    legend("right", legend=c("Gen. w/o Storage", "Generation", "Load", "Storage"), col=c(rgb(0,0,0,0.33),colors[1],colors[2],colors[3]), lty=c(2,1,1,1), lwd=2, bg="white")
dev.off()


file_name = "storage-comp.pdf"
pdf(file_name, pointsize=12, width=8, height=5)
    xlim = range(data_dc$time)
    ylim = c(min(data_dc$ps), max(data_dc$ps))

    #plot(xlim, 100*ylim, type="n", xlab="Time", ylab="Power (MW)", main="Storage Dispatch in Different Power Models")
    plot(xlim, 100*ylim, type="n", xlab="Time", ylab="Active Power Dispatch (MW)")
    points(data_ac$time, 100*data_ac$ps, type="l", lwd=2, col=colors[3])
    points(data_soc$time, 100*data_soc$ps, type="l", lwd=2, col=colors[2])
    points(data_dc$time, 100*data_dc$ps, type="l", lwd=2, col=colors[1])
    abline(h=0, col=rgb(0,0,0,0.33), lty=1, lwd=1)
    legend("topright", legend=c("AC", "SOC", "DC"), col=c(colors[3],colors[2],colors[1]), lwd=2, bg="white")
dev.off()


file_name = "charge-comp.pdf"
pdf(file_name, pointsize=12, width=8, height=5)
    xlim = range(data_dc$time)
    ylim = range(data_dc$se)

    #plot(xlim, 100*ylim, type="n", xlab="Time", ylab="Energy (MWh)", main="Title")
    plot(xlim, 100*ylim, type="n", xlab="Time", ylab="Energy State (MWh)")
    points(data_ac$time, 100*data_ac$se, type="l", lwd=2, col=colors[3])
    points(data_soc$time, 100*data_soc$se, type="l", lwd=2, col=colors[2])
    points(data_dc$time, 100*data_dc$se, type="l", lwd=2, col=colors[1])
    #legend("topleft", leg=display_names, fill=colors[1:3], bg="white")
dev.off()