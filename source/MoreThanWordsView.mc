using Toybox.WatchUi;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.ActivityMonitor;

class MoreThanWordsView extends WatchUi.WatchFace {
    var hours = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven",
    			 "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen",
    			 "twenty", "twenty-one", "twenty-two", "twenty-three"];
    var minutes = ["o'clock", "oh one", "oh two", "oh three", "oh four", "oh five", "oh six", "oh seven", "oh eight", "oh nine", "ten", "eleven",
    			 "twelve", "thirteen", "fourteen", "quarter past", "sixteen", "seventeen", "eighteen", "nineteen",
    			 "twenty", "twenty-one", "twenty-two", "twenty-three", "twenty-four", "twenty-five", "twenty-six", "twenty-seven",
    			 "twenty-eight", "twenty-nine", "half past", "thirty-one", "thirty-two", "thirty-one", "thirty-two", "thirty-three",
    			 "thirty-four", "thirty-five", "thirty-six", "thirty-seven", "thirty-eight", "thirty-nine", "fourty", "fourty-one",
    			 "fourty-two", "fourty-three", "fourty-four", "quarter to", "fourty-six", "fourty-seven", "fourty-eight", "fourty-nine",
    			 "fifty", "fifty-one", "fifty-two", "fifty-three", "fifty-four", "fifty-five", "fifty-six", "fifty-seven", "fifty-eight",
    			 "fifty-nine"];
    var days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {}

	// Get arc size
	function getFinalArcSize(current, max) {
		return ((current * 360 * -1) / max).toNumber() % 360 + 90;
	}

    // Update the view
    function onUpdate(dc) {
		var date = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
		var systemStats = System.getSystemStats();
		var finalBatteryArcPos = getFinalArcSize(systemStats.battery, 100);
		
		var info = ActivityMonitor.getInfo();
		var steps = info.steps;
		var stepGoal = info.stepGoal;
        var calories = info.calories; // TODO: add calories
		
		var screenWidth = dc.getWidth();
		var screenHeight = dc.getHeight();
		var centerX = screenWidth / 2;
		var centerY = screenHeight / 2;

		
		// Draw date text
        View.findDrawableById("Date").setText(
        	days[date.day_of_week - 1] + " " + date.day.format("%02d")
    	);
    	
    	// Draw time text
    	// Invert in case of "past" or "quarter to"
    	if (date.min == 15 || date.min == 30 || date.min == 45) {
	    	View.findDrawableById("Minutes").setColor(Graphics.COLOR_YELLOW);
	    	View.findDrawableById("Hours").setColor(Graphics.COLOR_WHITE);
    		View.findDrawableById("Minutes").setLocation(centerX, centerY-35);
    		View.findDrawableById("Hours").setLocation(centerX, centerY+5);
    	} else {
	    	View.findDrawableById("Hours").setColor(Graphics.COLOR_YELLOW);
    		View.findDrawableById("Hours").setLocation(centerX, centerY-35);
    		View.findDrawableById("Minutes").setColor(Graphics.COLOR_WHITE);
    		View.findDrawableById("Minutes").setLocation(centerX, centerY+5);
    	}
        View.findDrawableById("Hours").setText(
			hours[date.hour]
    	);
    	View.findDrawableById("Minutes").setText(
			minutes[date.min]
    	);
 
        View.findDrawableById("Battery").setText(
        	systemStats.battery.format("%d") + "%"
    	);
    	

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
   
   		dc.setPenWidth(3);
   		// Draw battery arc
   		if (finalBatteryArcPos != 90) {
			dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
			dc.drawArc(centerX, centerY, centerX-3, Graphics.ARC_CLOCKWISE, 90, finalBatteryArcPos);
		}
		// Draw steps progress arc
		if (steps != 0) {
			if (steps < stepGoal) {
				dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_TRANSPARENT);
				dc.drawArc(centerX, centerY, centerX-8, Graphics.ARC_CLOCKWISE, 90, getFinalArcSize(steps, stepGoal));
			} else {
				dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
				dc.drawArc(centerX, centerY, centerX-8, Graphics.ARC_CLOCKWISE, 90, 90);
			}
			
		}
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {}

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {}

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {}

}
