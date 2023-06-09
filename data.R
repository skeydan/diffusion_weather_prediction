# https://blogs.rstudio.com/ai/posts/2020-09-01-weather-prediction/
# https://github.com/pangeo-data/WeatherBench
# to download individual files, do, e.g.
# wget -- no-check-certificate https://dataserv.ub.tum.de/s/m1524895/download?path=%2F5.625deg%2Fvorticity&files=vorticity_5.625deg.zip

library(dplyr)
library(ggplot2)
library(tidyr)
library(purrr)
library(lubridate)
library(tidync)

data_dir <- "~/downloads/weatherbench/"
levels <- c(50, 100, 150, 200, 250, 300, 400, 500, 600, 700, 850, 925, 1000)
vars <- c(
  "2m_temperature" = NA,
  "toa_incident_solar_radiation" = NA,
  "10m_u_component_of_wind" = NA,
  "10m_v_component_of_wind" = NA,
  "total_cloud_cover" = NA,
  "total_precipitation" = NA,
  "relative_humidity" = 50,
  "specific_humidity" = 50,
  "geopotential_500" = NA,
  "vorticity" = 700,
  "potential_vorticity" = 700,
  "u_component_of_wind" = 700,
  "v_component_of_wind" = 700,
  "temperature_850" = NA
)

for (i in 1:length(vars)) {
  variable <- names(vars[i])
  all <- list.files(file.path(data_dir, variable))
  last <- grep("2018", all, value = TRUE)
  file <- file.path(data_dir, variable, last)
  info <- tidync(file)
  data <- (info |> hyper_array())[[1]]
  print(info)
  if (!is.na(vars[variable])) {
    level <- match(vars[variable], levels)
    data <- data[, , level, ]
  }
  image(data[, , 1],
    col = hcl.colors(20, "viridis"),
    xaxt = "n",
    yaxt = "n",
    main = variable,
    useRaster = TRUE
  )
}

# next step: create dataset