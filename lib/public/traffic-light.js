$(".light").click(function () {
  // Get current image
  $image = $(this);

  // Extract parameters from id
  $parameters = $image.attr("id").split('-');
  $line = $parameters[0];
  $light = $parameters[1];
  $old_state = $parameters[2];

  // Swicht status
  if ($old_state == '0') {
    $state = '1';
  } else {
    $state = '0';
  }

  // Make url to change status
  $url = $line + '/' + $light + '/' + $state;

  // And call it
  $.get($url, function(data) {
    // Get page resut & extract new state
    $newstate = data.split(':')[1];

    // Make new src & id
    $src = "images/" + $light + "-" + $newstate + ".png";
    $id = $line + '-' + $light + '-' + $newstate;

    // And update it
    $image.attr('src', $src);
    $image.attr('id', $id);
  });
});
