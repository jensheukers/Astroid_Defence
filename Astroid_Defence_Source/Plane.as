package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.DataEvent;
	import flash.geom.ColorTransform;
	
	public class Plane extends MovieClip {
		
		var position:Vector2;
		var main:Main;
		var planeGroup:Group;
		
		var force:Vector2;
		var velocity:Vector2;
		var acceleration:Vector2;
		var topSpeed:int;

		var state:int;
		var canShoot:Boolean;
		var gotTarget:Boolean;
		var leader:Plane;
		var leading:Boolean;
		var specialState:Boolean;
		
		var dir:Vector2;
		var targetPos:Vector2;
		
		var view:Number;
		var planeColor:ColorTransform;
		
		var health:int;
		var timer:int;
		var bullets:Array;
		
		var afterBurner:AfterBurner;
		
		public function Plane(main:Main, planeGroup:Group,pos:Vector2) {
			this.timer = 0;
			this.main = main;
			this.planeGroup = planeGroup;
			topSpeed = main.RandomRange(2,6);
			view = main.RandomRange(60,100);
			position = pos;
			acceleration = new Vector2();
			velocity = new Vector2();
			force = new Vector2(0,0);
			state = 0;
			this.targetPos = this.ChangeTargetPos();
			this.bullets = new Array();
			this.addEventListener(Event.ENTER_FRAME,this.Update);
			
			afterBurner = new AfterBurner();
			afterBurner.x -= 13;
			afterBurner.y -= 1;
			afterBurner.alpha = 0;
			this.addChild(afterBurner);
			
			if(Math.random() < 0.2) {
				specialState = true;
			}
			else
			{
				specialState = false;
			}
			planeColor = this.transform.colorTransform;
			//planeColor.color = 0x00ff0c;
			gotTarget = true;
			this.health = 100;
		}
		
		public function Update(event) {
			//Position ect
			this.x = position.x;
			this.y = position.y;
			this.transform.colorTransform = planeColor;
			
			switch(state) {
				case 0: //Roaming Behavior
					if(this.state != 4 && leader.state == 4) {
						this.state = 1;
						this..topSpeed = main.RandomRange(7,8);
					}
					if(InRange(view,main.tower.position)) {
						for(i = 0; i < planeGroup.planes.length; i++) {
							if(planeGroup.planes[i].state != 4) {
								planeGroup.planes[i].state = 1;
								planeGroup.planes[i].topSpeed = main.RandomRange(7,8);
							}
						}
					}
					else if(InRange(150,targetPos) && leading) {
						trace("Reached Point " + targetPos);
						targetPos = this.ChangeTargetPos();
						trace("New Point " + targetPos);
					}
					
					//Check for collision
					
					for(i = 0; i < planeGroup.planes.length; i++) {
						if(InRange(10,planeGroup.planes[i].position) && planeGroup.planes[i] != this) {
						}
					}
					
					break;
				case 1: //Attack Behavior
					afterBurner.alpha = 0;
					planeGroup.DisposeGroup();
					
					canShoot = true;
					if(InRange(75,main.tower.position)) {
						//planeColor.color = 0xffbb00;
						gotTarget = false;
						state = 2;
					}
					else
					{
						//planeColor.color = 0xff0000;
						targetPos = new Vector2(main.tower.position.x,main.tower.position.y);
						gotTarget = true;
						
						if(timer == main.stage.frameRate * 1.5 && canShoot){
							timer = 0;
							ShootBullet();
						}
						else
						{
							timer++
						}
					}
					break;
				case 2:
					afterBurner.alpha = 1;
					if(!InRange(350,main.tower.position)) {
						//planeColor.color = 0xff8300;
						state = 3;
					}
					break;
				case 3:
					gotTarget = true;
					this.rotation += 75;
					var tempVelocity:Vector2 = new Vector2(Math.cos((this.rotation) * Math.PI / 180) * Math.floor(topSpeed * 0.9), Math.sin((this.rotation) * Math.PI / 180) * Math.floor(topSpeed * 0.9));
					targetPos = new Vector2(position.x + tempVelocity.x, position.y + tempVelocity.y);
					if(InRange(350, main.tower.position)) {
						state = 1;
					}
					break;
					
				case 4: //Dead
					canShoot = false;
					break;
				
				case 5: //Game Ended
					targetPos = new Vector2(1000,1000);
					break;
			}
			var destination:Vector2
			if(gotTarget) {
				if(!leading && state == 0) {
					 destination = new Vector2(leader.targetPos.x,leader.targetPos.y);
				}
				else
				{
					destination = new Vector2(this.targetPos.x,this.targetPos.y);
				}
			
				dir = Vector2.sub(destination,position);

				dir.normalize();
				dir.mult(new Vector2(0.5,0.5));
				acceleration = dir;
			}
			for(var i:int = 0; i < planeGroup.planes.length; i++) {
				if(InRange(1,planeGroup.planes[i].position)) {
					acceleration.add(new Vector2(0.2,0.2));
				}
			}
			
			velocity.add(acceleration);
			velocity.limit(topSpeed);
			position.add(velocity);
		
			
			if(force.x > 0 || force.y > 0 ) {
				force.add(new Vector2(-0.01,-0.01));
			}
			this.rotation = Vector2.rad2deg(velocity.heading());
			
		}
		
		public function InRange(radians:int,otherPos:Vector2) : Boolean{
			var distance:Vector2 = position.GetDistance(otherPos); 
			if(distance.x < radians && distance.x > radians * -1 && distance.y < radians && distance.y > radians * -1) {
				return true;
			}
			else
			{
				return false;
			}
			
		}
		
		public function ChangeTargetPos():Vector2 {
			return new Vector2(main.RandomRange(planeGroup.roamingX.x,planeGroup.roamingX.y),main.RandomRange(planeGroup.roamingY.x,planeGroup.roamingY.y));
		}
		
		public function SetLead(leader:Plane) {
			if(leader != this) {
				this.leader = leader;
				leading = false
				this.targetPos = leader.position;
			}
			else
			{
				this.leader = this;
				leading = true;
			}
			
		}
		
		public function ShootBullet() {
			var b:Bullet = new Bullet(main);
			main.stage.addChild(b);
			b.rotation = this.rotation;
			b.position = new Vector2(this.position.x,this.position.y);
			b.velocity.add(this.velocity);
			b.velocity.mult(new Vector2(4,4));
		}
	}
	
}
