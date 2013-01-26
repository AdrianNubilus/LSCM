<!--  /templates/skin/synio/actions/ActionTopic/add.tpl  -->

{if $sEvent=='add'}
  {include file='header.tpl' menu_content='create'}
{else}
	{include file='header.tpl'}
	<h2 class="page-header">{$aLang.topic_topic_edit}</h2>
{/if}


{include file='editor.tpl'}


{hook run='add_topic_topic_begin'}


<form action="" method="POST" enctype="multipart/form-data" id="form-topic-add" class="wrapper-content">
	{hook run='form_add_topic_topic_begin'}

	
	<input type="hidden" name="security_ls_key" value="{$LIVESTREET_SECURITY_KEY}" />

	
	<p><label for="blog_id">{$aLang.topic_create_blog}</label>
	<select name="blog_id" id="blog_id" onChange="ls.blog.loadInfo(jQuery(this).val());" class="input-width-full">
		<option value="0">{$aLang.topic_create_blog_personal}</option>
		{foreach from=$aBlogsAllow item=oBlog}
			<option value="{$oBlog->getId()}" {if $_aRequest.blog_id==$oBlog->getId()}selected{/if}>{$oBlog->getTitle()|escape:'html'}</option>
		{/foreach}
	</select>
	<small class="note">{$aLang.topic_create_blog_notice}</small></p>

	
	<script type="text/javascript">
		jQuery(document).ready(function($){
			ls.blog.loadInfo($('#blog_id').val());
		});
    </script>
	
	
	<p><label for="topic_title">{$aLang.topic_create_title}:</label>
	<input type="text" id="topic_title" name="topic_title" value="{$_aRequest.topic_title}" class="input-text input-width-full" />
	<small class="note">{$aLang.topic_create_title_notice}</small></p>

	
	<label for="topic_text">{$aLang.topic_create_text}:</label>
	<textarea name="topic_text" id="topic_text" class="mce-editor markitup-editor input-width-full" rows="20">{$_aRequest.topic_text}</textarea>

	{if !$oConfig->GetValue('view.tinymce')}
		{include file='tags_help.tpl' sTagsTargetId="topic_text"}
		<br />
		<br />
	{/if}
	
	<p><label for="topic_tags">{$aLang.topic_create_tags}:</label>
	<input type="text" id="topic_tags" name="topic_tags" value="{$_aRequest.topic_tags}" class="input-text input-width-full autocomplete-tags-sep" />
	<small class="note">{$aLang.topic_create_tags_notice}</small></p>

	
	<p><label><input type="checkbox" id="topic_forbid_comment" name="topic_forbid_comment" class="input-checkbox" value="1" {if $_aRequest.topic_forbid_comment==1}checked{/if} />
	{$aLang.topic_create_forbid_comment}</label>
	<small class="note">{$aLang.topic_create_forbid_comment_notice}</small></p>

	
	{if $oUserCurrent->isAdministrator()}
		<p><label><input type="checkbox" id="topic_publish_index" name="topic_publish_index" class="input-checkbox" value="1" {if $_aRequest.topic_publish_index==1}checked{/if} />
		{$aLang.topic_create_publish_index}</label>
		<small class="note">{$aLang.topic_create_publish_index_notice}</small></p>
	{/if}

	<input type="hidden" name="topic_type" value="topic" />
	
	{hook run='form_add_topic_topic_end'}
<!-- map -->	
<script>
	var vallmappa = '{$_aRequest.coodrinati}';
</script>
<script src="https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false"></script>
{literal}
	<script type="text/javascript">
		var marker;
		var map;
		var markers = [];	
		var geocoder;
  
		$(document).ready(function(){
			initialize();
		});	
		function initialize() {
			geocoder = new google.maps.Geocoder();
			var latlng = new google.maps.LatLng(53.902315, 27.561758);
			var myOptions = {
				zoom: 12,
				center: latlng,
				mapTypeId: google.maps.MapTypeId.ROADMAP,  
				mapTypeControlOptions: {  
					style: google.maps.MapTypeControlStyle.DROPDOWN_MENU  
				}  
			};		
			map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
			google.maps.event.addListener(map, 'click', function(event) {
				setAllMap(null);
				addMarker(event.latLng);
			});
			if (vallmappa !='') {
				perr = vallmappa.split(',');
				myLatlng = new google.maps.LatLng(perr[0],perr[1]);
				setAllMap(null);
				addMarker(myLatlng);
			}						 
			
		}
		function getAttributeByIndex(obj, index){
			var i = 0;
			for (var attr in obj){
				if (index === i){
					return obj[attr];
				}
				i++;
			}
			return null;
		}
		function setAllMap(map) {
			for (var i = 0; i < markers.length; i++) {
				  markers[i].setMap(map);
			}
		}					  
		function addMarker(location) {
			marker = new google.maps.Marker({
				  position: location,
				  map: map
			});
			$('#coodrinati').val(getAttributeByIndex(location,0)+','+getAttributeByIndex(location,1));
			markers.push(marker);

		}				
		function codeAddress() {
			var address = document.getElementById('address').value;
			geocoder.geocode( { 'address': address}, function(results, status) {
				if (status == google.maps.GeocoderStatus.OK) {
					map.setCenter(results[0].geometry.location);
					setAllMap(null);
					addMarker(results[0].geometry.location);				
				} else {
					alert('Geocode was not successful for the following reason: ' + status);
				}
			});
		}			
	</script>
{/literal}	
<p><label for="topic_tags">1. Введите адрес и нажмите найти:</label>
    <input id="address" type="textbox" class="input-text" value="" style="width: 520px;"/>
    <input type="button" onclick="codeAddress()" class="button" value="Найти"/>
</p>
	
	<label for="topic_tags">2. Отметьте точное место на карте:</label>
	<i>для большей детализации можете переключить вид с карты на спутник</i><br/><br/>
	<div id="map_canvas" style="width: 600px; height: 300px;margin-bottom: 10px;"></div>
	<input type="hidden" name="coodrinati" value="{$_aRequest.coodrinati}" id="coodrinati">
<!-- end map -->
	<button type="submit"  name="submit_topic_publish" id="submit_topic_publish" class="button button-primary fl-r">{$aLang.topic_create_submit_publish}</button>
	<button type="submit"  name="submit_preview" onclick="ls.topic.preview('form-topic-add','text_preview'); return false;" class="button">{$aLang.topic_create_submit_preview}</button>
	<button type="submit"  name="submit_topic_save" id="submit_topic_save" class="button">{$aLang.topic_create_submit_save}</button>
</form>

	
<div class="topic-preview" style="display: none;" id="text_preview"></div>


{hook run='add_topic_topic_end'}


{include file='footer.tpl'}
