document.addEventListener("DOMContentLoaded", function() {
$(function() {
	$('.btn-gNav').on("click", function(){
		$(this).toggleClass('open');
		$('#gNav').toggleClass('open');
	});
});
});