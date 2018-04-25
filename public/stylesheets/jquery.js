$(".up").click(function(){
	var num = $(this).parent().children(".val").val();
	$(this).parent().children(".val").focus();
	if ( num < 99 )
	{
		num = Number(num) + Number(1);
		$(this).parent().children(".val").val(num);
	}
})
$(".down").click(function(){
	var num = $(this).parent().children(".val").val();
	$(this).parent().children(".val").focus();
	if ( num > 1 )
	{
		num -= 1;
		$(this).parent().children(".val").val(num)
		
	}
})

function isNumberKey(evt)
{
   var charCode = (evt.which) ? evt.which : event.keyCode;
   if(charCode == 59 || charCode == 46)
	return true;
   if (charCode > 31 && (charCode < 48 || charCode > 57))
	  return false;
   return true;
}


$(".remove").click(function(){
	$(this).parent().parent().remove();
});

function Gia(gia){

	var team='';
	for($i=gia.toString().length-1;$i>=0;$i--){
		team += gia.toString()[$i];
	}

	gia = team;
	team = '';

	for($i=0;$i<gia.toString().length;$i++){

		if(($i+1)%3==0 && ($i+1)!=gia.toString().length)
			team+= gia.toString()[$i]+',';
		else
			team+= gia.toString()[$i];
	}

	gia='';
	for($i=team.toString().length-1;$i>=0;$i--){
		gia += team.toString()[$i];
	}

	return gia + "đ";

}

	$(".loc").before('<input class="valmin" name="min" hidden="hidden" /><input hidden="hidden" class="valmax" name="max"/><div class="max"></div><div class="cen">-</div><div class="min"></div><input class="focus" value="" />');
	var valmin = Number($(".pire").attr("data-valmin"));
	var rank = Number($(".pire").attr("data-rank"));
	
	var right = 239 - Number(Math.round($(".pire").attr("data-max")/rank));
	var left = Number($(".pire").attr("data-min")/rank);
	$(".min").html(Gia(left*rank + valmin));
	$(".max").html(Gia((239-right)*rank + valmin));
	$(".valmin").val(left*rank + valmin);
	$(".valmax").val((239-right)*rank + valmin);
	$(".pire").width(239 - left - right);
	$(".pire").css({"marginRight": right });
	$(".pire").css({"marginLeft": left });
	var val = 172;	var dagging = null;
	$(".content-pire").on("mousedown",".pire", function(e){
		dagging = e.target;
		val = Math.round(Number($(".container").css("marginLeft").substring(0,$(".container").css("marginLeft").length - 2 )) + 35.3);
	});
	
	$(document.body).on("mousemove", function(e){
		if( dagging ){
			var vt = e.pageX - val;
			var width = $(".pire").width();
			$(".focus").focus();
			if( vt > width/2 + left){
				tamp = Math.round(239 - (e.pageX - val));
				if ( tamp > -1 && tamp < (234 - left) ){
					right = tamp;
					$(".pire").width(e.pageX - val - left);
					$(".pire").css({"marginRight": right });
					$(".min").html(Gia(left*rank + valmin));
					$(".max").html(Gia((e.pageX - val)*rank + valmin));
					$(".valmin").val(left*rank + valmin);
					$(".valmax").val((e.pageX - val)*rank + valmin);
				}
			}
			else
			{
				tamp = Math.round(e.pageX - val);
				if( tamp > -1 && tamp < (234 - right) ){
					left = tamp;
					$(".pire").width(val + 239 - e.pageX - right);
					$(".pire").css({"marginLeft": left });
					$(".min").html(Gia(left*rank + valmin) );
					$(".max").html(Gia((239 - right)*rank + valmin));
					$(".valmin").val(left*rank + valmin);
					$(".valmax").val((239 - right)*rank + valmin);
				}
			}
		
		}
	});
	
	$(document.body).on("mouseup", function(){
		dagging = null;
	});
	
	$(".rang").before('<input name="star" class="valstar" hidden="hidden" />');
	$(".step1 .icon").click(function(){
		$(".rang").addClass("rang-1");
		$(".rang").removeClass("rang-2");
		$(".rang").removeClass("rang-3");
		$(".rang").removeClass("rang-4");
		$(".rang").removeClass("rang-5");
		$(".valstar").val(1);
	});
	
	$(".step2 .icon").click(function(){
		$(".rang").addClass("rang-2");
		$(".rang").removeClass("rang-3");
		$(".rang").removeClass("rang-4");
		$(".rang").removeClass("rang-5");
		$(".valstar").val(2);
	});
	
	$(".step3 .icon").click(function(){
		$(".rang").addClass("rang-3");
		$(".rang").removeClass("rang-4");
		$(".rang").removeClass("rang-5");
		$(".valstar").val(3);
	});
	
	$(".step4 .icon").click(function(){
		$(".rang").addClass("rang-4");
		$(".rang").removeClass("rang-5");
		$(".valstar").val(4);
	});
	
	$(".step5 .icon").click(function(){
		$(".rang").addClass("rang-5");
		$(".valstar").val(5);
	});
	

/*
var name = document.getElementsByName("show");

$(".show-replay").click(function(){
	var id = $(this).attr('for');
	if($('#'+id).attr("checked") == true){
		alert("");
		$('#'+id).attr("checked",false);
	}
	else
	{
		alert("ádfasd");
		$('#'+id).attr("checked",true);
	}
})
*/

/*
$(".min").val(left*10000);
$(".max").val((239+right)*5000);
var bool = false;
$(".pire").on("mousedown",function(e){
	bool = true;
	
	
});

$(this).on("mouseup", function(){
		bool = false;
		
	});

$(this).on("mousemove", function(e){
		var vt = e.pageX - 172;
		var width = $(".pire").width();
		if( bool) {
			if( vt > width/2 + left){
				right = 239	 - (e.pageX - 172);
				if ( right > -1 && left > -1 ){
					$(".pire").width(e.pageX - 172 - left);
					$(".pire").css({"marginRight": right });
					$(".min").val(left*10000);
					$(".max").val((e.pageX - 172)*10000);
				}
			}
			else
			{
				left = e.pageX - 172;
				if( right > -1 && left > -1 ){
					$(".pire").width(411 - e.pageX - right);
					$(".pire").css({"marginLeft": left });
					$(".min").val(left*10000);
					$(".max").val((239+right)*10000);
				}
			} 
		}
	});

*/
$(document).ready(function () {
    $('#myCarousel').carousel({
        interval: 10000
    })
    $('.fdi-Carousel .item').each(function () {
        var next = $(this).next();
        if (!next.length) {
            next = $(this).siblings(':first');
        }
        next.children(':first-child').clone().appendTo($(this));

        if (next.next().length > 0) {
            next.next().children(':first-child').clone().appendTo($(this));
        }
        else {
            $(this).siblings(':first').children(':first-child').clone().appendTo($(this));
        }
    });
});

$(".khuyenmai").click(function(){
    
    $.ajax({
        url:"/trangchu/giohang/check",
        type:"POST",
        dataType:"html",
        data:{ makhuyenmai: $("#numberlucky").val(),
        },
        success: function(data){ 
            alert(data);
        }
    });
});

$(".add").click(function(){
    var num = $(this).parent().parent().children(".price").children(".number").children(".val").val();
    var id = $(this).attr("data-id");
    $.ajax({
        url:"/addcart",
        type:"POST",
        dataType:"html",
        data:{ id: id, num: num, authenticity_token: $("#authenticity_token").val(),
        },
        success: function(data){ 
            alert("Đã Thêm Vào Giỏ Hàng");
            $("#cartquantity").html(data);
        }
    });
})

$(".add-to-cart").click(function(){
    var num = $(this).parent().children("#number").val();
    var id = $(this).attr("data-id");
    $.ajax({
        url:"/addcart",
        type:"POST",
        dataType:"html",
        data:{ id: id, num: num, authenticity_token: $("#authenticity_token").val()
        },
        success: function(data){ 
            alert("Đã Thêm Vào Giỏ Hàng");
            $("#cartquantity").html(data);
        }
    });
});


$(".btn-rank").click(function(){
	var star = $(".valstar").val();
	var id = $(".btn-rank").data("id");
	if (star > 0)
	{
            $(".btn-rank").attr('disabled', 'disabled');
            $.ajax({
                url:"/rank",
                type:"POST",
                dataType:"html",
                data:{star: star, id: id, authenticity_token: $("input:hidden[name=authenticity_token]").val()
                },
                success: function(){ 
                    location.reload();
                    $(".btn-rank").attr('disabled', false);
                }
            });
	}
        else
        {
            alert("Bạn Chưa Chọn Đánh Giá");
        }
});
/*
$(".show-replay").click(function(){
	$("#"+$(this).attr("for")).parent().children(".form-replay").children(".bl-comment").focus();
});
*/
$(".btn-comment.sanpham").click(function(){
	var noidung = $(this).parent().children(".bl-comment").val().replace(/\r?\n/g, "<br>");
	var bl = $(this).attr("data-bl")
    
	
	if (noidung.length > 10)
	{
            $.ajax({
                url:"/trangchu/sanpham/binhluan",
                type:"POST",
                dataType:"html",
                data:{noidung: noidung, id_sp: sp, id_bl: bl
                },
                success: function(data){ 
                    if (data == 1){
                        if (confirm("Bạn Chưa Đăng Nhập") == true)
                        {
                            window.location.href = "/trangchu/dangnhap";
                        }
                    }
                    else{
                        $(".load-commnet").html(data);
                        $(".bl-comment").val("");
                    }
                }
            });
	}
        else
        {
            alert("Nội Dung Bình Luận Phải Lớn Hơn 50 Ký Tự");
        }
});


$(".btn-comment.tintuc").click(function(){
	var noidung = $(this).parent().children(".bl-comment").val().replace(/\r?\n/g, "<br>");
	var bl = $(this).attr("data-bl")
	if (noidung.length > 10)
	{
            $.ajax({
                url:"/comment/news",
                type:"POST",
                dataType:"html",
                data:{noidung: noidung, id_tin: sp, id_bl: bl,
                },
                success: function(data){ 
                    if (data == 1){
                        if (confirm("Bạn Chưa Đăng Nhập") == true)
                        {
                            window.location.href = "/trangchu/dangnhap";
                        }
                    }
                    else{
                        $(".load-commnet").html(data);
                        $(".bl-comment").val("");
                    }
                }
            });
	}
        else
        {
            alert("Nội Dung Bình Luận Phải Lớn Hơn 50 Ký Tự");
        }
})


$(".choose").on("change",function(){
	
	$.ajax({
                url:"/trangchu/thanhtoan/chon",
                type:"POST",
                dataType:"html",
                data:{id: $(".choose").val(),
                },
                success: function(data){ 
                    $(".reply-comment").html(data)
                }
            });
})


$(".thanhtoan").click(function(){
	$.ajax({
		url:"/trangchu/thanhtoan/dathang",
		type:"POST",
		dataType:"html",
		data:  $("#new_nguoidung").serialize()+"&idthanhtoan=" +$(".choose").val()+"&diachi=" +$("#diachi2").val(),
		success: function(data){ 
			alert(data)
		}
	});
	
	
})

$("footer").before('<div class="top"><i class="glyphicon glyphicon-menu-up"></i></div>');

$(window).scroll(function(){
	
	if($(window).scrollTop() > 80){
		$(".top").show();
	}
	else
	{
		$(".top").hide();
	}
	
});

$(".top").click(function(){
	$('body,html').animate({
	scrollTop: 0
	});
});



$(window).scroll(function() {
	if($(window).scrollTop() > 80){
		$(".top").show();
	}
	else
	{
		$(".top").hide();
	}
	
});


	var bool = true;
$("#detail").css({"height":"850px","overflow":"hidden"});
$("#more").click(function(){
	if( bool == true ){
		$(this).parent().css({"height":"auto","overflow":"visible"});
		$(this).html("Thu nhỏ");
		bool = false;
	}
	else{
		$(this).parent().css({"height":"850px","overflow":"hidden"});
		$(this).html("Đọc thêm");
		bool = true;
		$('body,html').animate({
		scrollTop: 1100
		});
	}
});


$("#id_shipment").change(function(){
   var price = $(this).find('option:selected').data('price');
   var messager = $(this).find('option:selected').data('choose');
   $(".reply-comment").html(messager);
   var tr = $(this).closest('tbody').find('tr');
   tr.eq(tr.length-3).find('td').html(price.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + ' đ');
   tr.eq(tr.length-2).find('td').html((price + parseInt(tr.eq(tr.length-4).find('td').text().replace(/,/g, '').replace('đ',''))).toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + ' đ');
});
