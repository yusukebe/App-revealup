requires 'perl', '5.008001';

requires 'Try::Tiny', '0.060';
requires 'Getopt::Long';
requires 'File::chdir';
requires 'File::ShareDir';
requires 'Path::Tiny';
requires 'Text::MicroTemplate';
requires 'Plack';
requires 'MIME::Types';

on 'test' => sub {
    requires 'Test::File::Contents', '0.20';
    requires 'Test::More', '0.98';
    requires 'Test::TCP', '2.06';
    requires 'Capture::Tiny';
    requires 'LWP::UserAgent';
    requires 'FindBin';
};
