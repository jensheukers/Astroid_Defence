package  {
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.text.*; 
	
	import com.adobe.tvsdk.mediacore.timeline.Placement;
	
	public class Main extends MovieClip {
		
		var ps:ParticleSystem;		
		var tower:Tower;
		var gameOver:GameOver
		
		private var notificationTextField:TextField; 
		
		var isGameEnded:Boolean;
		var aPressed:Boolean;
		var dPressed:Boolean;
		var wPressed:Boolean;
		var sPressed:Boolean;
		var spacePressed:Boolean;
		
		var groups:Array;
		var planes:Array;
		
		var waveNumber:Number;
		var waveIncrement:Number;
		
		public function Main() {
			isGameEnded = false;
			notificationTextField = new TextField();
			stage.addChild(notificationTextField);
			ps = new ParticleSystem(this);
			this.waveIncrement = 0;
			this.waveNumber = 0;
			planes = new Array();
			groups = new Array();
			tower = new Tower(this);
			stage.addChild(tower);
			
			var format:TextFormat = new TextFormat(); 
            format.font = "Verdana"; 
            format.color = 0xFF0000; 
            format.size = 10;
			
			notificationTextField.defaultTextFormat = format;
			notificationTextField.width = 500;
		
			CreateWave();
			
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN,HandleKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP,HandleKeyUp);
			this.addEventListener(Event.ENTER_FRAME, Update);	
			trace(GetStageData());
		}
		
		public function CreateWave() {
		
			waveNumber += 1;
			waveIncrement += 0.5;
		
			var amountPlanes:int = this.RandomRange(5,7) * waveIncrement;
			var amountGroups:int = this.RandomRange(1,5);
		
			var planesPerGroup:int = amountPlanes / amountGroups;
		
			notificationTextField.text = "Current Wave: " + waveNumber;
		
			for(var i:int = 0; i < amountGroups; i++) {
				var group:Group = new Group(planesPerGroup,this);
			}

		}
		
		public function Update(event) {
			ps.Update();
			if(planes.length == 0) {
			//Create new wave	
				CreateWave();
			}
			
			this.InputEvents();
		}
		
		public function AddPlane(p:Plane) {
			this.planes.push(p);
		}
		
		public function InputEvents() {
			if(wPressed) {
				tower.RangeIncrease();
			}
			
			if(sPressed) {
				tower.RangeDescrease();
			}
			
			if(aPressed) {
				tower.RotateCounterClockWise();
			}
			
			if(dPressed) {
				tower.RotateClockWise();
			}
			
			if(spacePressed) {
				tower.mussleFlash.alpha = 1;
				
				if(isGameEnded) {
					this.RestartGame();
				}
				else
				{
					tower.ShootCannon();
				}
			}
			if(!spacePressed) {
				tower.mussleFlash.alpha = 0;
			}
		}
		
		public static function RandomRange(min:Number, max:Number):Number { 
			var randomNum:Number = Math.floor(Math.random() * (max - min + 1)) + min; 
			return randomNum; 
		} 
		
		public function RandomRange(min:Number, max:Number):Number { 
			var randomNum:Number = Math.floor(Math.random() * (max - min + 1)) + min; 
			return randomNum; 
		} 
		
		public function HandleKeyDown(e:KeyboardEvent):void {
			if(e.keyCode == Keyboard.D) {
				dPressed = true;
			}
			if(e.keyCode == Keyboard.A) {
				aPressed = true;
			}
			
			if(e.keyCode == Keyboard.S) {
				sPressed = true;
			}
			
			if(e.keyCode == Keyboard.W) {
				wPressed = true;
			}
			
			if(e.keyCode == Keyboard.SPACE) {
				spacePressed = true;
			}
		}
		
			public function HandleKeyUp(e:KeyboardEvent):void {
			if(e.keyCode == Keyboard.D) {
				dPressed = false;
			}
			if(e.keyCode == Keyboard.A) {
				aPressed = false;
			}
			
			if(e.keyCode == Keyboard.S) {
				sPressed = false;
			}
			
			if(e.keyCode == Keyboard.W) {
				wPressed = false;
			}
			
			if(e.keyCode == Keyboard.SPACE) {
				spacePressed = false;
			}
		}
		
		
		public function GetStageData(): Vector2 {
			return new Vector2(stage.stageWidth,stage.stageHeight);
		}
		
		public static function InRange(radians:int,myPos:Vector2,otherPos:Vector2) : Boolean{
			var distance:Vector2 = myPos.GetDistance(otherPos); 
			if(distance.x < radians && distance.x > radians * -1 && distance.y < radians && distance.y > radians * -1) {
				return true;
			}
			else
			{
				return false;
			}
			
		}
		
		public function EndGame() {
			isGameEnded = true;
			
			gameOver = new GameOver();
			gameOver.x = tower.position.x;
			gameOver.y = tower.position.y;
			stage.addChild(gameOver);
			
			for(var i:int = 0; i < Main.RandomRange(100,150); i++) {
				ps.AddParticle(tower.position,"Explosion");
			}
			
			for(var ii:int = 0; ii < planes.length; ii++) {
				planes[ii].state = 5;
			}
			tower.removeEventListener(Event.ENTER_FRAME,tower.Update);
			stage.removeChild(tower);
			stage.removeChild(tower.healthRed);
			stage.removeChild(tower.healthGreen);
		}
		
		public function RestartGame() {
			isGameEnded = false;
			stage.removeChild(gameOver);
			trace("Restarting Game...");
			tower.health = 100;
			tower.addEventListener(Event.ENTER_FRAME,tower.Update);
			stage.addChild(tower);
			stage.addChild(tower.healthRed);
			stage.addChild(tower.healthGreen);
			
			for(var i:int = planes.length - 1; i > -1; i--) {
				this.removeChild(this.planes[i]);
				var removePlane:Plane = this.planes.removeAt(i);
				removePlane.state = 4;
			}
			
			waveNumber = 0;
			waveIncrement = 0;
			this.CreateWave();
		}
	}
}
