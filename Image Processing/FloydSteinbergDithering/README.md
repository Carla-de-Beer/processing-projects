# Floyd-Steinberg Dithering #

A dithering technique using error diffusion, meaning it pushes (adds) the residual quantisation error of a pixel onto its neighbouring pixels, to be dealt with later.

Based on Daniel Shiffman's Coding Train video:
https://www.youtube.com/watch?v=0L2n8Tg2FwI

## Compression rate

* Frog image:
  * The original image: 1,040,283 bytes.
  * The segmented image: 613,827 bytes (this will vary depending on each segmentation initialisation).
  * Compression rate: 59.005770545%.

</br>
<p align="center">
  <img src="images/screenShot.png"/>
</p>
