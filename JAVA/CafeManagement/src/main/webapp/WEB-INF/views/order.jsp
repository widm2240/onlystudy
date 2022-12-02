<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<table style='width:100%;border:1px solid green;'>
	<tr><td style='width:33%;text-align:center' ><a href='/menu'><h3>메뉴관리</h3></a></td>
		<td style='width:33%;text-align:center'><h3>주문관리</h3></td>
		<td style='width:33%;text-align:center'><a href='/sales'><h3>실적관리</h3></a></td>
	</tr>
</table>
<table align=center style='border-collapse:collapse;border:1px solid blue;'>
<tr>
	<td style='border:1px solid blue;'><select id=selMenu size=20 style='width:200px'></select></td>
	<td style='border:1px solid blue;'><select id=selOrder size=20 style='width:200px'></select></td>
</tr>
<tr>
	<td style='border:1px solid blue;vertical-align:top'>
		<table>
		<tr><td>메뉴</td><td><input type=text id=name readonly size=20></td></tr>
		<tr><td>수량</td><td><input type=number id=qty min=1 max=99>잔</td></tr>
		<tr><td>가격</td><td><input type=number id=price min=0 max=9999>원
							<input type=hidden id=net>
						</td></tr>
		<tr><td colspan=2 align=center>
			<input type=button id=btnOrder value='주문'>&nbsp;
			<input type=button id=btnEmpty value='비우기'>
		</td></tr>
		</table>
	</td>
	<td style='border:1px solid blue;vertical-align:top'>
		<table>
		<tr><td>총금액</td><td><input type=text readonly id=total size=5>원</td></tr>
		<tr><td>모바일번호</td><td><input type=text id=mobile size=15></td></tr>
		<tr><td colspan=2><label id=lblComment></label></td></tr>
		<tr><td colspan=2 align=center>
			<input type=button id=btnComplete value='주문완료'>&nbsp;
			<input type=button id=btnCancel value='주문취소'>
		</td></tr>
		</table>
	</td>
</tr>
</table>
</body>
<script src='https://code.jquery.com/jquery-3.4.1.js'></script>
<script>
$(document)
.ready(function(){
	getList();
})
.on('click','#selMenu option',function(){ // 익명함수(unnamed function), 콜백(call back)함수.
	let str=$(this).text();
	let ar=str.split(',');
	$('#name').val($.trim(ar[1]));
	$('#qty').val(1);
	$('#price,#net').val($.trim(ar[2]));
	return false;
})
.on('change','#qty',function(){
	let qty=parseInt($(this).val());
	let price = qty*parseInt($('#net').val());
	$('#price').val(price);
	return false;
})
.on('click','#btnEmpty',function(){
	$('#name,#qty,#price').val('');
	return false;
})
.on('click','#btnOrder',function(){
	let str='<option>'+$('#name').val()+', x'+$('#qty').val()+', '+$('#price').val()+'</option>';
	$('#selOrder').append(str);
	$('#btnEmpty').trigger('click');
	let total=0;
	$('#selOrder option').each(function(){
		let str=$(this).text();
		let ar=str.split(',');
		total=total+parseInt(ar[2]);
	});
	$('#total').val(total);
	return false;
})
.on('click','#btnCancel',function(){
	$('#selOrder').empty();
	$('#total,#mobile').val('');
	return false;
})
.on('click','#btnComplete',function(){
	$('#selOrder option').each(function(){
		let str=$(this).text();
		let ar=str.split(',');
		ar[1]=parseInt(ar[1].substr(2));
		ar[2]=parseInt($.trim(ar[2]));
		$.post('http://localhost:8081/addOrder',
				{mobile:$('#mobile').val(),menu:ar[0],qty:ar[1],price:ar[2]},function(rcv){
			$('#lblComment').text(str+" inserted");
			$('#btnCancel').trigger('click');
			setTimeout(function(){
				$('#lblComment').text('');
			},5000);
		},'text');
	});
})

function getList(){
	$.post('http://localhost:8081/loadMenu',{},function(rcv){
		$('#selMenu').empty();
		for(i=0; i<rcv.length; i++){
			let str='<option>'+rcv[i]['id']+', '+rcv[i]['name']+', '+rcv[i]['price']+'</option>';
			$('#selMenu').append(str);
		}
		$('#btnEmpty').trigger('click');
	},'json');
}
</script>
</html>