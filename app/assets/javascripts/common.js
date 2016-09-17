$(document).on("turbolinks:load", function () {
  $(window).scroll(onScrollToBottom);
  $("#searchNameText").keyup(onSearchNameTextKeyUp);
  $("#newPostText").keydown(auto_grow);
  $("#newPostText").keyup(auto_grow);
  $("#newPostSendButton").click(onNewPostSendButtonClick)

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

function onNewPostSendButtonClick(event) {
  if (!$("#newPostWrap") || !$("#newPostText"))
    return
  $.ajax({
    url: "/createPost",
    type: "POST",
    dataType: "json",
    data: {
      user_id: $("#newPostWrap").attr("data-user-id"),
      description: $("#newPostText").val(),
      target_id: $("#newPostWrap").attr("data-target-id")
    },
    complete: function(data, status) {
      $("#newPostText").val("");
      appendPostsByTargetId(true);
    }
  });
}

/**
 * [appendPostsByTargetId description]
 * @param  {[bool]} direction    [true: append new posts, false: append old posts]
 * @param  {[int]}  appendNumber [append post number, only available when direction is false]
 * @return {[type]}              [description]
 */
var fireAppendPostsByTargetId = false;
function appendPostsByTargetId(direction, appendNumber) {
  if (!$("#posts") || !$("#posts").attr("data-target-id"))
    return;
  var posts = $(".postWrap")
  var data = {}

  if (posts.length) {
    var firstPost = undefined;
    var lastPost = undefined;
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
    data = {
      target_id: $("#posts").attr("data-target-id"),
      first_post_time: firstPost.attr("data-post-time"),
      last_post_time: lastPost.attr("data-post-time"),
      isUpdate: direction,
      append_number: !direction? appendNumber : undefined,
    }
  } else {
    data = {
      target_id: $("#posts").attr("data-target-id"),
      first_post_time: undefined,
      last_post_time: undefined,
      isUpdate: false,
      append_number: 10,
    }
  }

  if (!fireAppendPostsByTargetId) {
    fireAppendPostsByTargetId = true;
    $.ajax({
      url: "/appendPostsByTargetId",
      type: "POST",
      dataType: "json",
      data: data,
      complete: function(data, status) {
        fireAppendPostsByTargetId = false;
        if (data.responseText) {
          if (posts.length) {
            if (direction)
              lastPost.before(data.responseText);
            else
              firstPost.after(data.responseText);
          } else {
            $("#posts").append(data.responseText)
          }
        }
      }
    });
  }
}