package Regexp::Common::VATIN;

use strict;
use warnings FATAL => "all";
use utf8;
use Regexp::Common qw(pattern clean no_defaults);

# VERSION
# ABSTRACT: Patterns for matching EU VAT Identification Numbers

my $a  = "[a-zA-Z]";
my $an = "[0-9a-zA-Z]";
my $d  = "[0-9]";
my $s  = "[ ]?";

# repeats:
my ($r2, $r3, $r4, $r5, $r7, $r8, $r9, $r10, $r11, $r12) = map {
    "{" . $_ . "}"
} 2..5, 7..12;

my $uk_pattern = do {
    my $multi_block  = "$d$r3$s$d$r4$s$d$r2$s(?:$d$r3)?";
    my $single_block = "(?:GD|HA)$d$r3";
    "(?:$multi_block|$single_block)";
};

my %patterns = (
    AT => "U$d$r8",                   # Austria
    BE => "0$d$r9",                   # Belgium
    BG => "${d}{9,10}",               # Bulgaria
    CY => "$d$r8$a",                  # Cyprus
    CZ => "${d}{8,10}",               # Czech Republic
    DE => "$d$r9",                    # Germany
    DK => "(?:$d$r2$s){3}$d$r2",      # Denmark
    EE => "$d$r9",                    # Estonia
    EL => "$d$r9",                    # Greece
    ES => "$an$d$r7$an",              # Spain
    FI => "$d$r8",                    # Finland
    FR => "$an$r2$s$d$r9",            # France
    GB => $uk_pattern,                # United Kingdom
    HU => "$d$r8",                    # Hungary
    IE => "${d}[0-9a-zA-Z+*]$d$r5$a", # Ireland
    IM => $uk_pattern,                # Isle of Man
    IT => "$d$r11",                   # Italy
    LT => "(?:$d$r9|$d$r12)",         # Lithuania
    LU => "$d$r8",                    # Luxembourg
    LV => "$d$r11",                   # Latvia
    MT => "$d$r8",                    # Malta
    NL => "$d${r9}[bB]$d$r2",         # The Netherlands
    PL => "$d$r10",                   # Poland
    PT => "$d$r9",                    # Portugal
    RO => "${d}{2,10}",               # Romania
    SE => "$d$r12",                   # Sweden
    SI => "$d$r8",                    # Slovenia
    SK => "$d$r10"                    # Slovakia
);

foreach my $alpha2 ( keys %patterns ) {
    my $prefix = $alpha2 eq "IM" ? "GB" : $alpha2;
    pattern(
        name   => ["VATIN", $alpha2],
        create => "$prefix$patterns{$alpha2}"
    );
};
pattern(
    name   => [qw(VATIN any)],
    create => do {
        my $any = join("|", map { "$_$patterns{$_}" } keys %patterns);
        "(?:$any)";
    }
);

1;
