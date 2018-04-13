package  {
	import flash.display.MovieClip;
	import flash.events.*;
	
	public class Particle extends MovieClip{
		
		var lifeSpan:Number;
		var lifeSpanDecreaseMax:Number;
		var ptype:String;
		var topSpeed:int;
		var position:Vector2;
		var velocity:Vector2;
		var acceleration:Vector2;
		
		public function Particle() {
			topSpeed = 10;
			lifeSpanDecreaseMax = 3
			lifeSpan = 1;
			this.addEventListener(Event.ENTER_FRAME,this.Update);
		}
		
		public function Update(event) {
			lifeSpan -= Main.RandomRange(0,lifeSpanDecreaseMax) / 100;
			this.alpha = lifeSpan;
			this.x = position.x;
			this.y = position.y;
			
			Move();
		}
		
		public function Move() {
			
		}
		
		public function IsDead() :Boolean {	
			if(this.lifeSpan < 0) {
				return true;
			} 
			else 
			{
			return false;
			}
		}
		
		public function CalculateVelocityDirection():Number {
			var value:Number = Math.random();
			if(Math.random() > 0.5) {
				value = value * -1;
			}
			
			return value;
		}
	}
}
