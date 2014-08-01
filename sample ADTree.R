# study variables
age <- sample(c(18:70), 100, replace=TRUE)
bmi <- sample(round(seq(from=17, to=40, length.out=100),1), 100, replace=TRUE)
department <- sample(c("Sales", "Marketing", "Finance", "Operations"), 100, replace=TRUE)
location <- sample(c("Georgia", "Florida", "South Carolina"), 100, replace=TRUE)
salary <- sample(c(20000:120000), 100, replace=TRUE)
rank <- as.factor(sample(seq(1:4), 100, replace=TRUE))
d <- data.frame(age, bmi, department, location, salary, rank)

# ADTree classifier is now in an external Weka package which needs to be loaded first:
library(RWeka)
list_Weka_interfaces()
WPM("install-package", "alternatingDecisionTrees")
Sys.setenv(WEKA_HOME = "C:/Users/JS033085/wekafiles")
WPM("list-packages", "installed")
WPM("load-package", "alternatingDecisionTrees")

# cost matrix
c4 <- matrix(c(0,0,0,0, 1,0,0,0, 1,1,0,0, 2,2,1,0), ncol = 4, byrow=TRUE)

# create R-interface to Weka Classifiers
ADTree <- make_Weka_classifier("weka/classifiers/trees/ADTree")
MCC <- make_Weka_classifier("weka/classifiers/meta/MultiClassClassifier")
CSC <- make_Weka_classifier("weka/classifiers/meta/CostSensitiveClassifier")

# doesn't work because 2+ variables
m.adt <- ADTree(rank~., data=d)

# ADTree w/ MultiClassClassifier
m.adt <- MCC(rank~., data = d, control = Weka_control(W = ADTree), na.action = NULL)
evaluate_Weka_classifier(m.adt, class = TRUE)

# ADTree w/ cost matrix attempt #1 (in evaluating function) -- doesn't seem to work
evaluate_Weka_classifier(m.adt, cost=c4, class = TRUE)

# J48
m.j48 <- J48(rank~., data=d)
evaluate_Weka_classifier(m.j48, class = TRUE)

# J48 w/ cost matrix
m.csc.j48 <- CostSensitiveClassifier(rank~., data = d, na.action = NULL, control = Weka_control(`cost-matrix` = c4, W = J48, M = TRUE))
evaluate_Weka_classifier(m.csc.j48, class = TRUE)

# ADTree w/ cost matrix; fails b/c no MCC
m.csc.adt <- CostSensitiveClassifier(rank~., data = d, na.action = NULL, control = Weka_control(`cost-matrix` = c4, W = ADTree, M = TRUE))
evaluate_Weka_classifier(m.csc.adt, class = TRUE)

# MCC inside of a CSC ??
m.csc.mcc <- CostSensitiveClassifier(rank~., data = d, na.action = NULL, 
            control = Weka_control(`cost-matrix` = c4, M = TRUE, W = MCC(W = ADTree)))
evaluate_Weka_classifier(m.csc.mcc, class = TRUE)




