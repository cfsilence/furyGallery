component
{
	
	public array function getArtists()
	{
		return entityLoad('Artist');
	}
	
	public boolean function saveArtist( com.cfsilence.artgallery.Artist artist )
	{
		entitySave( artist );
		return true;
	}
	
	public com.cfsilence.artgallery.Artist function getArtistById( numeric id )
	{
		return entityLoadByPK('Artist', arguments.id);
	}
	
	public array function getArt()
	{
		return entityLoad('Art');
	}
	
	public com.cfsilence.artgallery.Art function getArtById( numeric id )
	{
		return entityLoadByPK('Art', arguments.id);
	}
}