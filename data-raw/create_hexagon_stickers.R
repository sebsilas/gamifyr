
library(hexSticker)

sticker_imgs <- list.files('data-raw/sticker_images/input', full.names = TRUE)


# Using https://www.imgonline.com.ua/eng/get-dominant-colors.php to get dominant colours
# Then https://coolors.co to get a new pallete colour for the background

# BAT


bat_sticker <- sticker(sticker_imgs[1],
                       package="BAT",
                       p_size=20, s_x=1, s_y=.60, s_width=.6,
                       p_color = "#f90047",
                       h_color = "#3bacfc",
                       h_fill = "#fafbfb",
                       filename = 'data-raw/sticker_images/output/bat_sticker.png',
                       white_around_sticker = FALSE)

bat_sticker

# BDT

bdt_sticker <- sticker(sticker_imgs[2],
                       package="BDT",
                       p_color = "#25a686",
                       h_color = "#1d2523",
                       h_fill = "#fafbfb",
                       p_size=20, s_x=1, s_y=.65, s_width=.6,
                       filename = 'data-raw/sticker_images/output/bdt_sticker.png',
                       white_around_sticker = FALSE)

bdt_sticker

# EDT

edt_sticker <- sticker(sticker_imgs[3],
                       package="EDT",
                       p_color = "#f5a12b",
                       h_color = "#fae219",
                       h_fill = "#fafbfb",
                       p_size=20, s_x=1, s_y=.60, s_width=.6,
                       filename = 'data-raw/sticker_images/output/edt_sticker.png',
                       white_around_sticker = FALSE)

edt_sticker

# MDT

mdt_sticker <- sticker(sticker_imgs[4],
                       package="MDT",
                       p_color = "#519bfb",
                       h_color = "#083b55",
                       h_fill = "#fafbfb",
                       p_size=20, s_x=1, s_y=.65, s_width=.6,
                       filename = 'data-raw/sticker_images/output/mdt_sticker.png',
                       white_around_sticker = FALSE)

mdt_sticker

# MPT

mpt_sticker <- sticker(sticker_imgs[5],
                       p_color = "#84c642",
                       h_color = "#083b55",
                       h_fill = "#fafbfb",
                       package="MPT",
                       p_size=20, s_x=1, s_y=.65, s_width=.6,
                       filename = 'data-raw/sticker_images/output/mpt_sticker.png',
                       white_around_sticker = FALSE)

mpt_sticker

# PIAT

piat_sticker <- sticker(sticker_imgs[6],
                        p_color = "#d64646",
                        h_color = "#083b55",
                        h_fill = "#fafbfb",
                       package="PIAT",
                       p_size=20, s_x=1, s_y=.65, s_width=.6,
                       filename = 'data-raw/sticker_images/output/piat_sticker.png',
                       white_around_sticker = FALSE)

piat_sticker

# RAT

rat_sticker <- sticker(sticker_imgs[7],
                       p_color = "#ac2b22",
                       h_color = "#65696d",
                       h_fill = "#fafbfb",
                       package="RAT",
                       p_size=20, s_x=1, s_y=.65, s_width=.6,
                       filename = 'data-raw/sticker_images/output/rat_sticker.png',
                       white_around_sticker = FALSE)

rat_sticker

# SAA

saa_sticker <- sticker(sticker_imgs[8],
                       package="SAA",
                       p_color = "#e32548",
                       h_color = "#612782",
                       h_fill = "#fafbfb",
                       p_size=18,
                       s_x=.90,
                       s_y=.55,
                       s_width=.50,
                       s_height = .50,
                       filename = 'data-raw/sticker_images/output/saa_sticker.png',
                       white_around_sticker = FALSE)

saa_sticker

# TPT

tpt_sticker <- sticker(sticker_imgs[9],
                       package="TPT",
                       p_color = "#aec326",
                       h_color = "#1b989f",
                       h_fill = "#fafbfb",
                       p_size=20, s_x=1, s_y=.65, s_width=.6,
                       filename = 'data-raw/sticker_images/output/tpt_sticker.png',
                       white_around_sticker = FALSE)

tpt_sticker



