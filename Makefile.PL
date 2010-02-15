use inc::Module::Install;
name 'Catalyst-Plugin-Lazy-Encoding';
all_from 'lib/Catalyst/Plugin/Lazy/Encoding.pm';

requires 'Data::Recursive::Encode';
requires 'Catalyst::Runtime', 5.80;
requires 'Encode';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
test_requires 'Test::Requires';
test_requires 'URI::Escape';
test_requires 'HTTP::Request::Common';
auto_set_repository;
auto_include;
WriteAll;
