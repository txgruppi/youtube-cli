#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "Chrome.h"

NSMutableArray *getYoutubeWindows(ChromeApplication *app) {
  NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:1];
  for (ChromeWindow *window in [[app windows] get]) {
    for (ChromeTab *tab in [[window tabs] get]) {
      if ([[tab URL] hasPrefix:@"http://www.youtube.com/"] || [[tab URL] hasPrefix:@"https://www.youtube.com/"]) {
        [result addObject:tab];
      }
    }
  }
  return result;
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

  NSMutableArray *windows = getYoutubeWindows(app);
  int count = [windows count];
  int i;

  if (count == 0) {
    printf("Can't find Youtube tab\n");
    return 1;
  }

  if (argc == 2) {
    if (strcmp(argv[1], "play") == 0 || strcmp(argv[1], "pause") == 0 || strcmp(argv[1], "playpause") == 0 || strcmp(argv[1], "pp") == 0) {
      for (i = 0; i < count; i++) {
        executePlayPause(windows[i]);
      }
      cmdFound = 1;
    }
  }

  if (!cmdFound) {
    usage(argv[0]);
    return 1;
  }

  return 0;
}
