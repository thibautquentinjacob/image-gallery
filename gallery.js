$( document ).ready( function () {
    var hoverButtons = 0;
    var hoverI = 0;
    var hoverFrame = 0;
    var types = {};
    var showcaseShown = 0;
    var baseHeight = 150;
    var lastID = -1;

    var picture_count = $( "div.img_frame" ).size();
    var gallery_count = $( "div.img_frame_gallery" ).size();
    if ( gallery_count > 0 && picture_count > 0 ) {
        $( "div.footer" ).html( gallery_count + " galleries, " + picture_count + " pictures" );
    } else if ( gallery_count > 0 && picture_count == 0 ) {
        $( "div.footer" ).html( gallery_count + " galleries" );
    } else {
        $( "div.footer" ).html( picture_count + " pictures" );
    }

    $( "div.img_frame" ).mouseenter( function() {
        var id = $( this ).attr( "id" );
        lastID = id;
        var selected_class = $( "div.drawer span.selected" ).attr('class');
        if ( selected_class == "exif selected" ) {
            $( "table.exif_view" ).html( $( "table#" + id + ".exif" ).html());
        } else {
            $( "table.property_view" ).html( $( "table#" + id + ".property" ).html());
        }
    });    

    $(".fa.fa-th-list").css({"color":"white", "top":"-2px"});

    // For each picture, determine if it is a portrait or a landscape
    $( 'img.picture' ).each( function() {
        var id = $( this ).attr( 'id' );
        var height = $( this ).height();
        var width = $( this ).width();
        var ratio = width / height;
        $( this ).height( baseHeight );
        $( this ).width( baseHeight * ratio );
        if ( width > height ) {
            types[id] = "landscape";
        } else {
            types[id] = "portrait";
        }
        $( 'div.img_frame#' + id ).height( $( this ).height() - 2 );
        $( 'div.img_frame#' + id ).width( $( this ).width() - 2 );
        $( 'div.img_frame_gallery#' + id ).height( $( this ).height() - 2 );
        $( 'div.img_frame_gallery#' + id ).width( $( this ).width() - 2 );
        $( 'div.buttons_gallery#' + id + " div.subgallery_title" ).width( $( this ).width() - 15 );
        $( 'div#outer_frame' + id + ' div.buttons' ).width( $( this ).width());
        $( 'div#outer_frame' + id + ' div.buttons_gallery' ).width( $( this ).width());
        $( 'div#outer_frame' + id + ' div.buttons span.description' ).width( $( this ).width() - 60 );
//         $( "div.buttons_gallery#" + id + " .fa.fa-th-list").css({ "left", "35px" });
        $( this ).css( 'top', "" + -( $( this ).height() + 26 ) + "px" );
    });
    
    // Show buttons on frame hover
    $( 'div.img_frame' ).each( function () {
        var id = $( this ).attr( 'id' );
        $( this ).mouseenter( function() {
            $( 'div.buttons#' + id + ' span.description' ).css( 'color', 'white' );
            $( 'div.buttons#' + id + ' i.fa' ).css( 'color', 'white' );
            $( '#outer_frame' + id + ' div.buttons' ).css( 'background', 'rgba( 0, 0, 0, 0.7 )' );
            hoverFrame = 1;
        });
        $( this ).mouseout( function() {
            // Check if
// 					hoverButtons = 1;
            hoverFrame = 0;
            if ( hoverButtons === 0 && hoverI === 0 ) {
                $( 'div.buttons#' + id + ' span.description' ).css( 'color', 'rgba( 255, 255, 255, 0 )' );
                $( 'div.buttons#' + id + ' i.fa' ).css( 'color', 'rgba( 255, 255, 255, 0 )' );
                $( '#outer_frame' + id + ' div.buttons' ).css( 'background', 'rgba( 0, 0, 0, 0 )' );
            }
        });
    });
    $( 'div.buttons' ).each( function() {
        var id = $( this ).attr( 'id' );
        $( this ).mouseenter( function() {
            hoverButtons = 1;
            $( 'div.buttons#' + id + ' span.description' ).css( 'color', 'white' );
            $( 'div.buttons#' + id + ' i.fa' ).css( 'color', 'white' );
            $( '#outer_frame' + id + ' div.buttons' ).css( 'background', 'rgba( 0, 0, 0, 0.7 )' );
        });
        $( this ).mouseover( function() {
            $( 'div.buttons#' + id + ' span.description' ).css( 'color', 'white' );
            $( 'div.buttons#' + id + ' i.fa' ).css( 'color', 'white' );
            $( '#outer_frame' + id + ' div.buttons' ).css( 'background', 'rgba( 0, 0, 0, 0.7 )' );
            hoverButtons = 1;
        });
        $( this ).mouseout( function() {
            hoverButtons = 0;
            if ( hoverI === 0 && hoverFrame === 0 ) {
                $( 'div.buttons#' + id + ' span.description' ).css( 'color', 'rgba( 255, 255, 255, 0 )' );
                $( 'div.buttons#' + id + ' i.fa' ).css( 'color', 'rgba( 255, 255, 255, 0 )' );
                $( '#outer_frame' + id + ' div.buttons' ).css( 'background', 'rgba( 0, 0, 0, 0 )' );
            }
        });
    });
    $( 'i' ).each( function() {
        var id = $( this ).attr( 'id' );
        $( this ).mouseenter( function() {
            hoverI = 1;
            $( 'div.buttons#' + id + ' span.description' ).css( 'color', 'white' );
            $( 'div.buttons#' + id + ' i.fa' ).css( 'color', 'white' );
            $( '#outer_frame' + id + ' div.buttons' ).css( 'background', 'rgba( 0, 0, 0, 0.7 )' );
        });
        $( this ).mouseout( function() {
            hoverI = 0;
            if ( hoverFrame === 0 && hoverButtons === 0 ) {
                $( 'div.buttons#' + id + ' span.description' ).css( 'color', 'rgba( 255, 255, 255, 0 )' );
                $( 'div.buttons#' + id + ' i.fa' ).css( 'color', 'rgba( 255, 255, 255, 0 )' );
                $( '#outer_frame' + id + ' div.buttons' ).css( 'background', 'rgba( 0, 0, 0, 0 )' );
            }
        });
    });

    // Close showcase
    $( "div.showcase" ).click( function() {
        if ( showcaseShown === 1 ) {
            showcaseShown = 0;
            $( "div.showcase" ).fadeOut( 'fast' );
            $( "div.drawer" ).css({ "z-index": "0", "top": "-82px" });
        }
    })

    // Function to showcase zoomed picture on click
    var showcase = function ( id ) {
        var image = 
            $( "a.picture_link#picture_link" + id ).attr( "href" );
        $( "div.picture_number" ).text(( parseInt( id, 10 ) + 1 ) + " / " +  ( $( "a.picture_link" ).size()));
        if ( showcaseShown === 0 ) {
            showcaseShown = 1;
            $( "div.showcase img" ).attr( "src", image );
            $( "div.showcase img" ).attr( "id", id );
            console.log( "Type for id " + id + " is " + types[id] );
            if ( types[id] == "portrait" ) {
                $( "div.showcase img" ).addClass( "portrait" );
                $( "div.showcase img" ).removeClass( "landscape" );
                var ratio = $( "div.showcase img" ).height() / $( "div.showcase img" ).width();
                $( "div.showcase img" ).removeAttr( "width" );
            } else {
                $( "div.showcase img" ).addClass( "landscape" );
                $( "div.showcase img" ).removeClass( "portrait" );
            }
            $( "div.showcase" ).fadeIn( 'fast' );
        }
    };

    $( "div.img_frame" ).click( function() {
        var id = $( this ).attr( 'id' );
        showcase( id );
        $( "div.drawer" ).css({ "z-index": "1000", "top": "-130px" });
    });
    
    // Clicking on gallery, open sub gallery
    $( "div.img_frame_gallery" ).click( function() {
        var id = $( this ).attr( 'id' );
        $( "a#picture_link" + id )[0].click();
    });

    $( "i.fa-search" ).click( function() {
        var id = $( this ).attr( 'id' );
        showcase( id );
        $( "div.drawer" ).css({ "z-index": "1000", "top": "-130px" });
    });
    
    // Hide exif table when clicking on property and reverse
    $( "div.drawer span.properties" ).click( function() {
        $( this ).addClass( "selected" );
        $( "div.drawer span.exif" ).removeClass( "selected" );
        $( "table.property_view" ).html( $( "table#" + lastID + ".property" ).html() );
        $( "div.drawer table.property_view" ).show();
        $( "div.drawer table.exif_view" ).hide();
    })
    
    $( "div.drawer span.exif" ).click( function() {
        $( this ).addClass( "selected" );
        $( "div.drawer span.properties" ).removeClass( "selected" );
        $( "table.exif_view" ).html( $( "table#" + lastID + ".exif" ).html() );
        $( "div.drawer table.exif_view" ).show();
        $( "div.drawer table.property_view" ).hide();
    })

    // Bind arrow keys to slideshow
    $( document ).keydown( function( e ) {
        switch ( e.which ) {
            case 37: // left
                console.log( "Pressed left" );
                if ( showcaseShown == 1 ) {
                    var currentID = $( "div.showcase img" ).attr( "id" );
                    console.log( "Current ID was " + currentID );
                    if ( currentID > 0 ) {
                        currentID--;
                        $( "div.picture_number" ).text(( currentID + 1 ) + " / " +  ( $( "a.picture_link" ).size()));
                        $( "div.showcase img" ).attr( "id", currentID );
                        console.log( "Current ID is " + currentID );
                        var image = 
                            $( "a.picture_link#picture_link" + currentID ).attr( "href" );
                        $( "div.showcase img" ).attr( "src", image );
                        if ( types[currentID] == "portrait" ) {
                            $( "div.showcase img" ).addClass( "portrait" );
                            $( "div.showcase img" ).removeClass( "landscape" );
                            var ratio = $( "div.showcase img" ).height() / $( "div.showcase img" ).width();
                            $( "div.showcase img" ).removeAttr( "width" );
                        } else {
                            $( "div.showcase img" ).addClass( "landscape" );
                            $( "div.showcase img" ).removeClass( "portrait" );
                        }
                    }
                    lastID = currentID;
                    var selected_class = $( "div.drawer span.selected" ).attr('class');
                    if ( selected_class == "exif selected" ) {
                        $( "table.exif_view" ).html( $( "table#" + currentID + ".exif" ).html());
                    } else {
                        $( "table.property_view" ).html( $( "table#" + currentID + ".property" ).html());
                    }
                }
            break;

            case 38: // up
            break;

            case 39: // right
                console.log( "Pressed right" );
                if ( showcaseShown == 1 ) {
                    var currentID = $( "div.showcase img" ).attr( "id" );
                    console.log( "Current ID was " + currentID );
                    if ( currentID < $( "a.picture_link" ).size() - 1 ) {
                        currentID++;
                        $( "div.picture_number" ).text(( currentID + 1 ) + " / " +  ( $( "a.picture_link" ).size()));
                        $( "div.showcase img" ).attr( "id", currentID );
                        console.log( "Current ID is " + currentID );
                        var image = 
                            $( "a.picture_link#picture_link" + currentID ).attr( "href" );
                        $( "div.showcase img" ).attr( "src", image );
                        if ( types[currentID] == "portrait" ) {
                            $( "div.showcase img" ).addClass( "portrait" );
                            $( "div.showcase img" ).removeClass( "landscape" );
                            var ratio = $( "div.showcase img" ).height() / $( "div.showcase img" ).width();
                            $( "div.showcase img" ).removeAttr( "width" );
                        } else {
                            $( "div.showcase img" ).addClass( "landscape" );
                            $( "div.showcase img" ).removeClass( "portrait" );
                        }
                    }
                    lastID = currentID;
                    var selected_class = $( "div.drawer span.selected" ).attr('class');
                    if ( selected_class == "exif selected" ) {
                        $( "table.exif_view" ).html( $( "table#" + currentID + ".exif" ).html());
                    } else {
                        $( "table.property_view" ).html( $( "table#" + currentID + ".property" ).html());
                    }
                }
            break;

            case 40: // down
            break;
            
            case 27: // ESC
                // Close slideshow
                if ( showcaseShown === 1 ) {
                    showcaseShown = 0;
                    $( "div.showcase" ).fadeOut( 'fast' );
                    $( "div.drawer" ).css({ "z-index": "0", "top": "-82px" });
                }
            break;
            
            case 9: // On tab, switch between EXIF and properties
                var selected_class = $( "div.drawer span.selected" ).attr('class');
                if ( selected_class == "exif selected" ) {
                    $( "div.drawer span.exif" ).removeClass( "selected" );
                    $( "div.drawer span.properties" ).addClass( "selected" );
                    $( "table.property_view" ).html( $( "table#" + lastID + ".property" ).html());
                    $( "div.drawer table.exif_view" ).hide();
                    $( "div.drawer table.property_view" ).show();
                } else {
                    $( "div.drawer span.properties" ).removeClass( "selected" );
                    $( "div.drawer span.exif" ).addClass( "selected" );
                    $( "table.exif_view" ).html( $( "table#" + lastID + ".exif" ).html());
                    $( "div.drawer table.property_view" ).hide();
                    $( "div.drawer table.exif_view" ).show();
                }
            break;
            
            case 32: // On space, open slideshow
                if ( showcaseShown == 1 ) {
                    showcaseShown = 0;
                    $( "div.showcase" ).fadeOut( 'fast' );
                    $( "div.drawer" ).css({ "z-index": "0", "top": "-82px" });
                } else {
                    showcase( lastID );
                    $( "div.drawer" ).css({ "z-index": "1000", "top": "-130px" });
                }
                break;
            
            default: return; // exit this handler for other keys
        }
        e.preventDefault(); // prevent the default action (scroll / move caret)
    });

});