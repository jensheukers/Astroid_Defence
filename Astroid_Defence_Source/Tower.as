package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class Tower extends MovieClip {
		
		var position:Vector2;
		var theta:Number;
		var crossHair:CrossHair;
		var mussleFlash:MussleFlash;
		var crossHairPosition:Vector2;
		var health:Number;
		var healthGreen:HealthGreen;
		var healthRed:HealthRed;
		var healthBarResolution:int;
		
		var main:Main;
		
		
		public function Tower(main:Main) {
			this.main = main;
			crossHair = new CrossHair;
			crossHair.x = 300;
			this.addChild(crossHair);
			mussleFlash = new MussleFlash;
			mussleFlash.x += 50;
			mussleFlash.alpha = 0;
			this.addChild(mussleFlash);
			theta = 0;
			position = new Vector2(main.GetStageData().x / 2, main.GetStageData().y / 2);
			this.addEventListener(Event.ENTER_FRAME,this.Update);
			health = 100;
			
			healthRed = new HealthRed();
			healthRed.width = healthRed.width / 2;
			healthRed.height = healthRed.height / 2;
			healthRed.x = this.position.x - healthRed.width / 2;
			healthRed.y = this.position.y - 50;
			
			healthGreen = new HealthGreen();
			healthGreen.width = healthGreen.width / 2;
			healthGreen.height = healthGreen.height / 2;
			healthGreen.x = this.position.x - healthGreen.width / 2;
			healthGreen.y = this.position.y - 50;
			healthBarResolution = healthGreen.width;
			
			main.stage.addChild(healthRed);
			main.stage.addChild(healthGreen);
		}
		
		public function Update(event) {
			var pt:Point = new Point(crossHair.x, crossHair.y);
			pt = crossHair.parent.localToGlobal(pt);
			crossHairPosition = new Vector2(pt.x,pt.y);
			
			
			healthGreen.width = Math.floor(healthBarResolution * health) / 100;
			this.x = position.x;
			this.y = position.y;
			
			this.rotation += Vector2.rad2deg(theta);
			theta = 0;
			
			if(crossHair.x > 300) {
				crossHair.x = 300;
			}
			else if (crossHair.x < 100) {
				crossHair.x = 100;
			}
			
			if(this.health <= 0) {
				if(!main.isGameEnded) {
					main.EndGame();
				}
			}
		}
		
		public function RangeIncrease() {
			this.crossHair.x += 3;
		}
		
		public function RangeDescrease() {
			this.crossHair.x -= 3;
		}
		
		public function RotateClockWise() {
			theta = 0.050;
		}
		
		public function RotateCounterClockWise() {
			theta = -0.050;
		}
		
		public function GenerateHealth() {
			if(health < 100) {
				health += 0.5;
			}
		}
		
		public function ShootCannon() {
			for(var i:int = 0; i < main.planes.length; i++) {
				if(Main.InRange(25,crossHairPosition,main.planes[i].position)) {
					//Cheaty remove way || just temp
					GenerateHealth();
					for(var ii:int = 0; ii < Main.RandomRange(20,30); ii++) {
						main.ps.AddParticle(main.planes[i].position,"Explosion");
					}
					main.removeChild(main.planes[i]);
					var removePlane:Plane = main.planes.removeAt(i);
					removePlane.state = 4;
				}
			}
		}
	}
	
}
