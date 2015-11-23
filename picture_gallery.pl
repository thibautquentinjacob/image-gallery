#!/opt/local/bin/perl
#  This program is free software; you can redistribute it and/or
#  modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation; either version 2
#  of the License, or (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor,
#  Boston, MA  02110-1301, USA.
#
#  ---
#  Copyright (C) 2015.05.14 AD 00:38:03 GMT+2, 
#  Thibaut Jacob <thibaut.jacob@telecom-paristech.fr>

# ┌───────────────────────────────────────────────────────────────┐
# │░░░░░░░░░░ Description ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░│
# ├───────────────────────────────────────────────────────────────┤
# │ What it does                                                  │
# ├─────────────────────────────────────────────────────────────╤─┤
# │ TODO                                                        │░│
# │   …                                                         │░│
# │ FIXME                                                       │░│
# │   …                                                         │░│
# └─────────────────────────────────────────────────────────────┴─┘

use strict;
use warnings;
use Term::ANSIColor qw(:constants);
local $Term::ANSIColor::AUTORESET = 1;
use Data::Dumper;
use Getopt::Long;
use POSIX;
use File::Find;
use FindBin qw($Bin);

my $verbose  = 0;
my $imageDir = undef;
my $name     = undef;
my $force    = "";
my @dirs     = ();

# ╔════════════════════════════════════════════╗
# ║ ░ Program  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ ║
# ╚════════════════════════════════════════════╝
my $parameters = GetOptions (
    "image-dir=s" => \$imageDir,
    "name=s"      => \$name,
    "verbose"     => sub { $verbose = 1 },
    "help|?"      => sub { printUsage()},
    "force=s"     => \$force,
);

# Check if all parameters are been provided
if ( !defined( $imageDir )) {
    printUsage();
    exit;
} else {
    # Create a gallery folder with the name provided
    @dirs = ( $imageDir );
    find( \&wanted, @dirs);
}


# ╔════════════════════════════════════════════╗
# ║ ░ Functions  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ ║
# ╚════════════════════════════════════════════╝

# Thibaut Jacob -> 2015.11.11 AD 12:46:31 GMT+1
# ╔════════════════════════════════════════════╗
# ║ ░ picture_gallery :: wanted ░░░░░░░░░░░░░░ ║
# ╟────────────────────────────────────────────╢
# │ Called by file recursion                   │
# └────────────────────────────────────────────┘
sub wanted {
    my $file = $_;
    if ( -d $File::Find::name && $_ ne "thumbs" ) {
        my @splits = split( "/", $File::Find::name );
        generateThumbs( $File::Find::name );
        generateHTML(   $File::Find::name, $splits[@splits-1] );
    }
}

# Thibaut Jacob -> 2015.10.08 AD 23:33:07 GMT+2
# ╔════════════════════════════════════════════╗
# ║ ░ picture_gallery :: generateThumbs ░░░░░░ ║
# ╟────────────────────────────────────────────╢
# │ Generate thumbs for images and videos      │
# └────────────────────────────────────────────┘
sub generateThumbs {
    my ( $imageDir ) = @_;
    print( BLUE "-> Generating thumbs for $imageDir : " );
    opendir( my $images, $imageDir ) or die $!;
    my @files = readdir( $images );
    closedir( $images );

    # Create thumbs directory if it does not already exists
    unless ( -d "$imageDir/thumbs" ) {
#         print( "Creating folder $imageDir/thumbs\n" );
        `mkdir $imageDir/thumbs`;
    } else {
        print( GREEN "Thumbs already generated\n" );
        unless ( $force eq "thumbs" || $force eq "all" ) {
            return;
        } else {
            print( GREEN "Forcing thumbs creation\n" );
        }
    }

    my $fileDone = 0;
    my $total    = 0;
    for my $file ( @files ) {
        if ( $file =~ /.*\.(?:JPG|jpg|jpeg|PNG|png)/ ) {
            $total++;
        }
    }
    if ( $total > 0 ) {
        for my $file ( @files ) {
            if ( $file =~ /.*\.(?:JPG|jpg|jpeg|PNG|png)/ ) {
                print( "\rGenerating thumbnails: $fileDone / $total [" . 
                       floor( $fileDone * 100 / $total ) . "%]: " . $file . 
                       "                                              " );
                `convert -thumbnail 200 $imageDir/$file $imageDir/thumbs/$file`;
                $fileDone++;
            }
        }
        print( "\rGenerating thumbnails: $fileDone / $total [" . 
               floor( $fileDone * 100 / $total ) . "%]: done\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\n" );
    } else {
        print( "Nothing to be done\n" );
    }
}

# Thibaut Jacob -> 2015.10.08 AD 23:38:36 GMT+2
# ╔════════════════════════════════════════════╗
# ║ ░ picture_gallery :: generateHTML ░░░░░░░░ ║
# ╟────────────────────────────────────────────╢
# │ Gnerate HTML gallery code                  │
# └────────────────────────────────────────────┘
sub generateHTML {
    my ( $imageDir, $name ) = @_;
    print( BLUE "-> Generating HTML for $imageDir : " );
    # Copy CSS and JS
    `cp $Bin/gallery.css $Bin/gallery.js $imageDir`;
    if ( -e "$imageDir/index.html" && $force ne "all" && $force ne "html" ) {
        print( GREEN "HTML already generated, skipping\n" );
        return;
    } elsif ( $force eq "all" || $force eq "html" ) {
        print( GREEN "Forcing HTML generation\n" );
    } else {
        print( GREEN "\n" );
    }
    open( OUTPUT,   ">", "$imageDir/index.html"    );
    open( SKELETON, "<", "$Bin/skeleton.html" );
    my $line;
    while ( <SKELETON> ) {
        $line = $_;
        if ( $line =~ /(.*)\{title\}(.*)/ ) {
            print( OUTPUT $1 . $name . $2 );
            print( GREEN "* Adding title\n" );
        } elsif ( $line =~ /.*\{crumbs\}.*/ ) {
            print( GREEN "* Adding crumbs\n" );
            my $root = $dirs[0]; # get root
            my @splitRoot = split( "/", $root );
            $root = $splitRoot[@splitRoot-1];
            my @path = split( "/", $File::Find::dir ); # split path
            my @splitCurrent = split( "/", $imageDir );
            my $current = $splitCurrent[@splitCurrent-1];
            my $reachedRoot = 0;
            for my $dir ( @path ) {
                # If we are at root level
                if ( $dir eq $root && !$reachedRoot ) {
                    $reachedRoot = 1;
                    print( OUTPUT "<a class='breadcrumb_link' href='/'>$dir</a>" );
                }
                if ( $reachedRoot && $dir ne $current && $dir ne $root ) {
                    print( OUTPUT "<a class='breadcrumb_link' href='$dirs[0]/$dir/index.html'>$dir</a>" );
                } elsif ( $reachedRoot && $dir eq $current ) {
#                     print( OUTPUT "<a class='breadcrumb_link_current'>$dir</a>" );
                } else {
#                     print( OUTPUT "<a class='breadcrumb_link'>$dir</a>" );
                }
            }
            print( OUTPUT "<a class='breadcrumb_link_current' href='./index.html'>$current</a>" );
        } elsif ( $line =~ /\{content\}/ ) {
            print( GREEN "* Incorporating content\n" );
            opendir( my $images, $imageDir ) or die $!;
            my @files = sort {(stat "$imageDir/$a")[9] <=> (stat "$imageDir/$b")[9]} readdir( $images );
            closedir( $images );
    
            my $counter = 0;
            for my $file ( @files ) {
                # If we have a subfolder
                if ( -d $file && $file ne "." && $file ne ".." && $file ne "thumbs" ) {
                    # Take the first image as preview of the gallery
                    opendir( my $subImages, $imageDir . "/" . $file ) or die $!;
                    my @subFiles = readdir( $subImages );
                    my $preview;
                    for my $subFile ( @subFiles ) {
                        if ( $subFile =~ /.*\.(?:JPG|jpg|jpeg|PNG|png)/ ) {
                            $preview = $subFile;
                            last;
                        }
                    }
                    closedir( $subImages );
                    
                    print( OUTPUT "<div class='outer_frame' id='outer_frame$counter'>
                          <div class='img_frame_gallery' id='$counter'></div>
                          <div class='buttons_gallery' id='$counter'>
                          <div class='subgallery_title'>
                          <i class='fa fa-th-list' id='$counter' class=''></i>
                          &nbsp;&nbsp;
                          $file
                          </div>
                          </div>
                          <a href='$file/index.html' class='picture_link_subgallery' id='picture_link$counter'>
                              <img class='picture' id='$counter' style='background-color: black' src='$file/thumbs/$preview'>
                          </a>
                          </div>" );
                    $counter++;
                } elsif ( $file =~ /.*\.(?:JPG|jpg|jpeg|PNG|png)/ ) {
                    print( OUTPUT "<div class='outer_frame' id='outer_frame$counter'>
                          <div class='img_frame' id='$counter'></div>
                          <div class='buttons' id='$counter'>
                          <i class='fa fa-search' id='$counter' style='left: 5px;'></i>
                          <a href='$file'><i class='fa fa-download' id='$counter' style='left: 15px;'></i></a>
                          <span class='description' id='$counter'>$file</span>
                          </div>
                          <a href='$file' class='picture_link' id='picture_link$counter'>
                              <img class='picture' id='$counter' style='background-color: black' src='thumbs/$file'>
                          </a>
                          </div>" );
                    $counter++;
                }
            }
        # Load exif informations
        } elsif ( $line =~ /\{exif\}/ ) {
            print( GREEN "* Parsing EXIF " );
            opendir( my $images, $imageDir ) or die $!;
            my @files = readdir( $images );
            closedir( $images );
            my @keyBlackList = ( "ComponentsConfiguration", "MakerNote", 
                                 "thumbnail:.InteroperabilityIndex", 
                                 "thumbnail:Compression", 
                                 "thumbnail:JPEGInterchangeFormat", 
                                 "thumbnail:JPEGInterchangeFormatLength",
                                 "thumbnail:ResolutionUnit",
                                 "thumbnail:XResolution",
                                 "thumbnail:YResolution", "UserComment" );
            my $counter = 0;
            for my $file ( @files ) {
                if ( $file =~ /.*\.(?:JPG|jpg|jpeg|PNG|png)/ ) {
                    my $a = `identify -format "%[EXIF:*]" $imageDir/$file`;
                    my @exif = split(/[\r\n]/, $a);
#                     print( Dumper( @exif ));
                    print( OUTPUT "<table class='exif' id='$counter' style='display: none'>" );
                    for my $entry ( @exif ) {
                        if ( $entry =~ /exif:(?<key>.*)=(?<value>[a-zA-Z0-9\/]*|.*)/ ) {
                            if ( grep( /^$+{key}$/, @keyBlackList )) {
                                next;
                            }
                            my $key = $+{key};
#                             $key =~ s/Value//g;
                            if ( !defined( $+{value})) {
                                print( RED "Invalid value for entry with key=$key : $entry\n" );
                            } else {
                                print( OUTPUT "<tr><td class='key'>$key</td><td class='value'>$+{value}</td></tr>" );
                            }
                        } else {
                            die( RED "Could not parse entry: $entry" );
                        }
                    }
                    print( OUTPUT "</table>" );
                    $counter++;
                }
            }
            print( "\n" );
        } elsif ( $line =~ /\{properties\}/ ) {
            print( GREEN "* Filling in file properties\n" );
            opendir( my $images, $imageDir ) or die $!;
            my @files = readdir( $images );
            closedir( $images );
            my $counter = 0;
            for my $file ( @files ) {
                if ( $file =~ /.*\.(?:JPG|jpg|jpeg|PNG|png)/ ) {
                    my ( $dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,
                         $atime,$mtime,$ctime,$blksize,$blocks ) = stat( "$imageDir/$file" );
                     $mode = sprintf( "%04o", $mode & 07777 );
                     my $sizeCount = 0;
                     my @units = ( "B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB" );
                     while ( $size > 1024 ) {
                        $size /= 1024;
                        $sizeCount++;
                     }
                    $size = ceil( $size );
                    $size .= " " . $units[$sizeCount];
                    $atime = epochToReadable( $atime );
                    $mtime = epochToReadable( $mtime );
                    $ctime = epochToReadable( $ctime );
                    print( OUTPUT "<table class='property' id='$counter' style='display: none'>" );
                    print( OUTPUT "<tr><td class='key'>File Name</td><td class='value'>$file</td></tr>" );
                    print( OUTPUT "<tr><td class='key'>Device Number</td><td class='value'>$dev</td></tr>" );
                    print( OUTPUT "<tr><td class='key'>Inode Number</td><td class='value'>$ino</td></tr>" );
                    print( OUTPUT "<tr><td class='key'>File Mode</td><td class='value'>$mode</td></tr>" );
                    print( OUTPUT "<tr><td class='key'>Hard Links</td><td class='value'>$nlink</td></tr>" );
                    print( OUTPUT "<tr><td class='key'>Owner ID (UID)</td><td class='value'>$uid</td></tr>" );
                    print( OUTPUT "<tr><td class='key'>Group ID (GID)</td><td class='value'>$gid</td></tr>" );
                    print( OUTPUT "<tr><td class='key'>Device ID</td><td class='value'>$rdev</td></tr>" );
                    print( OUTPUT "<tr><td class='key'>Size</td><td class='value'>$size</td></tr>" );
                    print( OUTPUT "<tr><td class='key'>Access Time</td><td class='value'>$atime</td></tr>" );
                    print( OUTPUT "<tr><td class='key'>Modification Time</td><td class='value'>$mtime</td></tr>" );
                    print( OUTPUT "<tr><td class='key'>Inode Change Time</td><td class='value'>$ctime</td></tr>" );
                    print( OUTPUT "<tr><td class='key'>IO Size</td><td class='value'>$blksize</td></tr>" );
                    print( OUTPUT "<tr><td class='key'>Blocks allocated</td><td class='value'>$blocks</td></tr>" );
                    print( OUTPUT "</table>" );
                    $counter++;
                }
            }
        } else {
            print( OUTPUT $line );
        }
    }
    close( SKELETON );
    close( OUTPUT );
}

# Thibaut Jacob -> 2015.11.16 AD 00:31:48 GMT+1
# ╔════════════════════════════════════════════╗
# ║ ░ picture_gallery :: epochToReadable ░░░░░ ║
# ╟────────────────────────────────────────────╢
# │ Convert EPOCH time to human readable format│
# └────────────────────────────────────────────┘
sub epochToReadable {
	my ( $epoch ) = @_;
    my @months = ("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec");
    my ($sec, $min, $hour, $day,$month,$year) = (localtime($epoch))[0,1,2,3,4,5];
    return ( $year + 1900 ) . ":" . $month . ":" . $day . " " . $hour . ":" . 
            $min . ":" . $sec;
}

# ╔════════════════════════════════════════════╗
# ║ ░ picture_gallery :: printUsage ░░░░░░░░░░ ║
# ╟────────────────────────────────────────────╢
# │ Appears when the user invoke help using -h │
# │ or --help. Reminds him the available       │
# │ commands.                                  │
# └────────────────────────────────────────────┘
sub printUsage {
	print GREEN "\nperl picture_gallery.pl --image-dir xxx --name yyy\n";
	print "-v --verbose\t\tVerbose mode\n";
	print "-h --help\t\tPrint this help\n";
	print "--image-dir\t\tImage dir to make a gallery of\n";
	print "--name\t\t\tThe name of the gallery\n";
	print "--force\t\t\tForce recreation of (all|thumbs|html)\n";
	print "\n";
	exit;
}