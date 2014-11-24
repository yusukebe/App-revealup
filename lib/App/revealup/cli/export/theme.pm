package App::revealup::cli::export::theme;
use App::revealup::base;
use App::revealup::util;
use Path::Tiny qw/path/;
use Getopt::Long qw/GetOptionsFromArray/;

has 'base' => 'default';
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
        die "[Warning] $filepath exists.\n";
    }

    my $base = $self->base !~ m!\.css$! ? $self->base . '.css' : $self->base;
    my $reveal_theme_path = App::revealup::util::share_path([qw/share revealjs css theme/]);
    my $base_path = $reveal_theme_path->child($base);

    if (!$base_path->exists) {
        die "[Warning] base theme '$base' does not exist.\n";
    }

    my $content = $base_path->slurp();
    $filepath->spew_utf8($content);
}

1;
