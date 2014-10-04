#!/usr/bin/perl

use strict;
use Cwd qw(abs_path getcwd);
use Getopt::Long;
use Pod::Usage;
use Data::Dumper;

use vars qw($help $dest $module_dat);
GetOptions('h'    => \$help,
	   'help' => \$help,
	   'd=s'    => \$dest,
	   'm=s'    => \$module_dat,
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

my %modules;

while (<DAT>)
{
    chomp;
    s/^\s*//;
    next if /^#/;
    my($dir, $cmd) = split(/\s+/, $_, 2);
    die "error parsing $module_dat" unless ($dir && $cmd);
    die "directory $dir does not exist" unless -d $dir;
    die "directory $dir is not executable" unless -e $dir;
    die "directory $dir is not writable" unless -w $dir;

    my $rec = [$dir, $dir, $cmd];
    push(@modules, $rec);
    push(@{$modules{$dir}}, $rec);
}
close(DAT);

#
# Rewrite dir-tag element ($rec[1]) for the
# directories that have more than one build record.
#

for my $dir (keys %modules)
{
    my $l = $modules{$dir};
    if (@$l > 1)
    {
	for my $i (0..$#$l)
	{
	    my $n = $i + 1;
	    $l->[$i]->[1] = "${dir}_$n";
	}
    }
}

# print Dumper(\@modules);

for my $mod (@modules)
{
    my($dir, $tag, $cmd) = @$mod;

    if (-f "$log_dir/built.$tag")
    {
	print "$tag already built\n";
	next;
    }

    my $to_run = "cd $dir; $cmd 2>&1";

    open(LOG, ">", "$log_dir/$tag") or die "Cannot open logfile $log_dir/$tag: $!";
    open(RUN, "$to_run |") or die "Cannot open pipe $to_run: $!";

    print LOG "$to_run\n";
    print "$to_run\n";

    while (<RUN>)
    {
	s/%/%%/g;
	printf "%-10s $_", $tag;
	print LOG $_;
    }
    if (!close(RUN))
    {
	if ($!)
	{
	    die "Error running $to_run: $!\n";
	}
	else
	{
	    die "Command $to_run failed with nonzero status $?\n";
	}
    }
    system("touch", "$log_dir/built.$tag");
    close(LOG);
}

system("git describe --always --tags > $dest/VERSION") == 0 or die "could not write VERSION file to $dest";



=pod

=head1  NAME

bootstrap_modules.pl

=head1  SYNOPSIS

=over

=item bootstrap_modules.pl -d /kb/runtime -m ./my_modules.dat

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
