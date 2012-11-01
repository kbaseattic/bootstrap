#!/usr/bin/env perl

#
# For all the perl scripts in the bindir, if they don't have the correct shebang,
# fix them.
#

@ARGV == 1 or die "Usage: $0 destdir\n";
my $dest = shift;

my $shebang = "#!/usr/bin/env kbperl";


for my $file (<$dest/bin/*>)
{
    open(F, "<", $file);
    my $l = <F>;
    close(F);
    
    if ($l =~ m,^\#\!.*perl,)
    {
	chomp $l;
	if ($l eq $shebang)
	{
	    print "$file OK\n";
	    next;
	}
	else
	{
	    print "Fix $file\n";
	    my @s = stat($file);
	    @s or die "Cannot stat $file: $!";
	    my $mode = $s[2];
	    my $bak = "$file.bak";
	    rename($file, $bak) or die "Cannot rename $file $bak: $!";
	    open(F, "<", $bak) or die "Cannot open $bak: $!";
	    open(T, ">", $file) or die "Cannot open $file for writing: $!";
	    $l = <F>;
	    print T "$shebang\n";
	    while (<F>)
	    {
		print T $_ or die "Erorr writing $file: $!";
	    }
	    close(F);
	    close(T) or die "Error closing $file: $!\n";
	    chmod $mode, $file or die "Cannot chmod file to $mode: $!";
	    unlink($bak);
	}
    }
    else
    {
	print "$file not perl\n";
	next;
    }
}
