#!/usr/bin/perl
#########################################################################################
### XBOX/PS3 Achievement/Trophy Generator
### Author : Arthur Caranta
### Date : 2012-09-18
### Version : 1.0
#########################################################################################

use strict ;
use CGI ;
use Image::Magick ;
use Data::Dumper ;

my $imgdir = 'img' ;
my $textHeader = "You have earned a trophy" ;
my $text = "" ;
my $textsize = '28' ;
my $logo = "$imgdir/OrangeLogo.png" ;
#my $fontfile = "fonts/SCE-PS3-RD-R-LATIN2.TTF" ;
my $fontfile = "fonts/SCE-PS3-RD-L-LATIN2.TTF" ;
my $fontfilebold = "fonts/SCE-PS3-RD-B-LATIN2.TTF" ;
my $pLevel = "0" ;
my $trophy = "" ;

##### CGI Start and options parsing
my $cgi = new CGI ;
print $cgi->header('Content-type: image/png; charset=utf-8') ;

my $pText = $cgi->param('text') ;
my $pLevel = $cgi->param('level') ;
my $pLevel = $cgi->param('level') ;
my $pLocale = $cgi->param('locale') ;

if ($pLocale eq "fr") { $textHeader = "Vous avez obtenu un trophée." ; } 
else { $textHeader = "You have earned a trophy." ; } 

if ($pText ne "")
{
	$text = "$pText" ;
} 

if ($pLevel eq "0") { $trophy = "$imgdir/trophee_ps3_bronze.png" ; }
elsif ($pLevel eq "1") { $trophy = "$imgdir/trophee_ps3_argent.png" ; }
elsif ($pLevel eq "2") { $trophy = "$imgdir/trophee_ps3_or.png" ; }
elsif ($pLevel eq "3") { $trophy = "$imgdir/trophee_ps3_platine.png" ; }
else { $trophy = "$imgdir/trophee_ps3_bronze.png" ; }
##### CGI Start and options parsing


#### Getting Logo image information
my $imgText = Image::Magick->new;
my @ImgLogoinfos = $imgText->Ping("$logo") ;
#### Getting Logo image information

#### Getting Text informations
$imgText->ReadImage('NULL:purple') ;
my @Imgtextinfos = $imgText->QueryMultilineFontMetrics(
		text => "$textHeader\n$text", 
		geometry => '+140+0', 
		font => $fontfilebold, 
		gravity => 'west',
		pointsize => $textsize
		) ;
#### Getting Text informations

##### BACKGROUND GENERATION
my $imgComposite=Image::Magick->new();
my $imgTrophy=Image::Magick->new();
my $imgplayer=Image::Magick->new();

$imgComposite->readimage("$imgdir/back_rounded.png") ;
my $width = (@ImgLogoinfos[0])+50+(@Imgtextinfos[4]) ;
my $height = (@ImgLogoinfos[1])+(@Imgtextinfos[5]) ;
$imgComposite->Resize(
                width => $width,
                height => $height,
) ;
##### BACKGROUND GENERATION
$imgTrophy->ReadImage($trophy) ;
$imgTrophy->Resize(
                width => 30,
                height => 30,
) ;

$imgplayer->ReadImage($logo) ;

###### ADDING LEFT LOGOS
$imgComposite->Composite(
		image => $imgplayer, 
		composite => 'over', 
		gravity => 'west', 
		x => '+10'
		) ;

$imgComposite->Composite(
		image => $imgTrophy, 
		composite => 'over', 
		gravity => 'west', 
		x => '+110',
		y => '+30'
		) ;

###### ADDING LEFT LOGOS

###### ADDING TEXT
$imgComposite->Annotate(
		text => $textHeader, 
		geometry => '+110-20', 
		font => $fontfilebold, 
		pointsize => $textsize,
		fill => 'white',
		gravity => 'west',
		style => 'bold',
		) ;
$imgComposite->Annotate(
		text => $text, 
		geometry => '+150+30', 
		font => $fontfile, 
		pointsize => $textsize-4,
		fill => 'white',
		gravity => 'west',
		style => 'normal',
		) ;
###### ADDING TEXT

###### SENDING IMAGE DATA TO STDOUT
binmode STDOUT;
$imgComposite->Write('png:-');
###### SENDING IMAGE DATA TO STDOUT
