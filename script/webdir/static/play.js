<script type="text/javascript">

$( function() {
	$( "[type=button]" ).on("click",
		function() {
			var val=$(this).val();
			$.ajax( {
				type: "POST",
				url: val,
				success: function( data ) {
					var dt = data;
					$( '#message' ).text(dt);
				},
					error: function( data ) {
					$( '#message' ).txt("read_NG");
				}
			} );
		}
	);
} );

                document.getElementById("stop").onclick = function stop(){
                        var xhttp = new XMLHttpRequest();
                        xhttp.onreadystatechange = function(){
                                if(this.readyState == 4 && this.status == 200) {
                                        document.getElementById("message").innerHTML = this.responseText;
                                }
                        };
                        xhttp.open("GET","/stop",true);
                        xhttp.send();
                }

                document.getElementById("random").onclick = function random(){
                        var xhttp = new XMLHttpRequest();
                        xhttp.onreadystatechange = function(){
                                if(this.readyState == 4 && this.status == 200) {
                                        document.getElementById("message").innerHTML = this.responseText;
                                }
                        };
                        xhttp.open("GET","/random",true);
                        xhttp.send();
                }

		document.getElementById("soundminus").onclick = function soundminus(){
                        var xhttp = new XMLHttpRequest();
                        xhttp.onreadystatechange = function(){
                                if(this.readyState == 4 && this.status == 200) {
                                        document.getElementById("message").innerHTML = this.responseText;
                                }
                        };
                        xhttp.open("GET","/soundplus",true);
                        xhttp.send();
                }

		document.getElementByClassName("container4").onclick = function soundplus(){
                        var xhttp = new XMLHttpRequest();
                        xhttp.onreadystatechange = function(){
                                if(this.readyState == 4 && this.status == 200) {
                                        document.getElementById("message").innerHTML = this.responseText;
                                }
                        };
                        xhttp.open("GET","/soundminus",true);
                        xhttp.send();
                }



</script>
