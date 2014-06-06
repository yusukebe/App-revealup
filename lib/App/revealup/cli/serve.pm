package App::revealup::cli::serve;
use strict;
use warnings;
use Getopt::Long qw/GetOptionsFromArray/;
use File::ShareDir qw/dist_dir/;
use Path::Tiny qw/path/;
use Text::MicroTemplate qw/render_mt/;
use Plack::Runner;
use Pod::Usage;

my $_plack_port = 5000;
my $_dry_run = 0;
my $_theme_path = '';
my $_transition = 'default';

sub run {
    my ($self, @args) = @_;
    my $_theme;
    GetOptionsFromArray( \@args, 
                         'p|port=s' => \$_plack_port,
                         'theme=s' => \$_theme,
                         'transition=s' => \$_transition,
                         '_dry-run' => \$_dry_run );
    my $filename = shift @args;

    if( !$filename || !path($filename)->exists ) {
        pod2usage({-input => __FILE__, -verbose => 2, -output => \*STDERR});
    }

    $_theme_path = path('.', $_theme) if $_theme;
    my $html = $self->render($filename);
    my $app = $self->app($html);
    my $runner = Plack::Runner->new();
    $runner->parse_options("--port=$_plack_port");
    $runner->parse_options("--no-default-middleware");
    $runner->run($app) if !$_dry_run;
}

sub render {
    my ($self, $filename) = @_;
    my $template_dir = $self->share_path([qw/share templates/]);
    my $template = $template_dir->child('slide.html.mt');
    my $content = $template->slurp_utf8();
    my $html = render_mt($content, $filename, $_theme_path, $_transition)->as_string();
    return $html;
}

sub app {
    my ($self, $html) = @_;
    return sub {
        my $env = shift;
        if ($env->{PATH_INFO} eq '/') {
            return [
                200,
                ['Content-Type' => 'text/html', 'Content-Length' => length $html],
                [$html]
            ];
        };
        my $path;
        if($env->{PATH_INFO} =~ m!\.(?:md|mkdn)$!) {
            $path = path('.', $env->{PATH_INFO});
        }else{
            if($_theme_path && $env->{PATH_INFO} =~ m!$_theme_path$!){
                if($_theme_path->exists) {
                    $path = path('.', $_theme_path);
                }else{
                    my $reveal_theme_path = $self->share_path([qw/share revealjs css theme/]);
                    $path = $reveal_theme_path->child($_theme_path->basename);
                }
            }else{
                my $reveal_dir = $self->share_path([qw/share revealjs/]);
                $path = $reveal_dir->child($env->{PATH_INFO});
            }
        }
        return $self->path_to_res($path);
    };
}

sub path_to_res {
    my ($self, $path) = @_;
    if( $path && $path->exists ) {
        my $c = $path->slurp();
        return [200, [ 'Content-Length' => length $c ], [$c]];
    }
    return [404, [], ['not found.']];
}

sub share_path {
    my ($self, $p) = @_;
    die "Parameter must be ARRAY ref" unless ref $p eq 'ARRAY';
    my $path = path(@$p);
    return $path if $path->exists();
    shift @$p;
    my $dist_dir = dist_dir('App-revealup');
    return path($dist_dir, @$p);
}

1;

__END__

=head1 SYNOPSIS

    $ revealup serve -p 5000 markdown.md

=head1 DESCRIPTION

I<serve> commnad makes your markdown texts as a HTTP Web application for slideshow.
Run C<revealup serve> the with markdown filename and options.
And with your browser access such url I<http://localhost:5000/>.

Options:

=over 4

=item -p           : HTTP Port Number

=item --theme      : CSS filename or path

=item --transition : default/cube/page/concave/zoom/linear/fade/none

=back

=head1 MORE INFORMATION

    $ perldoc App::revealup

=cut
