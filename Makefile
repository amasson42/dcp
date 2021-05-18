
all: dcpmaker
	./dcpmaker -help

.PHONY: dcpmaker
dcpmaker:
	@cd dcpmaker_srcs && swift build && cp .build/debug/dcpmaker ../dcpmaker

.PHONY: clean
clean:
	cd dcpmaker_srcs && swift package clean

.PHONY: fclean
fclean: clean
	cd dcpmaker_srcs && swift package reset
	rm -f dcpmaker
	rm -rf workspace

.PHONY: re
re: fclean all
