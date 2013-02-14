#!/usr/bin/env perl

use strict;
use warnings FATAL => "all";
use Test::More tests => 4;
use Regexp::Common qw(VATIN);

ok "DE123456789" =~ $RE{VATIN}{DE};
ok "DE123456789" =~ $RE{VATIN}{any};
ok "DE12345678" !~ $RE{VATIN}{DE};
ok "DE1234567890" !~ $RE{VATIN}{any};
