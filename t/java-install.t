#!/kb/runtime/bin/perl
use strict vars;
use warnings;
use Test::More;

$ENV{JAVA_HOME}     = "/kb/runtime/java";
$ENV{ANT_HOME}      = "/kb/runtime/ant";
$ENV{THRIFT_HOME}   = "/kb/runtime/thrift";
$ENV{CATALINA_HOME} = "/kb/runtime/tomcat";
$ENV{PATH}          = "$ENV{JAVA_HOME}/bin:$ENV{ANT_HOME}/bin:/kb/runtime/bin:$ENV{THRIFT_HOME}/bin:$ENV{CATALINA_HOME}/bin:$ENV{PATH}";

my $testCount = 0;

# keep adding tests to this list
my @tests = qw(start_tomcat  shutdown_tomcat);

foreach my $test (@tests) {
        &$test();
        $testCount++;
}

done_testing($testCount);

# write your tests as subroutnes, add the sub name to @tests

# attempt to start the tomcat server
sub start_tomcat {
        eval {!system("startup.sh > /dev/null") or die $!; sleep 60};
        ok(!$@, (caller(0))[3] );
}

# attempt to telnet to the tomcat server
# TODO finish this subroutine and add it to @tests
# easiest way is to install Net::Telnet maybe?
sub connect_to_tomcat {
        eval {!system("") or die $!; sleep 30};
        ok(!$@, (caller(0))[3] );
}

# attempt to shutdown the tomcat server
sub shutdown_tomcat {
        eval {!system("shutdown.sh > /dev/null") or die $!; sleep 30};
        ok(!$@, (caller(0))[3] );
}

