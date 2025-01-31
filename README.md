# RumbleBlocker

Rumble.com is corrupted by many channels that evidently are named to try to capture viewers to watch bootlegged videos.  I've become fed up with sorting through them to find original videos in the channels worthy of peoples' views of them.

## Quick Start
Under construction, but here is what OpenAI is saying so far:


How to Run / Install (Same as Typical Extension)

    Put manifest.json + contentScript.js (with the above logic) in a folder.
    In Firefox:
        Go to about:debugging#/runtime/this-firefox.
        Click “Load Temporary Add-on” → pick your manifest.json.
        Now load Rumble pages; open DevTools console for logs. The script tries to discover the DOM structure for video items.
    Adjust the fallback logic for real Rumble page content. Check actual classes, text references for “views,” “subscribe,” “upload,” or channel links.
    Observe that once you’ve discovered a consistent pattern, it’s stored. Next time the page loads, your “quick approach” is used with document.querySelectorAll(discovered.videoItemSelector).

Conclusion

    The code above automatically identifies a “DOM construct of interest” by scanning a set of possible video items and channel name elements—no developer manually searching.
    Once found, it caches the discovered selector for a fast approach in future loads.
    If Rumble modifies the layout, the fast approach fails → fallback re-runs → re-discovers the structure.
    This is a robust solution, albeit more complex, letting you avoid constant manual selector changes.
