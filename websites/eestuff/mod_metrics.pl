use strict;
use threads;
use threads::shared;
use Thread::Queue;
use Date::Calc;
use XML::Simple;
use LWP::UserAgent;
use HTTP::Cookies;

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
         $result{hpage} = $uri;
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
   
   my %totals = (
         answ => 0,
         part => 0,
         aggr => 0,
         days => 0
      );

   # Calc totals
   foreach (@$users) {
      # Get totals
      $totals{answ} += $_->{qansw};
      $totals{part} += $_->{qpart};
      $totals{aggr} += $_->{aggre};
      $totals{days} += $_->{rdays};
   }

   my %averages = (
         answ => ($totals{answ} / $totals{days}),
         part => ($totals{part} / $totals{days}),
         aggr => ($totals{aggr} / $totals{days}),
      );

   # Calc averages
   foreach (@$users) {
      # Get totals
      $_->{aperd} = ($_->{qansw} / $_->{rdays});
      $_->{cperd} = ($_->{qpart} / $_->{rdays});
      $_->{gperd} = ($_->{aggre} / $_->{rdays});

      $_->{answp} = (($_->{aperd} / $averages{answ}) * 100);
      $_->{commp} = (($_->{cperd} / $averages{part}) * 100);
      $_->{aggrp} = (($_->{gperd} / $averages{aggr}) * 100);
   }
}

# And so it begins
sub main {
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
   
   # Print results
   print XMLout(\%results, RootName => "users", XMLDecl => 1);
}

# Entry point
main;
