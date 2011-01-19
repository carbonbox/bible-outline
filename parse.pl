#!/usr/bin/perl

use Modern::Perl;
use FindBin;
use lib "$FindBin::Bin/lib";
use Parser;
use Template;
use Carp qw/croak/;

use constant {
    DATADIR  => "$FindBin::Bin/data",
    TEMPLATE => "$FindBin::Bin/templates/bible.tt",
    HTML     => "$FindBin::Bin/index.html",
};

my $parser = Parser->new();
my $tt     = Template->new({
    INTERPOLATE  => 1,
    ABSOLUTE     => 1,
}) or croak $Template::ERROR;

# parse and process
opendir my $dir, DATADIR or croak "cannot open data directory: $!";
for my $file (readdir $dir) {
    next if $file =~ /\.{1,2}/;
    $file = DATADIR . "/$file";
    open my $data, '<', $file or croak "Failed to open '$file': $!";
    while (<$data>) { $parser->parse($_) }
}
$tt->process(TEMPLATE, { books => $parser->books }, HTML) or croak $tt->error();
