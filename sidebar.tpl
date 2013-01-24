<aside id="sidebar" {if $sidebarPosition == 'left'}class="sidebar-profile"{/if}>
  {include file='blocks.tpl' group='right'}
<div class="block"> 
{literal} 
<script type="text/javascript" src="//vk.com/js/api/openapi.js?77"></script>


<!-- VK Widget -->
<div id="vk_groups"></div>
<script type="text/javascript">
VK.Widgets.Group("vk_groups", {mode: 0, width: "240", height: "430"}, 42246254);
</script>
{/literal}
</div>
</aside>
