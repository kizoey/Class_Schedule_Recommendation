library(googledrive)
library(tidyverse)

drive_find(pattern='sample.csv')
drive_download(file='sample.csv', path='sample.csv', overwrite = T)
sample=read.csv('sample.csv', fileEncoding = 'CP949', encoding = 'UTF-8')
sample=sample[-1]

drive_find(pattern='electronic.csv')
drive_download(file='electronic.csv', path='electronic.csv', overwrite = T)
elec=read.csv('electronic.csv')
elec=elec %>% select(class_name, building, floor)

mat=as.matrix(sample)
temp=matrix(0, ncol=2)

comb=combn(nrow(mat), 2)
for(i in 1:ncol(comb)){
    a=comb[1, i]
    b=comb[2, i]
    if(1%in%abs(mat[a, 3:6]-mat[b, 3:6])==T){
        if(0%in%abs(mat[a, 1:2]-mat[b, 1:2])==T){
            temp=rbind(temp, c(a, b))
        }
    }
}
temp=temp[-1, ]

df=data.frame()
for(i in 1:nrow(temp)){
    a=temp[i, 1]; b=temp[i, 2]
    col=cbind(elec[a, ], elec[b, ])
    df=rbind(df, col)
}

df=df[c(1, 4, 2, 5, 3, 6)]
colnames(df)=c("class1", "class2", 
               "building1", "building2", 
               "floor1", "floor2")

write_csv(df, '연강.csv')
drive_upload('연강.csv')
