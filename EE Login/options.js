
function save_options() {

   var username = document.getElementById("username").value;
   var password = document.getElementById("password").value;

   if(!username || !password)
   {
      alert("You must set a username and password!");
   }
   else
   {
      // Update status to let user know options were saved.
      var status = document.getElementById("status");
      status.innerHTML = "Saving...";
      localStorage["username"] = username;
      localStorage["password"] = password;
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
   }
}

document.addEventListener('DOMContentLoaded', function () {
  document.querySelector('button').addEventListener('click', save_options);
});

document.addEventListener('DOMContentLoaded', function () {
  restore_options();
});
