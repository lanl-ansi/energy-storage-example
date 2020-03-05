
colors = c("dodgerblue", "darkorange", "forestgreen", "darkslateblue",
    "firebrick1", "blue3", "darkorange4", "darkgreen", "dodgerblue4",
    "firebrick4", "lightblue1")

data_ac = read.csv("ac.csv", header=TRUE, sep=",")
#data_ac = read.csv("soc.csv", header=TRUE, sep=",")
data_ac$time = as.POSIXct(data_ac$time, format="%H:%M:%S")

data_ac_3p = read.csv("ac-3p.csv", header=TRUE, sep=",")
data_ac_3p$time = as.POSIXct(data_ac_3p$time, format="%H:%M:%S")


file_name = "ac-3p-power.pdf"
pdf(file_name, pointsize=12, width=8, height=5)
    xlim = range(data_ac$time)
    ylim = c(min(data_ac_3p$ps_3), max(data_ac_3p$pd_1))

    #plot(xlim, 100*ylim, type="n", xlab="Time", ylab="Active Power Dispatch (MW)", main="Impacts of Storage on AC-OPF")
    plot(xlim, 100*ylim, type="n", xlab="Time", ylab="Active Power Dispatch (MW)")
    #points(data_ac$time, 100*data_ac_3p$pg_1, type="l", lwd=2, col=rgb(0,0,0,0.5), lty=11)
    points(data_ac_3p$time, 100*data_ac_3p$pg_1, type="l", lwd=2, col=colors[1], lty=4)
    points(data_ac_3p$time, 100*data_ac_3p$pg_2, type="l", lwd=2, col=colors[1], lty=1)
    points(data_ac_3p$time, 100*data_ac_3p$pg_3, type="l", lwd=2, col=colors[1], lty=6)

    points(data_ac_3p$time, 100*data_ac_3p$pd_1, type="l", lwd=2, col=colors[2], lty=4)
    points(data_ac_3p$time, 100*data_ac_3p$pd_2, type="l", lwd=2, col=colors[2], lty=1)
    points(data_ac_3p$time, 100*data_ac_3p$pd_3, type="l", lwd=2, col=colors[2], lty=6)

    points(data_ac_3p$time, 100*data_ac_3p$ps_1, type="l", lwd=2, col=colors[3], lty=4)
    points(data_ac_3p$time, 100*data_ac_3p$ps_2, type="l", lwd=2, col=colors[3], lty=1)
    points(data_ac_3p$time, 100*data_ac_3p$ps_3, type="l", lwd=2, col=colors[3], lty=6)

    #points(data_ac$time, 100*data_ac$ps, type="l", lwd=2, col=colors[3])
    abline(h=0, col=rgb(0,0,0,0.33), lty=1, lwd=1)
    #legend("right", legend=c("Gen. w/o Storage", "Generation", "Load", "Storage"), col=c(rgb(0,0,0,0.33),colors[1],colors[2],colors[3]), lty=c(2,1,1,1), lwd=2, bg="white")
dev.off()

#print(data_ac$pg)
#print(data_ac_3p$pg_1 + data_ac_3p$pg_2 + data_ac_3p$pg_3)

file_name = "ac-3p-generation-comp.pdf"
pdf(file_name, pointsize=12, width=8, height=5)
    xlim = range(data_ac$time)
    ylim = c(min(data_ac_3p$pg_3), max(data_ac$pg))

    #plot(xlim, 100*ylim, type="n", xlab="Time", ylab="Power (MW)", main="Storage Dispatch in Different Power Models")
    plot(xlim, 100*ylim, type="n", xlab="Time", ylab="Active Power Dispatch (MW)")
    points(data_ac$time, 100*data_ac$pg - 100*data_ac$ps, type="l", lwd=2, col=rgb(0,0,0,0.5), lty=11)
    points(data_ac$time, 100*data_ac$pd, type="l", lwd=2, col=colors[2])
    points(data_ac_3p$time, 100*data_ac_3p$pg_1, type="l", lwd=2, col=colors[3], lty=4)
    points(data_ac_3p$time, 100*data_ac_3p$pg_2, type="l", lwd=2, col=colors[3], lty=1)
    points(data_ac_3p$time, 100*data_ac_3p$pg_3, type="l", lwd=2, col=colors[3], lty=6)

    points(data_ac_3p$time, 100*(data_ac_3p$pg_1 + data_ac_3p$pg_2 + data_ac_3p$pg_3), type="l", lwd=2, col=colors[3])
    #points(data_ac_3p$time, 100*(data_ac_3p$pg_1 + data_ac_3p$pg_2 + data_ac_3p$pg_3 - data_ac_3p$ps_1 - data_ac_3p$ps_2 - data_ac_3p$ps_3), type="l", lwd=2, col=colors[3])

    #points(data_ac_3p$time, 100*(data_ac_3p$pd_1 + data_ac_3p$pd_2 + data_ac_3p$pd_3), type="l", lwd=2, col=colors[2])

    #abline(h=0, col=rgb(0,0,0,0.33), lty=1, lwd=1)
    #legend("topright", legend=c("AC", "SOC", "DC"), col=c(colors[3],colors[2],colors[1]), lwd=2, bg="white")
dev.off()


file_name = "ac-3p-storage-comp.pdf"
pdf(file_name, pointsize=12, width=8, height=5)
    xlim = range(data_ac$time)
    ylim = c(min(data_ac$ps/3), max(data_ac$ps/3))
    #ylim = c(min(data_ac_3p$ps_1), max(data_ac_3p$ps_3))

    #plot(xlim, 100*ylim, type="n", xlab="Time", ylab="Power (MW)", main="Storage Dispatch in Different Phase Models")
    plot(xlim, 100*ylim, type="n", xlab="Time", ylab="Active Power Dispatch (MW)")
    points(data_ac$time, 100*data_ac$ps/3, type="l", lwd=2, col=rgb(0,0,0,0.5), lty=11)
    points(data_ac_3p$time, 100*data_ac_3p$ps_1, type="l", lwd=2, col=colors[3], lty=4)
    points(data_ac_3p$time, 100*data_ac_3p$ps_2, type="l", lwd=2, col=colors[3], lty=1)
    points(data_ac_3p$time, 100*data_ac_3p$ps_3, type="l", lwd=2, col=colors[3], lty=6)

    abline(h=0, col=rgb(0,0,0,0.33), lty=1, lwd=1)
    legend("topright", legend=c("AC Single Phase (1/3)", "AC Three Phase A", "AC Three Phase B", "AC Three Phase C"), col=c(rgb(0,0,0,0.5), colors[3], colors[3], colors[3]), lty=c(11,4,1,6), lwd=2, bg="white")
dev.off()


file_name = "ac-3p-charge.pdf"
pdf(file_name, pointsize=12, width=8, height=5)
    xlim = range(data_ac$time)
    ylim = range(data_ac$se)

    #plot(xlim, 100*ylim, type="n", xlab="Time", ylab="Energy (MWh)", main="Storage State in Different Phase Models")
    plot(xlim, 100*ylim, type="n", xlab="Time", ylab="Energy State (MWh)")
    points(data_ac$time, 100*data_ac$se, type="l", lwd=2, col=rgb(0,0,0,0.5), lty=11)
    points(data_ac_3p$time, 100*data_ac_3p$se, type="l", lwd=2, col=colors[3])
    legend("topright", legend=c("AC Single Phase", "AC Three Phase"), col=c(rgb(0,0,0,0.5), colors[3]), lty=c(11,1), lwd=2, bg="white")
dev.off()



file_name = "ac-3p-storage-charge-comp.pdf"
pdf(file_name, pointsize=12, width=8, height=9)
    attach(mtcars)
    par(mfrow=c(2,1), mai=c(1, 1, 0.1, 0.1))

    xlim = range(data_ac$time)
    ylim = c(min(data_ac$ps/3), max(data_ac$ps/3))
    #ylim = c(min(data_ac_3p$ps_1), max(data_ac_3p$ps_3))

    plot(xlim, 100*ylim, type="n", xlab="", ylab="Active Power Dispatch (MW)")
    points(data_ac$time, 100*data_ac$ps/3, type="l", lwd=2, col=rgb(0,0,0,0.5), lty=11)
    points(data_ac_3p$time, 100*data_ac_3p$ps_1, type="l", lwd=2, col=colors[3], lty=4)
    points(data_ac_3p$time, 100*data_ac_3p$ps_2, type="l", lwd=2, col=colors[3], lty=1)
    points(data_ac_3p$time, 100*data_ac_3p$ps_3, type="l", lwd=2, col=colors[3], lty=6)

    abline(h=0, col=rgb(0,0,0,0.33), lty=1, lwd=1)
    legend("topright", legend=c("AC Single Phase (1/3)", "AC Three Phase A", "AC Three Phase B", "AC Three Phase C"), col=c(rgb(0,0,0,0.5), colors[3], colors[3], colors[3]), lty=c(11,4,1,6), lwd=2, bg="white")

    xlim = range(data_ac$time)
    ylim = range(data_ac$se)

    plot(xlim, 100*ylim, type="n", xlab="Time", ylab="Energy State (MWh)")
    points(data_ac$time, 100*data_ac$se, type="l", lwd=2, col=rgb(0,0,0,0.5), lty=11)
    points(data_ac_3p$time, 100*data_ac_3p$se, type="l", lwd=2, col=colors[3])
    legend("topright", legend=c("AC Single Phase", "AC Three Phase"), col=c(rgb(0,0,0,0.5), colors[3]), lty=c(11,1), lwd=2, bg="white")
dev.off()