package App::revealup::cli::export::html;
use App::revealup::base;
use App::revealup::util;
use App::revealup::builder;
use Path::Tiny qw/path/;
use Term::ANSIColor;
use Pod::Usage;

has 'theme';
has 'transition';
has 'width';
has 'height';
has 'output' => 'original.html';

sub run {
    my ($self, @args) = @_;
    my $opt;
    parse_options(
        \@args,
        'theme=s' => \$opt->{theme},
        'transition=s' => \$opt->{transition},
        'width=i' => \$opt->{width},
        'height=i' => \$opt->{height},
        'output=s' => \$opt->{output},
    );
    for my $key (keys %$opt) {
        $self->$key( $opt->{$key} );
    }

    if (path($self->output)->exists) {
        App::revealup::util::error("@{[$self->output]} exists");
    }

    my $filename = shift @args;
    if (!path($filename)->exists) {
        App::revealup::util::error("$filename is not exist");
    }
    
    my $builder = App::revealup::builder->new(
        filename => $filename || '',
        theme => $self->theme || '',
        transition => $self->transition || '',
        width => $self->width || 0,
        height => $self->height || 0,
    );
    
    my $html = $builder->build_html();
    die if !$html;
    path($self->output)->spew_utf8($html);
    App::revealup::util::info("Generated your HTML to @{[$self->output]}");
    my $reveal_path = App::revealup::util::share_path([qw/share revealjs/]);
    App::revealup::util::info("Copy command for the revealjs directory is:");
    App::revealup::util::info("cp -r @{[$reveal_path->absolute]} ./revealjs");
}

1;
