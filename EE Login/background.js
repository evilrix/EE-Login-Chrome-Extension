chrome.pageAction.onClicked.addListener(onClick_handler);
chrome.tabs.onUpdated.addListener(onUpdate_handler);

function get_redirect_url(tab)
{
   var url;

   if(re['ee']['regex'].test(tab.url))
   {
      url = "https://secure.experts-exchange.com/login.jsp";
   }
   else if(re['es']['regex'].test(tab.url))
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

function handle_login(tab)
{
   if(!localStorage["username"])
   {
      alert("You need to configure your EE username and password.");
      chrome.tabs.create( {'url': "options.html"});
      return;
   }

      var url = get_redirect_url(tab);

   if(url)
   {
      chrome.windows.create( {
         'url': url,
         'incognito': true
      });

      chrome.tabs.remove(tab.id);
   }
}

function onUpdate_handler(tabId, changeInfo, tab) {

   if(changeInfo.status == "loading") {
      if(tab.incognito)   {

         alert("EE Login doesn't work in incognito mode, please disable it!");

      } else {

         if(re['ee']['regex'].test(tab.url)) {

            chrome.pageAction.show(tabId);
         }
         else if(re['es']['regex'].test(tab.url)) {

            chrome.pageAction.show(tabId);
         }
      }
   }
}

function onClick_handler(tab) {

   handle_login(tab, localStorage["detonman"] == "true");
}
