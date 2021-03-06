package TestApp;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

#use Catalyst qw/-Debug Static::Simple Lazy::Encoding/;
use Catalyst qw/Lazy::Encoding/;

extends 'Catalyst';

our $VERSION = '0.01';
$VERSION = eval $VERSION;

__PACKAGE__->config(
    name => 'TestApp',
    disable_component_resolution_regex_fallback => 1,
);

__PACKAGE__->setup();

1;
