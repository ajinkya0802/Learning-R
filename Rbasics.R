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

tarwars %>% slice(c(1,5)) ## row 1 and 5













