package App::revealup::cli::server;
use strict;
use warnings;
use Getopt::Long qw/GetOptionsFromArray/;
use File::ShareDir qw/dist_dir/;
use Path::Tiny qw/path/;
use Text::MicroTemplate qw/render_mt/;
use Plack::Runner;
use Pod::Usage;
use App::revealup::util;

my $_plack_port = 5000;
my $_dry_run = 0;
my $_theme;
my $_theme_path = '';
my $_transition = 'default';
my $_size = { width => 960, height => 700 };

sub run {
    my ($self, @args) = @_;
    parse_options(
        \@args,
        'p|port=s' => \$_plack_port,
        'theme=s' => \$_theme,
        'transition=s' => \$_transition,
        'width=i' => \$_size->{width},
        'height=i' => \$_size->{height},
        '_dry-run' => \$_dry_run
    );

    my $filename = shift @args;
    if( !$filename || !path($filename)->exists ) {
        pod2usage( { -input => __FILE__, -verbose => 2, -output => \*STDERR } );
    }

    if($_theme) {
        $_theme .= '.css' if $_theme !~ m!.+\.css$!;
        $_theme_path = path('.', $_theme);
    }
    my $html = $self->render($filename);
    my $app = $self->app($html);
    my $runner = Plack::Runner->new();
    $runner->parse_options("--no-default-middleware");
    $runner->set_options(port => $_plack_port);
    $runner->run($app) if !$_dry_run;
}

sub render {
    my ($self, $filename) = @_;
    my $template_dir = App::revealup::util::share_path([qw/share templates/]);
    my $template = $template_dir->child('slide.html.mt');
    my $content = $template->slurp_utf8();
    my $html = render_mt(
        $content,
        $filename,
        $_theme_path,
        $_transition,
        $_size )->as_string();
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
        # theme
        if($_theme_path && $env->{PATH_INFO} =~ m!$_theme_path$!){
            if($_theme_path->exists) {
                $path = path('.', $_theme_path);
            }else{
                my $reveal_theme_path = App::revealup::util::share_path([qw/share revealjs css theme/]);
                $path = $reveal_theme_path->child($_theme_path->basename);
            }
            return App::revealup::util::path_to_res($path) if $path->exists;
        }
        
        $path = path('.', $env->{PATH_INFO});
        return App::revealup::util::path_to_res($path) if $path->exists;

        my $reveal_dir = App::revealup::util::share_path([qw/share revealjs/]);
        $path = $reveal_dir->child($env->{PATH_INFO});
        return App::revealup::util::path_to_res($path) if $path->exists;
        warn "[Warning] $path does not exist.\n";
        return [
            404,
            ['Content-Type' => 'text/plain'],
            ['Not Found']
        ];
    };
}

1;

__END__

=head1 SYNOPSIS

    $ revealup server -p 5000 markdown.md

=head1 DESCRIPTION

I<server> command makes your markdown texts as a HTTP Web application for slide show.
Run C<revealup server> the with markdown filename and options.
And with your browser access such url I<http://localhost:5000/>.

=head1 Options

=head2 -p or --port

HTTP port number

=head2 --theme

CSS filename or original CSS file path. The reveal.js default CSS filenames are below.

    beige.css / blood.css / default.css / moon.css / night.css / serif.css / simple.css / sky.css / solarized.css

=head2 --transition

Trasition effects for slides.

    default / cube / page / concave / zoom / linear / fade / none

=head2 width

Width of a slide's size. Default is 960.

=head2 height

Height of a slide's size. Default is 700.

=head1 MORE INFORMATION

    $ perldoc App::revealup

=cut
