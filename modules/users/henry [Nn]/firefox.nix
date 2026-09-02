let
  username = "henry";
in {
  flake.modules.homeManager."${username}" = {config, ...}: {
    programs.firefox = {
      policies = {
        OfferToSaveLogins = false;
        DisableTelemetry = true;
        DisableFormHistory = true;
        DefaultDownloadDirectory = "${config.home.homeDirectory}/downloads";

        # to find out the app name/email:
        #  curl -s https://addons.mozilla.org/api/v5/addons/addon/keepassxc-browser/ | jq .guid
        ExtensionSettings = {
          "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
          "sponsorBlocker@ajay.app" = {
            installation_mode = "force_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
          };
          "keepassxc-browser@keepassxc.org" = {
            installation_mode = "force_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/keepassxc-browser/latest.xpi";
          };
        };
        "3rdparty".Extensions = {
          "uBlock0@raymondhill.net".adminSettings = {
            selectedFilterLists = [
              "user-filters"

              # builtin
              "ublock-filters"
              "ublock-badware"
              "ublock-privacy"
              "ublock-quick-fixes"
              "ublock-unbreak"

              # ads
              "easylist"

              # privacy
              "easyprivacy"

              # malware, security
              "urlhaus-1"

              # multipurpose
              "plowe-0"

              # cookie notices
              "ublock-cookies-easylist"

              # social widgets
              "fanboy-social"
              "fanboy-thirdparty_social"

              # annoyances
              # "fanboy-ai-suggestions"
              # "easylist-chat"
              # "easylist-newsletters"
              # "easylist-notifications"
              # "easylist-annoyances"
              # swapped to adguard, easylist wasn't blocking "sign into google" popups
              "adguard-mobile-app-banners"
              "adguard-other-annoyances"
              "adguard-popup-overlays"
              "adguard-widgets"
            ];

            userFilters = ''
              # disables annoying reddit popup
              www.reddit.com###desktop-dynamic-upsell-dialog
              www.reddit.com###blocking-modal:remove()
              www.reddit.com##body:watch-attr(class):remove-class(rpl-scroll-lock)
              www.reddit.com##html:style(overflow: auto !important; position: static !important;)
              www.reddit.com##body:style(overflow: auto !important; position: static !important;)
            '';
          };
        };
      };
    };
  };
}
