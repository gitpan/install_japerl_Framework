@rem = '--*-Perl-*--
@echo off
if "%OS%" == "Windows_NT" goto WinNT
perl -x -S "%0" %1 %2 %3 %4 %5 %6 %7 %8 %9
goto endofperl
:WinNT
perl -x -S "%0" %*
if NOT "%COMSPEC%" == "%SystemRoot%\system32\cmd.exe" goto endofperl
if %errorlevel% == 9009 echo You do not have Perl in your PATH.
exit /b %errorlevel%
goto endofperl
@rem ';
#!perl
#line 15
undef @rem;
######################################################################
#
# install_japerl_Framework.bat - japerl_Framework installer for Microsoft Windows
#
# http://search.cpan.org/~ina/
#
# Copyright (c) 2014 INABA Hitoshi <ina@cpan.org>
######################################################################

use 5.00503;
$::VERSION = 0.01;
use strict;
BEGIN {
    if ($^O ne 'MSWin32') {
        die "This program can run only on Microsoft Windows.\n";
    }
}
use File::Basename;
use File::Path;
use File::Copy;
use LWP::Simple;
use Compress::Zlib;
use Archive::Tar;

my $encoding = {

    # Code Page Identifiers (Windows)
    # Identifier .NET Name Additional information

      '708' => 'Arabic',      # ASMO-708 Arabic (ASMO 708)
      '874' => 'TIS620',      # windows-874 ANSI/OEM Thai (same as 28605, ISO 8859-15); Thai (Windows)
      '932' => 'Sjis',        # shift_jis ANSI/OEM Japanese; Japanese (Shift-JIS)
      '936' => 'GBK',         # gb2312 ANSI/OEM Simplified Chinese (PRC, Singapore); Chinese Simplified (GB2312)
      '949' => 'UHC',         # ks_c_5601-1987 ANSI/OEM Korean (Unified Hangul Code)
      '950' => 'Big5Plus',    # big5 ANSI/OEM Traditional Chinese (Taiwan; Hong Kong SAR, PRC); Chinese Traditional (Big5)
      '951' => 'Big5HKSCS',   # HKSCS support on top of traditional Chinese Windows
     '1252' => 'Windows1252', # windows-1252 ANSI Latin 1; Western European (Windows)
     '1255' => 'Hebrew',      # windows-1255 ANSI Hebrew; Hebrew (Windows)
     '1258' => 'Windows1258', # windows-1258 ANSI/OEM Vietnamese; Vietnamese (Windows)
    '20127' => 'USASCII',     # us-ascii US-ASCII (7-bit)
    '20866' => 'KOI8R',       # koi8-r Russian (KOI8-R); Cyrillic (KOI8-R)
    '20932' => 'EUCJP',       # EUC-JP Japanese (JIS 0208-1990 and 0121-1990)
    '21866' => 'KOI8U',       # koi8-u Ukrainian (KOI8-U); Cyrillic (KOI8-U)
    '28591' => 'Latin1',      # iso-8859-1 ISO 8859-1 Latin 1; Western European (ISO)
    '28592' => 'Latin2',      # iso-8859-2 ISO 8859-2 Central European; Central European (ISO)
    '28593' => 'Latin3',      # iso-8859-3 ISO 8859-3 Latin 3
    '28594' => 'Latin4',      # iso-8859-4 ISO 8859-4 Baltic
    '28595' => 'Cyrillic',    # iso-8859-5 ISO 8859-5 Cyrillic
    '28596' => 'Arabic',      # iso-8859-6 ISO 8859-6 Arabic
    '28597' => 'Greek',       # iso-8859-7 ISO 8859-7 Greek
    '28598' => 'Hebrew',      # iso-8859-8 ISO 8859-8 Hebrew; Hebrew (ISO-Visual)
    '28599' => 'Latin5',      # iso-8859-9 ISO 8859-9 Turkish
    '28603' => 'Latin7',      # iso-8859-13 ISO 8859-13 Estonian
    '28605' => 'Latin9',      # iso-8859-15 ISO 8859-15 Latin 9
    '51932' => 'EUCJP',       # euc-jp EUC Japanese
    '54936' => 'GB18030',     # GB18030 Windows XP and later: GB18030 Simplified Chinese (4 byte); Chinese Simplified (GB18030)
    '65001' => 'UTF2',        # utf-8 Unicode (UTF-8)

}->{(qx{chcp} =~ m/([0-9]{3,5}) \Z/oxms)[0]};

my @dist = split(/\n\n/,<<END);
http://search.cpan.org/dist/japerl/
japerl.bat japerl.bat

http://search.cpan.org/dist/jacode/
jacode.pl lib/jacode.pl

http://search.cpan.org/dist/Char-$encoding/
$encoding.pm lib/$encoding.pm
E\L$encoding\E.pm lib/E\L$encoding\E.pm

http://search.cpan.org/dist/Strict-Perl/
Strict/Perl.pm lib/Strict/Perl.pm

http://search.cpan.org/dist/Stable-Module/
Stable/Module.pm lib/Stable/Module.pm

END

push @dist, split(/\n\n/,<<END) if $encoding eq 'Sjis';
http://search.cpan.org/dist/SjisTk/
SjisTk.pm lib/SjisTk.pm
SjisTk/Button.pm lib/SjisTk/Button.pm
SjisTk/Canvas.pm lib/SjisTk/Canvas.pm
SjisTk/Checkbutton.pm lib/SjisTk/Checkbutton.pm
SjisTk/ColorEditor.pm lib/SjisTk/ColorEditor.pm
SjisTk/Dialog.pm lib/SjisTk/Dialog.pm
SjisTk/DialogBox.pm lib/SjisTk/DialogBox.pm
SjisTk/Entry.pm lib/SjisTk/Entry.pm
SjisTk/Frame.pm lib/SjisTk/Frame.pm
SjisTk/Label.pm lib/SjisTk/Label.pm
SjisTk/LabFrame.pm lib/SjisTk/LabFrame.pm
SjisTk/Listbox.pm lib/SjisTk/Listbox.pm
SjisTk/MainWindow.pm lib/SjisTk/MainWindow.pm
SjisTk/Message.pm lib/SjisTk/Message.pm
SjisTk/Radiobutton.pm lib/SjisTk/Radiobutton.pm
SjisTk/ROText.pm lib/SjisTk/ROText.pm
SjisTk/Scale.pm lib/SjisTk/Scale.pm
SjisTk/Table.pm lib/SjisTk/Table.pm
SjisTk/Text.pm lib/SjisTk/Text.pm
SjisTk/Toplevel.pm lib/SjisTk/Toplevel.pm

http://search.cpan.org/dist/DBD-mysqlPPrawSjis/
DBD/mysqlPPrawSjis.pm lib/DBD/mysqlPPrawSjis.pm

END

push @dist, split(/\n\n/,<<END) if $] < 5.006;
http://search.cpan.org/dist/Modern-Open/
Modern/Open.pm lib/Modern/Open.pm

http://search.cpan.org/dist/Fake-Our/
Fake/Our.pm lib/Fake/Our.pm

END

while (my $dist = shift @dist) {
    my($url,@from_to) = split(/\n/,$dist);

    my $page = LWP::Simple::get($url);
    if (my($download_url) = $page =~ m{<a href="([^"]+)">Download</a>}i) {
        if (my($basename_ver_targz) = $download_url =~ m{/([^/]+)$}) {
print STDERR "Download: $basename_ver_targz\n";
            LWP::Simple::getstore(qq{http://search.cpan.org/$download_url},$basename_ver_targz);

            tar_xzvf($basename_ver_targz);

            (my $dirname = $basename_ver_targz) =~ s{\.tar\.gz$}{};
            while (my $from_to = shift @from_to) {
                my($from,$to) = split(/ +/,$from_to);
# print STDERR "Copy: $from --> $to\n";
                File::Path::mkpath(File::Basename::dirname($to),0,0777);
                File::Copy::copy(qq{$dirname/$from},$to);
            }
# print STDERR "Delete: $basename_ver_targz\n";
            unlink($basename_ver_targz);
            File::Path::rmtree($dirname,0,0);
        }
    }
}

open(CONF,'>japerl.bat.conf.EditMe') || die "Can't open file: jacode.bat.conf.EditMe";
(my $perlbin = $^X) =~ s#\\#/#g;
print CONF <<END;
#############################################################
# Edit and confirm this file, then save as "japerl.bat.conf"
#############################################################

# Configuration file of japerl.bat
+{
    PERL5BIN => '$perlbin',
    PERL5LIB => [ qw(mylib ourlib lib) ],
    ENCODING => '$encoding',
END
print CONF <<END if $] < 5.006;
    PERL5OPT => '-MModern::Open',             # for perl 5.00503, see http://search.cpan.org/dist/Modern-Open/
#   PERL5OPT => '-MModern::Open -MFake::Our', # is deprecated,    see http://search.cpan.org/dist/Fake-Our/
END
print CONF <<END;
}
__END__
END
close(CONF);

system(qq{notepad.exe japerl.bat.conf.EditMe});

exit;

sub tar_xzvf {
    my($targzfile) = @_;

    my $gz = gzopen($targzfile, 'rb');
    (my $tarfile = $targzfile) =~ s/\.gz$//xmsi;
    open(FH_TAR, ">$tarfile") || die "Can't open file: $tarfile\n";
    binmode FH_TAR;
    while ($gz->gzreadline(my $line)) {
        print FH_TAR $line;
    }
    $gz->gzclose;
    close FH_TAR;

    my $tar = Archive::Tar->new($tarfile,1);
    for my $file ($tar->list_files){
        if (-e $file) {
print STDERR "skip $file is already exists.\n";
        }
        else {
# print STDERR "x $file\n";
            $tar->extract($file);
        }
    }
    unlink $tarfile;
}

__END__

=pod

=head1 NAME

install_japerl_Framework.bat - japerl_Framework installer for Microsoft Windows

=head1 SYNOPSIS

  C:\WINDOWS> install_japerl_Framework.bat [Enter]

  Edit and confirm "japerl.bat.conf.EditMe", then save as "japerl.bat.conf"

=head1 DESCRIPTION

  install_japerl_Framework.bat provides japerl_Framework environment to your
  local directory. This software is for Microsoft Windows.

  The following software will be installed by install_japerl_Framework.bat

=over 4

=item * japerl.bat

=item * jacode.pl

=item * Any one of Sjis software family (ex. Sjis)

=item * Strict::Perl

=item * Stable::Module

=back

  If encoding is Sjis, the following software too

=over 4

=item * SjisTk

=item * DBD::mysqlPPrawSjis

=back

  If perl is older than 5.006, the following software too

=over 4

=item * Modern::Open

=item * Fake::Our

=back

=head1 BUGS and LIMITATIONS

I have tested and verified this software using the best of my ability.
However, a software containing much regular expression is bound to contain
some bugs. Thus, if you happen to find a bug that's in Sjis software and not
your own program, you can try to reduce it to a minimal test case and then
report it to the following author's address. If you have an idea that could
make this a more useful tool, please let everyone share it.

=head1 AUTHOR

INABA Hitoshi E<lt>ina@cpan.orgE<gt>

This project was originated by INABA Hitoshi.

=head1 LICENSE AND COPYRIGHT

This software is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

This software is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

=head1 SEE ALSO

=over 4

=item * L<ina|http://search.cpan.org/~ina/> - CPAN

=item * L<The BackPAN|http://backpan.perl.org/authors/id/I/IN/INA/> - A Complete History of CPAN

=back

=cut

:endofperl
