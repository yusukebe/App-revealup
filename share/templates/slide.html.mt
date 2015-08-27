? my ($filename, $theme, $transition, $size) = @_;
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <link rel="stylesheet" href="revealjs/css/reveal.css">
? if($theme) {
    <link rel="stylesheet" href="<?= $theme ?>" id="theme">
? }else{
    <link rel="stylesheet" href="revealjs/css/theme/black.css" id="theme">
? }
    <link rel="stylesheet" href="revealjs/lib/css/zenburn.css">
    <!-- If the query includes 'print-pdf', use the PDF print sheet -->
    <script>
      document.write( '<link rel="stylesheet" href="revealjs/css/print/' + ( window.location.search.match( /print-pdf/gi ) ? 'pdf' : 'paper' ) + '.css" type="text/css" media="print">' );
    </script>
    <!--[if lt IE 9]>
      <script src="revealjs/lib/js/html5shiv.js"></script>
    <![endif]-->
  </head>

  <body>
    <div class="reveal">
      <div class="slides">
        <section data-markdown="<?= $filename ?>"
                 data-separator="^---"
                 data-separator-vertical="^___"
                 data-charset="utf-8"
                 data-notes="^Note:">
        </section>
      </div>
    </div>

    <script src="revealjs/lib/js/head.min.js"></script>
    <script src="revealjs/js/reveal.js"></script>

    <script>
      Reveal.initialize({
        width: <?= $size->{width} ?>,
        height: <?= $size->{height} ?>,
        controls: true,
        progress: true,
        history: true,
        center: true,
        theme: Reveal.getQueryHash().theme, // available themes are in /css/theme
        transition: Reveal.getQueryHash().transition || '<?= $transition ?>', // default/cube/page/concave/zoom/linear/fade/none
        // Optional libraries used to extend on reveal.js
        dependencies: [
          { src: 'revealjs/lib/js/classList.js', condition: function() { return !document.body.classList; } },
          { src: 'revealjs/plugin/markdown/marked.js', condition: function() { return !!document.querySelector( '[data-markdown]' ); } },
          { src: 'revealjs/plugin/markdown/markdown.js', condition: function() { return !!document.querySelector( '[data-markdown]' ); } },
          { src: 'revealjs/plugin/highlight/highlight.js', async: true, callback: function() { hljs.initHighlightingOnLoad(); } },
          { src: 'revealjs/plugin/zoom-js/zoom.js', async: true, condition: function() { return !!document.body.classList; } },
          { src: 'revealjs/plugin/notes/notes.js', async: true, condition: function() { return !!document.body.classList; } }
        ]
      });
    </script>
  </body>
</html>
