var appId = "184193755060711";

var toast = function(friends){
  toastr.info("Selected: " + friends.map(function(friend){ return friend.name}).join(', '));
};

$(function(){

  FB.init({
    appId: appId,
    status: true
  });

  $(".basic-button").click(function(){
    $("#basic").fbFriends({
      whenDone: toast,
      shower: function(element){ element.parents(".modal").modal("show");},
      hider: function(element){ element.parents(".modal").modal("hide");},
    });
  });

  $(".multi-button").click(function(){
    $("#multi").fbFriends({
      multiple: true,
      whenDone: toast,
      friendChecked: function(friend){toastr.warning("Friend checked: " + friend.name);},
      friendUnchecked: function(friend){toastr.warning("Friend unchecked: " + friend.name);},
      shower: function(element){ element.parents(".modal").modal("show");},
      hider: function(element){ element.parents(".modal").modal("hide");},
    });
  });

  $("#jqueryui-button").click(function(){
    $("#jqueryui").fbFriends({
      whenDone: toast,
      shower: function(element){ element.parent().dialog({
        height: 400,
        width: 400
      });},
      hider: function(element){ element.parent().dialog("close");}
    });
  });

    $('#multi-submit').click(function(){
      $("#multi").fbFriends("submit");
    });
});
