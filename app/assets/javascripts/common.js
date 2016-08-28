$(document).ready(function() {
  $("#searchNameText").keyup(function() {
    $.ajax({
      url: "/searchUserByName",
      type: "POST",
      dataType: "json",
      data: {
        name: $("#searchNameText").val()
      },
      success: function(data, status) {
        $("#searchNameList").empty()
        if (data.users) {
          data.users.forEach(function(user) {
            var item = $("<div></div>");
            item.addClass("item");
            item.append(user.name);
            $("#searchNameList").append(item);
          })
        }
      },
      error: function(data, status) {
        console.log(data, status);
      }
    });
  });
});