component
{
	import com.cfsilence.service.TestService;
	
	variables.util = new com.cfsilence.util.Util();
	variables.service = new TestService();
	 
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
	
	remote Artist function getArtistById( numeric id )
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
	
	remote Art function getArtById( numeric id )
	{
		return variables.util.deflate( variables.service.getArtById( id ) );
	}
}