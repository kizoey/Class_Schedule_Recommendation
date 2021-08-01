library(googledrive)
library(tidyverse)
library(combinat)

drive_find(pattern='sample.csv')
drive_download(file='sample.csv', path='sample.csv', overwrite = T)
sample=read.csv('sample.csv', fileEncoding = 'UTF8')
sample=sample[-1]
sample$day2=as.integer(as.character(sample$day2))

# convert NA values to 9
sample[is.na(sample)]=9

# sample random 10 classes
index=sample(63, 10)
test=sample[index, ]

# append unique class code
test=test %>% mutate(code=c(1:10))

# combination of choosing 6 classes out of 10
comb=combn(10, 6)
timetable=array(0, c(8, 5, 210))

# save time tables which consists of 6 unique classes
for(i in 1:210){
    temp=test[comb[, i], ]
    mat=matrix(0, 9, 9)
    for(j in 1:6){
        class=temp[j, ]
        while((mat[class$start1:class$end1, class$day1]==0)|
              (mat[class$start2:class$end2, class$day2]==0)){
            mat[class$start1:class$end1, class$day1]=class$code
            mat[class$start2:class$end2, class$day2]=class$code
        }
    }
    mat=mat[1:8, 1:5]
    num=length(unique(mat[which(mat!=0)]))
    if(num==6) {timetable[, , i]=mat}
    else {next}
}

# print required time tables
zero_mat=matrix(0, 8, 5)
sum(timetable[, , 1]==zero_mat)
cnt=0

for(i in 1:210){
    if(sum(timetable[, , i]==zero_mat)!=40){
        cnt=cnt+1
        print(timetable[, , i])
    }
}

cnt
