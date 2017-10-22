$("#<<button>>").click(function(){
  var req = $("#<<canvas>>").rplot("<<r_fun>>", {
      <<<<args>>>>
  });

  //optional
  req.fail(function(){
      alert("R returned an error: " + req.responseText);
  });
});

