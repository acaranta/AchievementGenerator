#!/usr/bin/perl
use strict ;
use CGI ;
use Image::Magick ;
use Data::Dumper ;

my $imgdir = 'img' ;
my $text = "You have earned a trophy" ;
my $textsize = '28' ;
my $logo = "$imgdir/OrangeLogo.png" ;
my $fontfile = "fonts/SCE-PS3-RD-R-LATIN2.TTF" ;

##### CGI Start and options parsing
my $cgi = new CGI ;
print $cgi->header('Content-type: image/png; charset=utf-8') ;

my $pText = $cgi->param('text') ;

if ($pText ne "")
{
	$text = "You have earned a trophy\n$pText" ;
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

##### BACKGROUND GENERATION
my $imgComposite=Image::Magick->new();
my $images=Image::Magick->new();
my $imgplayer=Image::Magick->new();

$imgComposite->readimage("$imgdir/back_rounded.png") ;
##### BACKGROUND GENERATION
$imgplayer->ReadImage($logo) ;

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

###### SENDING IMAGE DATA TO STDOUT
binmode STDOUT;
$imgComposite->Write('png:-');
###### SENDING IMAGE DATA TO STDOUT
