function radio_click_handler(name)
{
   var rds = document.getElementsByName(name);
   var cbname = name + '_cb';
   var cb = document.getElementById(cbname);

   cb.disabled = rds[0].checked;
}

function save_radio(name) {
   var rds = document.getElementsByName(name);
   var res = 0;

   for(var i = 0 ; i < rds.length ; ++i) {
      if(rds[i].checked) {
         res = i;
      }
   }

   localStorage[name] = res;
}

function load_radio(name) {
   var rds = document.getElementsByName(name);

   if(localStorage["username"])
   {
      for(var i = 0 ; i < rds.length ; ++i) {
         rds[i].checked = (i == localStorage[name]);
      }
   }
   else
   {
      rds[0].checked = true;
   }
}

function save_cb(name) {
   var name = name + '_cb';
   var cb = document.getElementById(name);
   localStorage[name] = cb.checked?1:0;
}

function load_cb(name) {
   var cbname = name + '_cb';
   var cb = document.getElementById(cbname);

   if(localStorage["username"])
   {
      cb.checked = (1 == localStorage[cbname]);
   }
   else
   {
      cb.checked = false;
   }

   radio_click_handler(name);
}

function save_options() {

   var username = document.getElementById("username").value;
   var password = document.getElementById("password").value;

   if(!username || !password)
   {
      alert("You must set a username and password!");
   }
   else
   {
      localStorage["username"] = username;
      localStorage["password"] = password;

      for(section in re)
      {
         for(key in re[section]['regex'][1])
         {
            save_radio(key);
            save_cb(key);
         }
      }

      localStorage["detonman"] = document.getElementById("detonman").checked;

      // Update status to let user know options were saved.
      var status = document.getElementById("status");
      status.innerHTML = "Saving...";
      setTimeout(function() {
         status.innerHTML = "";
      }, 750);
   }
}

// Restores select box state to saved value from localStorage.
function restore_options() {
   if(localStorage["username"])
   {
      document.getElementById("username").value = localStorage["username"];
      document.getElementById("password").value = localStorage["password"];


      document.getElementById("detonman").checked = localStorage["detonman"] == "true";
   }

   for(section in re)
   {
      for(key in re[section]['regex'][1])
      {
         load_radio(key);
         load_cb(key);
      }
   }
}

function wl (line)
{
   document.write(line);
}

String.prototype.supplant = function (o)
{
   return this.replace(/{([^{}]*)}/g,
         function (a, b) {
            var r = o[b];
            return typeof r === 'string' || typeof r === 'number' ? r : a;
         });
};

function generate_opts_table()
{
   for(section in re)
   {
      wl('<tr> <td colspan="5">{section}</td></tr>'.supplant({'section': re[section]['name']}));
      for(key in re[section]['regex'][1])
      {
         wl('<tr> \
               <td class="hzones"><label class="zones" for= \
               "{key}">{name}:</label></td> \
               <td class="zones"><input onclick="radio_click_handler(\'{key}\')" type="radio" name="{key}"></td> \
               <td class="zones"><input onclick="radio_click_handler(\'{key}\')"  type="radio" name="{key}"></td> \
               <td class="zones"><input onclick="radio_click_handler(\'{key}\')"  type="radio" name="{key}"></td> \
               <td class="zones"><input type="checkbox" id="{key}_cb"></td> \
               </tr>'.supplant({'key': key, 'name': re[section]['regex'][1][key][0]}));
      }

      wl('<tr> <td colspan="5"><hr></td></tr>');
   }
}

