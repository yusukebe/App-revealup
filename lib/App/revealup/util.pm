package App::revealup::util;
use strict;
use warnings;
use base qw/Exporter/;
use File::ShareDir qw/dist_dir/;
use Path::Tiny qw/path/;
use Getopt::Long qw//;

our @EXPORT = qw/path_to_res share_path parse_options/;

sub parse_options {
    my ($args, @options) = @_;
    my $p = Getopt::Long::Parser->new(
        config => [ "no_ignore_case", "no_auto_abbrev" ],
    );
    my $result = $p->getoptionsfromarray(
        $args, @options
    );
    return $result;
}

sub path_to_res {
    my $path = shift;
    if( $path && $path->exists ) {
        my $c = $path->slurp();
        return [200, [ 'Content-Length' => length $c ], [$c]];
    }
    return [404, [], ['not found.']];
}

sub share_path {
    my $p = shift;
    die "Parameter must be ARRAY ref" unless ref $p eq 'ARRAY';
    my $path = path(@$p);
    return $path if $path->exists();
    shift @$p;
    my $dist_dir = dist_dir('App-revealup');
    return path($dist_dir, @$p);
}

1;
