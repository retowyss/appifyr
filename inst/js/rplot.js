$("#<<button>>").click(function(){
  var req = $("#<<canvas>>").rplot("<<r_fun>>", {
      <<<<args>>>>
  });

  //Error
  req.fail(function(){
      alert("Error in R function call: " + req.responseText);
  });
});

