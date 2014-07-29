Requirements
---------------
Software :
- debian/ubuntu : perlmagick
- other/CPAN : Perl::Magick
- and obviously apache2 with perl module enabled


Rights :
the only really needed right is theon the cache directory which must be readable AND writable by apache

Usage
---------
point your browser to 
`http://<whateverhteinstallpath>/generateimage.pl?<parameters>`
where parameters are :
- Common Parameters :
  - mode=(xbox|ps3)
  - locale=(en|fr)
  - text=<well...your text which should be shown on the second line>
  - size=[0-9]+ ... Sets the output image width
  - date=[0-9]+.[0-9]+.[0-9]+ ... Adds the date entered as a watermark
- XBOX Specifics :
  - point=[0-9]+ ... this allows to show a GamerPoint earned score
- PS3 Trophies
  - level=[0-3] ... this allows to change the level of the trophy ranging from 0 to 3... which is from bronze up to platinum

if the parameters are omitted then they are set like this by default :
- mode=xbox
- locale=en
- size=about 450px
- point=0 ... nothing shown
- level=0 .. bronze

How it works
--------------
It uses ImageMagick, several pieces of images and fonts to generate mockups of achievements/trophies well known of gamers.

The image is directly returned as an 'image/png' with transparency.

The nice trick is that if the image is asked (with its parameters) asked for the first time, it is generated, stored in the cache directory and returned to the browser.
Every other time the same image/parameters are asked, it is read from the disk insted of regenerating it completely

Examples
---------
`http://example.com/genachievement.pl?text=XBOX Rulez&point=5&date=08/04/2014&locale=en&size=400`
![XBOX](http://achieve.minixer.com/genachievement.pl?text=XBOX Rulez&point=5&date=08/04/2014&locale=en&size=400)

`http://example.com/genachievement.pl?mode=ps3&text=PS3 Rulez Too&level=1&date=08/04/2014&locale=en&size=400`
![PS3](http://achieve.minixer.com/genachievement.pl?mode=ps3&text=PS3 Rulez Too&level=1&date=08/04/2014&locale=en&size=400)

Future / TODO :
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
