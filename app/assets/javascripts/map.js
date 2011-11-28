$(document).ready(function() {
    if ($("#coordinate_search_longitude").val() && $("#coordinate_search_latitude").val()) {
        var long = $("#coordinate_search_longitude").val();
        var lat = $("#coordinate_search_latitude").val();

        // Creating a LatLng object containing the coordinate for the center of the map
        var latlng = new google.maps.LatLng(lat, long);

        // Creating an object literal containing the properties we want to pass to the map
        var options = {
            zoom: 3,
            center: latlng,
            mapTypeId: google.maps.MapTypeId.ROADMAP };

        var map = new google.maps.Map(document.getElementById('map_canvas'), options);

        var createInfo = function(screen_name, tweet) {
            return '<div class="infowindow"><strong>' + screen_name + ' </strong>' + tweet + '</div>';
        };

        var openInfoWindows = [];

        $("tr").each(function() {
            var row = $(this);
            var coords = eval(row.find(".location")[0].innerHTML);
            var link = row.find(".screen_name")[0]
            var screen_name = link.innerHTML;
            var tweet = row.find(".tweet")[0].innerHTML;

            // Add Marker
            var marker1 = new google.maps.Marker({
                position: new google.maps.LatLng(coords[0], coords[1])
            });

            marker1.setMap(map);

            // Add information window
            var infowindow1 = new google.maps.InfoWindow({
                content:  createInfo(screen_name, tweet)
            });

            function showWindow() {
               while (openInfoWindows.length > 0) {
                  openInfoWindows.pop().close();
                }
                infowindow1.open(map, marker1);
                openInfoWindows.push(infowindow1);
            }

            // Add listener for a click on the pin
            google.maps.event.addListener(marker1, 'click', function() {
              showWindow();
            });

            // Add listener for a click screen name
            $(link).click(function() {
                showWindow();
            });
        });
    }
});
