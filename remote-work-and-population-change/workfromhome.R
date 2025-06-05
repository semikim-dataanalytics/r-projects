library(dplyr)
library(tidyr)

pop <- read.csv("/Users/semi/Desktop/sp-R/final/cbsa-est2024-alldata.csv")
pop <- pop %>% 
  filter(LSAD == "Metropolitan Statistical Area") %>% 
  select(-c(2:3), -5, -c(17:ncol(.)))

# Create 5 new change columns
pop <- pop %>%
  mutate(
    pct_change2021 = 100 * NPOPCHG2021 / POPESTIMATE2020,
    pct_change2022 = 100 * NPOPCHG2022 / POPESTIMATE2021,
    pct_change2023 = 100 * NPOPCHG2023 / POPESTIMATE2022,
    pct_change2024 = 100 * NPOPCHG2024 / POPESTIMATE2023
  )

library(ggplot2)
library(tidyr)

# Convert wide to long for plotting
pop_long <- pop_cleaned %>%
  select(Geographic_Area, `2020`, `2021`, `2022`, `2023`, `2024`) %>%
  pivot_longer(cols = -Geographic_Area, names_to = "year", values_to = "population") %>%
  mutate(year = as.numeric(year))

# Filter for a few major metros
selected_metros <- c("New York-Newark-Jersey City, NY-NJ",
                     "Los Angeles-Long Beach-Anaheim, CA",
                     "Chicago-Naperville-Elgin, IL-IN")

# Prepare long dataset
pop_long <- pop %>%
  filter(NAME %in% selected_metros) %>%
  select(NAME, POPESTIMATE2020, POPESTIMATE2021, POPESTIMATE2022, POPESTIMATE2023, POPESTIMATE2024) %>%
  pivot_longer(cols = starts_with("POPESTIMATE"),
               names_to = "year", values_to = "population") %>%
  mutate(year = as.numeric(gsub("POPESTIMATE", "", year)))

# Create individual plots
ny_plot <- ggplot(pop_long %>% filter(NAME == selected_metros[1]),
                  aes(x = year, y = population / 1e6)) +
  geom_line(color = "steelblue", size = 1.5) +
  geom_point(color = "darkred", size = 3) +
  labs(title = "New York-Newark-Jersey City", x = "Year", y = "Population (Millions)") +
  scale_x_continuous(breaks = 2020:2024) +
  theme_minimal()
ny_plot

la_plot <- ggplot(pop_long %>% filter(NAME == selected_metros[2]),
                  aes(x = year, y = population / 1e6)) +
  geom_line(color = "steelblue", size = 1.5) +
  geom_point(color = "darkred", size = 3) +
  labs(title = "Los Angeles-Long Beach-Anaheim", x = "Year", y = "Population (Millions)") +
  scale_x_continuous(breaks = 2020:2024) +
  theme_minimal()
la_plot

chicago_plot <- ggplot(pop_long %>% filter(NAME == selected_metros[3]),
                       aes(x = year, y = population / 1e6)) +
  geom_line(color = "steelblue", size = 1.5) +
  geom_point(color = "darkred", size = 3) +
  labs(title = "Chicago-Naperville-Elgin", x = "Year", y = "Population (Millions)") +
  scale_x_continuous(breaks = 2020:2024) +
  theme_minimal()
chicago_plot


# Plot 2-1: Histogram of % change for 2021
ggplot(pop, aes(x = pct_change2021)) +
  geom_histogram(bins = 30, fill = "skyblue", color = "black") +
  labs(title = "Distribution of Metro Population % Change (2020–2021)",
       x = "% Change in Population",
       y = "Number of Metro Areas") +
  theme_minimal()

# Plot 2-2: for 2022
ggplot(pop, aes(x = pct_change2022)) +
  geom_histogram(bins = 30, fill = "skyblue", color = "black") +
  labs(title = "Distribution of Metro Population % Change (2021-2022)",
       x = "% Change in Population",
       y = "Number of Metro Areas") +
  theme_minimal()


# Plot 3: Map
library(sf)
library(dplyr)
library(ggplot2)

# Step 1: Read metro shapefile
metro_shapes <- st_read("/Users/semi/Desktop/sp-R/final/tl_2023_us_cbsa.shp")

# First, make sure both CBSA columns are character
metro_shapes$GEOID <- as.character(metro_shapes$GEOID)
final_data$CBSA <- as.character(final_data$CBSA)

# Step 2: Check your population data
metro_shapes <- metro_shapes %>%
  left_join(final_data, by = c("GEOID" = "CBSA"))  # GEOID = CBSA code in shapefile

# Step 3: Plot map for a specific year, e.g., pct_change2021
map <- ggplot(metro_shapes) +
  geom_sf(aes(fill = pct_change2021), color = NA) +
  scale_fill_gradient2(low = "red", mid = "white", high = "blue", midpoint = 0,
                       name = "% Change") +
  labs(title = "US Metro Area Population % Change (2020–2021)",
       subtitle = "Data from US Census and our analysis",
       caption = "Negative values = population loss (red)\nPositive values = population gain (blue)") +
  theme_minimal()
map

###################

# Read the data
wfh <- read.csv("/Users/semi/Desktop/sp-R/final/MSA_workfromhome.csv")

# Merge
wfh$AREA <- as.character(wfh$AREA)
final_data <- left_join(pop, wfh, by = c("CBSA" = "AREA"))

# Drop rows with NA
final_data <- final_data %>%
  drop_na()

# Regression: WFH - % pop. change
reg <- lm(pct_change2021 ~ teleworkable_emp, data = final_data)
reg

# Scatterplot
library(ggplot2)
ggplot(final_data, aes(x = teleworkable_emp, y = pct_change2021)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "blue") +
  labs(title = "WFH Feasibility vs. % Population Change (2020–2021)",
       x = "% of Jobs Feasible for WFH",
       y = "% Population Change") +
  theme_minimal(base_size = 14)


# Quadratic regression (second-degree polynomial)
ggplot(final_data, aes(x = teleworkable_emp, y = pct_change2021)) +
  geom_point() +
  geom_smooth(method = "lm", formula = y ~ poly(x, 2), se = FALSE, color = "red") +
  labs(title = "WFH Feasibility vs. % Population Change (2020–2021)",
       x = "% of Jobs Feasible for WFH",
       y = "% Population Change") +
  theme_minimal(base_size = 14)


model_control <- lm(pct_change2021 ~ teleworkable_emp + log(ESTIMATESBASE2020), 
                     data = final_data)
model_control
summary(model_control)
reg # compare the results
