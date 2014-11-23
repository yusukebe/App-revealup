package App::revealup::base;
use strict;
use warnings;

sub import {
    my $caller = caller;
    no strict 'refs';
    *{"${caller}::new"} = sub {
        my ($klass, %opt) = @_;
        return bless \%opt, $klass;
    };
    *{"${caller}::has"} = sub {
        my ($k, $v) = @_;
        *{"${caller}::$k"} = sub {
            return $v
        };
    };
    strict->import;
    warnings->import;
}

1;
