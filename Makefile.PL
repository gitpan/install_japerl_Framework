use strict;
use ExtUtils::MakeMaker;

if ($^O ne 'MSWin32') {
    warn "This distribution is only for Microsoft Windows.\n";
    exit 0;
}

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'             => 'install_japerl_Framework.bat',
    'VERSION_FROM'     => 'META.yml', # finds $VERSION
    ($] >= 5.005 ?                    # Add these new keywords supported since 5.005
      ('PREREQ_PM'     => {},         # e.g., Module::Name => 1.1
       'ABSTRACT_FROM' => 'META.yml', # retrieve abstract from module
       'AUTHOR'        => 'ina <ina@cpan.org>',
      )
      :
      ()
    ),
);
__END__
