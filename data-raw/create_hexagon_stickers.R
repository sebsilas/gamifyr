
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

# HPT

hpt_sticker <- sticker(sticker_imgs[4],
                       package="HPT",
                       p_color = "#da4d72",
                       h_color = "#fcf295",
                       h_fill = "#fafbfb",
                       p_size=20, s_x=1, s_y=.60, s_width=.6,
                       filename = 'data-raw/sticker_images/output/hpt_sticker.png',
                       white_around_sticker = FALSE)

hpt_sticker


# MDT

mdt_sticker <- sticker(sticker_imgs[5],
                       package="MDT",
                       p_color = "#519bfb",
                       h_color = "#083b55",
                       h_fill = "#fafbfb",
                       p_size=20, s_x=1, s_y=.65, s_width=.6,
                       filename = 'data-raw/sticker_images/output/mdt_sticker.png',
                       white_around_sticker = FALSE)

mdt_sticker

# MPT

mpt_sticker <- sticker(sticker_imgs[6],
                       p_color = "#84c642",
                       h_color = "#083b55",
                       h_fill = "#fafbfb",
                       package="MPT",
                       p_size=20, s_x=1, s_y=.65, s_width=.6,
                       filename = 'data-raw/sticker_images/output/mpt_sticker.png',
                       white_around_sticker = FALSE)

mpt_sticker

# MSA

msa_sticker <- sticker(sticker_imgs[7],
                       h_color = "#aec326",
                       p_color = "#df5c59",
                        h_fill = "#fafbfb",
                        package="MSA",
                        p_size=20, s_x=1, s_y=.65, s_width=.6,
                        filename = 'data-raw/sticker_images/output/msa_sticker.png',
                        white_around_sticker = FALSE)

msa_sticker

# MUS

mus_sticker <- sticker(sticker_imgs[8],
                        h_color = "#00ba2a",
                        p_color = "#fc9b00",
                        h_fill = "#fafbfb",
                        package="MUS",
                        p_size=20, s_x=1, s_y=.65, s_width=.6,
                        filename = 'data-raw/sticker_images/output/mus_sticker.png',
                        white_around_sticker = FALSE)

mus_sticker

# PIAT

piat_sticker <- sticker(sticker_imgs[9],
                        p_color = "#d64646",
                        h_color = "#083b55",
                        h_fill = "#fafbfb",
                       package="PIAT",
                       s_height = .5, s_width = .5,
                       p_size=20, s_x=1, s_y=.70,
                       filename = 'data-raw/sticker_images/output/piat_sticker.png',
                       white_around_sticker = FALSE)

piat_sticker

# RAT

rat_sticker <- sticker(sticker_imgs[10],
                       p_color = "#ac2b22",
                       h_color = "#65696d",
                       h_fill = "#fafbfb",
                       package="RAT",
                       p_size=20, s_x=1, s_y=.65, s_width=.6,
                       filename = 'data-raw/sticker_images/output/rat_sticker.png',
                       white_around_sticker = FALSE)

rat_sticker

# SAA

saa_sticker <- sticker(sticker_imgs[11],
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

tpt_sticker <- sticker(sticker_imgs[12],
                       package="TPT",
                       p_color = "#aec326",
                       h_color = "#1b989f",
                       h_fill = "#fafbfb",
                       p_size=20, s_x=1, s_y=.65, s_width=.6,
                       filename = 'data-raw/sticker_images/output/tpt_sticker.png',
                       white_around_sticker = FALSE)

tpt_sticker




# musicassessr

musicassessr_sticker <- sticker('data-raw/sticker_images/input/other/musicassessr.png',
                       package = "musicassessr",
                       p_color = "#f8523f",
                       h_color = "#18b896",
                       h_fill = "#fafbfb",
                       p_size=10, s_x=1, s_y=.65, s_width=.7,
                       filename = 'data-raw/sticker_images/output/musicassessr_sticker.png',
                       white_around_sticker = FALSE)

musicassessr_sticker


# pbet

pbet_sticker <- sticker('data-raw/sticker_images/input/other/pbet.png',
                                package = "PBET",
                                p_color = "#555a66",
                                h_color = "#00b8c1",
                                h_fill = "#fafbfb",
                                p_size=12, s_x=1, s_y=.70, s_width=.50,
                                filename = 'data-raw/sticker_images/output/pbet_sticker.png',
                                white_around_sticker = FALSE)

pbet_sticker


# pyin

pyin_sticker <- sticker('data-raw/sticker_images/input/other/pyin.png',
                        package = "pyin",
                        p_color = "#f0295a",
                        h_color = "#5c5c5c",
                        h_fill = "#fafbfb",
                        p_size=12, s_x=1, s_y=.70, s_width=.80,
                        filename = 'data-raw/sticker_images/output/pyin_sticker.png',
                        white_around_sticker = FALSE)

pyin_sticker



# saa

saa_sticker <- sticker('data-raw/sticker_images/input/other/saa.png',
                        package = "SAA",
                        p_color = "#bb8bf3",
                        h_color = "#45413c",
                        h_fill = "#fafbfb",
                        p_size=12, s_x=1, s_y=.80, s_width=.50,
                        filename = 'data-raw/sticker_images/output/saa_sticker.png',
                        white_around_sticker = FALSE)

saa_sticker




# PDT

pdt_sticker <- sticker(sticker_imgs[5],
                       package="PDT",
                       p_color = "#519bfb",
                       h_color = "#083b55",
                       h_fill = "#fafbfb",
                       p_size=20, s_x=1, s_y=.8, s_width=.60,
                       filename = 'data-raw/sticker_images/output/pdt_sticker.png',
                       white_around_sticker = FALSE)

pdt_sticker



# itembankr

itembankr_sticker <- sticker('data-raw/sticker_images/input/other/itembankr.png',
                       package="itembankr",
                       p_color = "#fe646f",
                       h_color = "#083b55",
                       h_fill = "#fafbfb",
                       p_size=12, s_x=1,
                       s_y=.8, s_width=.40,
                       filename = 'data-raw/sticker_images/output/itembankr_sticker.png',
                       white_around_sticker = FALSE)

itembankr_sticker



# RTT

rtt_sticker <- sticker('data-raw/sticker_images/input/other/rtt.png',
                             package="RTT",
                             p_color = "#f5604c",
                             h_color = "#083b55",
                             h_fill = "#fafbfb",
                             p_size=12, s_x=1,
                             s_y=.8, s_width=.40,
                             filename = 'data-raw/sticker_images/output/rtt_sticker.png',
                             white_around_sticker = FALSE)

rtt_sticker


# gamifyr

gamifyr_sticker <- sticker('data-raw/sticker_images/input/other/gamifyr.png',
                       package="gamifyr",
                       h_color = "#94afe5",
                       p_color = "#ce747a",
                       h_fill = "#fafbfb",
                       p_size=12, s_x=1,
                       s_y=.8, s_width=.40,
                       filename = 'data-raw/sticker_images/output/gamifyr_sticker.png',
                       white_around_sticker = FALSE)

gamifyr_sticker


