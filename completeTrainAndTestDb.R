
### Change base to the folder name of your data
base = "../input/"
test = read.csv(paste0(base, "test_set.csv"))
train = read.csv(paste0(base, "train_set.csv"))

train$id = -(1:nrow(train))
test$cost = 0

dFull = rbind(train, test)

dFull = merge(dFull, read.csv(paste0(base, "bill_of_materials.csv"), quote = ""), by = "tube_assembly_id", all.x = TRUE)
dFull = merge(dFull, read.csv(paste0(base, "specs.csv"), quote = ""), by = "tube_assembly_id", all.x = TRUE)
dFull = merge(dFull, read.csv(paste0(base, "tube.csv"), quote = ""), by = "tube_assembly_id", all.x = TRUE)
compFiles = dir(base)[grep("comp_", dir(base))]

idComp = 1
keyMerge = 0
for(idComp in 1:8){
  for(f in compFiles){
    d = read.csv(paste0(base, f), sep = ',', quote = "")
    names(d) = paste0(names(d), "_", keyMerge)
    dFull = merge(dFull, d, by.x = paste0("component_id_", idComp), by.y = paste0("component_id_", keyMerge), all.x = TRUE)
    keyMerge = keyMerge + 1
  }
  cat("idComp = ", idComp, " - nrow(dFull) = ", nrow(dFull), " and ncol(dFull) = ", ncol(dFull), "\n")
}

test = dFull[which(dFull$id > 0),]
train = dFull[which(dFull$id < 0),]

test = test[,-match("id", names(test))]
train = train[,-match("id", names(train))]

cat("Final train dataset : ", nrow(train), " rows and ", ncol(train), " columns\n")
cat("Final test dataset : ", nrow(test), " rows and ", ncol(test), " columns\n")

#write.table(test, "testFull.csv", sep = ";", row.names = FALSE, quote = FALSE)
#write.table(train, "trainFull.csv", sep = ";", row.names = FALSE, quote = FALSE)


