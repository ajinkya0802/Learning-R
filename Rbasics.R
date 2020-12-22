#vignette("dplyr")

100%/%60 # quotient

100%/%60 # remainder

4 %in% 1:12 # whether 4 is in 1:12

df <- data.frame(x = 1:2, y = 3:4)
df
class(df) # class of df
typeof(df) # evaluate its type
str(df) ## show its structure

#View(df)

# have to tell R that y,x belong to df, thats why lm(y~x) doesn't work
# Another good rule of thumb is that you want to load your most important packages last. (E.g. Load the tidyverse after you've already loaded any other packages.)
# package::function() 


lm(y~x, data = df)

df2 <- data.frame(x = rnorm(10), y = runif(10))

myvector <- c(1,2,5)

#use package::function()

#lists

my_list <- list(a = "hello", b = c(1,2,3), c = data.frame(x = 1:5, y = 6:10))

a <- "hello"
b <- "world"

rm(a,b)

plot(1:10)
dev.off()

## Tidyverse
library(tidyverse)
library(data.table)

mpg %>% filter(manufacturer=="audi") %>% 
  group_by(model) %>% 
  summarise(hwy_mean = mean(hwy))

## filter - Filter (i.e. subset) rows based on their values.
## arrange - Arrange (i.e. reorder) rows based on their values.
## select - Select (i.e. subset) columns by their names:
## mutate - create new columns 
## summarise : collapse multiple rows into a single summary value

starwars %>% filter(species == "Human", height>=190)

starwars %>% filter(grepl("Skywalker", name))

starwars %>% filter(!is.na(height)) %>% arrange(birth_year) %>% arrange(name)

starwars %>% select(name:skin_color, species, -height)

starwars %>% select(alias = name, crib = homeworld, sex = gender)

starwars %>% rename(alias = name)

starwars %>% select(name, contains("color"))

starwars %>% select(species, homeworld, everything()) %>% head(5)

starwars %>% select(name, birth_year) %>% mutate(dog_years = birth_year*7) %>% mutate(comment = paste0(name, " is ", dog_years, " in dog years."))


starwars%>%select(name, height) %>% filter(name %in% c("Luke Skywalker")) %>% mutate(tall1 = height>180) %>% 
  mutate(tall2 = ifelse(height>180, "Tall", "Short"))
  
starwars %>% 
  select(name:eye_color) %>% 
  mutate(across(where(is.character), toupper)) %>%
  head(5)

starwars%>% group_by(species, gender) %>% summarise(mean_height = mean(height, na.rm = TRUE))

## summarize as long as numeric
starwars %>% group_by(species) %>% summarise(across(where(is.numeric), mean, na.rm = T))

starwars %>% slice(c(1,5)) ## row 1 and 5

starwars %>% filter(gender=="female") %>% pull(height)

starwars %>% group_by(species) %>% mutate(num = n())

starwars%>% count(species)

library(nycflights13)
left_join(flights, planes) %>%
  select(year, month, day, dep_time, arr_time, carrier, flight, tailnum, type, model)

left_join(
  flights,
  planes %>% rename(year_built = year), ## Not necessary w/ below line, but helpful
  by = "tailnum" ## Be specific about the joining column
)

starwars_dt = as.data.table(starwars)

starwars_dt[species== "Human", mean(height, na.rm = T), by = homeworld] ## data.table

starwars %>% filter(species== "Human")%>% group_by(homeworld) %>% summarise(mean_height = mean(height))

## Syntax for tables = DT[i,j,by], i = On which rows, j = What to do, by = Grouped by what

DT = data.table(x = 1:2)

DT[, x_sq := x^2][]

DT2 = data.table(a = -2:2, b = LETTERS[1:5])

DT2[a<0, b:=NA][]


starwars_dt[, mean(height, na.rm = T), by = species]

starwars_dt[, mean(height, na.rm = T), by = height>190]

starwars_dt[, species_n := .N, by = species][]

starwars_dt[, .(mean_height = mean(height, na.rm = T)), by = .(species, homeworld)] %>% head(4)


starwars_dt[species== 'Human']

## To add, delete, or change columns in data.table, we use the := operator.


DT = data.table(x = 1:2)

DT[, x_sq := x^2][]


DT_copy = copy(DT)

DT_copy[, x_sq := NULL]

DT2 = data.table(a = -2:2, b = LETTERS[1:5])
DT2[a<0, b:= NA][]

## To modify multiple columns simultaneously
DT[, ':=' (y= 3:4, y_name = c("three", "four"))][]

DT[, z:=5:6][, z_sq:=z^2][]

## But if you prefer the magrittr pipe, then that's also possible. Just prefix each step with .:

DT %>% .[,xyz := x+y+z] %>% .[, xyz_sq := xyz^2] %>% .[]


DT[, y_name := NULL][] ## remove column


starwars_dt[1:2, c(1:3,10)][]

starwars_dt[, c("name", "height", "mass", "homeworld")] ## Also works
starwars_dt[, list(name, height, mass, homeworld)] ## So does this

##You can think of it as one of data.table's syntactical quirks. But, really, it's just there to give you more options. You can often — if not always — use these three forms interchangeably in data.table:
##.(var1, var2, ...)
##list(var1, var2, ...)
##c("var1", "var2", ...)

## exclude columns

starwars_dt[, !c("name", "height")]

##renaming
setnames(starwars_dt, old = c("name", "homeworld"), new = c ("alias" , "crib"))[]



starwars_dt[, mean(height, na.rm=T)]

starwars_dt[, mean_height := mean(height, na.rm = T)] %>% .[1:5, .(alias, height, mean_height)]

starwars_dt[, mean(height, na.rm = T), by = species]


starwars_dt[, species_height:= mean(height, na.rm =T), by = species][]

starwars_dt[, species_n := .N, by = species][] %>% .[1:3,]

starwars_dt[, mean_height:= mean(height, na.rm = T), by = c("species", "crib")] %>% .[1:3,]


starwars_dt[, .(mean(height, na.rm = T), mean(mass, na.rm = T), mean(birth_year, na.rm = T)), by = species][]

## better way
starwars_dt[, lapply(.SD, mean, na.rm =T), .SDcols = c("height", "mass", "birth_year" ), by = species]%>% head(2)

DT[, lapply(.SD, mean)][]


## Functions 

square <- function(x) {
  x^2
}

## square <- function(x) x^2 
square(3)


square2 <- function(x = 1) {
  x_sq <- x^2
  df <- tibble(val = x, val2 = x_sq)
  return(df)
}
square2() ##default value =2 

square(2)

square2(1:5)

square2(c(2,4))

for(i in 1:10) print(LETTERS[i])

kelvin <- 300:305

fahrenheit <- NULL
# fahrenheit <- vector("double", length(kelvin)) ## Better than the above. Why?
for(k in 1:length(kelvin)) {
  fahrenheit[k] <- kelvin[k] * 9/5 - 459.67
}
fahrenheit

## try using apply functions































  
  
  
  
  





