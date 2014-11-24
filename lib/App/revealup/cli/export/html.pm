package App::revealup::cli::export::html;
use App::revealup::base;
use App::revealup::util;
use App::revealup::builder;
use Path::Tiny qw/path/;

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

    my $filename = shift @args;
    my $builder = App::revealup::builder->new(
        filename => $filename || '',
        theme => $self->theme || '',
        transition => $self->transition || '',
        width => $self->width || 0,
        height => $self->height || 0,
    );
    
    my $html = $builder->build_html();
    if(!$html) {
        #XXX
    }
    print "Generate your HTML to @{[$self->output()]}.\n";
    path($self->output)->spew_utf8($html);
}

1;
