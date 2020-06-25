################################################################################
# Autor: Grzegorz Okoñ - g³ówny programista
#
# Obserwacja wielkoœci kolejek i statusu w¹tków na serwerze replikacji Sybase.
# Pokazywane s¹ w¹tki, których status jest ró¿ny od aktywnych.
#
# Przyk³ad formatu u¿ytego w logu:
# admin who_is_down 
# 
#  Spid Name       State                Info
#  ---- ---------- -------------------- ----------------------------------------
# 
#
# mj_kol
#
#  Polaczenie                                         typ_kolejki kolejka 
#  -------------------------------------------------- ----------- -----------
#  nazwa_polaczenia                                    Otbound              1  
#  nazwa_polaczenia                                    Inbound              1
#################################################################################

use strict;
use warnings;

my $console = $ARGV[0];

my $threads = 'admin_who_is_down_xxx_yyyy.bat';
my $queues = 'mj_kol_xx_RSSD.bat';
my $flag = 0;

open (RESULT_ETIQUETTE, ">REP1.txt") || die "nie mozna utworzyc pliku";

open (INPUT_FILE,"$threads|");   
while (<INPUT_FILE>) {	
   if($_ =~ /Spid\s+/) { 
      $flag = 1;
	  open (RESULT_ETIQUETTE, ">>REP1.txt") || die "nie moge utworzyc polaczenia do konsoli";
      print RESULT_ETIQUETTE "admin who_is_down\n\n";
	  if (defined $console) {
	     open (RESULT_ETIQUETTE, ">&STDOUT") || die "nie moge utworzyc polaczenia do konsoli";
		 print RESULT_ETIQUETTE "admin who_is_down\n\n";
	  }
   }
   if ($flag == 1) {
      open (RESULT_ETIQUETTE, ">>REP1.txt") || die "nie moge utworzyc polaczenia do konsoli";
      print RESULT_ETIQUETTE $_;
	  if (defined $console) {
	     open (RESULT_ETIQUETTE, ">&STDOUT") || die "nie moge utworzyc polaczenia do konsoli";
		 print RESULT_ETIQUETTE $_;
	  }
   }
}
close INPUT_FILE;

$flag = 0;
open (INPUT_FILE,"$queues|"); 
while (<INPUT_FILE>) {	
   if($_ =~ /Polaczenie\s+/) { 
      $flag = 1;
	  open (RESULT_ETIQUETTE, ">>REP1.txt") || die "nie moge utworzyc polaczenia do konsoli";
      print RESULT_ETIQUETTE "\n\nmj_kol\n\n";
	  if (defined $console) {
	     open (RESULT_ETIQUETTE, ">&STDOUT") || die "nie moge utworzyc polaczenia do konsoli";
		 print RESULT_ETIQUETTE "\n\nmj_kol\n\n";
	  }
   }
   if($_ =~ /row/) { 
      $flag = 0;
   }
   if ($flag == 1) {
      print RESULT_ETIQUETTE $_;
   }
}
close INPUT_FILE;

format RESULT_ETIQUETTE =
.