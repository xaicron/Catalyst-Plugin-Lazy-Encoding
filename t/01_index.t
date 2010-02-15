use strict;
use warnings;
use utf8;
use Test::Requires qw/Test::WWW::Mechanize::Catalyst/;
use Test::More;

use FindBin qw/$Bin/;
use lib "$Bin/lib";

use Test::WWW::Mechanize::Catalyst 'TestApp';
my $mech = Test::WWW::Mechanize::Catalyst->new;
$mech->get_ok('http://localhost/');
$mech->content_is('it works');
is $mech->response->header('Content-Type'), 'text/plain; charset=UTF-8';

done_testing;

