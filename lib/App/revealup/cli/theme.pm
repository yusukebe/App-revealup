package App::revealup::cli::theme;
use strict;
use warnings;
use Getopt::Long qw/GetOptionsFromArray/;
use File::ShareDir qw/dist_dir/;
use Path::Tiny qw/path/;
use Pod::Usage;
use App::revealup::util;

my $_dry_run = 0;
my $_base = 'default';
my $_output = 'original.css';

sub run {
    my ($self, @args) = @_;
    my $result = GetOptionsFromArray( \@args, 
                         'base=s' => \$_base,
                         'output=s' => \$_output,
                         '_dry-run' => \$_dry_run );
    my $sub_command = shift @args || '';
    if( !$result || !$sub_command || $sub_command ne 'generate' ) {
        pod2usage({-input => __FILE__, -verbose => 2, -output => \*STDERR});
    }
    $self->generate(@args);
}

sub generate {
    my ($self, @args) = @_;

    my $filepath = path('.', $_output);
    if ($filepath->exists) {
        die "[Warning] $filepath exists.\n";
    }

    my $base = $_base !~ m!\.css$! ? $_base . '.css' : $_base;
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

=over 4

=item beige.css

=item blood.css

=item default.css

=item moon.css

=item night.css

=item serif.css

=item simple.css

=item sky.css

=item solarized.css  

=back

=head2 --output

Output CSS filename. I<original.css> is default.

=head1 MORE INFORMATION

    $ perldoc App::revealup

=cut
