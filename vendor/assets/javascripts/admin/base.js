// @ESSENTIAL Hash change
(function ($, e, b) {
    var c = "hashchange",
        h = document,
        f, g = $.event.special,
        i = h.documentMode,
        d = "on" + c in e && (i === b || i > 7);

    function a(j) {
        j = j || location.href;
        return "#" + j.replace(/^[^#]*#?(.*)$/, "$1")
    }
    $.fn[c] = function (j) {
        return j ? this.bind(c, j) : this.trigger(c)
    };
    $.fn[c].delay = 50;
    g[c] = $.extend(g[c], {
        setup: function () {
            if (d) {
                return false
            }
            $(f.start)
        },
        teardown: function () {
            if (d) {
                return false
            }
            $(f.stop)
        }
    });
    f = (function () {
        var j = {},
            p, m = a(),
            k = function (q) {
                return q
            },
            l = k,
            o = k;
        j.start = function () {
            p || n()
        };
        j.stop = function () {
            p && clearTimeout(p);
            p = b
        };

        function n() {
            var r = a(),
                q = o(m);
            if (r !== m) {
                l(m = r, q);
                $(e).trigger(c)
            } else {
                if (q !== m) {
                    location.href = location.href.replace(/#.*/, "") + q
                }
            }
            p = setTimeout(n, $.fn[c].delay)
        }
        $.browser.msie && !d && (function () {
            var q, r;
            j.start = function () {
                if (!q) {
                    r = $.fn[c].src;
                    r = r && r + a();
                    q = $('<iframe tabindex="-1" title="empty"/>').hide().one("load", function () {
                        r || l(a());
                        n()
                    }).attr("src", r || "javascript:0").insertAfter("body")[0].contentWindow;
                    h.onpropertychange = function () {
                        try {
                            if (event.propertyName === "title") {
                                q.document.title = h.title
                            }
                        } catch (s) {}
                    }
                }
            };
            j.stop = k;
            o = function () {
                return a(q.location.href)
            };
            l = function (v, s) {
                var u = q.document,
                    t = $.fn[c].domain;
                if (v !== s) {
                    u.title = h.title;
                    u.open();
                    t && u.write('<script>document.domain="' + t + '"<\/script>');
                    u.close();
                    q.location.hash = v
                }
            }
        })();
        return j
    })()
})(jQuery, this);
// @ESSENTIAL Push hash change
(function($){
	$.change = function(page, title, first) {
	if(!$(page).length>0) {
		$.info({desc: "The hash <strong>"+page+"</strong> is not valid"});
	} else {
		window.location.hash = page;
		if (!$.browser.msie && first==true) {
			history.replaceState('', title, page);
		}
	}
};
})(jQuery);
// @ESSENTIAL Notifications
(function ($) {
    $.notification = function (settings) {
       	var con, notification, hide, image, right, left, inner;
        
        settings = $.extend({
        	title: undefined,
        	content: undefined,
            timeout: 0,
            img: undefined,
            border: true,
            fill: false,
            showTime: false,
            click: undefined,
            icon: undefined,
            color: undefined,
            error: false
        }, settings);
        
        con = $("#notifications");
        if (!con.length) {
            con = $("<div>", { id: "notifications" }).appendTo($("#overlays"))
        };
        
		notification = $("<div>");
        notification.addClass("notification animated fadeInLeftMiddle fast");
        
        if(settings.error == true) {
        	notification.addClass("error");
        }
        
        if( $("#notifications .notification").length > 0 ) {
        	notification.addClass("more");
        } else {
        	con.addClass("animated flipInX").delay(1000).queue(function(){ 
        	    con.removeClass("animated flipInX");
        			con.clearQueue();
        	});
        }
        
        hide = $("<div>", {
			click: function () {
				 
				
				if($(this).parent().is(':last-child')) {
				    $(this).parent().remove();
				    $('#notifications .notification:last-child').removeClass("more");
				} else {
					$(this).parent().remove();
				}
			}
		});
		
		hide.addClass("hide");

		left = $("<div class='left'>");
		right = $("<div class='right'>");
		
		if(settings.title != undefined) {
			var htmlTitle = "<h2>" + settings.title + "</h2>";
		} else {
			var htmlTitle = "";
		}
		
		if(settings.content != undefined) {
			var htmlContent = settings.content;
		} else {
			var htmlContent = "";
		}
		
		inner = $("<div>", { html: htmlTitle + htmlContent });
		inner.addClass("inner");
		
		inner.appendTo(right);
		
		if (settings.img != undefined) {
			image = $("<div>", {
				style: "background-image: url('"+settings.img+"')"
			});
		
			image.addClass("img");
			image.appendTo(left);
			
			if(settings.border==false) {
				image.addClass("border")
			}
			
			if(settings.fill==true) {
				image.addClass("fill");
			}
			
		} else {
			if (settings.icon != undefined) {
				var iconType = settings.icon;
			} else {
				if(settings.error!=true) {
					var iconType = '"';
				} else {
					var iconType = '!';
				}
			}	
			icon = $('<div class="icon">').html(iconType);
			
			if (settings.color != undefined) {
				icon.css("color", settings.color);
			}
			
			icon.appendTo(left);
		}

        left.appendTo(notification);
        right.appendTo(notification);
        
        hide.appendTo(notification);
        
        function timeSince(time){
        	var time_formats = [
        	  [2, "One second", "1 second from now"], // 60*2
        	  [60, "seconds", 1], // 60
        	  [120, "One minute", "1 minute from now"], // 60*2
        	  [3600, "minutes", 60], // 60*60, 60
        	  [7200, "One hour", "1 hour from now"], // 60*60*2
        	  [86400, "hours", 3600], // 60*60*24, 60*60
        	  [172800, "One day", "tomorrow"], // 60*60*24*2
        	  [604800, "days", 86400], // 60*60*24*7, 60*60*24
        	  [1209600, "One week", "next week"], // 60*60*24*7*4*2
        	  [2419200, "weeks", 604800], // 60*60*24*7*4, 60*60*24*7
        	  [4838400, "One month", "next month"], // 60*60*24*7*4*2
        	  [29030400, "months", 2419200], // 60*60*24*7*4*12, 60*60*24*7*4
        	  [58060800, "One year", "next year"], // 60*60*24*7*4*12*2
        	  [2903040000, "years", 29030400], // 60*60*24*7*4*12*100, 60*60*24*7*4*12
        	  [5806080000, "One century", "next century"], // 60*60*24*7*4*12*100*2
        	  [58060800000, "centuries", 2903040000] // 60*60*24*7*4*12*100*20, 60*60*24*7*4*12*100
        	];
        	
        	var seconds = (new Date - time) / 1000;
        	var token = "ago", list_choice = 1;
        	if (seconds < 0) {
        		seconds = Math.abs(seconds);
        		token = "from now";
        		list_choice = 1;
        	}
        	var i = 0, format;
        	
        	while (format = time_formats[i++]) if (seconds < format[0]) {
        		if (typeof format[2] == "string")
        			return format[list_choice];
        	    else
        			return Math.floor(seconds / format[2]) + " " + format[1];
        	}
        	return time;
        };
        
        if(settings.showTime != false) {
        	var timestamp = Number(new Date());
        	
        	timeHTML = $("<div>", { html: "<strong>" + timeSince(timestamp) + "</strong> ago" });
        	timeHTML.addClass("time").attr("title", timestamp);
        	timeHTML.appendTo(right);
        	
        	setInterval(
	        	function() {
	        		$(".time").each(function () {
	        			var timing = $(this).attr("title");
	        			$(this).html("<strong>" + timeSince(timing) + "</strong> ago");
	        		});
	        	}, 4000)
        	
        }

        notification.hover(
        	function () {
            	hide.show();
        	}, 
        	function () {
        		hide.hide();
        	}
        );
        
        notification.prependTo(con);
		notification.show();

        if (settings.timeout) {
            setTimeout(function () {
            	var prev = notification.prev();
            	if(prev.hasClass("more")) {
            		if(prev.is(":first-child") || notification.is(":last-child")) {
            			prev.removeClass("more");
            		}
            	}
	        	notification.remove();
            }, settings.timeout)
        }
        
        if (settings.click != undefined) {
        	notification.addClass("click");
            notification.bind("click", function (event) {
            	var target = $(event.target);
                if(!target.is(".hide") ) {
                    settings.click.call(this)
                }
            })
        }
        return this
    }
})(jQuery);
// @ESSENTIAL HasAttr
(function($){
	$.fn.hasAttr = function(name) {  
	return this.attr(name) !== undefined;
};
})(jQuery);
// @ESSENTIAL Error / Info handling
(function($){
	$.info = function(options) {
	var defaults = { 
		icon: "!",
		type: "Error",  
		title: "404",
		particles: "multi",
		desc: "An error occurred",
		theme: undefined
	};  
	var o = $.extend(defaults, options); 
	
	var container;
	function create() {
		remove();
		$("body").addClass("hidden");
		container = $('<div class="particles" />');
		$("#overlays").addClass("info").append(container);
		
		if(o.theme!=undefined) {
			$("#overlays").addClass(o.theme);
		}
		
		$("#overlays").append('<div class="wrapper"><span class="icon">'+o.icon+'</span><h2>'+o.type+': <span>'+o.title+'</span></h2><span class="desc">'+o.desc+'<br>Click anywhere to dismiss this message.</span></div>');
		
		$("#overlays .wrapper").addClass("animated fadeInDown");
		
		$(".particles").live("tap", function() {
			remove();
		});
		
	}
	
	function remove() {
		$("#overlays").removeClass();
		$("#overlays .wrapper").remove();
		$("body").removeClass("hidden");
		$(".particles").remove();
	}
	
	$.getScript("assets/admin/three.js", function(){
		if (!window.requestAnimationFrame) {
		    window.requestAnimationFrame = (function () {
		        return window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame ||
		        function (callback, element) {
		            window.setTimeout(callback, 1000 / 60)
		        }
		    })()
		}
		var camera, scene, renderer, particle;
		var mouseX = 0,
		    mouseY = 0;
		var windowHalfX = window.innerWidth / 2;
		var windowHalfY = window.innerHeight / 2;
		
		create();
		init();
		animate();
		
		function init() {
		    camera = new THREE.Camera(75, window.innerWidth / window.innerHeight, 1, 3000);
		    camera.position.z = 1000;
		    scene = new THREE.Scene();
		    for (var i = 0; i < 180; i++) {
		    	if(o.particles=="multi") {
		    		var color = Math.random() * 0x808008 + 0x808080;
		    		//Math.random() * 0xCFF09E + 0x3B8686
		    	} else {
		    		var color = "0x" + o.particles;
		    	}
		        particle = new THREE.Particle(new THREE.ParticleCircleMaterial({
		            color: color,
		            opacity: 0.9
		        }));
		        particle.position.x = Math.random() * 2000 - 1000;
		        particle.position.y = Math.random() * 2000 - 1000;
		        particle.position.z = Math.random() * 2000 - 1000;
		        particle.scale.x = particle.scale.y = Math.random() * 10 + 1;
		        scene.addObject(particle)
		    }
		    renderer = new THREE.CanvasRenderer();
		    renderer.setSize(window.innerWidth, window.innerHeight);
		    container.append(renderer.domElement);
		    document.addEventListener('mousemove', onDocumentMouseMove, false);
		    document.addEventListener('touchstart', onDocumentTouchStart, false);
		    document.addEventListener('touchmove', onDocumentTouchMove, false)
		}
		function onDocumentMouseMove(event) {
		    mouseX = event.clientX - windowHalfX;
		    mouseY = event.clientY - windowHalfY
		}
		function onDocumentTouchStart(event) {
		    if (event.touches.length == 1) {
		        event.preventDefault();
		        mouseX = event.touches[0].pageX - windowHalfX;
		        mouseY = event.touches[0].pageY - windowHalfY
		    }
		}
		function onDocumentTouchMove(event) {
		    if (event.touches.length == 1) {
		        event.preventDefault();
		        mouseX = event.touches[0].pageX - windowHalfX;
		        mouseY = event.touches[0].pageY - windowHalfY
		    }
		}
		function animate() {
		    requestAnimationFrame(animate);
		    render()
		}
		function render() {
		    camera.position.x += (mouseX - camera.position.x) * 0.15;
		    camera.position.y += (-mouseY - camera.position.y) * 0.15;
		    renderer.render(scene, camera)
		}
	}).fail(function(jqxhr, settings, exception) {
		create();
	}); 
	
};
})(jQuery);
// @ESSENTIAL Touch events
jQuery.event.special.tap = {
    setup: function (a, b) {
        var c = this,
            d = jQuery(c);
        if (window.Touch) {
            d.bind("touchstart", jQuery.event.special.tap.onTouchStart);
            d.bind("touchmove", jQuery.event.special.tap.onTouchMove);
            d.bind("touchend", jQuery.event.special.tap.onTouchEnd)
        } else {
            d.bind("click", jQuery.event.special.tap.click)
        }
    },
    click: function (a) {
        a.type = "tap";
        jQuery.event.handle.apply(this, arguments)
    },
    teardown: function (a) {
        if (window.Touch) {
            $elem.unbind("touchstart", jQuery.event.special.tap.onTouchStart);
            $elem.unbind("touchmove", jQuery.event.special.tap.onTouchMove);
            $elem.unbind("touchend", jQuery.event.special.tap.onTouchEnd)
        } else {
            $elem.unbind("click", jQuery.event.special.tap.click)
        }
    },
    onTouchStart: function (a) {
        this.moved = false
    },
    onTouchMove: function (a) {
        this.moved = true
    },
    onTouchEnd: function (a) {
        if (!this.moved) {
            a.type = "tap";
            jQuery.event.handle.apply(this, arguments)
        }
    }
};