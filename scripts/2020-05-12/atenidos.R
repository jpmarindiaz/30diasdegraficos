
library(gtrendsR)
# Paquetes experimentales de Datasketch http://datasketch.co
library(ggmagic) # devtools::install_github("datasketch/ggmagic")
library(paletero) # devtools::install_github("datasketch/paletero")

# Get Data
res <- gtrends("Atenidos", geo = "CO", time = "now 7-d")
region <- res$interest_by_region
# write_csv(region, "scripts/2020-05-12/atenidos.csv")
# Save data

x <- read_csv("scripts/2020-05-12/atenidos.csv")

x <- x %>%
  filter(!is.na(hits))
x$location[x$location == "North Santander"] <- "Norte de Santander"
x$location[x$location == "Narino"] <- "Nariño"
x$location[x$location == "Bogota"] <- "Bogotá"
x$location[x$location == "Boyaca"] <- "Boyacá"
x$location[x$location == "Quindío"] <- "Quindio"
x$location[x$location == "Cordoba"] <- "Córdoba"
x$location[x$location == "Atlantico"] <- "Atlántico"
x$location[x$location == "Bolivar"] <- "Bolívar"
x$location <- gsub("Department","", x$location)
x <- x %>%
  select(Departamento = location, Hits = hits)

opts <- list(
  sort = "asc",
  title = "'Atenidos'",
  subtitle = "Departamentos con mayor interés por la palabra",
  ver_title = " ",
  hor_title = " ",
  orientation = "hor",
  # format_cat_sample = "Title Case",
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
  caption = "Datos de Google Trends para los últimos 7 días. <br>Generado el 12 de mayo de 2020.",
  branding_text = "Hecho por @jpmarindiaz con herramientas de datasketch.co"
)
gg <- gg_bar_CatNum(x, opts = opts)
gg
#ggsave("scripts/2020-05-12/atenidos.png", width = 5, height = 5)
save_ggmagic(gg, "scripts/2020-05-12/atenidos.png", width = 5, height = 5)


