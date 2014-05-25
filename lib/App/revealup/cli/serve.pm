package App::revealup::cli::serve;
use strict;
use warnings;
use Getopt::Long qw/GetOptionsFromArray/;
use File::ShareDir qw/dist_dir/;
use Path::Tiny qw/path/;
use Text::MicroTemplate qw/render_mt/;
use Plack::Runner;

my $_plack_port = 5000;
my $_dry_run = 0;
my $_theme_path = '';

sub run {
    my ($self, @args) = @_;
    my $_theme;
    GetOptionsFromArray( \@args, 
                         'p|port=s' => \$_plack_port,
                         'theme=s' => \$_theme,
                         'dry-run' => \$_dry_run );
    my $filename = shift @args;
    die "Markdown filename is required in args.\n" unless $filename;
    die "File: $filename is not found.\n" unless path($filename)->exists;
    $_theme_path = path('.', $_theme) if $_theme;

    my $html = $self->render($filename);
    my $app = $self->app($html);
    my $runner = Plack::Runner->new();
    $runner->parse_options("--port=$_plack_port");
    $runner->run($app) if !$_dry_run;
}

sub render {
    my ($self, $filename) = @_;
    my $template_dir = $self->share_path([qw/share templates/]);
    my $template = $template_dir->child('slide.html.mt');
    my $content = $template->slurp_utf8();
    my $html = render_mt($content, $filename, $_theme_path)->as_string();
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
        }else{
            my $path;
            if($env->{PATH_INFO} =~ m!\.(?:md|mkdn)$!) {
                $path = path('.', $env->{PATH_INFO});
            }else{
                if($_theme_path && $env->{PATH_INFO} =~ m!$_theme_path$!){
                    if($_theme_path->exists) {
                        $path = path('.', $_theme_path);
                    }else{
                        my $revealjs_theme_path = $self->share_path([qw/share revealjs css theme/]);
                        $path = $revealjs_theme_path->child($_theme_path->basename);
                    }
                }else{
                    my $revealjs_dir = $self->share_path([qw/share revealjs/]);
                    $path = $revealjs_dir->child($env->{PATH_INFO});
                }
            }
            return $self->path_to_res($path);
        }
    };
}

sub path_to_res {
    my ($self, $path) = @_;
    if( $path && $path->exists ) {
        my $c = $path->slurp();
        return [200, [ 'Content-Length' => length $c ], [$c]];
    }else{
        return [404, [], ['not found.']];
    }
}

sub share_path {
    my ($self, $p) = @_;
    die "Parameter must be ARRAY ref" unless ref $p eq 'ARRAY';
    my $path = path(@$p);
    return $path if $path->exists();
    shift @$p;
    my $dist_dir = dist_dir('App-revealup');
    return path($dist_dir, @$p);
}

1;

