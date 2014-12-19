package App::revealup::base;
use strict;
use warnings;

sub import {
    my $caller = caller(0);
    no strict 'refs';
    *{"${caller}::has"} = sub { attr($caller, @_) };
    *{"${caller}::new"} = sub {
        my ($klass, %opt) = @_;
        for my $key (keys %opt) {
            attr($caller, $key, $opt{$key}) if $opt{$key};
        }
        return bless \%opt, $klass;
    };
    strict->import;
    warnings->import;
}

sub attr {
    my ( $caller, $k, $v ) = @_;
    no strict 'refs';
    return if defined *{"${caller}::$k"};
    *{"${caller}::$k"} = sub {
        my ( $self, $value ) = @_;
        if ( !$value ) {
            $self->{$k} = $v if !$self->{$k};
            return $self->{$k};
        }
        $self->{$k} = $value if $value;
    };
}

1;
