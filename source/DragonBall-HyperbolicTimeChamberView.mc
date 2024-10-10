import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Lang;
import Toybox.Time.Gregorian;
import Toybox.Lang;

class DragonBall_HyperbolicTimeChamberView extends WatchUi.WatchFace {

    var goku = new Array<Resource>[12];
    var lightningRed = new Array<Resource>[2];
    var lightningYellow = new Array<Resource>[2];
    var lightningBlue = new Array<Resource>[2];
    var dragonBalls = new Array<Resource>[8];
    var dragonRadar;
    var background;
    var font;

    var frameLightning = 0;

    var days = ["Dim", "Lun", "Mar", "Mer", "Jeu", "Ven", "Sam"];
    var months = ["Janv", "Fev", "Mars", "Avr", "Mai", "Juin", "Juil", "Aout", "Sept", "Oct", "Nov", "Dec"];

    function initialize() {
        WatchFace.initialize();

        font = WatchUi.loadResource(Rez.Fonts.saiyan);

        goku[0] = WatchUi.loadResource(Rez.Drawables.goku_1);
        goku[1] = WatchUi.loadResource(Rez.Drawables.goku_2);
        goku[2] = WatchUi.loadResource(Rez.Drawables.goku_3);
        goku[3] = WatchUi.loadResource(Rez.Drawables.goku_4);
        goku[4] = WatchUi.loadResource(Rez.Drawables.goku_5);
        goku[5] = WatchUi.loadResource(Rez.Drawables.goku_6);
        goku[6] = WatchUi.loadResource(Rez.Drawables.goku_7);
        goku[7] = WatchUi.loadResource(Rez.Drawables.goku_8);
        goku[8] = WatchUi.loadResource(Rez.Drawables.goku_9);
        goku[9] = WatchUi.loadResource(Rez.Drawables.goku_10);
        goku[10] = WatchUi.loadResource(Rez.Drawables.goku_11);
        goku[11] = WatchUi.loadResource(Rez.Drawables.goku_12);


        lightningRed[0] = WatchUi.loadResource(Rez.Drawables.lightning_1);
        lightningRed[1] = WatchUi.loadResource(Rez.Drawables.lightning_2);
        lightningYellow[0] = WatchUi.loadResource(Rez.Drawables.lightning_3);
        lightningYellow[1] = WatchUi.loadResource(Rez.Drawables.lightning_4);
        lightningBlue[0] = WatchUi.loadResource(Rez.Drawables.lightning_5);
        lightningBlue[1] = WatchUi.loadResource(Rez.Drawables.lightning_6);

        dragonRadar = WatchUi.loadResource(Rez.Drawables.dragonradar);

        dragonBalls[0] = dragonRadar;
        dragonBalls[1] = WatchUi.loadResource(Rez.Drawables.dragonballs_1);
        dragonBalls[2] = WatchUi.loadResource(Rez.Drawables.dragonballs_2);
        dragonBalls[3] = WatchUi.loadResource(Rez.Drawables.dragonballs_3);
        dragonBalls[4] = WatchUi.loadResource(Rez.Drawables.dragonballs_4);
        dragonBalls[5] = WatchUi.loadResource(Rez.Drawables.dragonballs_5);
        dragonBalls[6] = WatchUi.loadResource(Rez.Drawables.dragonballs_6);
        dragonBalls[7] = WatchUi.loadResource(Rez.Drawables.dragonballs_7);

        background = WatchUi.loadResource(Rez.Drawables.background);
    }

    // Load your resources here
    function onLayout(dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc) as Void {

        var stats = System.getSystemStats();
        var clockTime = System.getClockTime();
        var activity = ActivityMonitor.getInfo();

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.clear();
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);

        var frameProgress = min((goku.size() - 1) * activity.steps / activity.stepGoal, goku.size() - 1);

        // ideal size for the temple is around for 240px res 215 bitmaps
        var initialBackgroundSize = 215;
        var backgroundTransform = new AffineTransform(); 
        var backgroundSize = (dc.getHeight() * initialBackgroundSize / 240).toFloat();
        var backgroundScale = backgroundSize / initialBackgroundSize.toFloat();
        backgroundTransform.scale(backgroundScale, backgroundScale);

        // ideal size for goku is around 160px res for 80px bitmaps
        var initialGokuSize = 80;
        var gokuTransform = new AffineTransform();  
        var gokuSize = (dc.getHeight() * initialGokuSize / 160).toFloat();
        var gokuScale = gokuSize / initialGokuSize.toFloat();
        gokuTransform.scale(gokuScale, gokuScale);

        // Lightning shouyld be around 1.2x wider than goku
        var lightingTransform = new AffineTransform();
        var lightningScale = gokuScale * 1.2;
        var lightningSize = initialGokuSize * lightningScale;
        lightingTransform.scale(lightningScale, lightningScale);
        
        var topBackgroundPercent = 0.25;
        var bottomGokuPercent = 0.9;

        dc.drawBitmap2(dc.getWidth() / 2 - backgroundSize / 2, topBackgroundPercent * dc.getHeight(), background, { :transform => backgroundTransform });
        dc.drawBitmap2(dc.getWidth() / 2 - gokuSize / 2, bottomGokuPercent * dc.getHeight() - gokuSize, goku[frameProgress], { :transform => gokuTransform });

        if(frameProgress == 3){
            dc.drawBitmap2(dc.getWidth() / 2 - lightningSize / 2, bottomGokuPercent * dc.getHeight() - lightningSize, lightningRed[frameLightning], { :transform => lightingTransform });
        }else if(frameProgress == 4){
            dc.drawBitmap2(dc.getWidth() / 2 - lightningSize / 2, bottomGokuPercent * dc.getHeight() - lightningSize, lightningYellow[frameLightning], { :transform => lightingTransform });
        }else if(frameProgress == 5){
            dc.drawBitmap2(dc.getWidth() / 2 - lightningSize / 2, bottomGokuPercent * dc.getHeight() - lightningSize, lightningYellow[frameLightning], { :transform => lightingTransform });
            dc.drawBitmap2(dc.getWidth() / 2 - lightningSize / 2, bottomGokuPercent * dc.getHeight() - lightningSize, lightningBlue[frameLightning], { :transform => lightingTransform });
        }else if(frameProgress == 6){
            dc.drawBitmap2(dc.getWidth() / 2 - lightningSize / 2, bottomGokuPercent * dc.getHeight() - lightningSize, lightningYellow[frameLightning], { :transform => lightingTransform });
            dc.drawBitmap2(dc.getWidth() / 2 - lightningSize / 2, bottomGokuPercent * dc.getHeight() - lightningSize, lightningBlue[frameLightning], { :transform => lightingTransform });
        }else if(frameProgress == 7){
            dc.drawBitmap2(dc.getWidth() / 2 - lightningSize / 2, bottomGokuPercent * dc.getHeight() - lightningSize, lightningRed[frameLightning], { :transform => lightingTransform });
        }else if(frameProgress == 8){
            dc.drawBitmap2(dc.getWidth() / 2 - lightningSize / 2, bottomGokuPercent * dc.getHeight() - lightningSize, lightningRed[frameLightning], { :transform => lightingTransform });
        }else if(frameProgress == 9){
            dc.drawBitmap2(dc.getWidth() / 2 - lightningSize / 2, bottomGokuPercent * dc.getHeight() - lightningSize, lightningBlue[frameLightning], { :transform => lightingTransform });
        }else if(frameProgress == 10){
            dc.drawBitmap2(dc.getWidth() / 2 - lightningSize / 2, bottomGokuPercent * dc.getHeight() - lightningSize, lightningRed[frameLightning], { :transform => lightingTransform });
        }else if(frameProgress == 11){
            dc.drawBitmap2(dc.getWidth() / 2 - lightningSize / 2, bottomGokuPercent * dc.getHeight() - lightningSize, lightningBlue[frameLightning], { :transform => lightingTransform });
        }

        var radius = (dc.getHeight() - 20 - 5) / 2; // 20 is dragonball size, 5 is small padding
        var angleRange = Math.PI * 0.5;
        var dragonballTransform = new AffineTransform();  
        dragonballTransform.translate(-10.0, -10.0); // 20 is dragonball size
        var nbDisplayDragonBalls = stats.battery * dragonBalls.size() / 100;
        for(var i = 0; i < nbDisplayDragonBalls; i++){
            var currentAngle = angleRange / dragonBalls.size() * i + angleRange / 2;
            dc.drawBitmap2(dc.getWidth() / 2 - radius * Math.sin(currentAngle), dc.getHeight() / 2 + radius * Math.cos(currentAngle), dragonBalls[i], { :transform => dragonballTransform });
        }

        dc.drawText(
              dc.getWidth() / 2,
              dc.getHeight() - 18,
              Graphics.FONT_XTINY,
              activity.steps,
              Graphics.TEXT_JUSTIFY_CENTER
        );

        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
        dc.drawText(
              dc.getWidth() / 2,
              0,
              Graphics.FONT_SYSTEM_LARGE,
              timeString,
              Graphics.TEXT_JUSTIFY_CENTER
        );

        dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
        var date = Gregorian.info(Time.now(), Time.FORMAT_SHORT);

        var dateY = 0.15 * dc.getHeight();

        dc.drawText(
              dc.getWidth() / 2 - 40,
              dateY,
              font,
              days[date.day_of_week - 1],
              Graphics.TEXT_JUSTIFY_CENTER
        );
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
              dc.getWidth() / 2,
              30,
              Graphics.FONT_SYSTEM_MEDIUM,
              date.day,
              Graphics.TEXT_JUSTIFY_CENTER
        );
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
              dc.getWidth() / 2 + 40,
              dateY,
              font,
              months[date.month - 1],
              Graphics.TEXT_JUSTIFY_CENTER
        );


        frameLightning = (frameLightning + 1) % 2;
    }

    function min(a, b){
        if(a > b){
            return b;
        }
        return a;
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}
