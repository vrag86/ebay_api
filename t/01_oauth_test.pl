#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use lib 'lib';

use Test::More qw/no_plan/;

use_ok('Ebay::Api::OAuth');

my $scopes = [
    'https://api.ebay.com/oauth/api_scope',
];

SKIP: {
    skip "Not defined 'CLIENT_ID'" if not $ENV{'CLIENT_ID'};
    skip "Not defined 'CLIENT_SECRET'" if not $ENV{'CLIENT_SECRET'};

    my $oauth = Ebay::Api::OAuth->new(
        -client_id          => $ENV{'CLIENT_ID'},
        -client_secret      => $ENV{'CLIENT_SECRET'},
    );
    isa_ok($oauth, 'Ebay::Api::OAuth') // BAIL_OUT("Can't create Ebay::Api::OAuth");
    my $application_token = $oauth->get_application_token(
        -scopes        => $scopes,
    );
    ok ($application_token->{'access_token'}, "get_application_access_token");


}
