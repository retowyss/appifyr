$("#<<submit>>").click(function(){
  var req = ocpu.rpc(
    "<<rfunction>>",
    {<<body>>},
    function(output){
      $("<<target>>").<<jsfunction>>(output);
    }
  );
  req.fail(function(){
    alert("Error in R function call: " + req.responseText);
  });
});
