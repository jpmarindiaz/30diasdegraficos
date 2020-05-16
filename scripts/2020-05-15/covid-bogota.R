
library(tidyverse)
library(homodatum)

#x0 <- read_csv("scripts/2020-05-15/osb_enftransm-covid-19.csv")

x0 <- read_csv("scripts/2020-05-15/osb_enftransm-covid-19.csv",
               locale = locale(encoding = "latin1"), guess_max = 5000)
x0$`Fecha de diagnóstico` <- lubridate::dmy(x0$`Fecha de diagnóstico`)
problems(x0)




x <- x0 %>%
  rename(category = one_of(var) ) %>%
  mutate(casos = 1) %>%
  select(`Fecha de diagnóstico`, casos) %>%
  group_by(`Fecha de diagnóstico`) %>%
  summarise(casos = sum(casos), .groups = "drop") %>%
  mutate(casos = cumsum(casos))
f <- fringe(x, frtype = c("Dat-Num"))
opts <- list(
  palette_colors = "#fcae07",
  locale = "es-CO",
  title = "Casos en Bogotá",
  ver_title = "Casos disgonosticados",
  caption = "Gráfico por @jpmarindiaz."
)
gg_line_DatNum(f, opts)

var <- "Localidad de residencia"
x <- x0 %>%
  rename(category = one_of(var)) %>%
  select(`Fecha de diagnóstico`, category) %>%
  mutate(casos = 1) %>%
  group_by(`Fecha de diagnóstico`, category) %>%
  # group_by(category) %>%
  summarise(casos = sum(casos), .groups = "drop")
x1 <- x %>%
  group_by(category) %>%
  mutate(casos = cumsum(casos)) %>%
  select(fecha = 1,casos = 3,localidad = 2) %>%
  filter(localidad != "Sin Dato") %>%
  ungroup()

top_localidades <- x1 %>%
  group_by(localidad) %>%
  summarise(casos = sum(casos)) %>%
  arrange(desc(casos)) %>% .$localidad

library(forcats)
x1$localidad <- fct_relevel(x1$localidad, top_localidades)


xs <- x1 %>%
  arrange(localidad) %>%
  group_split(localidad) %>%
  set_names(levels(x1$localidad))

opts <- list(
  hor_title = "Fecha",
  ver_title = "Casos",
  palette_colors = "#fcae07",
  locale = "es-CO"
)
l <- map(xs, function(xx){
  opts$title <- unique(xx$localidad)
  d <- xx %>% select(fecha, casos)
  gg_line_DatNum(xx, opts)
})


library(patchwork)

pwtheme <- theme(
  plot.title = element_text(
    color = "#4b4b4b",
    margin = margin(30,10,20,10),
    family = "Montserrat",
    size = 35),
  plot.subtitle = element_text(
    color = "#4b4b4b",
    family = "Montserrat",
    margin = margin(10,10,20,10),
    size = 18),
  plot.caption = element_text(
    color = "#4b4b4b",
    family = "Montserrat",
    margin = margin(10,10,20,10),
    size = 12),
  plot.background = element_rect(
    colour = "#FaFaF5",
    fill = "#FaFaF5")
)

qplot() +
  plot_annotation(title = 'Casos de Coronavirus por Localidades',
                  theme = pwtheme,
                  subtitle = "Por @jpmarindiaz",
                  caption = "Datos de http://saludata.saludcapital.gov.co")

gg <- wrap_plots(l, ncol = 2) +
  plot_annotation(title = 'Casos de Coronavirus por Localidades',
                  subtitle = "Por @jpmarindiaz",
                  caption = "Datos de http://saludata.saludcapital.gov.co",
                  theme = pwtheme)

gg

ggsave("scripts/2020-05-15/covid-bogota.png", plot = gg,
       width = 10, height = 30)

## Notas

# Primer caso reportado
x2 <- x1 %>%
  group_by(localidad) %>%
  slice(1) %>%
  arrange(fecha) %>%
  select(-casos)

# Crecimiento

xx1 <- x %>%
  mutate(growth = (casos/lag(casos) - 1) * 100,
         nuevos_casos = casos - lag(casos))

x3 <- x1 %>% group_by(localidad) %>%
  mutate(growth = (casos/lag(casos) - 1) * 100) %>%
  filter(casos > 20)





