 $(document).ready(function(){
    $(".blocmetrics").click(function(event){
    var clickedObject = $(event.target);
    var obj_id = clickedObject.prop('id');
    var obj_type = clickedObject.prop('type');
    alert("id is: " + obj_id + "; type is: " + obj_type);

    $.ajax({
      type: "POST",
      url: "/event/data",
      data: { event: "click" }
    }).done(function( msg ) {
      alert( "Data Saved: " + msg );
    });
  });
 });
 