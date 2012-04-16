component extends="mxunit.framework.TestCase"
{
	function setUp()
	{
		variables.service = createObject('component', 'furyGallery.com.cfsilence.service.TestService');
		variables.util = createObject('component', 'furyGallery.com.cfsilence.util.Util').init();
	}
	
	private function getDefalatedObject()
	{
		var obj = variables.service.getArtistById(2);
		return variables.util.deflate( obj );		
	}
	
	function canDeflateObjectIntoStruct()
	{
		assertIsStruct( getDefalatedObject() );			
	}
	
	function canInflateDeflatedObject()
	{
		var obj = getDefalatedObject();
		var inflated = variables.util.inflate( obj );
		debug( inflated );		
	}
	
	function tearDown()
	{
		
	}
}