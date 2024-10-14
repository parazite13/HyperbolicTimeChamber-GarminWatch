import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Lang;
import Toybox.Time.Gregorian;

class CharacterPhase {
    public var drawable as Resource;
    public var aura as Aura;

    public function initialize(d as Resource, a as Aura) {
        aura = a;
        drawable = d;
    }
}

enum Aura {
    NONE = 0,
    RED = 1,
    YELLOW = 2,
    RED_YELLOW = 3,
    BLUE = 4,
    BLUE_RED = 5,
    YELLOW_BLUE = 6,
    BLUE_RED_YELLOW = 7
}