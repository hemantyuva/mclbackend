$(function(){
// ***************************** Admin *************************************

 // search the user name according to the user keyup function
 $("#user_search_term").keyup(function(){
    search_user = this.value
    $.ajax({
      url: "/admin/search_user",
      method: "get", 
      data: {searchterm: search_user}
    });
    if (search_user == "") {
    }
  });

 // serach the user status according to the active or disable
  $("body").on("change",".user_status_select",function(){
    search_status = this.value
    $.ajax({
      url: "/admin/select_user_status",
      method: "get", 
      data: {statusterm: search_status}
    });
    if (search_status == "") {
    }
  });

// search the speciality name according to keyup 
  $("body").on("keyup","#speciality_user_search",function(){
    search_specialist = this.value
      $.ajax({
        url: "/specialities/specialist_search",
        method: "get", 
        data: {specialityterm: search_specialist}
      });
  });

  // search the surgery  name according to keyup 
  $("body").on("keyup","#surgery_name_search",function(){
    search_surgery = this.value
    $.ajax({
      url: "/surgeries/surgery_search",
      method: "get", 
      data: {surgeryterm: search_surgery}
    });
    if (search_surgery == "") {
    }
  });

  // search the diagnose name according to keyup 
  $("body").on("keyup","#diagnose_name_search",function(){
    search_diagnose = this.value
    $.ajax({
      url: "/diagnoses/diagnose_search",
      method: "get", 
      data: {diagnoseterm: search_diagnose}
    });
    if (search_diagnose == "") {
    }
  });

  $("body").on("change","#admin_field_field_type",function(){
    if (this.value == "select" || this.value == "radio" )
    { 
      $("#radio_options").show();
    }else
    {
      $("#radio_options").hide();
      $("#radio_options .fields").remove();
    }
    if($('select option:selected').text()=="Multiple select dropdown")
    {
      $("#admin_field_multiple").val(true)
    }else
    {
      $("#admin_field_multiple").val(false)
    }
  });

  $("body").on("click",".default_option",function(){
    $(".default_option").attr("value",false)
    $(".default_option").prop("checked",false)
    $(this).prop("checked",true)
    $(this).attr("value",true)
  })

  // Getting the youtube thumbnails
  
  $('a.thumbnail_youtube').each(function() {
      var id = getYoutubeID( this.href );
      this.id = id;
      var thumb_url = "http://i.ytimg.com/vi/"+id+"/mqdefault.jpg";
      $('<img src="'+thumb_url+'" />').appendTo($('#'+id));
  });

});
// Getting the youtube thumbnails
function getYoutubeID(url) {
    var id = url.match("[\\?&]v=([^&#]*)");
    id = id[1];
    return id;
};