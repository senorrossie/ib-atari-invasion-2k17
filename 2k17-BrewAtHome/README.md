# Atari Invasion 2k17 - Info Beamer

Code that drove the displays during the Atari Invasion 2k17 event at the HCC Commodore meeting in Maarssen. Lots of code borrowed from the examples by the author of the info-beamer software.

## The code in action...
![ai-2k17_ib_museum](https://user-images.githubusercontent.com/29672548/28383680-47d78430-6cc2-11e7-9958-17a67126050c.png)

## Screen layout
Layout consists of:
 * Header (Text area with logo - 1920x300)
 * Center (Where things happen - 1920x800 (overlaps header))
 * Footer (Scrolltext area     - 1920x55)

The center area has a rotation cycle for the subscenes of 300 seconds. There are the following subscenes created:
 * Adverts - rotation speed: 30 seconds
 * Exhibition - rotation speed: 60 seconds
 * Game Compo - rotation speed: 60 seconds
 * Homebrew - rotation speed: 60 seconds
 * Museum - rotation speed: 60 seconds
 * Posters - rotation speed: 30 seconds