package App::revealup::cli::serve;
use App::revealup::base;
use Getopt::Long qw/GetOptionsFromArray/;
use File::ShareDir qw/dist_dir/;
use Path::Tiny qw/path/;
use Plack::Runner;
use Pod::Usage;
use App::revealup::util;
use App::revealup::builder;

has 'plack_port' => 5000;
has 'dry_run' => 0;
has 'theme';
has 'transition';
has 'width';
has 'height';
has 'theme_path';

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
    my $builder = App::revealup::builder->new(
        filename => $filename || '',
        theme => $self->theme || '',
        transition => $self->transition || '',
        width => $self->width || 0,
        height => $self->height || 0,
    );
    my $html = $builder->build_html();
    if( !$html ) {
        system "perldoc App::revealup::cli::serve";
        exit;
    }

    my $app = $self->app($html);
    my $runner = Plack::Runner->new();
    $runner->parse_options("--no-default-middleware");
    $runner->set_options(port => $self->plack_port);
    $runner->run($app) if !$self->dry_run
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

        my $reveal_dir = App::revealup::util::share_path([qw/share/]);
        $path = $reveal_dir->child($env->{PATH_INFO});
        return App::revealup::util::path_to_res($path) if $path->exists;
        App::revealup::util::warn("$path does not exist");
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

    $ revealup serve -p 5000 markdown.md

=head1 DESCRIPTION

C<serve> command makes your Markdown text as a HTTP Web application for the slide show.
Run C<revealup serve> command with the Markdown formatted text file name and options, 
then open by your web browser such a URL I<http://localhost:5000/>.

=head2 Options

=head3 C<-p> or C<--port>

HTTP port number.

=head3 C<--theme>

CSS file name or original CSS file path. C<reveal.js> default CSS filenames are below.

    beige.css / blood.css / default.css / moon.css / night.css / serif.css / simple.css / sky.css / solarized.css

=head3 C<--transition>

Trasition effects for slides.

    default / cube / page / concave / zoom / linear / fade / none

=head3 C<--width>

Width of a slide's size. Default is 960.

=head3 C<--height>

Height of a slide's size. Default is 700.

=head1 MORE INFORMATION

    $ perldoc App::revealup

=cut
