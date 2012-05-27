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
   var res = 0;

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
         for(key in re[section][1])
         {
            save_radio(key);
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
      for(key in re[section][1])
      {
         load_radio(key);
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
      for(key in re[section][1])
      {
         wl('<tr> \
               <td class="hzones"><label class="zones" for= \
               "{key}">{name}:</label></td> \
               <td class="zones"><input type="radio" name="{key}" \
               value="false"></td> \
               <td class="zones"><input type="radio" name="{key}" \
               value="true"></td> \
               <td class="zones"><input type="radio" name="{key}" \
               value="detach"></td> \
               </tr>'.supplant({'key': key, 'name': re[section][1][key][0]}));
      }

      wl('<tr> <td colspan="4"><hr></td></tr>');
   }
}

