
function watermark {
    if [ $# -lt 1 ]; then
        echo "Usage: $0 <file>"
    else
        ww=`convert $1 -format "%[fx:0.22*w]" info:`
        hh=`convert $1 -format "%[fx:0.11*h]" info:`
        convert $1 \( $DOTFILES/assets/cesium.png -resize ${ww}x${hh} -bordercolor transparent -border 7%x10% \) -gravity SouthEast -composite $1.new
    fi
}
