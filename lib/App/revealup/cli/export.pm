package App::revealup::cli::export;
use App::revealup::base;
use Pod::Usage;
use Try::Tiny;
use Carp qw/croak/;

has 'sub_commands' => [qw/html theme/];

sub run {
    my ($self, $sub_command, @args) = @_;
    usage() if !$sub_command;
    if ($sub_command eq 'generate'){
        $sub_command = 'theme';
    }
    if( grep { $_ eq $sub_command } @{$self->sub_commands} ) {
        my $klass = sprintf("App::revealup::cli::export::%s", lc($sub_command));
        if(eval "require $klass;1;"){
            my $instance = $klass->new();
            try {
                $instance->run(@args);
            }catch{
                croak $_;
            };
            return;
        }
    }
    usage();
}

sub usage {
    system "perldoc App::revealup::cli::export";
    exit;
}

1;

__END__


=head1 SYNOPSIS

    $ revealup export html --output slides.html

=head1 DESCRIPTION

C<export> command with a sub-command makes file of CSS theme or generated HTML.

=head1 SUB COMMAND: C<theme>

    $ revealup export theme --base blood.css --output theme.css

=head2 Options

=head3 C<--base>

The base CSS file name that is included in C<reveal.js> package. Available base theme CSS names are below.

    beige.css / blood.css / default.css / moon.css / night.css / serif.css / simple.css / sky.css / solarized.css

=head3 C<--output>

Output CSS file name. I<original.css> is default.

=head1 SUB COMMAND: C<html>

    $ revealup export html slides.md --theme ./origina.css --output slides.html

=head2 Options

=head3 C<--theme>

CSS file name or original CSS file path. Your can use the C<reveal.js> default CSS file names.

=head3 C<--transition>

Trasition effects for slides. C<default, cube, page, concave, zoom, linear, fade, none> are available.

=head3 C<--width>

Width of a slide's size. Default is 960.

=head3 C<--height>

Height of a slide's size. Default is 700.

=head3 C<--output>

Output HTML file name. I<original.html> is default.

=head1 MORE INFORMATION

    $ perldoc App::revealup

=cut
