#!/usr/bin/perl
use strict ;
use CGI ;
use Image::Magick ;
use Data::Dumper ;

my $imgText = Image::Magick->new;
my $text = "Achievement Unlocked !\n10G - Un Générateur d'Achievements XBOX Fonctionnel !!! Yeeeaaaahhh !" ;
my $textsize = '28' ;
my $logo = "img/360_logo.png" ;
my $fontfile = 'fonts/ConvectionRegular.ttf'

my $cgi = new CGI ;
print $cgi->header('Content-type: text/html; charset=utf-8') ;
print $cgi->start_html(-title=>"XBOX Achievement Generator", -encoding=>"UTF-8") ;

#### Getting Logo image information
my @ImgLogoinfos = $imgText->Ping("$logo") ;
#### Getting Logo image information

#### Getting Text informations
$imgText->ReadImage('NULL:purple') ;
my @Imgtextinfos = $imgText->QueryMultilineFontMetrics(
			text => $text, 
			geometry => '+0+0', 
			font => $fontfile, 
			gravity => 'west',
			pointsize => $textsize
	    ) ;
#### Getting Text informations

#### LOGO + Player Generation
my $images=Image::Magick->new();
my $imgplayer=Image::Magick->new();
$imgplayer->readimage('img/dark_circle.png') ;

my $imgplayer2=Image::Magick->new();
$imgplayer2->readimage('img/p1_on_green.png') ;
$imgplayer->Composite(
image => $imgplayer2, 
gravity => 'northwest', 
geometry => "+3+3"
) ;
my $imgplayer2=Image::Magick->new();
$imgplayer2->readimage('img/p2_off.png') ;
$imgplayer->Composite(
image => $imgplayer2, 
gravity => 'northeast', 
geometry => "-3+3"
) ;
my $imgplayer2=Image::Magick->new();
$imgplayer2->readimage('img/p3_off.png') ;
$imgplayer->Composite(
image => $imgplayer2, 
gravity => 'southwest', 
geometry => "+3-3"
) ;
my $imgplayer2=Image::Magick->new();
$imgplayer2->readimage('img/p4_off.png') ;
$imgplayer->Composite(
image => $imgplayer2, 
gravity => 'southeast', 
geometry => "-3-3"
) ;

my $imgLogo=Image::Magick->new();
$imgLogo->ReadImage($logo) ;
$imgplayer->Composite(
image => $imgLogo, 
gravity => 'center'
) ;

my $images=Image::Magick->new();
$imgText->Resize(
		width => @Imgtextinfos[4],
		height => @Imgtextinfos[5],
		) ;
push(@$images,$imgplayer) ;
push(@$images,$imgText) ;

my $width = (@ImgLogoinfos[0])+(@Imgtextinfos[4]) ;
my $height = (@ImgLogoinfos[1])+(@Imgtextinfos[5]-5) ;

my $imgInner = $images->Montage(
geometry => "+0+0", 
compose => 'over' , 
border => '0'
) ;
#### LOGO + Player Generation

##### BACKGROUND GENERATION
my $images=Image::Magick->new();;
my $imgComposite = Image::Magick->new;
$imgComposite->ReadImage('img/left_cap.png') ;
$imgComposite->Resize(
height => $height
) ;
push(@$images,$imgComposite) ;
my $imgComposite = Image::Magick->new;
$imgComposite->ReadImage('img/middle.png') ;
$imgComposite->Resize(
width => $width, 
height => $height
) ;
push(@$images,$imgComposite) ;
my $imgComposite = Image::Magick->new;
$imgComposite->ReadImage('img/left_cap.png') ;
$imgComposite->Flop() ;
$imgComposite->Resize(
height => $height
) ;
push(@$images,$imgComposite) ;
my $imgComposite = Image::Magick->new;

$imgComposite = $images->Montage(
geometry => "+0+0", 
compose => 'over' , 
border => '0', 
gravity => 'center'
) ;
$imgComposite->Transparent(
color => 'white' 
);
##### BACKGROUND GENERATION

###### ADDING LEFT LOGOS
$imgComposite->Composite(
image => $imgplayer, 
composite => 'over', 
gravity => 'west', 
x => '+10'
) ;
###### ADDING LEFT LOGOS

###### ADDING TEXT
$imgComposite->Annotate(
		text => $text, 
		geometry => '+140+0', 
		font => $fontfile, 
		pointsize => $textsize,
		fill => 'white',
		gravity => 'west',
		style => 'bold',
		) ;
###### ADDING TEXT



$imgComposite->Write('out.png') ;
