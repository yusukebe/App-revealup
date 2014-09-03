requires 'perl', '5.008001';

requires 'Try::Tiny';
requires 'Getopt::Long';
requires 'File::ShareDir';
requires 'Path::Tiny';
requires 'Text::MicroTemplate';
requires 'Plack';

on 'test' => sub {
    requires 'Test::More', '0.98';
    requires 'Test::TCP';
    requires 'Capture::Tiny';
    requires 'LWP::UserAgent';
    requires 'FindBin';
};
