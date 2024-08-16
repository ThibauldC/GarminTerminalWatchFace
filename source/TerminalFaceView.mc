using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Application;
using Toybox.Time.Gregorian as Date;
using Toybox.ActivityMonitor as Mon;

class TerminalFaceView extends WatchUi.WatchFace {
	
	// var default_font = Graphics.FONT_GLANCE;
	var default_font = WatchUi.loadResource(Rez.Fonts.font_ubuntu);
	var default_font_hb = WatchUi.loadResource(Rez.Fonts.font_ubuntu_hb);
	var def_start_Y = 45;
	var def_increment_Y = 20.5;
	var def_start_X = 20;
	var def_increment_X = 60;
	var text_color = 0x000000;
	
    //in right order
	var list = ["DateText","TimeText", "BatteryText", "StepText",  "MessageText"];


    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
  
	
	}
	
    function initialize() {
        WatchFace.initialize();
        
    
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    
    }

    // Update the view
    function onUpdate(dc) {
        setHead();
        setClockDisplay();
		setDateDisplay();
		setBatteryDisplay();
		setStepCountDisplay();
		setNotificationCountDisplay();
		//setHeartrateDisplay();
		setDisplayText();
		setBottom();
		
		text_color = Application.getApp().getProperty("ForegroundColor");
		
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }
    
    private function setDisplayText() {
    	
    	for (var i=0; i<list.size(); i++){
    		var view = View.findDrawableById(list[i]);
			view.setFont(default_font);
			view.setColor(text_color);
			view.setLocation(def_start_X, def_start_Y + (i+1)*def_increment_Y);
		}
    
    }
    
    private function setHead() {        
		var view = View.findDrawableById("Head");
		view.setFont(default_font_hb);
		view.setColor(text_color);
		view.setLocation(def_start_X, def_start_Y + 0*def_increment_Y - 3);  
		view.setText("user@watch:~ $ now"); 	    	
    }
    
    private function setBottom() {        
		var view = View.findDrawableById("Bottom");
		view.setFont(default_font_hb);
		view.setColor(text_color);
		view.setLocation(def_start_X, def_start_Y + (list.size()+1)*def_increment_Y + 3);  
		view.setText("user@watch:~ $"); 	    	
    }
    
    private function setClockDisplay() {
    	// Get the current time and format it correctly
        var timeFormat = "$1$:$2$:$3$ $4$ $5$";
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        
        // get AM or PM right
        var meridies ="";
        if (hours < 12){
        	meridies = "AM";
        } else{
        	meridies = "PM";
        }
        
        if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } else {
            if (Application.getApp().getProperty("UseMilitaryFormat")) {
                timeFormat = "$1$$2$";
                hours = hours.format("%02d");
            }
        }
        
        
        // Get the european time Zone
        var utcOffset = clockTime.timeZoneOffset/3600;
        var timeZone = "";
        if (utcOffset == 1){
        	timeZone = "CET";
        }
        else if (utcOffset == 2){
        	timeZone = "CEST";
        }
        
        var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d"), clockTime.sec.format("%02d"), meridies, timeZone]);
		
		
        // Update the view
        var view = View.findDrawableById("TimeLabel");
        view.setFont(default_font);
        view.setLocation(def_start_X + def_increment_X, def_start_Y + (list.indexOf("TimeText")+1)*def_increment_Y);
        view.setColor(Application.getApp().getProperty("PinkColor"));
        view.setText(timeString);
    }
    
    private function setDateDisplay() {        
    	var now = Time.now();
		var date = Date.info(now, Time.FORMAT_LONG);
		var dateString = Lang.format("$1$ $2$ $3$ $4$", [date.day_of_week, date.month, date.day, date.year]);
		var dateDisplay = View.findDrawableById("DateDisplay");
		dateDisplay.setFont(default_font);
		dateDisplay.setLocation(def_start_X + def_increment_X, def_start_Y + (list.indexOf("DateText")+1)*def_increment_Y);
        dateDisplay.setColor(Application.getApp().getProperty("YellowColor"));   
		dateDisplay.setText(dateString);	    	
    }
    
    private function setBatteryDisplay() {
    	var battery = System.getSystemStats().battery;
    	
    	var battBar = "[";
    	var count = battery;
    	count.format("%i");
    	
    	for (var i=0; i<100; i+=10){
    		if (i<=count-10){
    			battBar += "#";
    		}
    		else{
    			battBar += ".";
    		}
    	}
    	battBar += "] ";
    	
		var batteryDisplay = View.findDrawableById("BatteryDisplay"); 
		batteryDisplay.setFont(default_font);
        batteryDisplay.setColor(Application.getApp().getProperty("GreenColor"));
		batteryDisplay.setLocation(def_start_X + def_increment_X, def_start_Y + (list.indexOf("BatteryText")+1)*def_increment_Y);     
		batteryDisplay.setText(battBar + battery.format("%d")+" %");	
    }
    
    private function setStepCountDisplay() {
    	var stepCount = Mon.getInfo().steps.toString();	
    	var stepGoal = Mon.getInfo().stepGoal.toString();	
		var stepCountDisplay = View.findDrawableById("StepCountDisplay");
		stepCountDisplay.setFont(default_font);
        stepCountDisplay.setColor(Application.getApp().getProperty("CyanColor"));
		stepCountDisplay.setLocation(def_start_X + def_increment_X, def_start_Y + (list.indexOf("StepText")+1)*def_increment_Y);   
		stepCountDisplay.setText(stepCount + "/" + stepGoal + " steps");		
    }
    
    private function setNotificationCountDisplay() {
    	var notificationAmount = System.getDeviceSettings().notificationCount;
		
		var formattedNotificationAmount = "";
	
		if(notificationAmount > 10)	{
			formattedNotificationAmount = "10+";
		}
		else {
			formattedNotificationAmount = notificationAmount.format("%d");
		}
	
		var notificationCountDisplay = View.findDrawableById("MessageCountDisplay");
        notificationCountDisplay.setColor(Application.getApp().getProperty("OrangeColor"));		
		notificationCountDisplay.setFont(default_font); 
		notificationCountDisplay.setLocation(def_start_X + def_increment_X, def_start_Y + (list.indexOf("MessageText")+1)*def_increment_Y);   
		notificationCountDisplay.setText(formattedNotificationAmount + " messages");
    }
    
    private function setHeartrateDisplay() {
    	var heartRate = "";
    	
    	if(Mon has :INVALID_HR_SAMPLE) {
    		heartRate = retrieveHeartrateText();
    	}
    	else {
    		heartRate = "";
    	}
    	
		var heartrateDisplay = View.findDrawableById("HeartrateDisplay");   
        heartrateDisplay.setColor(Application.getApp().getProperty("RedColor"));
		heartrateDisplay.setFont(default_font);
		heartrateDisplay.setLocation(def_start_X + def_increment_X, def_start_Y + (list.indexOf("HeartText")+1)*def_increment_Y);   
		heartrateDisplay.setText(heartRate + " bpm");
	}
	    
    private function retrieveHeartrateText() {
    	var heartrateIterator = ActivityMonitor.getHeartRateHistory(null, false);
		var currentHeartrate = heartrateIterator.next().heartRate;
	
		if(currentHeartrate == Mon.INVALID_HR_SAMPLE) {
			return "";
		}		
	
		return currentHeartrate.format("%d");
    }    
}