package App::revealup;
use 5.008005;
use strict;
use warnings;

our $VERSION = "0.01";

1;
__END__

=encoding utf-8

=head1 NAME

App::revealup - HTTP Server app for viewing Markdown texts as slides

=head1 SYNOPSIS

    revealup serve slide.md --port 5000

=head1 DESCRIPTION

App::revealup is a web application mobule to showing Markdown with reveal.js. Markdown texts will be like a slideshow if you use this revealup command.

=head2 Sample Markdown

    ## This is Title
    
    Description... The page separetor charactors are '---'
    
    ---
    
    ## This is second title

=head1 LICENSE

Copyright (C) Yusuke Wada.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Yusuke Wada E<lt>yusuke@kamawada.comE<gt>

=cut

