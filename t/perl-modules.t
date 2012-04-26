#!/kb/runtime/bin/perl
use strict;
use warnings;
use Test::More;
use Try::Tiny;
use File::Basename;
use Cwd qw(abs_path);
my $testCount = 0;
# go through each package in 
# ../kb_perl_runtime/module-list
# and try to require them
my $dir = dirname(abs_path($0));
my $moduleListFile = "$dir/../kb_perl_runtime/module-list";
open(my $fh, "<", $moduleListFile) || die("Could not open file: $moduleListFile: $!");
my $failedPackages = {};
while(my $package = <$fh>) {
    # don't include if commented out
    next if $package =~ m/^#/;
    # remove "Pacakge::Trailing  --parameters"
    chomp $package;
    $package =~ s/\s.*//;
    my $success = 0;
    try {
        require $package;
        $success = 1;
    };
    ok($success, "Failed to find required package $package");
    $testCount += 1;
}

done_testing($testCount);
