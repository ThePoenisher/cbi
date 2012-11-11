#!/usr/bin/perl
# Passes all its args to `git log` and puts <OK> behind every commit, that is verified by git-verify-commit-signature.sh
sub check{
		my ($H)=@_;
		return substr($H,0,8).
				(system("git-verify-commit-signature.sh $H > /dev/null")==0 ?
				 "<OK>" : "");
}

my $a=join(" ",@ARGV);
my $r=`git log --color $a`;
		
$r =~ s/([0-9a-f]{40})/check($1)/ge;
print $r;
