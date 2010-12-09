#!/usr/bin/perl

use Modern::Perl;
use LWP::Simple;
use HTML::TreeBuilder;

package MyParser;
use base qw(HTML::TreeBuilder);

my $price_flag = 0;
my $title_flag = 0;
my $price_val;
my $title;
sub start { 
	my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
  if($tagname eq 'b') {
    if( $origtext =~ /class="priceLarge"/) {
      $price_flag = 1;      
    }
  } elsif($tagname eq 'span') {
    if($title_flag ==1) {
      $title_flag++;
    }
    if( $origtext =~ /id="btAsinTitle"/) {
      $title_flag = 1;
    }
  }
}

sub text {
  my ($self, $text) = @_;
  if($price_flag) {
    $price_val = $text;    
  } elsif($title_flag==1) {
    $title = $text;
  }
}

sub end {
  my ($self, $tag, $origtext) = @_;
  if($price_flag && $tag eq 'b') {
    $price_flag = 0;    
  }
  if($title_flag && $tag eq 'span') {
    $title_flag--;
  }
}

package main;

die get_usage() unless (scalar @ARGV ==3);
my ($gbphuf, $usdhuf, $isbn) = @ARGV;
die "isbn missing...\n".get_usage() unless defined($isbn);

my $uk_url="http://www.amazon.co.uk/dp/";
my $us_url="http://www.amazon.com/dp/";

my $html = get($uk_url.$isbn);
my $p = MyParser->new;
$p->parse($html);
my $uk_price = substr($price_val,1);
my $book_title = $title;

$html = get($us_url.$isbn);
$p = MyParser->new;
$p->parse($html);
my $us_price = substr($price_val,1);
my $uk_price_huf = $uk_price*$gbphuf;
my $us_price_huf = $us_price*$usdhuf;
printf("Title: $book_title\nUK Price: GBP %.2f - HUF %.2f\nUS Price: USD %.2f - HUF %.2f\n", 
  $uk_price, $uk_price_huf, $us_price, $us_price_huf);
my $diff = $uk_price_huf - $us_price_huf;
printf("Diff: HUF %.2f\n", $diff);

# subs
sub get_usage {
  "Usage: ./compare.pl <gbphuf> <usdhuf> <isbn>\n";
}
