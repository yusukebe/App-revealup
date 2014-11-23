package App::revealup::cli::server;
use App::revealup::base;
use Getopt::Long qw/GetOptionsFromArray/;
use File::ShareDir qw/dist_dir/;
use Path::Tiny qw/path/;
use Text::MicroTemplate qw/render_mt/;
use Plack::Runner;
use Pod::Usage;
use App::revealup::util;
use App::revealup::builder;

has 'plack_port' => 5000;
has 'dry_run' => 0;
has 'theme' => '';
has 'theme_path' => '';
has 'transition' => 'default';
has 'width' => 960;
has 'height' => 700;

sub run {
    my ($self, @args) = @_;
    my $opt;
    parse_options(
        \@args,
        'p|port=s' => \$opt->{plack_port},
        'theme=s' => \$opt->{theme},
        'transition=s' => \$opt->{transition},
        'width=i' => \$opt->{width},
        'height=i' => \$opt->{height},
        '_dry-run' => \$opt->{dry_run},
    );

    for my $key (keys %$opt) {
        $self->$key( $opt->{$key} );
    }
    
    my $filename = shift @args;
    if( !$filename || !path($filename)->exists ) {
        pod2usage( { -input => __FILE__, -verbose => 2, -output => \*STDERR } );
    }
    if($self->theme) {
        $self->theme( $self->theme .= '.css' ) if $self->theme !~ m!.+\.css$!;
        $self->theme_path(path('.', $self->theme));
    }

    my $builder = App::revealup::builder->new(
        filename => $filename || '',
        theme => $self->theme || '',
        theme_path => $self->theme_path || '',
        transition => $self->transition || '',
        width => $self->width || 0,
        height => $self->width || 0,
    );
    
    my $html = $builder->build_html();
    my $app = $self->app($html);
    my $runner = Plack::Runner->new();
    $runner->parse_options("--no-default-middleware");
    $runner->set_options(port => $self->plack_port);
    $runner->run($app) if !$self->dry_run
}

sub render {
    my ($self, $filename) = @_;
    my $template_dir = App::revealup::util::share_path([qw/share templates/]);
    my $template = $template_dir->child('slide.html.mt');
    my $content = $template->slurp_utf8();
    my $html = render_mt(
        $content,
        $filename,
        $self->theme_path,
        $self->transition,
        { width => $self->width, height => $self->height },
    )->as_string();
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
        if($self->theme_path && $env->{PATH_INFO} =~ m!${self->theme_path}$!){
            if($self->theme_path->exists) {
                $path = path('.', $self->theme_path);
            }else{
                my $reveal_theme_path = App::revealup::util::share_path([qw/share revealjs css theme/]);
                $path = $reveal_theme_path->child($self->theme_path->basename);
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

=head2 --width

Width of a slide's size. Default is 960.

=head2 --height

Height of a slide's size. Default is 700.

=head1 MORE INFORMATION

    $ perldoc App::revealup

=cut
