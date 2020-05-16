library(tidyverse)
library(ggmagic) # devtools::install_github("datasketch/ggmagic")
library(paletero) # devtools::install_github("datasketch/paletero")

x <- read_csv("scripts/2020-05-14/maradona-goals.csv")
x <- x %>% select(1,3)

opts <- list(
  sort = "asc",
  title = "Goles internacionales de Maradona",
  subtitle = "",
  ver_title = " ",
  hor_title = " ",
  orientation = "hor",
  format_num_sample = 1990,
  text_size = 12,
  label_wrap = 30,
  axis_text_size = 10,
  # palette_colors = pal,
  # background_color = paletas[[img_number]]$bg,
  # color_by = names(d)[1],
  # text_color = "#dddddd",
  # line_color = "#dddd99",
  # grid_color = "#999999",
  branding_include = TRUE,
  logo = NULL,
  caption = "Datos de Wikipedia:<br>List_of_international_goals_scored_by_Diego_Maradona",
  branding_text = "Hecho por @jpmarindiaz con herramientas de datasketch.co"
)
gg <- gg_scatter_NumNum(x, opts = opts)
gg
#ggsave("scripts/2020-05-12/atenidos.png", width = 5, height = 5)
save_ggmagic(gg, "scripts/2020-05-14/goles-maradona.png", width = 5, height = 5)


