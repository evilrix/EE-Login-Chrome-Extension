#!/usr/bin/perl

use strict;
use threads;
use threads::shared;
use Thread::Queue;
use Date::Calc;
use XML::Simple;
use LWP::UserAgent;
use HTTP::Cookies;
use Getopt::Long;
use Data::Dumper;

# Add all user IDs here
my @uids = (
   # -- Snr Admins --
    621261, # Computer101
    698653, # Netminder
   
   # --   Admins   --
   1346757, # AnnieMod
   1328215, # BooMod
   4230925, # modus_operandi
   4481900, # WhackAMod
   4947778, # will_see
   
   # -- Moderators --
   5032103, # _alias99
   4723045, # coolleomod
   3306669, # DarthMod
   5046967, # DropBearMod
   1773779, # GhostMod
   5050994, # LadyModiva
    636257, # Lunchy
   4806300, # merry_mod
   5351960, # Mod_MarlEE
   5031943, # Modalot
   5145158, # Modawatt
   5031913, # ModEErf
   4701821, # ModernMatt
   3821453, # modguy
   4764598, # modus_in_rebus
   3494299, # PAQ_Man
   4920453, # quomodo
   5032449, # SouthMod
   5935014, # thermoduric
   3820901, # Vee_Mod
   5471512, # WallyMod
);

# Filters used to extract values
my %filters = (
      login => '<title>View Member - ([^>]+)</title>',
      rdate => '<span>([\d/]+)</span>\s+Registration Date',
      qansw => '<span>([\d,]+)</span>\s+Questions? Answered',
      qpart => '<span>([\d,]+)</span>\s+Questions? Participated In',
   );

# A global queue of work
my $queue = Thread::Queue->new();

# An output mutex (to make sure we can report thread errors safely)
my $output_mutex: shared;

# Authenticate with EE
sub authenticate {
   # We'll need a temporary cookie jar for authenticating
   my $cookie_jar = HTTP::Cookies->new({});
   
   # Next we need a user agent
   my $ua = LWP::UserAgent->new;
   $ua->timeout(60);
   $ua->cookie_jar($cookie_jar);
   
   # Some credentials
   my $user = "automod";
   my $pass = "0316at1na";
   
   # The endpoints
   my $uri = "https://secure.experts-exchange.com/login.jsp?msuLoginName=$user&msuPassword=$pass&msuLoginSubmit=1";
   
   # Create a request to authenticate
   my $req = HTTP::Request->new(POST => $uri);
   
   # Authenticate
   my $res = $ua->request($req);

   # Best endevours attempt to handle errors and authentication failure
   my $error = $res->is_error;
   unless($error) {
      my $content = $res->content;
      if($error = $content =~ /Invalid Username\/Email and Password combination/) {
         lock $output_mutex;
         print "AUTHENTICALTION FAILURE\n";
         return undef;
      }
   }

   # We now have an authenticated user agent, return it for use
   return $ua;
}

# Each thread will process the queue until it is drained
sub thread_proc {

   # Get an authenticated user agent (undef on error!)
   my $ua = authenticate;
   return unless defined $ua;

   # Create the XML result object
   my %results = (user => []);
   my $users = $results{user};

   # Process the queue
   while($queue->pending) {
      
      # Get an item from the queue and create a uri
      my $uid = $queue->dequeue_nb;
      
      if(defined $uid) {
         my $uri = "http://www.experts-exchange.com/M_$uid.html";

         # Create a HTTP request
         my $req = HTTP::Request->new(POST => $uri);
         $req->content_type('application/x-www-form-urlencoded');
   
         # Execute HTTP request and get a HTTP response
         my $res = $ua->request($req);
         
         # Get contents for processing
         my $content = $res->content;
         
         # Scrape the data
         my %result;
         $result{usrid} = $uid;
         $result{uprof} = $uri;
         $result{login} = $1 if($content =~ s/$filters{login}//);
         $result{rdate} = $1 if($content =~ s/$filters{rdate}//);
         $result{qansw} = $1 if($content =~ s/$filters{qansw}//);
         $result{qpart} = $1 if($content =~ s/$filters{qpart}//);

         # Remove numeric command (eg. 1,000,000 to 1000000) 
         $result{qansw} =~ s/,//g;
         $result{qpart} =~ s/,//g;
         
         # Get aggregated answer and question participation
         $result{aggre} = $result{qansw} + $result{qpart};
         
         #                      1:MM   2:DD   3:YY
         if($result{rdate} =~ /(\d+)\D(\d+)\D(\d+)/) {
            $result{rdate} = 2000+$3 . "-$1-$2"; # ISO format (we're not all American!!!
            $result{rdays} = Date::Calc::Delta_Days(2000+$3,$1,$2, Date::Calc::Today(1));
         }

         $result{aperd} = sprintf("%.3f", ($result{qansw} / $result{rdays}));
         $result{cperd} = sprintf("%.3f", ($result{qpart} / $result{rdays}));
         $result{gperd} = sprintf("%.3f", ($result{aggre} / $result{rdays}));
         
         push @$users, \%result;
      }
   }
   
   return %results;
}

# Add user ids to the queue for processing by thread pool
sub queue_work {
      # Add work to queue  
      foreach (@uids) {
         $queue->enqueue($_);
      }
      
      # Create thread pool and process queue
      foreach (1 .. 5) {
         threads->create(
            {'context' => 'list'},
            \&thread_proc
         )
      }
}

# Generate the report metics
sub generate_metrics {
   my $results = shift;
   my $users = $results->{user};
  
   # Total per day counts
   my %totals = (
         aperd => 0,
         cperd => 0,
         gperd => 0
      );

   # Accrue the total per day counts
   foreach (@$users) {
      $totals{aperd} += $_->{aperd};
      $totals{cperd} += $_->{cperd};
      $totals{gperd} += $_->{gperd};
   }

   # Figure out what % a mods per day count is of the total per day
   foreach (@$users) {
      $_->{answp} = sprintf("%.3f", (($_->{aperd} / $totals{aperd}) * 100));
      $_->{commp} = sprintf("%.3f", (($_->{cperd} / $totals{cperd}) * 100));
      $_->{aggrp} = sprintf("%.3f", (($_->{gperd} / $totals{gperd}) * 100));
   }
}

sub print_xml {
   print XMLout(shift, RootName => "users", XMLDecl => 1);
}

sub print_html {
   my $results = shift;
   my $users = $results->{user};

   # Start html document
   print "<!doctype HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">";
   print "<html><head>\n";
   print "<title>Moderator Statistics</title>\n";
   print "</head>\n";
   print "<body><table width=100% border=1>\n";

   # Print table header
   print "<tr>\n";
   print "<th>Moderator</th>\n";
   print "<th>Days</th>\n";
   print "<th>Answers</th>\n";
   print "<th>Comments</th>\n";
   print "<th>Aggregate</th>\n";
   print "<th>Answers/day</th>\n";
   print "<th>Comments/day</th>\n";
   print "<th>Aggregate/day</th>\n";
   print "<th>%Answers/day</th>\n";
   print "<th>%Comments/day</th>\n";
   print "<th>%Aggregate/day</th>\n";
   print "</tr>\n";
   
   # Print table data
   my @background = (
      "background-color:white;",
      "background-color:lightgrey;"
      );
   
   my $idx = 0;
   foreach my $user (@$users) {
      my $style = $background[++$idx % 2];
      print "<tr style='text-align:right; $style'>\n";
      print "<td>$user->{login}</td>\n";
      print "<td>$user->{rdays}</td>\n";
      print "<td>$user->{qansw}</td>\n";
      print "<td>$user->{qpart}</td>\n";
      print "<td>$user->{aggre}</td>\n";
      print "<td>$user->{aperd}</td>\n";
      print "<td>$user->{cperd}</td>\n";
      print "<td>$user->{gperd}</td>\n";
      print "<td>$user->{answp}</td>\n";
      print "<td>$user->{commp}</td>\n";
      print "<td>$user->{aggrp}</td>\n";
      print "</tr>\n";
   }
   
   # End html document
   print "</table></body>\n";
   print "</html>\n";
}

my %print_results = (
      xml => \&print_xml,
      html => \&print_html,
   );

# And so it begins
sub main {
   my $format="xml";
   GetOptions(
         "format=s", => sub {
         die "Unknown output format" if($_[1] !~ /^(?:html|xml)$/);
         $format = $_[1]
      }
   );

   # Create a queue of items to process
   queue_work;
   
   # Wait for threads to join, get results when they do
   my %results = (user => []);
   foreach (threads->list()) {
      my %element = $_->join();
      
      if (%element)
      {
         my $eusers = $element{user};
         my $rusers = $results{user};
         @$rusers = (@$rusers, @$eusers);
      }
   }
   
   die "Fatal error" unless %results;
   
   generate_metrics(\%results);
   
   $print_results{$format}(\%results);
}

# Entry point
main;
