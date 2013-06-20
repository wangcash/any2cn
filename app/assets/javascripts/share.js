/*!
 * 译文分享JS代码 v0.1
 *
 * Copyright 2013 Any2cn.com
 * Released under the MIT license
 *
 * Date: 2013-06-21T03:39Z
 */

$(document).ready(function() {

  //立即分享
  $("#share").click(function() {
    $("#form_div").load("submit");
  });

  //发布译文
  $("#btn_submit").click(function() {

    $("#alert").slideUp("fast"); //关闭警告框

    if($("#submit_origin_url").val() == '') {
      $("#submit_origin_url").popover("show");
      return
    }

    if($("#submit_origin_title").val() == '') {
      $("#submit_origin_title").popover("show");
      return
    }

    if($("#submit_translate_url").val() == '') {
      $("#submit_translate_url").popover("show");
      return
    }

    if($("#submit_translate_title").val() == '') {
      $("#submit_translate_title").popover("show");
      return
    }

    $("#btn_submit").button("loading");
    
    $.getJSON("/submit/s",
    {
      utf8                  :$("input[name='utf8']").val(),
      authenticity_token    :$("input[name='authenticity_token']").val(),
      submit_origin_url     :$("#submit_origin_url").val(),
      submit_origin_title   :$("#submit_origin_title").val(),
      submit_translate_url  :$("#submit_translate_url").val(),
      submit_translate_title:$("#submit_translate_title").val(),
      submit_sharer         :$("#submit_sharer").val(),
      submit                :"submit"
    },
    function(data, status, xhr) {
      if (status == "success") {
        $("#btn_submit").button("complete");
        if (data.errors == null) {
          $("#alert").removeClass("alert-error");
          $("#alert").addClass("alert-success");
          $("#alert").html("发布成功！");
          $("#alert").slideDown("fast");
          //延时1.5秒后跳转到搜索结果
          setTimeout(function(){location.href="s?q="+data.origin.url;},1500);
        }
        else {
          $("#btn_submit").button("reset");
          $("#alert").html("")
          for (var i = 0; i < data.errors.length; i++) {
            $("#alert").append(data.errors[i]+"<br>");
          };
          $("#alert").slideDown("fast");
        }
      }        
    }); //getJSON

  }); //("#btn_submit").click

});