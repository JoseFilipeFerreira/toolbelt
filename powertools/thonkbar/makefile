CC= gcc
CFLAGS= -lpthread

EXEC= thonkbar
DAEMON = thonkbar_daemon

SCRIPTS= scripts


$(EXEC): thonkbar.c
	$(CC) thonkbar.c -o $(EXEC) $(CFLAGS)

debug: thonkbar.c
	$(CC) -g thonkbar.c -o $(EXEC) $(CFLAGS)
clean:
	rm -f $(EXEC)

install: $(EXEC) $(DAEMON)
	cp $(EXEC) $(DAEMON) ~/.local/bin

uninstall:
	rm ~/.local/bin/{$(EXEC),$(DAEMON)}
