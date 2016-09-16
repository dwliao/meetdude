$(document).on("turbolinks:load", function () {
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
            var item = $("<a></a>");
            item.addClass("list-group-item");
            item.attr("href", "/" + user.id);
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