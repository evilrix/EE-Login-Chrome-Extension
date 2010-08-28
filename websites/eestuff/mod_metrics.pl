use strict;
use threads;
use threads::shared;
use Thread::Queue;
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
   # We'll need a cookie jar for logging in
   my $cookie_jar = HTTP::Cookies->new();
   
   # Next we need a user agent
   my $ua = LWP::UserAgent->new;
   $ua->timeout(60);
   $ua->cookie_jar($cookie_jar);
   
   # Some credentials
   my $user = "automodxxxx";
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
      }
   }

   # We now have an authenticated user agent, return it for use
   return $ua unless $error;
}

# Each thread will process the queue until it is drained
sub thread_proc {

   # Get an authenticaled user agent (undef on error!)
   my $ua = authenticate(shift);
   return unless defined $ua;

   # Create the XML result object
   my %results = (user => []);
   my $users = $results{user};

   # Process the queue
   while($queue->pending()) {
      
      # Get an item from the queue and create a uri
      my $uid = $queue->dequeue_nb();
      
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
         $result{login} = $1 if($content =~ s/$filters{login}//);
         $result{rdate} = $1 if($content =~ s/$filters{rdate}//);
         $result{qansw} = $1 if($content =~ s/$filters{qansw}//);
         $result{qpart} = $1 if($content =~ s/$filters{qpart}//);

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
   
   # Print results
   print XMLout(\%results, RootName => "users", XMLDecl => 1);
}

# Entry point
main;
