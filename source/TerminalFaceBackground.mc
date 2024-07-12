using Toybox.WatchUi;
using Toybox.Application;
using Toybox.Graphics;

class TerminalFaceBackground extends WatchUi.Drawable {

    function initialize() {
        var dictionary = {
            :identifier => "TerminalFaceBackground"
        };

        Drawable.initialize(dictionary);
    }

    function draw(dc) {
        // Set the TerminalFaceBackground color then call to clear the screen
        dc.setColor(Graphics.COLOR_TRANSPARENT, Application.getApp().getProperty("TerminalFaceBackgroundColor"));
        dc.clear();
    }

}
