component{

	public function init()
	{
		return this;	
	}
	
	public any function populate( any cfObject, struct object )
	{
		for( var key in object )
		{
			if( key != '__type__' && isSimpleValue( object[key] ) && len( trim( object[key]) ) )
			{
				try
				{
					evaluate( 'cfObject.set' & key & '("' & object[ key ] & '")' ); 
				}				
				catch( any e )
				{
					// fail silently.  could be a computed property from the client
				}
			}
		}
		
		return cfObject;
	}
	
	public any function inflate( struct object ) hint="expects a struct with a '__type__' key (as would come from the deflate() function) in order to serialize back into a cf object"
	{
		if( !structKeyExists( object, "__type__" ) )
		{
			throw "inflate() requires a '__type__' key in order to serialize this object";
		}
		
		var obj = createObject( 'component', object['__type__'] );
		
		for( var key in object )
		{
			if( key != '__type__' )
			{
				if( isSimpleValue( object[key] ) && len( trim( object[key]) ) )
				{
					evaluate( 'obj.set' & key & '("' & object[ key ] & '")' ); 				
				}
				// only inflate simple values for now.  complex values aren't working
				/*
				if( isArray( object[key] ) )
				{
					for( var child in object[key] )
					{
						var childObj = inflate( child );
						request.debug( key );
						request.debug( obj );
						request.debug( childObj );
						request.debug( 'obj.add' & key & '()' );
						obj.addArt( childObj );
						evaluate( 'obj.add#key#(#childObj#)' );  // for some unknown reason this throws a 'complex objects can not be converted to simple values' error.  why?  who knows...
					}
				}
				*/
			}
		}
		
		return obj;
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