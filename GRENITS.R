
source("https://bioconductor.org/biocLite.R")
biocLite("GRENITS")

library(GRENITS)
data(Athaliana_ODE)

TF <- data.matrix(Pilot_TF)[,-1]
rownames(TF) <- Pilot_TF[,1]

plot.ts( t(TF), plot.type = "single", col = 1:5,  xlim = c(0,65),
         main = "Circadian Clock Network \n ODE simulated data",
         xlab = "Time (h)",  ylab = "Expression")
legend("topright", rownames(TF), lty = 1, col = 1:5)

output.folder <- paste("./TF_LinearNet", sep="")
LinearNet(output.folder, TF)
analyse.output(output.folder)
dir(output.folder)
chain1 <- read.chain(output.folder,1)
chain2 <- read.chain(output.folder,2)
gamma1 <- colMeans(chain1$gamma)
gamma2 <- colMeans(chain2$gamma)
plot(x = gamma1, y = gamma2, xlab = "chain1", ylab = "chain2", 
     main = "Convergence plot for link probabilities", xlim = c(0,1), ylim = c(0,1), cex = 1.5, cex.lab = 1.6, cex.main = 1.6)
lines(c(0,1), c(0,1), col = "red")

prob.file <- paste(output.folder, "/NetworkProbability_Matrix.txt", sep = "")
prob.mat  <- read.table(prob.file)
print(prob.mat)

inferred.net <- 1*(prob.mat > 0.8)
print(inferred.net)

library(network)
inferred.net <- network(inferred.net)
par(mfrow = c(1,2), cex = 1.76, cex.lab = 1.3, cex.main = 1.4)
# Plot cut off
prob.vec <- sort(as.vector(as.matrix(prob.mat)), T)
# Remove self interaction (last 5 elements)
prob.vec <- prob.vec[4:0 - length(prob.vec)]
plot(x = prob.vec, y = 1:length(prob.vec), xlim = c(0,1), main = "Connections included vs threshold", 
     xlab = "Probability threshold", ylab = "Connections included")
lines(c(0.8,0.8), c(0, 30), col = "red", lty = 2, lwd = 2)
# Plot Network
plot(inferred.net, label = network.vertex.names(inferred.net), main = "A. thaliana Inferred Network", mode = "circle", vertex.cex=7, arrowhead.cex = 2,vertex.col="green")

prob.list.file <- paste(output.folder, "/NetworkProbability_List.txt", sep = "")
prob.list      <- read.table(prob.list.file, header = T)
above.08       <- (prob.list[,3] > 0.8)
print(prob.list[above.08,])