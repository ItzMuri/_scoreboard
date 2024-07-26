window.addEventListener("message", (event) => {
  switch (event.data.action) {
    case "open":
      Open(event.data);
      break;
    case "close":
      Close();
      break;
    case "setup":
      Setup(event.data);
      break;
  }
});

const Open = (data) => {
  $(".scoreboard-block").fadeIn(150);
  $("#total-players").html("<p>" + data.players + "/" + data.maxPlayers + "</p>");
  $("#servername").html(data.servername);

  $("#duty").html(data.locDuty);
  $("#job_title").html(data.locJobTitle);
  $("#job_rank").html(data.locJobRank);
  $("#robberies").html(data.locRobberies);
  $("#status").html(data.locStatus);
  $("#city_activity").html(data.locCityActivity);

  let copStars = `
      <i class="fa-solid fa-star star1"></i>
      <i class="fa-solid fa-star star2"></i>
      <i class="fa-solid fa-star star3"></i>
  `;

  $("#currentcops").html(copStars);
  if (data.currentCops >= data.cops3) {
      $(".star1, .star2, .star3").css("opacity", "1");
  } else if (data.currentCops >= data.cops2) {
      $(".star1, .star2").css("opacity", "1");
      $(".star3").css("opacity", "0.2");
  } else if (data.currentCops >= data.cops1) {
      $(".star1").css("opacity", "1");
      $(".star2, .star3").css("opacity", "0.2");
  } else {
      $(".star1, .star2, .star3").css("opacity", "0.2");
  }

  if (data.ambulanceCount >= 1) {
      $('#currentAmbulance').html(data.ambulanceCount);
  } else {
      $('#currentAmbulance').html('<i class="fa-solid fa-xmark"></i>');
  }

  if (data.mechanicCount >= 1) {
      $("#currentMechanic").html(data.mechanicCount);
  } else {
      $('#currentMechanic').html('<i class="fa-solid fa-xmark"></i>');
  }


  $("#player-job").html(data.job);
  $("#player-rank").html(data.grade);

  $.each(data.requiredCops, (i, category) => {
    var beam = $(".scoreboard-info").find('[data-type="' + i + '"]');
    var status = $(beam).find(".info-beam-status");
    var dutyToggle = $(".duty-toggle");

    if (data.duty) {
      dutyToggle.html('<i class="fa-solid fa-toggle-on"></i>');
    } else {
      dutyToggle.html('<i class="fa-solid fa-toggle-off"></i>');
    }
    if (category.busy)
      $(status).html('<i class="fas fa-clock"></i>');
    else if (data.currentCops >= category.minimumPolice)
    $(status).html("<i class=\"fa-solid fa-circle-dot\" style=\"color: #5af26e;\"></i>");
    else
    $(status).html("<i class=\"fa-solid fa-circle-dot\" style=\"color: #f25a5a;\"></i>");
  });
};

const Close = () => {
  $(".scoreboard-block").fadeOut(150);
};

const Setup = (data) => {
  let scoreboardHtml = "";
  $.each(data.items, (index, value) => {
    scoreboardHtml += `
      <div class="scoreboard-info-beam" data-type=${index}>
        <div class="info-beam-title">
            <p>${value}</p>
        </div>
        <div class="info-beam-status"></div>
        </div>
        `;
  });

  $(".scoreboard-info").html(scoreboardHtml);
};
