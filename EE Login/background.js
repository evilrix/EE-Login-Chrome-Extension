chrome.tabs.onUpdated.addListener(onUpdate_handler);
chrome.pageAction.onClicked.addListener(onClick_handler);

function get_redirect_url(tab)
{
   var url;

   if(re['ee']['regex'][0].test(tab.url))
   {
      url = "https://secure.experts-exchange.com/login.jsp";
   }
   else if(re['es']['regex'][0].test(tab.url))
   {
      url = " http://ee-stuff.com/login.php";
   }

   if(url)
   {
      url += "?loginName=" + localStorage["username"];
      url += "&loginPassword=" + encodeURIComponent(localStorage["password"]);
      url += "&loginSubmit=1&redirect=" + tab.url.replace(urlRe, '');
   }

   return url;
}

function handle_login(tab, detach, ask)
{
   if(!localStorage["username"])
   {
      alert("You need to configure your EE username and password.");
      chrome.tabs.create( {'url': "options.html"});
      return;
   }

   if(ask ? confirm("Go incognito") : true)
   {
      var url = get_redirect_url(tab);

      if(url)
      {
         chrome.windows.create( {
            'url': url,
            'incognito': true
         });

         if(detach)
         {
            chrome.tabs.remove(tab.id);
         }
      }
   }
}

function zone_handler(section, key, tab) {
   var ret = false

      if(localStorage[key] > 0 && re[section]['regex'][1][key][1].test(tab.url))
      {
         handle_login(tab, (localStorage[key] == 2), (localStorage[key] == 3));
         ret = true;
      }

   return ret;
}

function onUpdate_handler(tabId, changeInfo, tab) {

   if(changeInfo.status == "loading") {
      if(tab.incognito)   {

         alert("EE Login doesn't work in incognito mode, please disable it!");

      } else {

         var section;

         if(re['ee']['regex'][0].test(tab.url)) {

            chrome.pageAction.show(tabId);
            section = 'ee';
         }
         else if(re['es']['regex'][0].test(tab.url)) {

            chrome.pageAction.show(tabId);
            section = 'es';
         }
         else
         {
            return;
         }

         for(key in re[section]['regex'][1])
         {
            if(zone_handler(section, key, tab))
            {
               break;
            }
         }
      }
   }
}

function onClick_handler(tab) {

   handle_login(tab, localStorage["detonman"] == "true");
}

