using Toybox.Application;
using Toybox.WatchUi;

class TerminalFaceApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new TerminalFaceView() ];
    }

    // New app settings have been received so trigger a UI update
    function onSettingsChanged() {
        	    
        	    
        var text_color = 0xFFFFFF;
        
        if (Application.getApp().getProperty("BackgroundColor") == 0xFFFFFF){
	    	Application.getApp().setProperty("ForegroundColor", 0x000000);
	    }
	    else if (Application.getApp().getProperty("BackgroundColor") == 0x000000){
			Application.getApp().setProperty("ForegroundColor", 0xFFFFFF);
	    }
        	    
	    WatchUi.requestUpdate();
	   
    }

}