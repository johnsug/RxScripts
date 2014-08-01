

library(lifecontingencies)
exampleLt <- new("lifetable", x=c(0,1,2), lx=c(1, .99, .99*.99))
# no interest
200*Axn(exampleLt, 0, 2, i=0)
# 5% interest
200*Axn(exampleLt, 0, 2, i=.05)



