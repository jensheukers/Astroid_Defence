package  {
	
	public class Group {

		var main:Main;
		var size:int
		var planes:Array;
		
		var roamingX:Vector2;
		var roamingY:Vector2;
		
		public function Group(size:int,main:Main) {
			main.groups.push(this);
			roamingX = new Vector2(0 - 200,main.GetStageData().x + 200);
			roamingY = new Vector2(0 - 200, main.GetStageData().y + 200);
			planes = new Array();
			this.main = main;
			this.size = size;
			CreateGroup();
		}
		
		public function CreateGroup() {
			for(var i:int = 0; i < size; i++) {
				var p:Plane = new Plane(main,this,new Vector2(main.RandomRange(-200,0),main.RandomRange(-200,0)));
				planes.push(p);
				main.AddPlane(p);
				main.addChild(p);
			}
			
			var leader:int = main.RandomRange(0,planes.length - 1);
			for(i = 0; i < planes.length; i++) {
				planes[i].SetLead(planes[leader]);
			}
			//SetRandomGroupColor();
		}
		
		public function DisposeGroup() {
			for(var i:int = planes.length - 1; i >= 0; i = i - 1) {
				planes[i].leader = planes[i];
				planes.removeAt(i);
				trace("Removed from Group: " + i );
			}
		}
		
		public function SetRandomGroupColor() {
			var chosenColor:int = main.RandomRange(0,2);
			
			for(var i:int = 0; i < planes.length; i++) {
				
			switch(chosenColor) {
				case 0:
					planes[i].planeColor.color = 0x00ff11;
					break;
				case 1:
					planes[i].planeColor.color = 0x00ffe1;
					break;
				case 2:
					planes[i].planeColor.color = 0xff00e9;
					break;
				}
			}
		}
	}
	
}
