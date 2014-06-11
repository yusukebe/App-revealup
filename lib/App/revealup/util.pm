package App::revealup::util;
use strict;
use warnings;
use File::ShareDir qw/dist_dir/;
use Path::Tiny qw/path/;
use App::revealup::util;

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
