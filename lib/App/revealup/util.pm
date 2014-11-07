package App::revealup::util;
use strict;
use warnings;
use base qw/Exporter/;
use File::ShareDir qw/dist_dir/;
use Path::Tiny qw/path/;
use Getopt::Long qw//;
use MIME::Types qw//;

our @EXPORT = qw/path_to_res share_path parse_options/;

sub parse_options {
    my ($args, @options) = @_;
    Getopt::Long::Configure("no_ignore_case", "no_auto_abbrev");
    my $result = Getopt::Long::GetOptionsFromArray($args, @options);
    return $result;
}

sub path_to_res {
    my $path = shift;
    if( $path && $path->exists ) {
        my $c = $path->slurp();
        my $meta = ['Content-Length' => length $c ];
        if( my $mime = MIME::Types->new->mimeTypeOf($path->basename) ){
            push @$meta, ('Content-Type' => $mime->type );
        }
        return [200, $meta , [$c]];
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
