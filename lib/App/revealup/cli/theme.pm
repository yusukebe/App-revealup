package App::revealup::cli::theme;
use App::revealup::base;
use Getopt::Long qw/GetOptionsFromArray/;
use File::ShareDir qw/dist_dir/;
use Path::Tiny qw/path/;
use Pod::Usage;
use App::revealup::util;

has 'dry_run' => 0;
has 'base' => 'default';
has 'output' => 'original.css';

sub run {
    my ($self, @args) = @_;
    my $opt;
    my $result = parse_options(
        \@args,
        'base=s'   => \$opt->{base},
        'output=s' => \$opt->{output},
        '_dry-run' => \$opt->{dry_run}
    );

    for my $key (keys %$opt) {
        $self->$key( $opt->{$key} );
    }

    my $sub_command = shift @args || '';
    if( !$result || !$sub_command || $sub_command ne 'generate' ) {
        pod2usage({-input => __FILE__, -verbose => 2, -output => \*STDERR});
    }
    $self->generate(@args);
}

sub generate {
    my ($self, @args) = @_;

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
    $filepath->spew($content);
}

1;

__END__

=head1 SYNOPSIS

    $ revealup theme generate

=head1 DESCRIPTION

I<theme> command with I<generate> sub-command makes skeleton of theme CSS file.

=head1 Options

=head2 --base

The base CSS file name that is included in reveal.js package.
Available base theme CSS names are below.

    beige.css / blood.css / default.css / moon.css / night.css / serif.css / simple.css / sky.css / solarized.css

=head2 --output

Output CSS filename. I<original.css> is default.

=head1 MORE INFORMATION

    $ perldoc App::revealup

=cut
