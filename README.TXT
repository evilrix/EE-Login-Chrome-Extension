A simple extension to automatically log you into EE, via Incognito mode, with the EE account of your choice. 

You can either click on the little icon in the Omnibar or configure it to automatically log you in depending upon the area of the site you are accessing.

Useful for EE Badgers who have separate privileged accounts.

Instructions
=-=-=-=-=-=

Basic settings:

You need to add your EE username and password. Don't worry these are stored securely in Chrome's own storage framework.

The extension always spawns an incognito window so there is a tickbox there just to remind you of this; you cannot disable this option.

Advanced settings:

You can either invoke the extension manually by clicking the little EE login in the address bar when on EEs site or you can configure the extension to automatically invoke for certain zones. The extension uses URL detection to see you are about to browse to a zone it is monitoring and will either clone or detach a window and log you into EE using that URL via the new incognito window.

Not that auto-login even works if you open the link from an external source (say an e-mail client) as long as you have Chrome configured as your default browser. Initially a normal Chrome window will open and immediately the extension will detect the URL and either clone or detach depending upon your configuration for that zone.

The three options for auto-login are:

disable - the zone is not automatically detected (manual can still be used)
clone - a new window will open to log you in but the old one will remain open
detach- a new window will open to log you in and the old one will be closed

Finally, you can also choose for manual invocations to detach rather than clone (the default for manual).

Version History: -

1.0.3.1   - Fix small issue when saving 'confirmation' state

1.0.3.0   - Ask for confirmation before going incognito.

1.0.2.1   - Improved layout.

1.0.2.0   - Added support Articles and RA zone.

1.0.1.2   - Added support for EE v10.

1.0.1.1   - Added support for eestuff zones (admin, mod, za, pe. cv).

1.0.1.0   - Added support for eestuff (this is experimental - watch out for dragons!).

1.0.0.14 - don't assume all EE pages start with www (eg. blogs!).

1.0.0.13 - Added CS General as a seperate auto-login zone.

1.0.0.12 - Cosmetic change (docked is now known as clone).

1.0.0.11 - Ensure sensible defaults on first every install..

1.0.0.10 - Toggle to allow manual logins to detach rather than always dock.

1.0.0.9   - Oops, fix issue where Incognito window isn't forced.

1.0.0.8   - Specific granular control of how auto-login for each zone is handled.

   Options are:

      * Disabled - auto-login is not enabled for that zone (can still use manual)
      * Docked - auto-login enabled; new tab opens and original remains docked
      * Detached - auto-login enabled; new tab opens and original is closed

1.0.0.7   - Added PD Zone as a new auto-login zone as this one has it's own privs

1.0.0.6   - When selecting CS Other only pick up the auxiliary zones.
             - Added CV Only as a new auto-login zone as this one has it's own privs

1.0.0.5   - Only detach when performing an auto-login.

1.0.0.4   - Fix small cosmetic issue with options page.

1.0.0.3   - Incognito is now mandatory (it makes little sense for it not to be).
           - You can now specify certain zones to always automatically login.
           - Option to detach current tab as incognito rather than creating a copy.

1.0.0.2 - Don't force window position as it doesn't work very well on multi-screens.

1.0.0.1 - Only show icon when on EE's website.
           - Redirect back to the page we were originally on after authentication.

1.0.0.0 - Initial release.
