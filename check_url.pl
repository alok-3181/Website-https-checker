#!/usr/bin/perl
use warnings;
use strict;
use Tie::File;
`rm -rf status.txt`;
my $input_file = 'final.txt';       # From where program will read WEB Addresses
die "File $input_file is not exist\n" unless (-e $input_file);
my ($stat_code, @all_addr) = ();
tie @all_addr, 'Tie::File', 
    $input_file or error("Cant open $input_file to read addresses");
for (0 .. $#all_addr) {
 chop $all_addr[$_] if ($all_addr[$_] =~ /\s+$/);
  #if $all_addr[$_] =~ /^http:\/\/\S+\.\w{2,4}$/);  
      #address will beginnig with http://,next some string
      # finish with point and 2 to 4 letters
     my $site = "http://".$all_addr[$_];
     $stat_code = `curl -Ls -o /dev/null -w "%{url_effective}" $site`;
     `echo $stat_code| grep https`;
     if ( $? eq 0) 
     {
     printf "$all_addr[$_] $stat_code TRUE\n";
     my $filename = 'status.txt';
     open(my $fh, '>>', $filename) or die "Could not open file '$filename' $!";
     print $fh "$all_addr[$_] $stat_code TRUE\n";
     close $fh;
     }
     else 
     {
     printf "$all_addr[$_] $stat_code FALSE\n";
     my $filename = 'status.txt';
     open(my $fh, '>>', $filename) or die "could not open file '$filename' $!";
     print $fh "$all_addr[$_] $stat_code FALSE\n";
     close $fh;
     }
 }
