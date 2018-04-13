package  {
	
	import flash.display.MovieClip;
	import flash.events.*;
	
	public class Bullet extends MovieClip {
		
		var main:Main
		var position:Vector2;
		var velocity:Vector2;
		var lifeTime:int;
		
		public function Bullet(main:Main) {
			this.main = main;
			this.position = new Vector2(0,0);
			this.velocity = new Vector2(0,0);
			lifeTime = 0; 
			this.addEventListener(Event.ENTER_FRAME,Update);
		}
		
		public function Update(event) {
			this.x = position.x;
			this.y = position.y;
			
			position.add(velocity);
			
			if(Main.InRange(25,this.position,main.tower.position)) {
				for(var i:int = 0; i < Main.RandomRange(5,10); i++) {
					main.ps.AddParticle(main.tower.position,"Metal");
				}
				main.tower.health -= 5;
				this.removeEventListener(Event.ENTER_FRAME,Update);
				stage.removeChild(this);
			}
			if(lifeTime >= main.stage.frameRate) {
				this.removeEventListener(Event.ENTER_FRAME,Update);
				stage.removeChild(this);
			}
			lifeTime++;
		}
	}
	
}
