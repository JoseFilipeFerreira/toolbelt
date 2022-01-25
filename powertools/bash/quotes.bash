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
"Eu não sou uma banana - Rui Moreira"
"Sometimes you feel like you're fucked, but when you say you are actually fucked, you are only like about 45% fucked - Nims Purja"
"Lost time is never found again - Benjamin Franlin"
"A distributed system is one in which the failure of a computer you didn't even know existed can render your own computer unusable - Leslie Lamport"
"Everything you can imagine is real - Pablo Picasso"
"I am enough of the artist to draw freely upon my imagination. Imagination is more important than knowledge. Knowledge is limited. Imagination encircles the world - Albert Einstein"
"All men should strive to learn before they die, what they are running from, and to, and why - James Thurber"
"A computer is like air conditioning, it becomes useless once you open Windows - Linus Torvalds"
"The loudest thing in the room, by far, should be the occasional purring of the cat - Linus Torvalds"
"Microsoft isn't evil, they just make really crappy operating systems - Linus Torvalds"
"No problem is too big it can't be run away from - Linus Torvalds"
)


if [[ "$(pwd)" = "$HOME" ]]; then
    echo -en "\e[$((RANDOM % 6 + 31))m"
    echo "${quotes[$RANDOM % ${#quotes[@]}]// - /$'\n'$'\t'-}" |
        fold -s -w $(( COLUMNS < 80 ? COLUMNS : 80 ))
    echo -en "\e[0m"
fi
