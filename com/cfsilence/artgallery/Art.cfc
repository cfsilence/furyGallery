component persistent='true' table='art' entityname='Art' accessors='true'
{
	property name='artId' type='numeric' generator='increment' assemble='true';
	property name='artist' assemble='true' inverse='true' fieldtype='many-to-one' fkcolumn='artistId' cfc='com.cfsilence.artgallery.Artist';
	property name='artName' type='string' assemble='true';
	property name='description' type='string' assemble='true';
	property name='price' type='numeric' assemble='true';
	property name='largeImage' type='string' assemble='true';
	property name='media' fieldtype='one-to-one' inverse='true' cfc='com.cfsilence.artgallery.Media' fkcolumn='mediaId' assemble='true';
	property name='isSold' type='boolean' assemble='true';
}