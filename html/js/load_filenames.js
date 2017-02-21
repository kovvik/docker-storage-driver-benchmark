$( document ).ready( function() {
  var resultset = JSON.parse($.ajax({
      url: "results/resultset.json",
      dataType: "json",
      async: false
      }).responseText);
  for(i=0; i < resultset.length; i++) {
    document.getElementById("test_selector").innerHTML += '<option value="' + resultset[i] +'">' + resultset[i] + '</option>';
  }
});
