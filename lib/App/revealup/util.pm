package App::revealup::util;
use strict;
use warnings;
use base qw/Exporter/;
use File::ShareDir qw/dist_dir/;
use Path::Tiny qw/path/;
use Getopt::Long qw//;
use MIME::Types qw//;
use Term::ANSIColor;
use Carp qw/croak/;

our @EXPORT = qw/path_to_res share_path parse_options error warn info/;

sub parse_options {
    my ($args, @options) = @_;
    Getopt::Long::Configure("no_ignore_case", "no_auto_abbrev");
    my $result = Getopt::Long::GetOptionsFromArray($args, @options);
    return $result;
}

sub path_to_res {
    my $path = shift;
    if( $path && $path->exists ) {
        my $c = $path->slurp_raw();
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

sub error {
    my $message = shift;
    print "[";
    print color 'red';
    print "Error";
    print color 'reset';
    print "] $message\n";
    croak $message;
}

sub warn {
    my $message = shift;
    print "[";
    print color 'yellow';
    print "Warn";
    print color 'reset';
    print "] $message\n";
}

sub info {
    my $message = shift;
    print "[";
    print color 'green';
    print "Info";
    print color 'reset';
    print "] $message\n";
}

1;
