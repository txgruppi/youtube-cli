#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "Chrome.h"

ChromeTab *getFirstYoutubeWindow(ChromeApplication *app) {
  for (ChromeWindow *window in [[app windows] get]) {
    for (ChromeTab *tab in [[window tabs] get]) {
      if ([[tab URL] hasPrefix:@"http://www.youtube.com/"] || [[tab URL] hasPrefix:@"https://www.youtube.com/"]) {
        return tab;
      }
    }
  }
  return nil;
}

void executePlayPause(ChromeTab *tab) {
  [tab executeJavascript:@"(function(){ var v = document.getElementsByTagName('video')[0]; if (v) { v[v.paused?'play':'pause']();  } else { v = document.getElementById('movie_player'); v[v.getPlayerState()===1?'pauseVideo':'playVideo']();  } })();"];
}

void usage(char *cmd) {
  printf("Usage: %s <command>\n\n  Commands:\n", cmd);
  printf("    %-28s\n      %s\n", "play|pause|playpause|pp",    "Toggle the playing/paused state of the current track");
}

int main(int argc, char *argv[]) {
  ChromeApplication *app = [SBApplication applicationWithBundleIdentifier:@"com.google.Chrome"];

  int cmdFound = 0;

  ChromeTab *tab = getFirstYoutubeWindow(app);

  if (tab == nil) {
    printf("Can't find Youtube tab\n");
    return 1;
  }

  if (argc == 2) {
    if (strcmp(argv[1], "play") == 0 || strcmp(argv[1], "pause") == 0 || strcmp(argv[1], "playpause") == 0 || strcmp(argv[1], "pp") == 0) {
      executePlayPause(tab);
      cmdFound = 1;
    }
  }

  if (!cmdFound) {
    usage(argv[0]);
    return 1;
  }

  return 0;
}
