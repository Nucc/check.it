function updateRow(info_tr_element)
{
  if ($(info_tr_element).find(".comment").length > 0)
  {
    info_tr_element.prev("tr").addClass("commented");
  }
  else
  {
    info_tr_element.prev("tr").removeClass("commented");
  }
}

$(document).ready(function()
{
  $(".diff .number a").live("ajax:beforeSend", function(event, ui)
  {
    var tr = $(event.target).parents("tr").next("tr.info");
    if (tr.hasClass("open"))
    {
      tr.removeClass("open");
      tr.hide();
      return false;
    }
  });
  
  $(".diff .number a").live("ajax:complete", function(event, ui)
  {
    var tr = $(event.target).parents("tr").next("tr.info");
    tr.find(".reply").html(ui.responseText);
    tr.addClass("open");
    tr.show();
  });
  
  $(".info form").live("ajax:complete", function(event, ui)
  {
    $($(event.target).parents("td")).find(".comments").append(ui.responseText);
    updateRow($(event.target).parents("tr"));
    $($(event.target).parents("td")).find("textarea").val("");
  });
  
  $("div.comment_form .text_area").live("click", function(event, ui)
  {
    $(event.target).addClass("active");
  });

  $("div.comment_form .text_area").live("blur", function(event, ui)
  {
    $(event.target).removeClass("active");
  });

  
});