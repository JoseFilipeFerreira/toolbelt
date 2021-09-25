quotes=(
"Talent is just pursued interest - Bob Ross"
"It is possible to commit no mistakes and still lose. That is not a weakness; that is life - Jean Luc Picard"
"Do what you can, with what you’ve got, where you are - Theodore Roosevelt"
"If you look for the light, you can often find it. But if you only look for the dark, that is all you will ever see - Uncle Iroh"
"You're only given a little spark of madness. You mustn't lose it - Robin Williams."
"How lucky I am to have something that makes saying goodbye so hard - Winnie the pooh"
"One small step begets another, and with these steps, humanity begins to find its stride... - thndrchld"
"Leio descalço para seguir os passos dos poetas - João Aguiar Campos"
"E o caminho disse aos passos: Não posso dar-vos o destino, mas vou para la convosco - João Aguiar Campos"
"Talk is cheap. Show me the code. - Linus Torvalds"
"Learn the rules like a pro, so you can break them like an artist - Pablo Picasso"
"Eu não sou uma banana - Rui Rio"
)

if [[ "$(pwd)" = "$HOME" ]]; then
    echo -en "\e[$((RANDOM % 6 + 31))m"
    echo "${quotes[$RANDOM % ${#quotes[@]}]// - /$'\n'$'\t'-}" |
        fold -s -w $(( COLUMNS < 120 ? COLUMNS : 120 ))
    echo -en "\e[0m"
fi
