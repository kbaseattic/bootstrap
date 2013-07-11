#!/usr/bin/perl

use strict;
use Cwd qw(abs_path getcwd);
use Getopt::Long;
use Pod::Usage;

use vars qw($help $dest $module_dat);
GetOptions('h'    => \$help,
	   'help' => \$help,
	   'd'    => \$dest,
	   'm'    => \$module_dat,
    ) or pod2usage(0);

pod2usage(-exitstatus => 0,
          -output => \*STDOUT,
          -verbose => 2,
          -noperldoc => 1,
    ) if (defined $help or (!defined $dest) or (!defined $module_dat));

$ENV{PATH} = "$dest/bin:$ENV{PATH}";

my $start_cwd = getcwd();
my $log_dir = "$start_cwd/logs";
-d $log_dir || mkdir $log_dir || die "Cannot mkdir $log_dir: $!";
my $log_dir = abs_path($log_dir);

$ENV{TARGET} = $dest;

open(DAT, "<", $module_dat) or die "Cannot open $module_dat: $!";

my @modules;

while (<DAT>)
{
    chomp;
    my($dir, $cmd, @rest) = split /\s+/;
    my $args = join(" ", @rest);
    die "error parsing $module_dat" unless ($dir && $cmd);
    die "directory $dir does not exist" unless -d $dir;
    die "directory $dir is not executable" unless -e $dir;
    die "directory $dir is not writable" unless -w $dir;

    if (-f "$log_dir/built.$dir")
    {
	print "$dir already built\n";
	next;
    }
    push(@modules, [$dir, $cmd, $args]);
}
close(DAT);

print Dumper(\@modules);

for my $mod (@modules)
{
    my($dir, $cmd, $args) = @$mod;
    chdir $dir or die "could not chdir into $dir";

    my $full_cmd = "$cmd $args >& $log_dir/$dir";
    !system($cmd, $args) or die "failed to execute $cmd $args: $!";
    system("touch", "$log_dir/built.$dir");

    chdir $start_cwd or die "could not chdir back to start dir";
}




=pod

=head1  NAME

[% kb_method_name %]

=head1  SYNOPSIS

=over

=item bootstrap.pl -d /kb/runtime -m ./my_modules.dat

=back

=head1  DESCRIPTION

The bootstrap.pl script reads a module.dat and runs a builder for each module. A module is defined as a directory that contains a builder script. For example, kb_blast is a directory that represents a blast module. In that directory is a script that installs blast.

=head1  CONVENTIONS

The module directory may contain a suffix. If there is no suffix, it is assumed that the installer inside that directory will properly install the module on all supported operating systems. If there is a suffix on the module directory in the form _ubuntu and _centos, then the installer inside that directory will properly install the module on the named operating system.

Examples include bootstrap_ubuntu and bootstrap_centos. In side bootstrap_ubuntu the builder script could use apt-get to install ubuntu modules and inside the bootstrap_centos directory the builder script could use yum to install centos modules.

=head1 MODULES FILE

The modules.dat file contains a space delimited set of module directories and builer scripts. You can think of this as the module directory being the key and the name of the builder script being the value if you want. In sort, the named builder script associated with each module directory will be executed.

=head1  COMMAND-LINE OPTIONS

=over

=item -h, --help  This documentation

=item -d Destination target for runtime (ie /kb/runtime)

=item -m Name of the modules.dat file

=back

=head1  AUTHORS

Robert Olson, Tom Brettin

=cut
