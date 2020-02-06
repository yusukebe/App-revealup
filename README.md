[![Build Status](https://travis-ci.org/yusukebe/App-revealup.svg?branch=master)](https://travis-ci.org/yusukebe/App-revealup)
# NAME

App::revealup - HTTP Server application for viewing Markdown formatted text as slides

# SYNOPSIS

    $ revealup serve slide.md --port 5000

# DESCRIPTION

**App::revealup** is a web application module for giving Markdown-driven presentations. The `revealup` command starts a local web server to serve the your markdown presentation file with **reveal.js**. The presentation can be viewed in a web browser. The reveal.js library offers comprehensive presenting features such as slide transitions, speaker notes and more.

## Sample Markdown

    ## This is an H2 Title
    
    Description... The horizontal slide separator characters are '---'
    
    ---
    
    ## This is second title
    
    The vertical slide separator characters are '___'
    
    ___
    
    ## This is a third title

    ---

    ## This is a forth title
    <!-- .slide: data-background="#f70000" data-transition="page" -->
    
    You can add slide attributes like above.

    Note:
    This is a speaker note. It can be viewed in the speaker mode, just press S during the presentation to view notes and other useful information.

# COMMANDS

- `serve`

        $ revealup serve markdown.md --theme night.css

    `serve` command launch the HTTP server for showing slides on your web browser.

    SEE MORE: [App::revealup::cli::serve](https://metacpan.org/pod/App%3A%3Arevealup%3A%3Acli%3A%3Aserve)

- `export`

        $ revealup export theme --base beige.css --output style.css

    `export` command generate the files such as CSS of the theme and HTML for the slides.

    SEE MORE: [App::revealup::cli::export](https://metacpan.org/pod/App%3A%3Arevealup%3A%3Acli%3A%3Aexport)

# LICENSE

Copyright (C) Yusuke Wada.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

## reveal.js

`reveal.js` is by Hakim El Hattab, [http://hakim.se](http://hakim.se).

[https://github.com/hakimel/reveal.js/](https://github.com/hakimel/reveal.js/)

# AUTHOR

Yusuke Wada <yusuke@kamawada.com>
