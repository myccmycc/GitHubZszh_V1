package zszh_WorkSpace3D
{
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import mx.containers.Panel;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Geometry;
	import away3d.core.base.SubGeometry;
	import away3d.core.math.MathConsts;
	import away3d.debug.Trident;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.lights.DirectionalLight;
	import away3d.lights.PointLight;
	import away3d.materials.ColorMaterial;
	import away3d.materials.MaterialBase;
	import away3d.materials.TextureMaterial;
	import away3d.materials.TextureMultiPassMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.PlaneGeometry;
	import away3d.utils.Cast;
	
	public class WallInside_3D extends ObjectContainer3D
	{
		//plane textures
		[Embed(source="/../embeds/floor_diffuse.jpg")]
		public static var WallDiffuse:Class;
		
		//WorkSpace3D _lightPicker
		private var _lightPicker:StaticLightPicker;
		//material objects
		private var _wallMaterial:MaterialBase;

		
		//vertexs data
		private var posVec:Vector.<Number>;
		private var _wallHeight:int;
		private var _wallWidth:int;
		private var _floorY:int;
		
		private var _uvScale:int;
		
		public function WallInside_3D(_pos1:Vector.<Number>,lightPicker:StaticLightPicker)
		{
			super();
			
			posVec=_pos1;
			_wallHeight=270;
			_wallWidth=20;
			_floorY=0;
			_uvScale=100;
			
			_lightPicker=lightPicker;
			
			InitMaterials();
			BuiltWall();
			BuiltWallTop();
		}
		
		
		public function BuiltWall():void
		{
			var gem:Geometry=new Geometry();
			
			var posLen:int=posVec.length;
			for(var i:int=0;i<posLen;i+=2)
			{
				var subGeom : SubGeometry = new SubGeometry;
				
				var vertex : Vector.<Number> = new Vector.<Number>;
				var index : Vector.<uint> = new Vector.<uint>;
				var uv : Vector.<Number> = new Vector.<Number>;
				
				//p0  pi pi+1 顺时针方向 三角形
				vertex.push(posVec[i],_wallHeight, posVec[i+1],
					posVec[(i+2)%posLen],_wallHeight, posVec[(i+3)%posLen],
					posVec[(i+2)%posLen],_floorY, posVec[(i+3)%posLen],
					posVec[i],_floorY, posVec[i+1]);
				
				
				
				
				var v1:Point=new Point(posVec[2]-posVec[0],posVec[3]-posVec[1]);
				var v2:Point=new Point(posVec[4]-posVec[2],posVec[5]-posVec[3]);
				
				var d:Number=v1.x*v2.y-v1.y*v2.x;
				if(d>0)	
					index.push(0,1,2,0,2,3);
				else index.push(0,3,2,0,2,1);
				
				//uv 还是有点问题
				var dx:Number= posVec[(i+2)%posLen]- posVec[i];
				var dy:Number= posVec[(i+3)%posLen]- posVec[i+1];				
				var p1:Number=Math.sqrt(dx*dx+dy*dy);
				 
				
				uv.push(0, _wallHeight/_uvScale,
					p1/_uvScale, _wallHeight/_uvScale,
					p1/_uvScale, _floorY/_uvScale,
					0, _floorY/_uvScale);

				subGeom.updateVertexData(vertex);
				subGeom.updateIndexData(index);
				subGeom.updateUVData(uv);
				gem.addSubGeometry(subGeom);
			}

			addChild(new Mesh(gem,_wallMaterial));
		}
 
		public function BuiltWallTop():void
		{
			var gem:Geometry=new Geometry();
			
			var subGeom : SubGeometry = new SubGeometry;
			var vertex : Vector.<Number> = new Vector.<Number>;
			var index : Vector.<uint> = new Vector.<uint>;
			
			//p0  pi pi+1 顺时针方向 三角形
			vertex.push(posVec[0],_wallHeight, posVec[1],
						posVec[2],_wallHeight, posVec[3],
						posVec[4],_wallHeight, posVec[5],
						posVec[6],_wallHeight, posVec[7]);
			
			var v1:Point=new Point(posVec[2]-posVec[0],posVec[3]-posVec[1]);
			var v2:Point=new Point(posVec[4]-posVec[2],posVec[5]-posVec[3]);
			
			var d:Number=v1.x*v2.y-v1.y*v2.x;
			if(d<0)	
				index.push(0,1,2,0,2,3);
			else index.push(0,3,2,0,2,1);
			subGeom.updateVertexData(vertex);
			subGeom.updateIndexData(index);
			gem.addSubGeometry(subGeom);
			
			var whiteMaterial :ColorMaterial = new ColorMaterial(0xeff3f6, 1);
			whiteMaterial.lightPicker=_lightPicker;
			addChild(new Mesh(gem,whiteMaterial));
		}
		
		private function InitMaterials():void
		{
			//_wallMaterial = new TextureMaterial(Cast.bitmapTexture(WallDiffuse));
			 _wallMaterial  = new ColorMaterial(0xccd3d9, 1);
			_wallMaterial.lightPicker=_lightPicker;
			_wallMaterial.repeat=true;
		}
		private function onObjectMouseDown( event:MouseEvent3D ):void {
			event.target.showBounds=true;
		}
	}
}