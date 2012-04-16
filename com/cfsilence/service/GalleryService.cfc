component
{
	
	public array function getArtists()
	{
		return entityLoad('Artist');
	}
	
	public numeric function saveArtist( com.cfsilence.artgallery.Artist artist )
	{
		entitySave( artist );
		
		return artist.getArtistId();
	}
	
	public com.cfsilence.artgallery.Artist function getArtistById( numeric id )
	{
		var artist =  entityLoadByPK('Artist', arguments.id);
		if( isNull( artist ) )
		{
			artist = entityNew('Artist');
		}
		return artist;
	}
	
	public array function getArt()
	{
		return entityLoad('Art');
	}
	
	public com.cfsilence.artgallery.Art function getArtById( numeric id )
	{
		var art = entityLoadByPK('Art', arguments.id);
		if( isNull( art ) )
		{
			art = entityNew('Art');
		}
		return art;
	}
}