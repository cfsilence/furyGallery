component{

	public function init()
	{
		return this;	
	}
	
	public any function inflate( any object )
	{
		
	}
	
	public struct function deflate( any instance, string parent='' )
	{
		var md = getMetadata( arguments.instance );
		var props = md.properties;
		var object = {};
		for( var i =1; i<=arrayLen(props); i++ )
		{
			var prop = props[ i ];
			var assemble = structKeyExists( prop, 'assemble' ) && prop.assemble;
			var ignore = false;
			if( structKeyExists( prop, "cfc" ) && prop.cfc == arguments.parent )
			{
				ignore = true;
			}
			if( assemble && !ignore )
			{
				object[ prop.name ] = '';
			}
		}

		for( var instanceProp in object )
		{
			var instanceVar = evaluate( 'arguments.instance.get' & instanceProp & '()' );
			
			instanceVar = isNull( instanceVar ) ? '' : instanceVar;
			
			if( isSimpleValue( instanceVar ) )
			{
				object[ instanceProp ] = instanceVar;
			}
			else
			{
				if( isArray( instanceVar ) )
				{
					var items = [];
					
					for( var item in instanceVar )
					{
						arrayAppend( items, this.deflate( item, md.fullName ) );
					}
					object[ instanceProp ] = items;
				}
				else{
					object[ instanceProp ] = this.deflate( instanceVar, md.fullName );
				}
			}
		}
		object[ '__type__' ] = md.fullName;
		
		return object;
	}
}