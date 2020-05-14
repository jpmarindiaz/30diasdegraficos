
library(gtrendsR)
# Paquetes experimentales de Datasketch http://datasketch.co
library(ggmagic) # devtools::install_github("datasketch/ggmagic")
library(paletero) # devtools::install_github("datasketch/paletero")

# Get Data
res <- gtrends("Corte Suprema", geo = "CO", time = "all")

time <- res$interest_over_time
# write_csv(time, "scripts/2020-05-13/corte-suprema.csv")
# Save data

x <- read_csv("scripts/2020-05-13/corte-suprema.csv")
x <- x %>% select(date, hits) %>% filter(date > "2012-12-31")

x$date <- as.character(x$date)

opts <- list(
  title = 'Interés por "Corte Suprema',
  subtitle = "Interés por búsquedas en Google",
  ver_title = " ",
  hor_title = " ",
  format_dat_sample = "Abr 24 2010",
  text_size = 12,
  label_wrap = 30,
  axis_text_size = 10,
  # palette_colors = pal,
  branding_include = TRUE,
  logo = NULL,
  caption = "Datos de Google Trends desde 2013. <br>Generado el 13 de mayo de 2020.",
  branding_text = "Hecho por @jpmarindiaz con herramientas de datasketch.co"
)
gg <- gg_line_DatNum(x, opts = opts)

gg
#ggsave("scripts/2020-05-12/atenidos.png", width = 5, height = 5)
save_ggmagic(gg, "scripts/2020-05-13/corte-suprema.png", width = 5, height = 5)


opts$branding_include <- FALSE
gg <- gg_line_DatNum(x, opts = opts)
gg


library(ggforce)

gg + geom_mark_ellipse(aes(fill = a, filter = (a == "2019-10-01"),
                           label = "hola"),
                           # description = "This is something"),
                       show.legend = FALSE)
add_branding_bar(gg, opts$theme)

