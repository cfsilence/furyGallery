component
{
	
	public array function getArtists()
	{
		return entityLoad('Artist');
	}
	
	public Artist function getArtistById( numeric id )
	{
		return entityLoadByPK('Artist', arguments.id);
	}
	
	public array function getArt()
	{
		return entityLoad('Art');
	}
	
	public Art function getArtById( numeric id )
	{
		return entityLoadByPK('Art', arguments.id);
	}
}