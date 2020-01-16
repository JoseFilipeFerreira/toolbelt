if [ -e "$1" ]
then
    file=$1
else
    file=$(find "$WALLS" | shuf -n 1)
fi
feh --no-fehbg --bg-fill "$file"
echo "$file"
