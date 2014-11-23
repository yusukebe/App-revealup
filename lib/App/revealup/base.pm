package App::revealup::base;
use strict;
use warnings;
use Carp qw/croak/;

sub import {
    my $caller = caller(0);
    no strict 'refs';
    *{"${caller}::has"} = sub { has($caller, @_) };
    *{"${caller}::new"} = sub {
        my ($klass, %opt) = @_;
        for my $key (keys %opt) {
            has($caller, $key, $opt{$key});
        }
        return bless \%opt, $klass;
    };
    strict->import;
    warnings->import;
}

sub has {
    my ( $caller, $k, $v ) = @_;
    if ( !$caller->can($k) ) {
        no strict 'refs';
        *{"${caller}::$k"} = sub {
            my ( $self, $value ) = @_;
            if ( !$value ) {
                $self->{"$k"} = $v if !$self->{"$k"};
                return $self->{"$k"};
            }
            $self->{"$k"} = $value if $value;
        };
    }
}

1;
