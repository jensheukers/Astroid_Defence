package  {
	import flash.events.*;
	
	public class ParticleSystem {
		
		var main:Main;
		var particles:Array;
		
		public function ParticleSystem(main:Main) {
			this.main = main;
			particles = new Array();
		}
		
		public function AddParticle(position:Vector2,ptype:String) {
			switch(ptype) {
				case "Explosion":
					var pe:ExplosionParticle = new ExplosionParticle(position,ptype);
					particles.push(pe);
					main.stage.addChild(pe);
					break;
				case "Metal":
					var pm:MetalParticle = new MetalParticle(position,ptype);
					particles.push(pm);
					main.stage.addChild(pm);
					break;
			}
		}
		
		public function Update() {
			CheckParticles();
		}

		public function CheckParticles() {
			for(var i:int = particles.length - 1; i >= 0; i--) {
				if(particles[i].IsDead()) {
					switch(particles[i].ptype) {
						case "Explosion":
							var deadExplosionParticle:ExplosionParticle = particles.removeAt(i);
							deadExplosionParticle.removeEventListener(Event.ENTER_FRAME,deadExplosionParticle.Update);
							main.stage.removeChild(deadExplosionParticle);
							break;
						case "Metal":
							var deadMetalParticle:MetalParticle = particles.removeAt(i);
							deadMetalParticle.removeEventListener(Event.ENTER_FRAME,deadMetalParticle.Update);
							main.stage.removeChild(deadMetalParticle);
							break;
					}
				}
			}
		}
	}
	
}
