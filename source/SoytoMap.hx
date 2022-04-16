package;

import openfl.geom.Point;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;


using StringTools;

abstract Movement(Int) from Int from UInt to Int to UInt {
    public static inline var NONE:Movement =            0x00000000;
    public static inline var UP:Movement =              0x00000001;
    public static inline var DOWN:Movement =            0x10000001;
    public static inline var LEFT:Movement =            0x01000010;
    public static inline var RIGHT:Movement =           0x00000010;
    public static inline var UP_LEFT:Movement =         0x01000011;
    public static inline var UP_RIGHT:Movement =        0x00000011;
    public static inline var DOWN_LEFT:Movement =       0x11000011;
    public static inline var DOWN_RIGHT:Movement =      0x10000011;
}

class SoytoMap extends MusicBeatState
{
    private static inline var MOVEMENT_SPEED:Int = 64 * 4;

    private var bg:FlxSprite;
    private var character:FlxSprite;
    private var movement:Movement;

    // This variable will store the character Position on the global world. 
    private var characterPosition:Point;

    override function create() {
        super.create();

        // TODO: Replace me with an asset loaded on a different place.
        var bgPath:String = Paths.image('Map001');
        bg = new FlxSprite().loadGraphic(bgPath);
        character = new FlxSprite().makeGraphic(64, 64, FlxColor.BLACK);

        // Set the character position at starting point of 0,0
        this.characterPosition = new Point();

        add(new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.RED));
        add(bg);
        add(character);
    }

    function processMovement(increment:Array<Float>) {
        var middleScreenPoint = new Point(FlxG.width / 2, FlxG.height / 2);
        var bgPosition = new Point();
        var charPosition = new Point();

        this.characterPosition = new Point(this.characterPosition.x + increment[0], this.characterPosition.y + increment[1]);
        this.characterPosition = preventOutOfBoundsMovement(this.characterPosition);


        // Should we move the bg or the character?
        if (this.characterPosition.x > middleScreenPoint.x && this.characterPosition.x < (this.bg.width - middleScreenPoint.x)) {
            bgPosition.x = (this.characterPosition.x -  middleScreenPoint.x) * -1;
            charPosition.x = middleScreenPoint.x;
        }
        else if (this.characterPosition.x > middleScreenPoint.x) {
            bgPosition.x = (this.bg.width - FlxG.width) * -1;
            charPosition.x = this.characterPosition.x - (this.bg.width - FlxG.width);
        }
        else {
            charPosition.x = this.characterPosition.x;
        }

        if (this.characterPosition.y > middleScreenPoint.y && this.characterPosition.y < (this.bg.height - middleScreenPoint.y)) {
            bgPosition.y = (this.characterPosition.y - middleScreenPoint.y) * -1;
            charPosition.y = middleScreenPoint.y;
        }
        else if(this.characterPosition.y > middleScreenPoint.y) {
            bgPosition.y = (this.bg.height - FlxG.height) * -1;
            charPosition.y = this.characterPosition.y -(this.bg.height - FlxG.height);
        } 
        else {
            charPosition.y = this.characterPosition.y;
        }

        trace('--- FRAME DATA ---');
        trace('Window [${FlxG.width}, ${FlxG.height}]');
        trace('MiddleScreen [${middleScreenPoint.x}, ${middleScreenPoint.y}]');
        trace('characterPosition: [${this.characterPosition.x}, ${this.characterPosition.y}]');
        trace('bgPosition: [${bgPosition.x}, ${bgPosition.y}]');
        trace('charPosition: [${charPosition.x}, ${charPosition.y}]');
        trace('bg size: [${this.bg.width}, ${this.bg.height}]');
        trace('--- END FRAME DATA ---');

        bg.setPosition(bgPosition.x, bgPosition.y);
        character.setPosition(charPosition.x, charPosition.y);
    }

    function preventOutOfBoundsMovement(point: Point): Point {
        var newPoint = new Point();

        var maxX = this.bg.width;
        var maxY = this.bg.height;

        // Prevent X axis go out of bounds
        if (point.x < 0) {
            newPoint.x = 0;
        } else if(point.x > maxX - 64) {
            newPoint.x = maxX - 64;
        }
        else {
            newPoint.x = point.x;
        }

        // Prevent Y Axis go out of bounds
        if (point.y < 0) {
            newPoint.y = 0;
        } else if(point.y > maxY - 64) {
            newPoint.y = maxY - 64;
        } else {
            newPoint.y = point.y;
        }

        return newPoint;
    }


    override function update(elapsed:Float) {

        super.update(elapsed);

        // We want to make the movement up to the step size on 60 frames
        var movementValue:Float = MOVEMENT_SPEED * elapsed;


        var movement:Movement = 0;
        movement ^= controls.UP ? Movement.UP : Movement.NONE;
        movement ^= controls.DOWN ? Movement.DOWN : Movement.NONE;
        movement ^= controls.LEFT ? Movement.LEFT : Movement.NONE;
        movement ^= controls.RIGHT ? Movement.RIGHT : Movement.NONE;

        if (movement == Movement.UP) {
            processMovement([0, movementValue * - 1]);
        }
        else if (movement == Movement.DOWN) {
            processMovement([0, movementValue * 1]);
        }
        else if (movement == Movement.RIGHT) {
            processMovement([movementValue * 1, 0]);
        }
        else if (movement == Movement.LEFT) {
            processMovement([movementValue * -1, 0]);
        }
        else {
            var movementModule = Math.sqrt(Math.pow(movementValue, 2) / 2);

            if (movement == Movement.UP_RIGHT) {
                processMovement([movementModule * 1, movementModule * - 1]);
            }
            else if (movement == Movement.UP_LEFT) {
                processMovement([movementModule * -1, movementModule * - 1]);
            }
            else if (movement == Movement.DOWN_RIGHT) {
                processMovement([movementModule * 1, movementModule * 1]);
            }
            else if (movement == Movement.DOWN_LEFT) {
                processMovement([movementModule * -1, movementModule * 1]);
            }
        }
    }
}

