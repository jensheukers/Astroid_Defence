package  {
	import flash.display.MovieClip;
	import flash.events.*;
	
	public class MetalParticle extends Particle{
		
		public function MetalParticle(pos:Vector2,ptype:String) {
			this.ptype = ptype;
			velocity = new Vector2(CalculateVelocityDirection() * 6,CalculateVelocityDirection());
			acceleration = new Vector2(0,0.05);
			this.position = new Vector2(pos.x,pos.y);
			this.x = position.x;
			this.y = position.y;
		}
		
		public override function Move() {
			velocity.add(acceleration);
			velocity.limit(topSpeed);
			position.add(velocity);
			this.rotation = Vector2.rad2deg(velocity.heading());
		}
	}
}
