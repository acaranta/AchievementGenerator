#!/usr/bin/perl
use strict ;
use CGI ;
use Image::Magick ;
use Data::Dumper ;

my $imgdir = 'img' ;
my $text = "" ;
my $textsize = '28' ;
my $logo = "$imgdir/trophy.png" ;
my $fontfile = "fonts/ConvectionRegular.ttf" ;
my $imgP1 = "$imgdir/p1_on_green.png" ;
my $imgP2 = "$imgdir/p2_off.png" ;
my $imgP3 = "$imgdir/p3_off.png" ;
my $imgP4 = "$imgdir/p4_off.png" ;

##### CGI Start and options parsing
my $cgi = new CGI ;
print $cgi->header('Content-type: image/png; charset=utf-8') ;
my $imgGen ;

sub xboxgen()
{
my ($imgComposite) = (@_) ;

my $pText = $cgi->param('text') ;
my $pPoint = $cgi->param('point') ;
my $pLocale = $cgi->param('locale') ;

if ($pLocale eq "fr") { $text = "Succès déverrouillé !" ; }
else { $text = "Achievement Unlocked !" ; }


if ($pPoint !~ /[0-9]+/) {
	$pPoint = 0 ;
}

if ($pPoint != 0) {
	$pPoint = $pPoint."G - ";
} else {
	$pPoint = "" ;
}

if ($pText ne "")
{
	$text = "$text\n$pPoint$pText" ;
} 
##### CGI Start and options parsing


#### Getting Logo image information
my $imgText = Image::Magick->new;
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
$imgplayer->readimage("$imgdir/dark_circle.png") ;

my $imgplayer2=Image::Magick->new();
$imgplayer2->readimage($imgP1) ;
$imgplayer->Composite(
		image => $imgplayer2, 
		gravity => 'northwest', 
		geometry => "+3+3"
		) ;
my $imgplayer2=Image::Magick->new();
$imgplayer2->readimage($imgP2) ;
$imgplayer->Composite(
		image => $imgplayer2, 
		gravity => 'northeast', 
		geometry => "-3+3"
		) ;
my $imgplayer2=Image::Magick->new();
$imgplayer2->readimage($imgP3) ;
$imgplayer->Composite(
		image => $imgplayer2, 
		gravity => 'southwest', 
		geometry => "+3-3"
		) ;
my $imgplayer2=Image::Magick->new();
$imgplayer2->readimage($imgP4) ;
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
$imgComposite->ReadImage("$imgdir/left_cap.png") ;
$imgComposite->Resize(
		height => $height
		) ;
push(@$images,$imgComposite) ;
my $imgComposite = Image::Magick->new;
$imgComposite->ReadImage("$imgdir/middle.png") ;
$imgComposite->Resize(
		width => $width, 
		height => $height
		) ;
push(@$images,$imgComposite) ;
my $imgComposite = Image::Magick->new;
$imgComposite->ReadImage("$imgdir/left_cap.png") ;
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
}

xboxgen(\$imgGen) ;
###### SENDING IMAGE DATA TO STDOUT
binmode STDOUT;
$imgGen->Write('png:-');
###### SENDING IMAGE DATA TO STDOUT
