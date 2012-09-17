#!/usr/bin/perl
use strict ;
use Image::Magick ;
use Data::Dumper ;

my $img = Image::Magick->new;

$img->Set(size => '164x64', background => 'blue') ;

print Dumper($img->Ping('img/message.png')) ;
print "\n" ;
$img->ReadImage('NULL:blue') ;
print Dumper($img->QueryMultilineFontMetrics(text => "Pouet\nSalut", geometry => '+0+5', font => 'ConvectionRegular.ttf', pointsize => 14)) ;
$img->Annotate(text => "Pouet\nSalut", geometry => '+0+5', font => 'ConvectionRegular.ttf', gravity => 'east', pointsize => 14) ;
$img->Write('out.png') ;

undef $img ;
