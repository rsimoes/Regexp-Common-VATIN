package Regexp::Common::VATIN;

use strict;
use warnings FATAL => 'all';
use utf8;
use Regexp::Common qw(pattern clean no_defaults);

# VERSION
# ABSTRACT: Patterns for matching EU VAT Identification Numbers

my $uk_pattern = do {
    my $multi_block  = '[0-9]{3}[ ]?[0-9]{4}[ ]?[0-9]{2}[ ]?(?:[0-9]{3})?';
    my $single_block = '(?:GD|HA)[0-9]{3}';
    "(?:$multi_block|$single_block)";
};

my %patterns = (
    AT => 'U[0-9]{8}',                          # Austria
    BE => '0[0-9]{9}',                          # Belgium
    BG => '[0-9]{9,10}',                        # Bulgaria
    CY => '[0-9]{8}[a-zA-Z]',                   # Cyprus
    CZ => '[0-9]{8,10}',                        # Czech Republic
    DE => '[0-9]{9}',                           # Germany
    DK => '(?:[0-9]{2}[ ]?){3}[0-9]{2}',        # Denmark
    EE => '[0-9]{9}',                           # Estonia
    EL => '[0-9]{9}',                           # Greece
    GR => '[0-9]{9}',                           # Greece ISO-3166
    ES => '[0-9a-zA-Z][0-9]{7}[0-9a-zA-Z]',     # Spain
    FI => '[0-9]{8}',                           # Finland
    FR => '[0-9a-zA-Z]{2}[ ]?[0-9]{9}',         # France
    GB => $uk_pattern,                          # United Kingdom
    HR => '[0-9]{11}',                          # Croatia
    HU => '[0-9]{8}',                           # Hungary
    IE => do {                                  # Ireland
        my @formats = (
            '[0-9]{7}[a-zA-Z]',
            '[0-9][A-Z][0-9]{5}[a-zA-Z]',
            '[0-9]{7}[a-zA-Z]{2}'
        );
        '(?:' . join('|', @formats) . ')';
    },
    IM => $uk_pattern,                          # Isle of Man
    IT => '[0-9]{11}',                          # Italy
    LT => '(?:[0-9]{9}|[0-9]{12})',             # Lithuania
    LU => '[0-9]{8}',                           # Luxembourg
    LV => '[0-9]{11}',                          # Latvia
    MT => '[0-9]{8}',                           # Malta
    NL => '[0-9]{9}[bB][0-9]{2}',               # The Netherlands
    PL => '[0-9]{10}',                          # Poland
    PT => '[0-9]{9}',                           # Portugal
    RO => '[0-9]{2,10}',                        # Romania
    SE => '[0-9]{12}',                          # Sweden
    SI => '[0-9]{8}',                           # Slovenia
    SK => '[0-9]{10}'                           # Slovakia
);

foreach my $alpha2 ( keys %patterns ) {
    my $prefix = $alpha2 eq 'IM'
               ? 'GB'
               : $alpha2 eq 'GR'
                   ? 'EL'
                   : $alpha2;
    pattern(
        name   => ['VATIN', $alpha2],
        create => "$prefix$patterns{$alpha2}"
    );
}

pattern(
    name   => [qw(VATIN any)],
    create => do {
        my $any = join(
            '|',
            map {
                $_ . $patterns{$_}
            } keys %patterns
        );
        "(?:$any)";
    }
);

1;
