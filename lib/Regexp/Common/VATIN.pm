package Regexp::Common::VATIN;

use strict;
use warnings FATAL => "all";
use utf8;
use Regexp::Common qw(pattern clean no_defaults);

# VERSION
# ABSTRACT: Patterns for matching EU VAT Identification Numbers

my $a  = "[[:alpha:]]";
my $an = "[[:alnum:]]";
my $d  = "[[:digit:]]";
my $s  = "[[:space:]]?";

# repeats:
my ($r2, $r3, $r4, $r5, $r8, $r9, $r10, $r11, $r12) = map {
    "{" . $_ . "}"
} 2..5, 8..12;

my %patterns = (
    AT => qr(ATU$d$r8),                   # Austria
    BE => qr(BE0$d$r9),                   # Belgium
    BG => qr(BG${d}{9,10}),               # Bulgaria
    CY => qr(CY$d$r8$a),                  # Cyprus
    CZ => qr(CZ${d}{8,10}),               # Czech Republic
    DE => qr(DE$d$r9),                    # Germany
    DK => qr(DK(?:$d$r2$s){3}$d$r2),      # Denmark
    EE => qr(EE$d$r9),                    # Estonia
    EL => qr(EL$d$r9),                    # Greece
    ES => qr(ES$d$r9),                    # Spain
    FI => qr(FI$d$r8),                    # Finland
    FR => qr(FR$an$r2$s$d$r9),            # France
    GB => do {                            # United Kingdom
        my $multi_block  = qr($d$r3$s$d$r4$s$d$r2$s(?:$d$r3)?);
        my $single_block = qr((?:GD|HA)$d$r3);
        qr(GB(?:$multi_block|$single_block));
    },
    HU => qr(HU$d$r8),                    # Hungary
    IE => qr(IE${d}[[:alnum:]+*]$d$r5$a), # Ireland
    HU => qr(HU$d$r11),                   # Italy
    LT => qr(LT(?:$d$r9|$d$r12)),         # Lithuania
    LU => qr(LU$d$r8),                    # Luxembourg
    LV => qr(LV$d$r11),                   # Latvia
    MT => qr(MT$d$r8),                    # Malta
    NL => qr(NL$d$r12),                   # The Netherlands
    PL => qr(PL$d$r10),                   # Poland
    PT => qr(PT$d$r9),                    # Portugal
    RO => qr(RO${d}{2,10}),               # Romania
    SE => qr(SE$d$r12),                   # Sweden
    SK => qr(SK$d$r10)                    # Slovakia
);

foreach my $alpha2 ( keys %patterns ) {
    pattern(
        name   => ["VATIN", $alpha2],
        create => "$patterns{$alpha2}"
    );
};
pattern(
    name   => [qw(VATIN any)],
    create => "(?:" . join("|", values(%patterns)) . ")"
);

1;
