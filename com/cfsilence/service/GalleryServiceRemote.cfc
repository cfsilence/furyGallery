component
{
	import com.cfsilence.service.GalleryService;
	
	variables.util = new com.cfsilence.util.Util();
	variables.service = new GalleryService();
	 
	remote array function getArtists()
	{
		var artists = variables.service.getArtists();
		var artistObjects = [];
		for( var artist in artists )
		{
			arrayAppend( artistObjects, variables.util.deflate( artist ) );
		}	 
		return artistObjects;
	}
	
	remote numeric function saveArtist( string artist='' )
	{
		var deserializedArtist = deserializeJSON(arguments.artist);
		var artistObj = variables.service.getArtistById( structKeyExists( deserializedArtist, "artistId") ? deserializedArtist.artistId : -1 );
		return variables.service.saveArtist( variables.util.populate( artistObj, deserializedArtist ) );
	}
	
	remote struct function getArtistById( numeric id )
	{
		return variables.util.deflate( variables.service.getArtistById( id ) );
	}
	
	remote array function getArt()
	{
		var art = variables.service.getArt();
		var artObjects = [];
		for( var piece in art )
		{
			arrayAppend( artObjects, variables.util.deflate( piece ) );
		}	 
		return artObjects;
	}
	
	remote struct function getArtById( numeric id )
	{
		return variables.util.deflate( variables.service.getArtById( id ) );
	}
}