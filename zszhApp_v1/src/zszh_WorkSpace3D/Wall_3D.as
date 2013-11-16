package zszh_WorkSpace3D
{
 
	
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Geometry;
	import away3d.core.base.SubGeometry;
	import away3d.core.pick.PickingColliderType;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.materials.MaterialBase;
	import away3d.materials.TextureMaterial;
	
	import zszh_WorkSpace3D.WorkSpace3D;
	
	
	
	public class Wall_3D extends ObjectContainer3D
	{
		//material objects
		private var _wallMaterial:TextureMaterial;
		private var _wallHeight:int;
		private var _wallWidth:int;
		
		//vertexs data
		private var _pos1Vec:Vector.<Number>;
		private var _pos2Vec:Vector.<Number>;//inside
		private var _pos3Vec:Vector.<Number>;//outside
		private var _isVisible:Vector.<Boolean>;
		
		public function Wall_3D(vertex1:Vector.<Number>,vertex2:Vector.<Number>,vertex3:Vector.<Number>,isVisible:Vector.<Boolean>,material:MaterialBase)
		{
			super();
			if(vertex1.length!=vertex2.length || 
				vertex2.length!=vertex3.length ||
				vertex1.length!=vertex3.length || 
				vertex1.length!=isVisible.length ||
				vertex1.length < 1 ||
				vertex2.length <1 || 
				vertex3.length<1 || 
				isVisible.length < 1)
			{ 
				trace("ERROR:Wall_3D vertex data is worry!");
			}
				
			_pos1Vec= vertex1;
			_pos2Vec= vertex2;
			_pos3Vec= vertex3;
			_isVisible= isVisible;
			_wallHeight=270;
			_wallWidth=20;
			_wallMaterial = material;
		}
		

		private function BuiltWalls():void
		{
			var posLen:int=posVec.length;
			
			for(var i:int=0;i<posLen;i+=2)
			{
				var gem:Geometry=new Geometry();
				var subGeom : SubGeometry = new SubGeometry;
				
				var vertex : Vector.<Number> = new Vector.<Number>;
				var index : Vector.<uint> = new Vector.<uint>;
				var uv : Vector.<Number> = new Vector.<Number>;
				
				//p0  pi pi+1 顺时针方向 三角形
				vertex.push(posVec[i],wallHeight, posVec[i+1],
					posVec[(i+2)%posLen],wallHeight, posVec[(i+3)%posLen],
					posVec[(i+2)%posLen],floorZ, posVec[(i+3)%posLen],
					posVec[i],floorZ, posVec[i+1]);
				
				index.push(0,1,2,0,2,3);
				
				//uv 还是有点问题
				var dx:Number= posVec[(i+2)%posLen]- posVec[i];
				var dy:Number= posVec[(i+3)%posLen]- posVec[i+1];				
				var p1:Number=Math.sqrt(dx*dx+dy*dy);
				
				
				uv.push(0, _wallHeight/uvScale,
					p1/uvScale, _wallHeight/uvScale,
					p1/uvScale, floorZ/uvScale,
					0, floorZ/uvScale);
				
				subGeom.updateVertexData(vertex);
				subGeom.updateIndexData(index);
				subGeom.updateUVData(uv);
				gem.addSubGeometry(subGeom);
				
				
				var wallPlane:Mesh=new Mesh(gem,material);
				addChild(wallPlane);
				
				wallPlane.mouseEnabled=true;
				wallPlane.pickingCollider=PickingColliderType.AS3_BEST_HIT;
				
				wallPlane.addEventListener(MouseEvent3D.MOUSE_DOWN,onObjectMouseDown);
				wallPlane.addEventListener(MouseEvent3D.MOUSE_UP,onObjectMouseUp);
				wallPlane.addEventListener(MouseEvent3D.MOUSE_OVER,onObjectMouseOver);
				wallPlane.addEventListener(MouseEvent3D.MOUSE_OUT,onObjectMouseOut);
			}
			
			
			
		}

		
		
		//-------------mouse event----------------------------------
		private function onObjectMouseDown( event:MouseEvent3D ):void {
			var mesh:Mesh=event.target as Mesh;  
			mesh.bounds.boundingRenderable.color=0xff0000;
			mesh.showBounds=true;
		}
		
		private function onObjectMouseUp( event:MouseEvent3D ):void {
			WorkSpace3D.SetMousePosition(event.scenePosition);
		}
		
		private function onObjectMouseOver( event:MouseEvent3D ):void {
			var mesh:Mesh=event.target as Mesh;  
			mesh.bounds.boundingRenderable.color=0xff0000;
			mesh.showBounds=true;
			
			WorkSpace3D.SetCurrentWallMesh(mesh);
			WorkSpace3D.SetMousePosition(event.scenePosition);
		}
		
		private function onObjectMouseOut( event:MouseEvent3D ):void {
			var mesh:Mesh=event.target as Mesh;  
			mesh.showBounds=false;
		}
		
		
	}
}