install.packages("DescTools")               
library("DescTools")   
library("dplyr")
library("ggplot2")
library("tidyverse")
###############TASK 1######################

# assigning who1 the data from new_sp_m014 to new_sp_m014
who1 = who %>% pivot_longer(cols=c('new_sp_m014': 'newrel_f65'),
                            names_to='key',
                            values_to='cases',values_drop_na = TRUE)
who1 = who %>% pivot_longer(cols=c('new_sp_m014':'newrel_f65'), names_to='key',values_to='cases',values_drop_na = TRUE)

View(who1)
##Q1

who2 <- who1
# replacing 'newrel' with 'new_rel'
who2$key  <- stringr::str_replace(who1$key,'newrel','new_rel')
View(who2)

##Q3

# separating column 'key' into new,type,sexage.
whο3 = who2 %>% separate(key, c("new", "type", "sexage"), sep = "_")
View(whο3)

##Q4
# separating sexage into 'sex' and 'age'
who4 <-whο3 %>% separate(sexage, c("sex", "age"),sep = 1)
View(who4)

##Q5
#displaying first 5 rows
head(who4,5)

#displaying last 5 rows
tail(who4,5)
##Q6

# exporting the data into a csv file in the working directory
write.csv(who4,"who4.csv", row.names = FALSE)
################TASK 2######################
View(Nile)
##Q1
# Using the in built mean()
Nile_mean = mean(Nile)
print(Nile_mean)


# Using the in built median()
Nile_median = median(Nile,na.rm = FALSE)
print(Nile_median)

# Using Mode() from DescTools
Nile_mode = Mode(Nile)
print(Nile_mode)

#standard deviation using StdDev()
Nile_std = StdDev(Nile)
print(Nile_std)


# Using Var() for variance
Nile_var = var(Nile)
print(Nile_var)


##Q2
# Using min()
min_nile = min(Nile)
print(min_nile)

# Using max()
max_nile = max(Nile)
print(max_nile)

# Range max - min
range_nile = max_nile - min_nile
print(range_nile)

##Q3
# Using in built IQR()
IQR(Nile,na.rm = FALSE)
# Using in built quantile()
quantile(Nile,na.rm = TRUE)

##Q4
# Using the in built hist() to plot a histogram
hist(Nile,main ="Measurements of the annual flow of the river Nile",xlab = "volume of water(10^8 Cubic meter)",ylab = "frequency of the recorded volume of water",col='#2ADFC6')

##Q5 
qqnorm(Nile) 
qqline(Nile,col = "red",lwd=2)


##Q6
plot(Nile,main="Measurements of the annual flow of the river Nile",xlab = "Years",ylab = "Volume of water(10^8 cubic meter)")

##################Task3##################
##Q1
data = ggplot2::mpg
# Calculating the average mgp for each vehicle across both city and highway
data$Avg_mpg = rowMeans(cbind(data$cty,data$hwy),na.rm = TRUE)
View(data)
# Calcualting the average mgp for each brand 
AvgBrand_mpg = data %>% 
  group_by(manufacturer) %>% 
  summarise(Avg_mpg = mean(Avg_mpg))
#Plotting a bar chart to best represent our findings
ggplot(data=AvgBrand_mpg, aes(x=manufacturer, y=Avg_mpg)) +
  geom_bar(stat="identity")+
  ggtitle("Vehicle brand efficiency in mpg across both city and highway")+
  labs(y=" Average MPG (city and highway)",x="Manufacturer")

##Q2
# using ggplot with facet_wrap to plot mpg in city of vehicle with different engine sizes.
ggplot(data = data) + 
  geom_point(mapping = aes(x = displ, y = cty, color=class)) +
  facet_wrap(~ class, nrow = 2)+
  ggtitle("Engine size vs mpg in city - (categorised based on Vehicle type )")+
  labs(y="MPG in city",x="Engine size")
##Q3
# using ggplot with facet_grid to plot mpg in city and highway of vehicle        with different engine sizes and number of cylinders.
ggplot(data = data) + 
  geom_point(mapping = aes(x = cty, y = hwy , color=displ)) +
  facet_grid(cyl ~ drv )+
  scale_color_gradient(low="red", high='green')+
  ggtitle("mpg in city vs mpg on highway  - (categorised based on drive type,No.of cylinders and engine size )")+
  labs(y="MPG on highway",x="MPG in city")
