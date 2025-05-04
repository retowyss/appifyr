<<an>> : (function(){
  var x = $('#<<an>>-<<id>>').val();
  // Check if the value is a number and parse it appropriately
  return isNaN(parseFloat(x)) ? x : parseFloat(x);
})()
