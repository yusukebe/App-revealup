package App::revealup::cli::export::theme;
use App::revealup::base;
use App::revealup::util;
use Path::Tiny qw/path/;
use Getopt::Long qw/GetOptionsFromArray/;
use Term::ANSIColor;

has 'base' => 'black';
has 'output' => 'original.css';

sub run {
    my ($self, @args) = @_;
    my $opt;
    my $result = parse_options(
        \@args,
        'output=s' => \$opt->{output},
        'base=s'   => \$opt->{base},
    );

    for my $key (keys %$opt) {
        $self->$key( $opt->{$key} );
    }

    my $filepath = path('.', $self->output);
    if ($filepath->exists) {
        App::revealup::util::error("$filepath exists");
    }

    my $base = $self->base !~ m!\.css$! ? $self->base . '.css' : $self->base;
    my $reveal_theme_path = App::revealup::util::share_path([qw/share revealjs css theme/]);
    my $base_path = $reveal_theme_path->child($base);

    if (!$base_path->exists) {
        App::revealup::util::error("base theme '$base' does not exist");
    }

    my $content = $base_path->slurp();
    $filepath->spew_utf8($content);
    App::revealup::util::info("Generated your CSS to @{[$self->output]}");
}

1;
