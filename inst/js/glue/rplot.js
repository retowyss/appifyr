$("#submit-<<id>>").click(function(){
  var req = $("#target-<<id>>").rplot(
    "<<rf>>",
    {<<json>>}
  );
  req.fail(function(){
    alert(<<err>> + req.responseText);
  });
});
