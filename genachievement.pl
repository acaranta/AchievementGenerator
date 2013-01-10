#!/usr/bin/perl
#########################################################################################
### XBOX/PS3 Achievement/Trophy Generator
### Author : Arthur Caranta
### Date : 2012-09-18
### Version : 1.0.2
#########################################################################################

use strict ;
use CGI ;
use Image::Magick ;
use Digest::MD5 qw(md5 md5_hex md5_base64);
use Data::Dumper ;
my $imgdir = 'img' ;
my $cachedir = "cache" ;
my $cachestring = "" ;
##### CGI Start and options parsing
my $cgi = new CGI ;
my $pCGIMode = $cgi->param('cgimode') ;
if ($pCGIMode eq "link")
{
	print $cgi->header('Content-type: text/html; charset=utf-8') ;
	print $cgi->start_html(-title=>"Achievement Generator", -encoding=>"UTF-8")
} else {
	print $cgi->header('Content-type: image/png; charset=utf-8') ;
}
my $imgGen ;
sub imgcached
{
	my ($filename) = (@_) ;

	if (-e $filename) {
		return 1 ;
	} else {
		return 0 ;
	}
}

sub ps3gen
{
	$imgdir = "$imgdir/PS3" ;
	my $textHeader = "You have earned a trophy" ;
	my $text = "" ;
	my $texttop = "" ;
	my $textsize = '28' ;
#	my $logo = "$imgdir/OrangeLogo.png" ;
	my $logo = "$imgdir/default_logo.png" ;
#my $fontfile = "fonts/SCE-PS3-RD-R-LATIN2.TTF" ;
	my $fontfile = "fonts/PS3/SCE-PS3-RD-L-LATIN2.TTF" ;
	my $fontfilebold = "fonts/PS3/SCE-PS3-RD-B-LATIN2.TTF" ;
	my $pLevel = "0" ;
	my $trophy = "" ;

##### CGI Start and options parsing
	my $pText = $cgi->param('text') ;
	my $pLevel = $cgi->param('level') ;
	my $pLocale = $cgi->param('locale') ;
	my $pDate = $cgi->param('date') ;
	if ($pDate !~ /^[0-9]+.[0-9]+.[0-9]+$/) { $pDate = "" ; } 

	if ($pLocale eq "fr") { $textHeader = "Vous avez obtenu un trophée." ; } 
	else { $textHeader = "You have earned a trophy." ; } 

	if ($pText ne "")
	{
		$text = "$pText" ;
	} 
	if ($pText =~ /§/)
	{
		($textHeader, $text) = split('§',$pText) ;

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
	$imgplayer->Resize(
			width => 85,
			height => 85,
			) ;

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
	if ($pDate ne "") 
	{
		$imgComposite->Annotate(
				text => $pDate, 
				font => $fontfile, 
				pointsize => $textsize/2,
				geometry => '+20+40',
				fill => 'white',
				gravity => 'southeast',
				style => 'bold',
				) ;
	}
###### ADDING TEXT

	return $imgComposite ;

}


sub xboxgen
{
#	my ($imgComposite) = (@_) ;


	$imgdir = "$imgdir/XBOX" ;
	my $fontfile = "fonts/XBOX/ConvectionRegular.ttf" ;


	my $text = "" ;
	my $textsize = '28' ;
	my $logo = "$imgdir/trophy.png" ;
	my $imgP1 = "$imgdir/p1_on_green.png" ;
	my $imgP2 = "$imgdir/p2_off.png" ;
	my $imgP3 = "$imgdir/p3_off.png" ;
	my $imgP4 = "$imgdir/p4_off.png" ;
	my $pText = $cgi->param('text') ;
	my $pPoint = $cgi->param('point') ;
	my $pLocale = $cgi->param('locale') ;
	my $pDate = $cgi->param('date') ;
	if ($pDate !~ /^[0-9]+.[0-9]+.[0-9]+$/) { $pDate = "" ; } 

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
	if ($pText =~ /§/)
	{
		($text, $pText) = split('§',$pText) ;

	}

	if (defined($pText))
	{
		$text = "$text\n$pPoint$pText" ;
	} else {
		$text = "$text\n$pPoint..." ;

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
	if ($pDate ne "") 
	{
		$imgComposite->Annotate(
				text => $pDate, 
				font => $fontfile, 
				pointsize => $textsize/2,
				geometry => '+40+10',
				fill => 'white',
				gravity => 'southeast',
				style => 'bold',
				) ;
	}
###### ADDING TEXT

	return $imgComposite ;
}





###################################################
####################### Main ######################
###################################################


my $pMode = $cgi->param('mode') ;
my $pText = $cgi->param('text') ;
my $pLevel = $cgi->param('level') ;
my $pLocale = $cgi->param('locale') ;
my $pDate = $cgi->param('date') ;
my $pPoint = $cgi->param('point') ;
if ($pDate !~ /^[0-9]+\/[0-9]+\/[0-9]+$/) { $pDate = "" ; } 
if ($pMode eq "ps3") 
{
	$cachestring = "$pText$pLevel$pLocale$pDate" ;
	$cachestring = "$cachedir/$pMode"."_".md5_hex($cachestring).".png" ;
	if (imgcached($cachestring) == 0)
	{
		$imgGen = ps3gen() ;
		$imgGen->Write($cachestring) ;
	} else {
		$imgGen=Image::Magick->new();
		$imgGen->ReadImage($cachestring) ;
	}
} else {
	$pMode = "xbox" ;
	$cachestring = "$pText$pPoint$pLocale$pDate" ;
	$cachestring = "$cachedir/$pMode"."_".md5_hex($cachestring).".png" ;
	if (imgcached($cachestring) == 0)
	{
		$imgGen = xboxgen() ;
		$imgGen->Write($cachestring) ;
	} else {
		$imgGen=Image::Magick->new();
		$imgGen->ReadImage($cachestring) ;
	}
}

if ($pCGIMode eq "link")
{
	print "<p align='center'>Your Achievement : <br/><a href='http://$ENV{SERVER_NAME}/$cachestring'><img src='$cachestring' /></a><br/><br/>Link : <a href='http://$ENV{SERVER_NAME}/$cachestring'>http://$ENV{SERVER_NAME}/$cachestring</a><br/></p>" ;
} else {
	my $pSize = $cgi->param('size') ;
#$pSize = "200" ;
	if ($pSize =~ /[0-9+]/)
	{
		my $width = $imgGen->Get('columns');
		my $height = $imgGen->Get('rows'); ;
		my $ratio = $width / $height ;
		$height = ($pSize * $height) / $width ;

		$imgGen->Resize(
				width => $pSize,
				height => $height
			       ) ;
	}
###### SENDING IMAGE DATA TO STDOUT
	binmode STDOUT;
	$imgGen->Write('png:-');
###### SENDING IMAGE DATA TO STDOUT
}
