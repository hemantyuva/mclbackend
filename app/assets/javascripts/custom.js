 $(function() {
    // patient search in schedule add page ajax
    $( "#patients-tags" ).autocomplete({
    minLength: 0,
    source: '/schedules/search_patients', //send the term to the particular defined method
      focus: function( event, ui ) {
      $( "#patients-tags" ).val( ui.item.name ); // searching the patient name with search tem tag
      return false;
      },
      select: function( event, ui ) {
      $( "#patients-tags" ).val( ui.item.name ); // selecting the list item
         window.location.href = "/patients/"+ui.item.value+"/cases/new" //item select navigate to the patient cases page
      return false;
      }
    })
    .autocomplete( "instance" )._renderItem = function( ul, item ) {
    return $( "<li>" )
    .append(item.label) // appending the custom values to the autocomplete
    .appendTo( ul );
    };

  // Diagnose name search the according the term on schedule page
   $( "#diagnose-name-tags" ).autocomplete({
      source: '/schedules/search_diagnose',
      focus: function( event, ui ) {
          $( "#diagnose-name-tags" ).val( ui.item.label );
          return false;
      },
      select: function( event, ui ) {
          $( "#diagnose-name-tags" ).val( ui.item.label );
          return false;
      }     
  });

  // Surgery name search the according the term on schedule page
   $( "#surgery-name-tags" ).autocomplete({
    source: '/schedules/search_surgery',
    focus: function( event, ui ) {
        $( "#surgery-name-tags" ).val( ui.item.label );
        return false;
    },
    select: function( event, ui ) {
        $( "#surgery-name-tags" ).val( ui.item.label );
        return false;
    }     
});

// Specialitst name search the according to the term on profile setting page
  $( "#specialist_name_search" ).autocomplete({
    source: '/profiles/profile_specialist_search',
    focus: function( event, ui ) {
        $( "#specialist_name_search" ).val( ui.item.label );
        return false;
    },
    select: function( event, ui ) {
        $( "#specialist_name_search" ).val( ui.item.label );
        return false;
    }     
});

// media tag limit
$(function() {
    $('.media_tag_limit').limitslider({
      values: [$(".media_tag_limit").attr("data-value")],
      min: 0,
      max: 5,
      label:    true,
      title:    function (value) {
              return 'Currently set to '+value+'%';
            },
      change: function(event, ui) {
          $.ajax({
            url: "/settings/set_tag_limit",
            method: "get",
            data:{media_tag_limit: ui.value}
          });
        },
      showRanges: true,
      ranges:   [false, { styleClass: 'range-glow' }, false, true]
     });
  });


// scn tag limit 
$(function() {
    $('.scn_tag_limit').limitslider({
      values: [$(".scn_tag_limit").attr("data-value")],
      min: 0,
      max: 5,
      label:    true,
      title:    function (value) {
              return 'Currently set to '+value+'%';
            },
      change: function(event, ui) {
          $.ajax({
            url: "/settings/set_tag_limit",
            method: "get",
            data:{scn_tag_limit: ui.value}
          });
        },
      showRanges: true,
      ranges:   [false, { styleClass: 'range-glow' }, false, true]
     });
  });

// case assistant multiple select drop down 
  $('#case_assistant_name').multiselect();


function getYoutubeID(url) {
    var id = url.match("[\\?&]v=([^&#]*)");
    id = id[1];
    return id;
};

$('a.youtube_thumbnail').each(function() {
    var id = getYoutubeID( this.href );
    this.id = id;
    var thumb_url = "http://i.ytimg.com/vi/"+id+"/mqdefault.jpg";
    $('<img src="'+thumb_url+'" />').appendTo($('#'+id));
});




$(function () {
  $('#schedule_datepicker').datetimepicker({
    format : "DD-MM-YYYY LT",
    minDate :getNextDate()
    }).on("dp.change", function (e) {
    });
  });

  // patient datetimepicker
  $('#patient_datepicker').datetimepicker({
    format: 'DD/MM/YYYY',
    maxDate: new Date(),
  });
term:
  // Edit schedule page date picker
  $(function () {
  $('#edit_schedule_datepicker').datetimepicker({
    format : "DD-MM-YYYY LT"
    });
  });

  $(function () {
    $('#edit_surgery_datepicker').datetimepicker({
      format : "DD-MM-YYYY LT"
    });
    $('#surgery_datepicker').datetimepicker({
      format : "DD-MM-YYYY LT"
    });
  });
  // answer comment keypress event
  $("#answer_comment").keypress(function(e){
    source: 'answers/create'
  });

  activaTab('questions-tab');
  activaTab('recent-search');
  //sending the params to controller on index page question search
  $("#question_search").keyup(function(){
    search_question = this.value
    if (search_question.length > 0) {
      $.ajax({
        url: "/question_advance_search/search_questions",
        method: "get", 
        data: {searchterm: search_question}
      });
    }else
    {
     $("#question_icon_change").html("<i class=\"fa fa-search question-search-icon\"></i>")
    }
  });
  // end with question search params

  $("#case_search").keyup(function(){
    search_case = this.value
    if (search_case.length > 0) {
      $.ajax({
        url: "/search/case_search",
        method: "get", 
        data: {searchterm: search_case}
      });
    }else
    {
      $("#icon_change").html("<i class=\"fa fa-search search-icon\"></i>")
    }
  });


  $("#advance_search_cases").keyup(function(){
    search_case = this.value
    if (search_case.length > 0) {
      $.ajax({
        url: "/search/complex_case_search",
        method: "get", 
        data: {searchterm: search_case}
      });
    } 
    else {
      active_id = $('.advance-tabs-nav .active').find('a').attr('id')
      if (active_id == 'recent_search') {
        $.ajax({
          url: "/search/show_recent_search",
          method: "get"
        }).done(function( data ){
          if (data != 'false'){
            $("#recent-search").html(data);
          }
        });
      } else if (active_id == 'saved_search') {
        $.ajax({
          url: "/search/show_saved_search",
          method: "get"
        }).done(function( data ){
          if (data != 'false'){
            $("#recent-search").html(data);
          }
        });
      } else if (active_id == 'complex_search') {
        $.ajax({
          url: "/search/show_complex_search",
          method: "get"
        }).done(function( data ){
          if (data != 'false'){
            $("#recent-search").html(data);
          }
        });
      }
    }
  });

  $(document).on("change","#sort_cases",function () {
    $.ajax({
      url: "/search/sort_search_cases",
      method: "get", 
      data: {sort_type: this.value,searchterm: $("#case_search").val()}
    });
  });

  $("body").on("click","#save_search",function(){
    $.ajax({
      url: "/search",
      method: "post", 
      data: {searchterm: $("#case_search").val()}
    });
  });

  var delay = (function(){
    var timer = 0;
    return function(callback, ms){
      clearTimeout (timer);
      timer = setTimeout(callback, ms);
    };
  })();

  $('#case_search').keyup(function() {
    search_case = this.value
    if (search_case.length > 0) {
      delay(function(){
        $.ajax({
          url: "/search/create_recent_search",
          method: "get", 
          data: {searchterm: search_case}
        });
      }, 500 );
    }
  });

  $("body").on("click","#destroy_search",function(){
    $.ajax({
      url: "/search/destory_search_term",
      method: "get", 
      data: {searchterm: $("#case_search").val()}
    });
  });

  $("body").on("click","#recent_search",function(){
    $.ajax({
      url: "/search/show_recent_search",
      method: "get"
    }).done(function( data ){
      if (data != 'false'){
        $("#recent-search").html(data);
      }
    });
  })

  $("body").on("click","#saved_search",function(){
    $.ajax({
      url: "/search/show_saved_search",
      method: "get"
    }).done(function( data ){
      if (data != 'false'){
        $("#recent-search").html(data);
      }
    });
  })

  $("body").on("click","#complex_search",function(){
    $.ajax({
      url: "/search/show_complex_search",
      method: "get"
    }).done(function( data ){
      if (data != 'false'){
        $("#recent-search").html(data);
      }
    });
  })




  $("#advance_search_media").keyup(function(){
    search_media = this.value
    if (search_media.length > 0) {
      $.ajax({
        url: "/media_advance_search/complex_media_search",
        method: "get", 
        data: {searchterm: search_media}
      });
    } 
    else {
      active_id = $('.advance-tabs-nav .active').find('a').attr('id')
      if (active_id == 'media_recent_search') {
        $.ajax({
          url: "/media_advance_search/show_recent_search",
          method: "get"
        }).done(function( data ){
          if (data != 'false'){
            $("#media-recent-search").html(data);
          }
        });
      } else if (active_id == 'media_saved_search') {
        $.ajax({
          url: "/media_advance_search/show_saved_search",
          method: "get"
        }).done(function( data ){
          if (data != 'false'){
            $("#media-recent-search").html(data);
          }
        });
      } else if (active_id == 'media_complex_search') {
        $.ajax({
          url: "/search/show_complex_search",
          method: "get"
        }).done(function( data ){
          if (data != 'false'){
            $("#media-recent-search").html(data);
          }
        });
      }
    }
  });

  $("body").on("click","#media_save_search",function(){
    $.ajax({
      url: "/media_advance_search",
      method: "post", 
      data: {searchterm: $("#media_search").val()}
    });
  });

  $('#media_search').keyup(function() {
    search_media = this.value
    if (search_media.length > 0) {
      delay(function(){
        $.ajax({
          url: "/media_advance_search/create_recent_search",
          method: "get", 
          data: {searchterm: search_media}
        });
      }, 500 );
    }
  });

  $("body").on("click","#media_destroy_search",function(){
    $.ajax({
      url: "/media_advance_search/destory_search_term",
      method: "get", 
      data: {searchterm: $("#media_search").val()}
    });
  });

  $("body").on("click","#media_recent_search",function(){
    $.ajax({
      url: "/media_advance_search/show_recent_search",
      method: "get"
    }).done(function( data ){
      if (data != 'false'){
        $("#media-recent-search").html(data);
      }
    });
  })

  $("body").on("click","#media_saved_search",function(){
    $.ajax({
      url: "/media_advance_search/show_saved_search",
      method: "get"
    }).done(function( data ){
      if (data != 'false'){
        $("#media-recent-search").html(data);
      }
    });
  })

  $("body").on("click","#media_complex_search",function(){
    $.ajax({
      url: "/search/show_complex_search",
      method: "get"
    }).done(function( data ){
      if (data != 'false'){
        $("#media-recent-search").html(data);
      }
    });
  })

  $("#advance_search_graph").keyup(function(){
    from_date = $("#advance_from_date").val();
    to_date = $("#advance_to_date").val();
    search_graph = this.value
    if (search_graph.length == 0){
      active_id = $('.advance-tabs-nav .active').find('a').attr('id')
      if (active_id == 'graph_recent_search') {
        $.ajax({
          url: "/graph_advance_search/show_recent_search",
          method: "get",
          data: {from: from_date,to: to_date}
        }).done(function( data ){
          if (data != 'false'){
            $("#graph-recent-search").html(data);
          }
        });
      } else if (active_id == 'graph_saved_search') {
        $.ajax({
          url: "/graph_advance_search/show_saved_search",
          method: "get",
          data : {form: from_date,to: to_date}
        }).done(function( data ){
          if (data != 'false'){
            $("#graph-recent-search").html(data);
          }
        });
      } else if (active_id == 'graph_complex_search') {
        $.ajax({
          url: "/search/show_complex_search",
          method: "get",
          data : {graph_search: true,from: from_date,to: to_date}
        }).done(function( data ){
          if (data != 'false'){
            $("#graph-recent-search").html(data);
          }
        });
      }
    } 
  });

  $( "#advance_search_graph" ).autocomplete({
    source: function (request, response) {
        $.getJSON("/graphs/search_diagnose_and_surgery", {
            term: extractLast(request.term)
        }, response);
    },
    search: function () {
        // custom minLength
        var term = extractLast(this.value);
        if (term.length < 1) {
            return false;
        }
    },
    focus: function () {
        // prevent value inserted on focus
        return false;
    },
    select: function (event, ui) {
        var terms = split(this.value);
        // remove the current input
        terms.pop();
        // add the selected item
        terms.push(ui.item.value);
        // add placeholder to get the comma-and-space at the end
        terms.push("");
        this.value = terms.join(", ");
        ajax_call_advance_search($("#advance_search_graph").val())
        return false;
    }
  });

  $("body").on("click","#graph_save_search",function(){
    $.ajax({
      url: "/graph_advance_search",
      method: "post", 
      data: {searchterm: $("#graph-tag-search").val()}
    });
  });

  $( "#graph-tag-search" ).keyup(function() {
    search_graph = this.value
    if (search_graph.length == 0) {
      $("#icon_change").html("<i class=\"fa fa-search search-icon\"></i>");
    }
  });

  $("body").on("click","#graph_destroy_search",function(){
    $.ajax({
      url: "/graph_advance_search/destory_search_term",
      method: "get", 
      data: {searchterm: $("#graph-tag-search").val()}
    });
  });

  $("body").on("click","#graph_recent_search",function(){
    date_value = $(this).attr("data-value").split("_")
    from_date = date_value[0]
    to_date = date_value[1]
    $.ajax({
      url: "/graph_advance_search/show_recent_search",
      method: "get",
      data : {from: from_date,to: to_date}
    }).done(function( data ){
      if (data != 'false'){
        $("#graph-recent-search").html(data);
      }
    });
  })

  $("body").on("click","#graph_saved_search",function(){
    date_value = $(this).attr("data-value").split("_")
    from_date = date_value[0]
    to_date = date_value[1]
    $.ajax({
      url: "/graph_advance_search/show_saved_search",
      method: "get",
      data : {from: from_date,to: to_date}
    }).done(function( data ){
      if (data != 'false'){
        $("#graph-recent-search").html(data);
      }
    });
  })

  $("body").on("click","#graph_complex_search",function(){
    $.ajax({
      url: "/search/show_complex_search",
      method: "get",
      data : {graph_search: true}
    }).done(function( data ){
      if (data != 'false'){
        $("#graph-recent-search").html(data);
      }
    });
  })


  $("body").on("click","#question_recent_search",function(){
    $.ajax({
      url: "/question_advance_search/show_recent_search",
      method: "get"
    }).done(function( data ){
      if (data != 'false'){
        $("#question-recent-search").html(data);
      }
    });
  })

  $("body").on("click","#question_saved_search",function(){
    $.ajax({
      url: "/question_advance_search/show_saved_search",
      method: "get"
    }).done(function( data ){
      if (data != 'false'){
        $("#question-recent-search").html(data);
      }
    });
  })

  $("body").on("click","#question_complex_search",function(){
    $.ajax({
      url: "/search/show_complex_search",
      method: "get"
    }).done(function( data ){
      if (data != 'false'){
        $("#question-recent-search").html(data);
      }
    });
  })

  $("body").on("click","#question_save_search",function(){
    $.ajax({
      url: "/question_advance_search",
      method: "post", 
      data: {searchterm: $("#question_search").val()}
    });
  });

  $("body").on("click","#question_destroy_search",function(){
    $.ajax({
      url: "/question_advance_search/destory_search_term",
      method: "get", 
      data: {searchterm: $("#question_search").val()}
    });
  });

  $("#advance_search_question").keyup(function(){
    search_question = this.value
    if (search_question.length > 0) {
      $.ajax({
        url: "/question_advance_search/complex_question_search",
        method: "get", 
        data: {searchterm: search_question}
      });
    } 
    else {
      active_id = $('.advance-tabs-nav .active').find('a').attr('id')
      if (active_id == 'question_recent_search') {
        $.ajax({
          url: "/question_advance_search/show_recent_search",
          method: "get"
        }).done(function( data ){
          if (data != 'false'){
            $("#question-recent-search").html(data);
          }
        });
      } else if (active_id == 'question_saved_search') {
        $.ajax({
          url: "/question_advance_search/show_saved_search",
          method: "get"
        }).done(function( data ){
          if (data != 'false'){
            $("#question-recent-search").html(data);
          }
        });
      } else if (active_id == 'question_complex_search') {
        $.ajax({
          url: "/search/show_complex_search",
          method: "get"
        }).done(function( data ){
          if (data != 'false'){
            $("#question-recent-search").html(data);
          }
        });
      }
    }
  });

  $('#question_search').keyup(function() {
    search_question = this.value
    if (search_question.length > 0) {
      delay(function(){
        $.ajax({
          url: "/question_advance_search/create_recent_search",
          method: "get", 
          data: {searchterm: search_question}
        });
      }, 500 );
    }
  });

  $(document).on("change","#search_options",function () {
    window.location.href = "/"+this.value 
  });

  $("#media_search").keyup(function(){
    if (this.value.length > 0) {
      $.ajax({
        url: "/media/media_search",
        method: "get", 
        data: {searchterm: this.value}
      });
    }else
    {
      $("#icon_change").html("<i class=\"fa fa-search search-icon\"></i>")
    }
  });

  $(document).on("change","#sort_media",function () {
    $.ajax({
      url: "/media/sort_search_media",
      method: "get", 
      data: {sort_type: this.value,searchterm: $("#media_search").val()}
    });
  });

  $(document).on("change","#media_type",function () {
    $.ajax({
      url: "/media/group_search_media",
      method: "get",
      data: {group_type: this.value,searchterm: $("#media_search").val()}
    });
  });

  $("body").on("click",".calender-icon.fa-list",function(){
    $.ajax({
      url: "/schedules/list_view",
      method: "get", 
      data: {}
    });
  });

  $("body").on("click",".calender-icon.fa-calendar",function(){
    $.ajax({
      url: "/schedules/schedule_view",
      method: "get", 
      data: {}
    });
  });

  // Schedule form submission when click the Add button
  $("body").on("click","#my_scn_tab",function(){
    $.ajax({
      url: "/questions/my_scn",
      method: "get"
    }).done(function( data ){
      if (data != 'false'){
        $("#my-scn-tab").html(data);
      }
    });
  });

  $("body").on("click","#questions_tab",function(){
    $.ajax({
      url: "/questions/question_list",
      method: "get"
    })
  });

  $("body").on("click","#ask_question_tab",function(){
    $.ajax({
      url: "/questions/new",
      method: "get"
    }).done(function( data ){
      if (data != 'false'){
        $("#ask-question-tab").html(data);
      }
    });
  });

  $("body").on("click","#filter_list",function(){
    $.ajax({
      url: "/questions/show_filter_options",
      method: "get"
    }).done(function( data ){
      if (data != 'false'){
        $("#filter-list").html(data);
      }
    });
  });
  
  $("body").on("click","#most_answers",function(){
    $.ajax({
      url: "/questions/most_answers_questions",
      method: "get"
    }).done(function( data ){
      if (data != 'false'){
        activaTab('questions-tab');
        $("#questions-tab").html(data);
      }
    });
  });

  $("body").on("click","#most_votes",function(){
    $.ajax({
      url: "/questions/most_votes_questions",
      method: "get"
    }).done(function( data ){
      if (data != 'false'){
        activaTab('questions-tab');
        $("#questions-tab").html(data);
      }
    });
  });

  $("body").on("click","#scn_users",function(){
    $.ajax({
      url: "/questions/scn_users",
      method: "get"
    })
  });

  $(document).on("click","#show_answer",function(){
    $.ajax({
      url: "/questions/my_scn_answers",
      method: "get"
    }).done(function( data ){
      if (data != 'false'){
        $("#show_question_answer").html(data);
      }
    });
  });

  $("body").on("click","#question_media",function(e){
   $("#question_question_attachments_image").click()
  });
  
  $('.poll_option').change(function () {
    var option = $(this).val();
    $("#answer_poll").val(option);
  });
  
  $("body").on("click",".action-batton",function(){
    var id = $(this).attr("data")
    $("#"+id).toggle();
  });

  $("body").on("click","#scn_tabs a",function(){
    $("#scn_tabs a").removeClass("active");
    $(this).addClass("active");
  })

  // submission of the anaesthetistists form when we click the done button
  $(".submit-anaesthetist-form").click(function(e){$("form#anaesthetist_form").submit(); e.preventDefault();})
  // send the feedback submission when i click the send link
  $(".send_feedback_click").click(function(e){$("form.edit_setting").submit(); e.preventDefault();})
  // submission of the manage when we click the done button
  $(".submit-assistant-form").click(function(e){$("form.manage_assistant-form").submit(); e.preventDefault();})
  // surgery location submission when we click the done button
  $(".submit-surgery_location-form").click(function(e){$("form.surgery_location-form").submit(); e.preventDefault();})
  // surgery submission when we click the done button
  $(".submit-surgery-form").click(function(e){$("form.manage_surgery-form").submit(); e.preventDefault();})
  // diagonisis submission when we click the done button
  $(".submit-diagnose-form").click(function(e){$("form.manage_diagnose-form").submit(); e.preventDefault();})

  $(".submit-user-form").click(function(e){$("form.user_template-form").submit(); e.preventDefault();})
  
  $(".submit-my-form").click(function(e){ 
    $("form input#submit-my-form")[0].click(); 
    e.preventDefault(); 
  })
  $(".submit-no-form").click(function(e){
    $("#no_button").val("true");
    $("form input#submit-my-form")[0].click(); 
    e.preventDefault(); 
  })
  // Patinet form submission when click the Add button
  $(".submit-patient-form").click(function(e){  $("form.patient-form").submit(); e.preventDefault(); })

  // Add CaseNote form submission when click the Add button
  $(".submit-note-form").click(function(e){ 
    $("form input#submit-note-form")[0].click(); 
    e.preventDefault(); 
  })

  // Media form submission when click the Add button
  $("body").on("click",".submit-media-form",function(){
    $("form.edit_case_media_attachment").each(function(){
      attachment_id = this.id.split("_")[1]
      attachment = this.id
      case_id = $('#case_id').val();
      $.ajax({
        url: '/case_media_attachments/'+attachment_id+'/', 
        method: 'put',
        data:$("#"+attachment).serialize()
      });
      // $(".cssload-container").show();
      window.location.href = "/cases/"+case_id+"/case_media"
    });
  });

  // $(".cssload-container").hide();


  $("body").on("click",".close-button",function(){
    $(".error-box").hide();
  })

  $('.from_datepicker').datetimepicker({
      format : "DD-MM-YYYY",
  })

  $('.to_datepicker').datetimepicker({
    format : "DD-MM-YYYY"
  });

  $('.quick_stats_datepicker').datetimepicker({
    format : "MM-YYYY",
  })

 $("body").on("click",".line-chart-click",function(){
    data_params = $(this).data("params")
    $.ajax({
      url: "/graphs/date_line_chart",
      method: "get",
      data: data_params
    });
  });

 $("body").on("click",".bar-chart-click",function(){
    data_params = $(this).data("params")
    $.ajax({
      url: "/graphs/date_bar_chart",
      method: "get",
      data: data_params
    });
  });

 $("body").on("click",".quick-line-chart-click",function(){
    data_params = $(this).data("params")
    $.ajax({
      url: "/graphs/quick_stats_line_chart",
      method: "get",
      data: data_params
    });
  });

  $("body").on("click",".quick-bar-chart-click",function(){
    data_params = $(this).data("params")
    $.ajax({
      url: "/graphs/quick_stats_bar_chart",
      method: "get",
      data: data_params
    });
  });


 $("body").on("click",".quick-line-tags-chart-click",function(){
    ajax_call_graph($("#graph-tag-search").val(),"line")
  });

 $("body").on("click",".quick-bar-tags-chart-click",function(){
    ajax_call_graph($("#graph-tag-search").val(),"bar")
  });


  // Attachment form submission when click the Add button
  $("body").on("click",".attachment-media-submit-form",function(e){
    case_id = $('#case_id').val();
    attachment_id = $('#media_attachment_id').val();
    $.ajax({
      url: '/case_media_attachments/'+ attachment_id +'/attachment_update'+'/', 
      method: 'put',
      data:$("form#attachment-media-form-update").serialize(),
      success :function(response){
        if (response.type == 'success') {
          window.location.href = response.path
        } else {
          $('.error_msg').html(response.msg).addClass("failure-msg")
          $(".error-box, .cross-button").show();
        }
      }
    });
    // $("form#attachment-media-form-update")[0].submit()    
  });

  // Question form submission when click the Add button
  // $(".submit-question-form").click(function(e){  $("form.question-form").submit(); e.preventDefault(); })
  
  // Profile form submission when we click the update button
  $(".profile-submit").click(function(e){  $("form.profile-form").submit(); e.preventDefault(); })
 
  // Case Media creating while the popup selection
  $("body").on("click","#case_medium_update_popup",function(e){
    $("#case_medium_update_fields")[0].click()
  });
 
  // Case Media Images Upload while selecting add More
  $("body").on("click","#case_medium_update",function(e){
    $("#case_medium_update_fields")[0].click()
  });

  $("body").on("change","#case_medium_update_fields",function(e){
    $("form#media-form-update").submit()
  });
 
  // Rotating the Image In All the Angles
  $("body").on('click','.image-rotate-click',function(){
    attachment_id = this.id
    var img = $('#cropbox_'+attachment_id);
    if(img.hasClass('img-north')){
      img.attr('class','west');
      $("#rotate-angle_"+attachment_id).val(90)
    }else if(img.hasClass('west')){
        img.attr('class','south');
        $("#rotate-angle_"+attachment_id).val(180)
    }else if(img.hasClass('south')){
        img.attr('class','east');
        $("#rotate-angle_"+attachment_id).val(270)
    }else if(img.hasClass('east')){
        img.attr('class','img-north');
        $("#rotate-angle_"+attachment_id).val(0)
    }
  });

  // Attachment changing the images
  $(".attachment-show").hide();
  $(".attachment_click").click(function(){
    attachment_id = this.id
    $(".attachment-show").hide();
    $(".media-attachment").hide();
    $("#media-attachment_"+attachment_id).show();
  });
  
  // Croping the Images
  $("body").on('click',".image-crop-click",function(){
    attachment_id = this.id
    $('#cropbox_'+attachment_id).Jcrop({
      onChange: showCoords,
      onSelect: showCoords
    }); 
  });

  $(".submit-question-form").click(function(e){  
    $("form.question-form").submit();
    e.preventDefault(); 
  })

  // Delete the Particular attachment in the case attachment show page
  $("body").on("click",".attachment-delete",function(){
      attachment_id = this.id.split("_")[0]
      case_id = $("#case_id").val();
      $.ajax({
        url: '/case_media_attachments/'+attachment_id+'/attachment_destroy',
        method: 'get',
        data:{id: attachment_id,case_id: case_id}
      });
      window.location.href = "/cases/"+case_id+"/case_media"
    });

  // Zoom the Image the case attachment show page
    $("body").on('click',"#zoom_tab",function(){
      $("#myModal").modal("show")
    });

  $("#question_question_attachments_image").change(function(){
    readURL(this)
  })

  $("body").on("click",".new-added-image",function(){
    this.parentElement.remove();
  })

  $("#question-tags").tagsInput({ 
    'width':'100%',
    'autocomplete_url': "/questions/search_tags",
    onAddTag: function (tag) {
      attachment_tag_count = $("#question-tags_tagsinput").children(".tag").length;
      if (attachment_tag_count > tag_limit){
        $('#question-tags').removeTag(tag);
      }
    }
  });

 $("body").on("click",".attachment_click",function(){
    attachment_id = this.id
    $('#attachment_tag_'+attachment_id).tagsInput({ 
      'width':'100%',
      'height':'43px',
      'autocomplete_url': "/case_media_attachments/search_tags",
      onAddTag: function (tag) {
      attachment_tag_count = $("#attachment_tag_"+attachment_id+"_tagsinput").children(".tag").length;
      if (attachment_tag_count > tag_limit){
        $('#attachment_tag_'+attachment_id).removeTag(tag);
      }
    }
    });
  });

 $('#attachment_tag').tagsInput({ 
    'width':'100%',
    'height':'43px',
    'autocomplete_url': "/case_media_attachments/search_tags", 
      onAddTag: function (tag) {
      attachment_tag_count = $("#attachment_tag_tagsinput").children(".tag").length;
      if (attachment_tag_count > tag_limit){
        $('#attachment_tag').removeTag(tag);
      }
    }
  });


  $("body").on("change","#admin_form_id",function () {
    var id = $(this).attr("data-id")
    selected = $(':selected', this);
    if(selected.closest('optgroup').attr('label')=="My Case Templates"){
      $.ajax({
        url: "/cases/"+id+"/new_user_case_template",
        method: "get", 
        data: {case_from_id: this.value}
      }).done(function( data ){
        if (data != 'false'){
          $("#case_tempate").html(data);
        }
      });
    }else{ 
      if(this.value != "")
      {
        $.ajax({
          url: "/cases/"+id+"/new_case_template",
          method: "get", 
          data: {case_from_id: this.value}
        }).done(function( data ){
          if (data != 'false'){
            $("#case_tempate").html(data);
          }
        });
      }
    }
  });

  if ($("#admin_form_id").length==1){
    $("#admin_form_id").change()
  }
  

  // $("body").on("change","#user_form_id",function () {
  //   $.ajax({
  //     url: "/cases/new_user_case_template",
  //     method: "get", 
  //     data: {case_from_id: this.value}
  //   }).done(function( data ){
  //     if (data != 'false'){
  //       $("#case_tempate").html(data);
  //     }
  //   });
  // });

  $("body").on("change","#user_followup_form_id",function () {
    if (this.value !=""){
      $.ajax({
        url: "/cases/new_user_case_template",
        method: "get", 
        data: {case_from_id: this.value}
      }).done(function( data ){
        if (data != 'false'){
          $("#note_tempate").html(data);
        }
      });
    }else
    {
      $(".case_form_fields").remove();
    }
  });

  $("body").on("change","#user_field_field_type",function(){
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
      $("#user_field_multiple").val(true)
    }else
    {
      $("#user_field_multiple").val(false)
    }
  });

  $("body").on("click",".default_option",function(){
    $(".default_option").attr("value",false)
    $(".default_option").prop("checked",false)
    $(this).prop("checked",true)
    $(this).attr("value",true)
  })

  $("body").on('click','.case_template_form_submit',function(){
    var data =  new FormData( $('#new_user_field')[0] );
    url = $('#new_user_field')[0].action;
    $.ajax({
      method: 'POST',
      url: url,
      data: data,
      processData: false,
      contentType: false,
    });
    return false;
  });

  $("body").on("click",".case_template_form_cancel",function(){
   $( ".remove_new_user_field" ).remove();
  })

  $("body").on("click",".cancel_invitation",function(){
   $( ".search_user_detail" ).remove();
  })
  
  if (sessionStorage["graph_box"]=="none"){
    $( "#search-graph-main" ).show();
  }

  $("body").on("click","#search-graph",function(){
    sessionStorage.setItem("graph_box", $( "#search-graph-main" )[0].style.display);
    $( "#search-graph-main" ).slideToggle();
  })
  

  $("#associate_user_name,#associate_recipient_email,#associate_recipient_mobile").keyup(function(){
    search_user = this.value
    $.ajax({
      url: "/associates/search_user",
      method: "get", 
      data: {searchterm: search_user}
    });
  });

  $("body").on("click","#add_note,#add_media",function(){
    alert("you don't have add privilege")
  })

  graph_tag_search()
  $("#followup").hide();
  $("#surgary").hide();
  $("#user_form_type").change(function(){  
    if(this.value == "surgery"){
      $("#surgary").show();
      $("#surgary #surgary_form_id").prop("required",true);
      $("#followup #followup_form_id").prop("required",false);
      $("#followup").hide();
    }
    else{
      $("#surgary").hide();
      $("#surgary #surgary_form_id").prop("required",false);
      $("#followup #followup_form_id").prop("required",true);
      $("#followup").show();
    } 
  })

});

function readURL(input) {
  $(".newly-added-q-images").remove()
  $.each(input.files, function(i, file) {
    if (input.files && input.files[i]) {
      var reader = new FileReader();
      
      reader.onloadend = function (e) {
         $(".question-img").append("<span class=\"newly-added-q-images\"><i class=\"fa fa-times-circle-o close-icon new-added-image\"></i><img src="+e.target.result+"></span>")
      }
      reader.readAsDataURL(input.files[i]);
    }
  });
}

function showCoords(c)
{
  $('#x_'+attachment_id).val(c.x);
  $('#y_'+attachment_id).val(c.y);
  $('#x2_'+attachment_id).val(c.x2);
  $('#y2_'+attachment_id).val(c.y2);
  $('#w_'+attachment_id).val(c.w);
  $('#h_'+attachment_id).val(c.h);
}; 


function activaTab(tab){
  $('.nav-tabs a[href="#' + tab + '"]').tab('show');
};

var getNextDate = function(){
  var date = new Date();
  date = date.setDate(date.getDate()+1);
  return date;
}



  function split(val) {
      return val.split(/,\s*/);
  }
  function extractLast(term) {
      return split(term).pop();
  }

  
  function ajax_call_graph(all_tags, graph_resource){
    graph_type = $(".graph_type_input").val()
    data_params = $("#graph-tag-search").attr("data-params")
    $.ajax({
        url: "/graphs/tags_date_range",
        method: "get",
        data: data_params+"&term="+all_tags+"&type="+graph_type+"&graph_resource="+graph_resource
    });
  }

  function ajax_call_advance_search(all_tags){
    $.ajax({
        url: "/graph_advance_search/complex_graph_search",
        method: "get",
        data: {term: all_tags,from: from_date,to: to_date}
    });
  }

  function save_recent_term(term){
    $.ajax({
      url: "/graph_advance_search/create_recent_search",
      method: "get", 
      data: {searchterm: term}
    });
  }

  function graph_tag_search(){
    $( "#graph-tag-search" ).autocomplete({
      source: function (request, response) {
          $.getJSON("/graphs/search_diagnose_and_surgery", {
              term: extractLast(request.term)
          }, response);
      },
      search: function () {
          // custom minLength
          var term = extractLast(this.value);
          if (term.length < 1) {
              return false;
          }
      },
      focus: function () {
          // prevent value inserted on focus
          return false;
      },
      select: function (event, ui) {
          var terms = split(this.value);
          // remove the current input
          terms.pop();
          // add the selected item
          terms.push(ui.item.value);
          // add placeholder to get the comma-and-space at the end
          terms.push("");
          this.value = terms.join(", ");
          if($(".chart-icon .on-line-chart").length>0){
            ajax_call_graph($("#graph-tag-search").val(),"line")
          }
          else if ($(".chart-icon .quick-bar-tags-chart-click").length>0){
            ajax_call_graph($("#graph-tag-search").val(),"line")
          }else{
            ajax_call_graph($("#graph-tag-search").val(),"bar")
          }
          save_recent_term(ui.item.value)
          return false;
      }
    });
  }