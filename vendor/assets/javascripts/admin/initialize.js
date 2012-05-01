$.initialize = function() {
	// --------------- Navigation ----------------------------
	$('a').bind("tap", function(e) {
		if($(this).attr("rel") != "external") {
			if(!$(this).data("href")) {
				return false;
			}
			/* ADDED function for real page changes */
			function changePage(page, title){
				if(title==undefined) {
					title = $(this).text();
				}
				$.change(page, title);
			}
			var element = $( $(this).data("href") );
			if(!$(this).parents("ul.tabs").length>0) {
				if ($(this).data("href").charAt( 0 ) == '#' ) {
					if( $(this).hasAttr('data-reveal') ) {
						if( element.is(":hidden") ) {
							element.fadeIn(200);
						} else {
							element.fadeOut(200);
						}	
					} else if ( $(this).hasAttr('data-modal') ) {
						if(element.size()>0) {
							element.modal();
						} else {
							$.info({desc: "The hash <strong>"+$(this).data("href")+"</strong> is not valid"});
						}
					} else {
						var page = $(this).data("href");
						var title = element.data("title");
						
						if(title==undefined) {
							title = $(this).text();
						}
						$.change(page, title);
					}
				} else {
					if ( $(this).hasAttr('data-modal') ) {
						$.fn.modal(
							{
								url: $(this).data("href")
							}
						);
					// }
					/* ADDED real page changes */
					}else{
						var page = $(this).data("href");
						var title = element.data("title");
						changePage(page, title);
					}
				}
			} else {
				var tab = $("div.tabs > " + $(this).data("href"));
				if(tab.length>0) {
					$(this).parents("ul.tabs, .section").children("div.tabs").children(".tab.current").removeClass("current");
					$(this).parents("ul.tabs, .section").children("div.tabs").children($(this).data("href")).addClass("current");
					$(this).parents("ul.tabs").children("li.current").removeClass("current");
					$(this).parents("li").addClass("current");
				} else {
					$.info({desc: "The hash <strong>"+$(this).data("href")+"</strong> is not valid"});
				}
			}
			e.preventDefault();
		} else {
			window.location.href = $(this).attr("data-href");
		}
	});
	if (window.location.hash) {
		var url = location.hash;
		var caption = $(url).data("title");
		window.location.hash = "";
		$.change(url, caption);
	} else {
		var url = "#" + $(".section.current").attr("id");
		var caption = $(url).data("title");
		$.change(url, caption, true);
	}
	$(window).hashchange( function(){
	    var page = location.hash;
	    var title = $(page).data("title");
	    if($(page).length>0) {
		    if(title==undefined) {
		    	document.title = "Dashboard"
		    } else {
		    	document.title = title + " - Dashboard";
		    }
		    $(".section.current").removeClass("current").hide();
		    $('a[data-href*="#"].current').removeClass("current");
		    
		    $('a[data-href*="' + page + '"]').addClass("current");
		    $(page).addClass("current").show();
		    $(document).scrollTop(0);
	    } else {
	    	$.info({desc: "The page <strong>"+page+"</strong> was not found."});
	    }
	});	
	// -------------------------------------------------------
	
	// --------------- Add class to body ---------------
	$("body").addClass("dashboard");
	// -------------------------------------------------------
	

	// --------------- Check for touch devices ---------------
	if (window.Touch) {
		$("head").append('<meta name="viewport" content="user-scalable=no, initial-scale = 1, minimum-scale = 1, maximum-scale = 1, width=device-width" /><meta name="apple-mobile-web-app-capable" content="yes" /><meta name="apple-mobile-web-app-status-bar-style" content="black" />')
	};
	// -------------------------------------------------------

	// --------------- Overlay initialization ----------------
	$("body").append('<div id="overlays"></div>');
	$("#overlays.dark").live("tap", function() {
		$(this).removeClass("dark");
		$("#overlays .modal").remove();
	});
	// -------------------------------------------------------

	// --------------- Span image replace --------------------
	$("#header ul li > ul > li > img.avatar").each(function() {
		$(this).replaceWith( $('<span />').addClass("avatar").css("background-image", "url("+$(this).attr("src")+")") );
	});
	$("#header ul li.avatar, .comment .avatar").each(function() {
		var src = $(this).children("img").attr("src");
		$(this).children("img").remove();
		$(this).css("background-image", "url("+src+")");
	});
	// -------------------------------------------------------
	
	// --------------- Tabs in carton ------------------------
	$(".carton, .carton .column").each(function() {
		if($(this).children(".content").length>1) {
			var len = $(this).children(".content").length;
			$(this).addClass("multiple");
			$(this).children(".content:first").addClass("current");
			
			var round = $('<ul class="round" />');
			
			for (var i = 0; i < len; i++) {
				$('<li />').appendTo(round);
			}
			
			round.children("li:first").addClass("current");
			
			$('ul.round li', this).live("tap", function() {
				var index = $(this).index();
				var carton = $(this).parent("ul").parent();
				
				carton.children("ul").children("li.current").removeClass("current");
				$(this).addClass("current");
				
				carton.children(".content.current").removeClass("current");
				carton.children(".content").eq(index).addClass("current");
			})
			
			$(this).append(round);
			
		}
	});
	// -------------------------------------------------------
	
	// --------------- Menu elements -------------------------
	$("#header > ul > li").bind("tap", function() {
		var menu = $(this).children("ul");
		$("#header").removeClass("inactive");
		
		if(menu.length>0) {
			$("#header > ul > li").removeClass("active");
			$(this).addClass("active");
			$("#header > ul > li > ul").not(menu).hide();
			$("#header").addClass("inactive");
			if(menu.is(":hidden")) {
				menu.show();
			} else {
				menu.hide();
				$(this).removeClass("active");
				$("#header").removeClass("inactive");
			} 	
			
		} else {
			$("#header > ul > li > ul").hide();
			$("#header").removeClass("inactive");
			$("#header > ul > li").removeClass("active");
		}
		return false;
	});
	$("body").bind("tap", function() {
		$("#header > ul > li > ul").hide();
		$("#header").removeClass("inactive");
		$("#header > ul > li").removeClass("active");	
	});
	// -------------------------------------------------------
	
	// --------------- Removal of title/a attribute ----------
	$('[title]').attr('title', function(i, title) {
	    $(this).data('title', title).removeAttr('title');
	});
	$('a[href]').attr('href', function(i, title) {
	    $(this).data('href', title).removeAttr('href').attr('data-href', title);
	});
	// -------------------------------------------------------
	
	// --------------- Tabs initialization -------------------
	$("ul.tabs").each(function() {
		var hash = $(this).children("li.current").children("a").data("href");
		var tab = $(this).siblings("div.tabs").children(hash);
		if(tab.length>0) {
			tab.addClass("current");
		} else {
			tab = $(this).siblings("div.tabs").children("div.tab:first-child");
			href = "#" + tab.attr("id");
			$(this).children("li.current").removeClass("current");
			$('li a[data-href="'+href+'"]', this).parent("li").addClass("current");
			tab.addClass("current");
		}
	});
	// -------------------------------------------------------
	
	// // --------------- Pull to refresh -----------------------
	// if ($.browser.webkit && navigator.platform=='MacIntel') {
	// 	var distance;
	// 	$('body').append('<div class="pull"><span class="icon">w</span><div>Pull <span>to refresh</span></div></div>');
	// 	$(window).scroll(function () {
	// 		if($(window).scrollTop() < 0) {
	// 			distance = -$(window).scrollTop()*1.6;
	// 			$("#stream").addClass("hide");
	// 			if(distance < 2) {
	// 				distance = 0;
	// 				$("#stream").removeClass("hide");
	// 			}
	// 			if(distance > 62) {
	// 				$('.pull div').html('Release <span>to refresh</span>');
	// 				$('.pull .icon').addClass('release');
	// 			} else {
	// 				$('.pull div').html('Pull <span> to refresh</span>');
	// 				$('.pull .icon').removeClass('release');
	// 			}
	// 			
	// 			if(distance > 300) {
	// 				distance = 300;
	// 			}
	// 			
	// 			$("#dashboard").css("-webkit-transform", "translateY("+distance+"px"+")");
	// 		} else if ($(window).scrollTop() > 0) {
	// 			$("#stream").removeClass("hide");
	// 		} else {
	// 			$("dashboard").css("-webkit-transform", "translateY(0)");
	// 		}
	// 	});
	// }
	// -------------------------------------------------------
	
	$("#footer").bind("tap", function() {
		if($("body").hasClass("feather")) {
			$("body").removeClass("feather");
		} else {
			$("body").addClass("feather");
		}
	});
};

//This $.demo function can easily be deleted without hurting core functionality - just be aware that demo won't function properly.
// $.demo = function() {	
// 	$.notification( 
// 		{
// 			title: 'Pastel was initialized successfully!',
// 			content: 'Welcome to the Dashboard.',
// 			icon: "="
// 		}
// 	);
// }

// Initializing of the Pastel Dashboard!
$(document).ready(function() {
	$.initialize();
	// $.demo();
});