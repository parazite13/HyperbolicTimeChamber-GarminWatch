import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Lang;
import Toybox.Time.Gregorian;

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

    var characterPhases = new Array<CharacterPhase>[12];

    var months = new Array<String>[12];
    var days = new Array<String>[7];

    function initialize() {
        WatchFace.initialize();

        font = WatchUi.loadResource(Rez.Fonts.saiyan);

        days[0] = WatchUi.loadResource(Rez.Strings.day1) as String;
        days[1] = WatchUi.loadResource(Rez.Strings.day2) as String;
        days[2] = WatchUi.loadResource(Rez.Strings.day3) as String;
        days[3] = WatchUi.loadResource(Rez.Strings.day4) as String;
        days[4] = WatchUi.loadResource(Rez.Strings.day5) as String;
        days[5] = WatchUi.loadResource(Rez.Strings.day6) as String;
        days[6] = WatchUi.loadResource(Rez.Strings.day7) as String;
                 
        months[0] = WatchUi.loadResource(Rez.Strings.month1) as String;
        months[1] = WatchUi.loadResource(Rez.Strings.month2) as String;
        months[2] = WatchUi.loadResource(Rez.Strings.month3) as String;
        months[3] = WatchUi.loadResource(Rez.Strings.month4) as String;
        months[4] = WatchUi.loadResource(Rez.Strings.month5) as String;
        months[5] = WatchUi.loadResource(Rez.Strings.month6) as String;
        months[6] = WatchUi.loadResource(Rez.Strings.month7) as String;
        months[7] = WatchUi.loadResource(Rez.Strings.month8) as String;
        months[8] = WatchUi.loadResource(Rez.Strings.month9) as String;
        months[9] = WatchUi.loadResource(Rez.Strings.month10) as String;
        months[10] = WatchUi.loadResource(Rez.Strings.month11) as String;
        months[11] = WatchUi.loadResource(Rez.Strings.month12) as String;

        characterPhases[0] = new CharacterPhase(WatchUi.loadResource(Rez.Drawables.goku_1), NONE);
        characterPhases[1] = new CharacterPhase(WatchUi.loadResource(Rez.Drawables.goku_2), NONE);
        characterPhases[2] = new CharacterPhase(WatchUi.loadResource(Rez.Drawables.goku_3), NONE);
        characterPhases[3] = new CharacterPhase(WatchUi.loadResource(Rez.Drawables.goku_4), RED);
        characterPhases[4] = new CharacterPhase(WatchUi.loadResource(Rez.Drawables.goku_5), YELLOW);
        characterPhases[5] = new CharacterPhase(WatchUi.loadResource(Rez.Drawables.goku_5), YELLOW_BLUE);
        characterPhases[6] = new CharacterPhase(WatchUi.loadResource(Rez.Drawables.goku_7), YELLOW_BLUE);
        characterPhases[7] = new CharacterPhase(WatchUi.loadResource(Rez.Drawables.goku_8), RED);
        characterPhases[8] = new CharacterPhase(WatchUi.loadResource(Rez.Drawables.goku_9), RED);
        characterPhases[9] = new CharacterPhase(WatchUi.loadResource(Rez.Drawables.goku_10), BLUE);
        characterPhases[10] = new CharacterPhase(WatchUi.loadResource(Rez.Drawables.goku_11), RED);
        characterPhases[11] = new CharacterPhase(WatchUi.loadResource(Rez.Drawables.goku_12), BLUE);

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

        var frameProgress = min((characterPhases.size() - 1) * activity.steps / activity.stepGoal, characterPhases.size() - 1);

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

        // Lightning shouyld be around 1.1x wider than goku
        var lightingTransform = new AffineTransform();
        var lightningScale = gokuScale * 1.1;
        var lightningSize = initialGokuSize * lightningScale;
        lightingTransform.scale(lightningScale, lightningScale);
        
        var topBackgroundPercent = 0.25;
        var bottomGokuPercent = 0.9;

        dc.drawBitmap2(dc.getWidth() / 2 - backgroundSize / 2, topBackgroundPercent * dc.getHeight(), background, { :transform => backgroundTransform });
        dc.drawBitmap2(dc.getWidth() / 2 - gokuSize / 2, bottomGokuPercent * dc.getHeight() - gokuSize, characterPhases[frameProgress].drawable, { :transform => gokuTransform });

        // Draw lightnings
        if(characterPhases[frameProgress].aura & RED == RED){
            dc.drawBitmap2(dc.getWidth() / 2 - lightningSize / 2, bottomGokuPercent * dc.getHeight() - lightningSize, lightningRed[frameLightning], { :transform => lightingTransform });
        }
        if(characterPhases[frameProgress].aura & YELLOW == YELLOW){
            dc.drawBitmap2(dc.getWidth() / 2 - lightningSize / 2, bottomGokuPercent * dc.getHeight() - lightningSize, lightningYellow[frameLightning], { :transform => lightingTransform });
        }
        if(characterPhases[frameProgress].aura & BLUE == BLUE){
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
