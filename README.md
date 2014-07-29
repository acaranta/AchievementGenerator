1. PreRequisites :
------------------
1.2 Packages :
--------------
- debian/ubuntu : perlmagick
- other/CPAN : Perl::Magick
- and obviously apache2 with perl module enabled


1.3 Rights :
------------
the onyl really needed right is theon the cache directory which must be readable AND writable by apache

2 Usage :
---------
point your browser to 
`http://<whateverhteinstallpath>/generateimage.pl?<parameters>`

Parameters are passed as POST variables.

2.1 Parameters
--------------
2.1.1 Common Parameters
-----------------------
- mode=(xbox|ps3)
- locale=(en|fr)
- text=<well...your text which should be shown on the second line>
- size=[0-9]+ ... Sets the output image width
- date=[0-9]+.[0-9]+.[0-9]+ ... Adds the date entered as a watermark

2.1.2 for XBOX Achievements
---------------------------
- point=[0-9]+ ... this allows to show a GamerPoint earned score

2.1.3 for PS3 Trophies
----------------------
- level=[0-3] ... this allows to change the level of the trophy ranging from 0 to 3... which is from bronze up to platinum

2.1.4 Defaults 
--------------
if the parameters are omitted then they are set like this :
- mode=xbox
- locale=en
- size=about 450px
- point=0 ... nothing shown
- level=0 .. bronze

3 How it works
--------------
It uses ImageMagick, several pieces of images and fonts to generate mockups of achievements/trophies well known of gamers.

The image is directly returned as an 'image/png' with transparency.

The nice trick is that if the image is asked (with its parameters) asked for the first time, it is generated, stored in the cache directory and returned to the browser.
Every other time the same image/parameters are asked, it is read from the disk insted of regenerating it completely


4 Future / TODO :
----------
- Allow easy configuration
- [XBOX] Allow change of logo
- [XBOX] Allow differente Player LEDs configuration
- write a generator wrapper, html forms etc
- [PS3] Allow easy change of the logo used
- Allow a way to return directly an url to the cached generated image
- add a nocacheparameter
- add a way to empty cache (?)
- review system to deliver static urls ?
- Add XboxOne/PS4 Styles
