library(magick)
library(tidyverse)

imgfld <- "C:/Users/uomom/Documents/internalsizepercept/onlyobjs"

imgsset1 <- list.files(paste0(imgfld, "/set1_flip"), full.names = TRUE, pattern = ".png")


imgsset2 <- list.files(paste0(imgfld, "/set2_flip"), full.names = TRUE, pattern = ".png")

set1nms <- basename(imgsset1)
set2nms <- basename(imgsset2)

imglist1 <- map(imgsset1, image_read)

imglist1_flop <- map(imglist1, image_flop)



imglist2 <- map(imgsset2, image_read)

imglist2_flop <- map(imglist2, image_flop)


for(img in seq_along(imglist1_flop)) {
  image_write(imglist1_flop[[img]], paste0(imgfld, "/set1_flop/", set1nms[img]))
}


for(img in seq_along(imglist2_flop)) {
  image_write(imglist2_flop[[img]], paste0(imgfld, "/set2_flop/", set1nms[img]))
}