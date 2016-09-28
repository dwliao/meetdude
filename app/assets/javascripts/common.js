$(document).on("turbolinks:load", function () {
  $(window).scroll(onScrollToBottom);
  $("#searchNameText").keyup(onSearchNameTextKeyUp);
  $("#newPostText").keydown(auto_grow);
  $("#newPostText").keyup(auto_grow);
  $("#newPostSendButton").click(onClickNewPostSendButton)

  // Append posts
  if (!$(".postWrap").length)
    appendPostsByTargetId();
});

function onScrollToBottom(event) {
  if($(window).scrollTop() + $(window).height() === $(document).height()) {
    appendPostsByTargetId(false, 10);
  }
}

function onSearchNameTextKeyUp(event) {
  if (!$("#searchNameText") || !$("#searchNameList"))
    return;
  $.ajax({
    url: "/searchUsers",
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
}

function auto_grow(event) {
  event.target.style.height = event.target.style.minHeight;
  event.target.style.height = (event.target.scrollHeight)+"px";
}

function onClickNewPostSendButton(event) {
  if (!$("#newPostWrap") || !$("#newPostText"))
    return
  $.ajax({
    url: "/createPost",
    type: "POST",
    dataType: "json",
    data: {
      post: {
        user_id: $("#newPostWrap").attr("data-user-id"),
        description: $("#newPostText").val(),
        target_id: $("#newPostWrap").attr("data-target-id")
      }
    },
    complete: function(data, status) {
      if (data.responseJSON.status == "success") {
        $("#newPostText").val("");
        appendPostsByTargetId(true);
      }
    }
  });
}

/**
 * [appendPostsByTargetId description]
 * @param  {[bool]} isForward   [true: append new posts, false: append old posts]
 * @param  {[int]}  limitNumber [append post number, only available when isForward is false]
 * @return {[type]}             [description]
 */
var fireAppendPostsByTargetId = false;
function appendPostsByTargetId(isForward, limitNumber) {
  if (!$("#posts") || !$("#posts").attr("data-target-id"))
    return;
  var data = {
    user_id: $("#posts").attr("data-target-id"),
    search_type: "TO",
    start_search_time: undefined,
    is_forward: false,
    limit_number: 10,
  }

  var posts = $(".postWrap")
  if (posts.length) {
    var firstPost = undefined;
    var lastPost = undefined;
    // Get firstPost and lastPost
    posts.each(function() {
      if (firstPost === undefined)
        firstPost = $(this)
      else if (parseInt($(this).attr("data-post-time")) < parseInt(firstPost.attr("data-post-time")))
        firstPost = $(this)

      if (lastPost === undefined)
        lastPost = $(this)
      else if (parseInt($(this).attr("data-post-time")) > parseInt(lastPost.attr("data-post-time")))
        lastPost = $(this)
    });

    data.start_search_time = isForward? lastPost.attr("data-post-time") : firstPost.attr("data-post-time")
    data.is_forward = isForward
    data.limit_number = isForward? undefined : limitNumber
  }

  if (!fireAppendPostsByTargetId) {
    fireAppendPostsByTargetId = true;
    $.ajax({
      url: "/appendPosts",
      type: "POST",
      dataType: "json",
      data: data,
      complete: function(data, status) {
        fireAppendPostsByTargetId = false;
        if (data.responseText) {
          if (posts.length) {
            if (isForward)
              lastPost.before(data.responseText);
            else
              firstPost.after(data.responseText);
          } else {
            $("#posts").append(data.responseText)
          }
          // Bind edit and remove functions on posts
          $(".postWrap").each(function() {
            // Do something here
          });
        }
      }
    });
  }
}