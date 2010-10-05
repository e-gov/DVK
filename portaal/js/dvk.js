var toggleSubrow = {
	init : function(){
		$("td.toggle-subrow").children("a").click(this.clickIt);
	},
	clickIt : function(){
		var anchor = $(this);
		var row    = anchor.parents("tr:eq(0)");
		var subrow = row.next("tr.subrow");

		if(subrow.css("display") != "none") {
			subrow.css("display","none");
			row.removeClass("parent");
			anchor.removeClass("open");
		}
		else {
			subrow.css("display","");
			row.addClass("parent");
			anchor.addClass("open");
		}
		return false;
	}
};
var toggleSubrowToggle = {
	init : function(){
		$("p.subrow-toggle").find("a").click(this.clickIt);
	},
	clickIt : function(){
		var table = $(this).parent().next("table");
		    if (table.length < 1)
		    table = $(this).parent().parent().next("table");
		    if (table.length < 1)
		    table = $(this).parent().parent().parent().next("table");
		var anchor = table.find("td.toggle-subrow").find("a");
		var subrow = table.find(".subrow");

		if($(this).hasClass("open")) {
			subrow.css("display","");
			anchor.addClass("open");
		}
		else {
			subrow.css("display","none");
			anchor.removeClass("open");
		}
		return false;
	}
};

$(function(){
	toggleSubrow.init();
	toggleSubrowToggle.init();
	if($("input.date-range").length){
		$("input.date-range").datepick({ rangeSelect: true });
	}
	$("tr.subrow").css("display","none");
	$("div.moreinfo").css("display","none");
});