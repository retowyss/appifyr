// Handle form submission for plotting function
$("#submit-<<id>>").click(function(){
  // Show loading indicator
  $("#target-<<id>>").html('<div class="text-center p-3"><div class="spinner-border" role="status"><span class="sr-only">Loading...</span></div></div>');
  
  // Make the OpenCPU request
  var req = $("#target-<<id>>").rplot(
    "<<rf>>",
    {<<json>>}
  );
  
  // Handle failure case with better error display
  req.fail(function(xhr, textStatus, errorThrown){
    console.error("OpenCPU request failed:", textStatus, errorThrown);
    $("#target-<<id>>").html(
      '<div class="alert alert-danger">' +
      '<h4 class="alert-heading">Error</h4>' +
      '<p><<err>>' + xhr.responseText + '</p>' +
      '</div>'
    );
  });
  
  // Add successful response handling
  req.done(function(){
    console.log("OpenCPU request completed successfully");
  });
});
